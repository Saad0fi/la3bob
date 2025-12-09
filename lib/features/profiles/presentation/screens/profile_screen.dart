import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:la3bob/core/di/injection.dart';
import 'package:la3bob/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:la3bob/features/auth/presentation/pages/login_screen.dart';
import 'package:la3bob/features/profiles/domain/usecase/profile_usecase.dart';
import 'package:la3bob/features/profiles/presentation/bloc/porfile_bloc.dart';
import 'package:la3bob/features/profiles/presentation/screens/add_child_screen.dart';
import 'package:la3bob/features/profiles/presentation/screens/update_child_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PorfileBloc(getIt<ProfileUsecase>(), getIt<AuthUseCases>())
            ..add(const LoadChildren()),
      child: Builder(
        builder: (context) {
          final bloc = context.read<PorfileBloc>();
          return Scaffold(
            appBar: AppBar(
              title: const Text('الملف الشخصي'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.blue),
                  onPressed: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AddChildScreen()),
                    );

                    if (result == true) {
                      bloc.add(const LoadChildren());
                    }
                  },
                ),
              ],
            ),
            body: BlocListener<PorfileBloc, PorfileState>(
              listener: (context, state) {
                if (state is PorfileSuccess &&
                    state.message == 'تم تسجيل الخروج بنجاح') {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }

                if (state is PorfileSuccess &&
                    state.message != 'تم تسجيل الخروج بنجاح') {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }

                if (state is PorfileError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.failure.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }

                if (state is PorfileChildSelected) {
                  // عند اختيار طفل، ارجع true لإعادة تحميل الفيديوهات
                  Navigator.of(context).pop(true);
                }
              },
              child: BlocBuilder<PorfileBloc, PorfileState>(
                builder: (context, state) {
                  final isLoading = state is PorfileLoading;

                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is PorfileError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.failure.message,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => bloc.add(const LoadChildren()),
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    );
                  }

                  final children = state is PorfileChildrenLoaded
                      ? state.children
                      : [];
                  final isLoaded = state is PorfileChildrenLoaded;
                  final isLockActive = state is PorfileChildrenLoaded
                      ? state.isChildLockModeActive
                      : false;
                  final selectedChildId = state is PorfileChildrenLoaded
                      ? state.selectedChildId
                      : null;
                  const String parentName = "ولي الأمر";

                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: CustomScrollView(
                      slivers: [
                        // قسم بيانات ولي الأمر (BigUserCard)
                        SliverToBoxAdapter(
                          child: BigUserCard(
                            backgroundColor: Colors.blueAccent.shade700,
                            userName: parentName,
                            userProfilePic: const AssetImage(
                              "assets/images/image8.png",
                            ),
                            cardActionWidget: SettingsItem(
                              icons: Icons.edit,
                              iconStyle: IconStyle(
                                iconsColor: Colors.black,
                                withBackground: true,
                                borderRadius: 50,
                                backgroundColor: Colors.white,
                              ),
                              title: "تعديل البيانات",
                              subtitle: "اضغط لتغيير بياناتك",
                              onTap: () {},
                            ),
                          ),
                        ),

                        const SliverToBoxAdapter(child: SizedBox(height: 25)),

                        // قسم أدوات التحكم الأبوي
                        SliverToBoxAdapter(
                          child: SettingsGroup(
                            backgroundColor: Colors.white,
                            settingsGroupTitle: "أدوات الرقابة الأبوية",
                            items: [
                              // زر حماية الإعدادات
                              SettingsItem(
                                onTap: () {},
                                icons: CupertinoIcons.lock_shield_fill,
                                iconStyle: IconStyle(
                                  iconsColor: Colors.white,
                                  backgroundColor: Colors.orange,
                                ),
                                title: "حماية الإعدادات",
                                subtitle: "تفعيل رمز سري لدخول هذه الصفحة",
                              ),

                              // زر وضع الطفل (Kiosk Mode)
                              SettingsItem(
                                onTap: () {},
                                icons: isLockActive
                                    ? CupertinoIcons.lock_fill
                                    : CupertinoIcons.lock_open_fill,
                                iconStyle: IconStyle(
                                  iconsColor: Colors.white,
                                  backgroundColor: isLockActive
                                      ? Colors.red.shade700
                                      : Colors.green.shade700,
                                ),
                                title: isLockActive
                                    ? "إلغاء وضع القفل (وضع الطفل)"
                                    : "تفعيل وضع القفل (وضع الطفل)",
                                subtitle:
                                    "تثبيت التطبيق على الشاشة لمنع الخروج",
                                trailing: Switch.adaptive(
                                  value: isLockActive,
                                  onChanged: (newvlue) async {
                                    bloc.add(ToggleChildLockMode(newvlue));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SliverToBoxAdapter(child: SizedBox(height: 25)),

                        // قائمة ملفات الأطفال
                        if (isLoaded)
                          // قسم إدارة ملفات الأطفال
                          SliverToBoxAdapter(
                            child: SettingsGroup(
                              backgroundColor: Colors.white,
                              settingsGroupTitle:
                                  "ملفات الأطفال (${children.length})",
                              items: children.isEmpty
                                  ? [
                                      SettingsItem(
                                        title: "لا يوجد أطفال مسجلون.",
                                        subtitle:
                                            "اضغط على زر الإضافة أعلاه لإضافة طفل جديد.",
                                        icons: Icons.info_outline,
                                        iconStyle: IconStyle(
                                          backgroundColor: Colors.grey.shade300,
                                          iconsColor: Colors.black54,
                                        ),
                                        onTap: () {},
                                      ),
                                    ]
                                  : children.map((child) {
                                      final isSelected =
                                          child.id == selectedChildId;
                                      return SettingsItem(
                                        onTap: () {
                                          bloc.add(SelectChild(child));
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'تم اختيار ${child.name} لعرض الفيديوهات',
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        },
                                        icons: CupertinoIcons
                                            .person_alt_circle_fill,
                                        title: child.name ?? 'طفل غير مسمى',
                                        subtitle: isSelected
                                            ? "العمر: ${child.age} -  مختار"
                                            : "العمر: ${child.age}",
                                        iconStyle: IconStyle(
                                          iconsColor: Colors.white,
                                          backgroundColor: isSelected
                                              ? Colors.blue
                                              : Colors.green,
                                        ),
                                        trailing: isSelected
                                            ? const Icon(
                                                Icons.check_circle,
                                                color: Colors.blue,
                                                size: 24,
                                              )
                                            : IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                ),
                                                onPressed: () async {
                                                  final result =
                                                      await Navigator.of(
                                                        context,
                                                      ).push(
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              UpdateChildScreen(
                                                                child: child,
                                                              ),
                                                        ),
                                                      );

                                                  if (result == true) {
                                                    bloc.add(
                                                      const LoadChildren(),
                                                    );
                                                  }
                                                },
                                              ),
                                      );
                                    }).toList(),
                            ),
                          ),

                        const SliverToBoxAdapter(child: SizedBox(height: 25)),

                        // مجموعة إدارة الحساب
                        SliverToBoxAdapter(
                          child: SettingsGroup(
                            backgroundColor: Colors.white,
                            settingsGroupTitle: "الحساب",
                            items: [
                              // زر تغيير البريد الإلكتروني
                              SettingsItem(
                                onTap: () {},
                                icons: Icons.email_rounded,
                                title: "تغيير البريد الإلكتروني",
                              ),

                              // زر حذف الحساب
                              SettingsItem(
                                onTap: () {},
                                icons: Icons.delete_forever,
                                title: "حذف الحساب",
                                titleStyle: const TextStyle(color: Colors.red),
                              ),

                              // زر تسجيل الخروج
                              SettingsItem(
                                onTap: () {
                                  bloc.add(const LogoutRequested());
                                },
                                icons: Icons.exit_to_app_rounded,
                                title: "تسجيل الخروج",
                                titleStyle: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
