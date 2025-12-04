import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:la3bob/core/di/injection.dart';
import 'package:la3bob/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:la3bob/features/auth/presentation/pages/login_screen.dart';
import 'package:la3bob/features/profiles/domain/usecase/profile_usecase.dart';
import 'package:la3bob/features/profiles/presentation/bloc/porfile_bloc.dart';
import 'package:la3bob/features/profiles/presentation/screens/update_child_screen.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';

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
              actions: const [],
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
              },
              child: BlocBuilder<PorfileBloc, PorfileState>(
                builder: (context, state) {
                  if (state is PorfileLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is PorfileError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(state.error, textAlign: TextAlign.center),
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

                  const String parentName = "ولي الأمر";

                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView(
                      children: [
                        BigUserCard(
                          backgroundColor: Colors.blueAccent.shade700,
                          userName: parentName,
                          userProfilePic: const NetworkImage(
                            "https://i.pravatar.cc/150?img=3",
                          ),
                          cardActionWidget: SettingsItem(
                            icons: Icons.edit,
                            iconStyle: IconStyle(
                              iconsColor: Colors.black,
                              withBackground: true,
                              borderRadius: 50,
                              backgroundColor: Colors.white, // لون خلفية الزر
                            ),
                            title: "تعديل البيانات",
                            subtitle: "اضغط لتغيير بياناتك",
                            onTap: () {
                              print("الانتقال لتعديل ملف الوالدين");
                            },
                          ),
                        ),

                        // 2.  قسم أدوات التحكم الأبوي
                        SettingsGroup(
                          settingsGroupTitle: "أدوات الرقابة الأبوية",
                          items: [
                            //  زر حماية الإعدادات (بوابة الوالدين)
                            SettingsItem(
                              onTap: () {
                                print("استدعاء بوابة التحقق من الرمز السري...");
                              },
                              icons: CupertinoIcons.lock_shield_fill,
                              iconStyle: IconStyle(
                                iconsColor: Colors.white,
                                backgroundColor: Colors.orange,
                              ),
                              title: "حماية الإعدادات",
                              subtitle: "تفعيل رمز سري لدخول هذه الصفحة",
                            ),

                            //  زر وضع الطفل (Kiosk Mode)
                            SettingsItem(
                              onTap: () {
                                print("تبديل وضع قفل التطبيق...");
                              },
                              icons: CupertinoIcons.lock_open_fill,
                              iconStyle: IconStyle(
                                iconsColor: Colors.white,
                                backgroundColor: Colors.red,
                              ),
                              title: "تفعيل وضع القفل (وضع الطفل)",
                              subtitle: "تثبيت التطبيق على الشاشة لمنع الخروج",
                              trailing: Switch.adaptive(
                                value: isLockActive,
                                onChanged: (newvlue) async {
                                  bloc.add(ToggleChildLockMode(newvlue));
                                  print("تبديل وضع الطفل: $newvlue");

                                  if (newvlue) {
                                    await startKioskMode();
                                    print("Kiosk Mode: تم التفعيل بنجاح.");
                                  } else {
                                    await stopKioskMode();
                                    print("Kiosk Mode: تم الإلغاء.");
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                        //   قسم إدارة ملفات الأطفال
                        if (isLoaded)
                          SettingsGroup(
                            settingsGroupTitle:
                                "ملفات الأطفال (${children.length})",
                            // trailing: IconButton(
                            //   icon: const Icon(Icons.add, color: Colors.blue),
                            //   onPressed: () async {
                            //     final result = await Navigator.of(context).push(
                            //       MaterialPageRoute(
                            //         builder: (_) => const AddChildScreen(),
                            //       ),
                            //     );
                            //     if (result == true) {
                            //       bloc.add(const LoadChildren());
                            //     }
                            //   },
                            // ),
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
                                    return SettingsItem(
                                      onTap: () async {
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                UpdateChildScreen(child: child),
                                          ),
                                        );
                                        bloc.add(const LoadChildren());
                                      },
                                      icons:
                                          CupertinoIcons.person_alt_circle_fill,
                                      title: child.name,
                                      subtitle: "العمر: ${child.age}",
                                      iconStyle: IconStyle(
                                        iconsColor: Colors.white,
                                        backgroundColor: Colors.green,
                                      ),
                                      trailing: const Icon(
                                        Icons.edit,
                                        size: 20,
                                      ),
                                    );
                                  }).toList(),
                          ),

                        // 4. 🚪 زر تسجيل الخروج
                        SettingsGroup(
                          items: [
                            SettingsItem(
                              onTap: () => bloc.add(const LogoutRequested()),
                              icons: Icons.exit_to_app_rounded,
                              title: "تسجيل الخروج",
                              titleStyle: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
