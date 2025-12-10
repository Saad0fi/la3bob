import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:la3bob/core/di/injection.dart';
import 'package:la3bob/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:la3bob/features/auth/presentation/pages/login_screen.dart';
import 'package:la3bob/features/profiles/domain/usecase/profile_usecase.dart';
import 'package:la3bob/features/profiles/presentation/bloc/porfile_bloc.dart';
import 'package:la3bob/features/profiles/presentation/screens/add_child_screen.dart';
import 'package:la3bob/features/profiles/presentation/screens/update_child_screen.dart';
import 'package:la3bob/features/videos/presentation/screens/video_home_screen.dart';

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
                // هنا  معالجة النجاح العام (Logout, Save Settings, Toggle Lock Mode)
                if (state is PorfileSuccess) {
                  Fluttertoast.showToast(
                    msg: state.message,
                    backgroundColor: Colors.green,
                  );
                  if (state.message == 'تم تسجيل الخروج بنجاح') {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                }

                //  معالجةال Erors
                if (state is PorfileError) {
                  Fluttertoast.showToast(
                    msg: state.failure.message,
                    backgroundColor: Colors.red,
                  );
                }
                if (state is PorfileChildrenLoaded) {
                  if (state.accessStatus == AccessStatus.denied) {
                    Navigator.of(context).pop();
                  }
                }
                //  معالجة اختيار الطفل
                if (state is PorfileChildSelected) {
                  Fluttertoast.showToast(
                    msg: 'تم اختيار الطفل ${state.selectedChild.name} بنجاح!',
                    backgroundColor: Colors.green,
                  );
                  Navigator.of(context).pop(true);
                }
              },

              child: BlocBuilder<PorfileBloc, PorfileState>(
                builder: (context, state) {
                  final isLoading = state is PorfileLoading;
                  if (isLoading) {
                    return const Center(
                      child: CupertinoActivityIndicator(radius: 20.0),
                    );
                  }

                  //  تعريف المتغيرات
                  final children = state is PorfileChildrenLoaded
                      ? state.children
                      : [];
                  final isLoaded = state is PorfileChildrenLoaded;
                  final isLockActive = state is PorfileChildrenLoaded
                      ? state.isChildLockModeActive
                      : false;
                  final isSettingsProtected = state is PorfileChildrenLoaded
                      ? state.isSettingsProtected
                      : false;

                  final selectedChildId = state is PorfileChildrenLoaded
                      ? state.selectedChildId
                      : null;
                  const String parentName = "ولي الأمر";

                  //  المحتوى الحساس يعرض فقط بعد منح الوصول
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
                              onTap: () {
                                Fluttertoast.showToast(
                                  msg:
                                      'جارٍ الانتقال لتعديل بيانات ولي الأمر...',
                                  backgroundColor: Colors.blue,
                                );
                              },
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
                              //  زر تبديل تفعيل/إلغاء حماية الدخول بالبصمة
                              SettingsItem(
                                onTap: () {},
                                icons: isSettingsProtected
                                    ? CupertinoIcons.lock_shield_fill
                                    : CupertinoIcons.lock_open_fill,
                                iconStyle: IconStyle(
                                  iconsColor: Colors.white,
                                  backgroundColor: isSettingsProtected
                                      ? Colors.green.shade700
                                      : Colors.grey,
                                ),
                                title: isSettingsProtected
                                    ? "إلغاء حماية الدخول بالبصمة"
                                    : "تفعيل حماية الدخول بالبصمة",
                                subtitle:
                                    "تفعيل المصادقة البيومترية عند دخول هذه الصفحة",
                                trailing: Switch.adaptive(
                                  value: isSettingsProtected,
                                  onChanged: (newValue) {
                                    if (isLoaded) {
                                      // نتحقق من أن الحالة الحالية هي PorfileChildrenLoaded
                                      bloc.add(
                                        SaveSettingsProtectionEvent(
                                          isProtected: newValue,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),

                              //  زر وضع الطفل Kiosk Mode)
                              SettingsItem(
                                onTap: () {},
                                icons: isLockActive
                                    ? CupertinoIcons.lock_fill
                                    : CupertinoIcons.lock_open_fill,
                                iconStyle: IconStyle(
                                  iconsColor: Colors.white,
                                  backgroundColor: isLockActive
                                      ? Colors.green.shade700
                                      : Colors.grey,
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
                                        },
                                        icons: CupertinoIcons
                                            .person_alt_circle_fill,
                                        title: child.name ?? 'طفل غير مسمى',
                                        subtitle: isSelected
                                            ? "العمر: ${child.age} - مختار"
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
                              SettingsItem(
                                onTap: () {
                                  Fluttertoast.showToast(
                                    msg:
                                        'تم إطلاق طلب تغيير البريد الإلكتروني.',
                                    backgroundColor: Colors.blue,
                                  );
                                },
                                icons: Icons.email_rounded,
                                title: "تغيير البريد الإلكتروني",
                              ),
                              SettingsItem(
                                onTap: () {
                                  Fluttertoast.showToast(
                                    msg: 'جارٍ تجهيز شاشة تأكيد حذف الحساب...',
                                    backgroundColor: Colors.red,
                                  );
                                },
                                icons: Icons.delete_forever,
                                title: "حذف الحساب",
                                titleStyle: const TextStyle(color: Colors.red),
                              ),
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
