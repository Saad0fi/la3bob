import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:la3bob/core/comon/helper_function/dialog_helper.dart';
import 'package:la3bob/core/comon/helper_function/toast_helper.dart';
import 'package:la3bob/features/auth/presentation/pages/login_screen.dart';
import 'package:la3bob/features/profiles/presentation/bloc/porfile_bloc.dart';
import 'package:la3bob/features/profiles/presentation/screens/add_child_screen.dart';
import 'package:la3bob/features/profiles/presentation/screens/update_child_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              final result = await Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const AddChildScreen()));

              if (result == true) {
                // إعادة تحميل بيانات الاطفال  بعد إضافة طفل جديد
                bloc.add(const ForceReload());
              }
            },
          ),
        ],
      ),

      body: BlocListener<PorfileBloc, PorfileState>(
        listener: (context, state) {
          // معالجة النجاح  (Logout, Save Settings, Toggle Lock Mode)
          if (state is PorfileSuccess) {
            showAppToast(message: state.message, type: ToastType.success);
            if (state.message == 'تم تسجيل الخروج بنجاح') {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            }

            if (state.message ==
                'تم حذف الحساب بنجاح. نأمل أن نراك مرة أخرى قريبًا!') {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            }
          }

          // معالجة الأخطاء
          if (state is PorfileError) {
            showAppToast(
              message: state.failure.message,
              type: ToastType.failure,
            );
          }

          //  معالجة حالة رفض الوصول المصادقة فشلت
          if (state is PorfileChildrenLoaded) {
            if (state.accessStatus == AccessStatus.denied) {
              Navigator.of(context).pop();
            }
          }

          // معالجة اختيار الطفل
          if (state is PorfileChildSelected) {
            showAppToast(
              message: 'تم اختيار الطفل ${state.selectedChild.name} بنجاح!',
              type: ToastType.success,
            );
            // إغلاق الصفحة بعد الاختيار لإعادة تحميل الشاشة الرئيسية
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

            // تعريف المتغيرات (لتقليل التكرار)
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
            final parentUser = state is PorfileChildrenLoaded
                ? state.currentParentUser
                : null;
            final parentName = parentUser?.name ?? 'ولي الأمر';
            final parentEmail = parentUser?.email ?? 'غير متوفر';

            // المحتوى الحساس يعرض فقط بعد منح الوصول
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
                        icons: Icons.email_rounded,
                        iconStyle: IconStyle(
                          iconsColor: Colors.white,
                          withBackground: true,
                          borderRadius: 50,
                          backgroundColor: Colors.blueAccent.shade700,
                        ),
                        title: "البريد الإلكتروني",
                        subtitle: parentEmail,
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
                        // زر تبديل تفعيل/إلغاء حماية الدخول بالبصمة
                        SettingsItem(
                          onTap: () {},
                          icons: isSettingsProtected
                              ? CupertinoIcons.map_pin_ellipse
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

                        // زر وضع الطفل Kiosk Mode)
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
                          subtitle: "تثبيت التطبيق على الشاشة لمنع الخروج",
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
                                final isSelected = child.id == selectedChildId;
                                return SettingsItem(
                                  onTap: () {
                                    bloc.add(SelectChild(child));
                                  },
                                  icons: CupertinoIcons.person_alt_circle_fill,
                                  title: child.name,
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
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.check_circle,
                                              color: Colors.blue,
                                              size: 24,
                                            ),
                                            IconButton(
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
                                                  bloc.add(const ForceReload());
                                                }
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete_forever_rounded,
                                                size: 20,
                                                color: Colors.red,
                                              ),
                                              onPressed: () async {
                                                showDeleteConfirmationDialog(
                                                  context: context,
                                                  itemName:
                                                      "ملف الطفل ${child.name}",
                                                  onConfirm: () {
                                                    bloc.add(
                                                      DeleteChild(child.id),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
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
                                              bloc.add(const ForceReload());
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
                            showDeleteConfirmationDialog(
                              context: context,
                              itemName: "حسابك",
                              onConfirm: () {
                                bloc.add(const DeleteAcount());
                              },
                            );
                          },
                          icons: Icons.delete_forever_rounded,
                          title: "حذف الحساب",
                          titleStyle: const TextStyle(color: Colors.red),
                        ),
                        SettingsItem(
                          onTap: () {
                            showLogoutConfirmationDialog(
                              context: context,
                              onConfirmLogout: () {
                                bloc.add(const LogoutRequested());
                              },
                            );
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
  }
}
