import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:la3bob/core/comon/helper_function/dialog_helper.dart';
import 'package:la3bob/core/comon/helper_function/toast_helper.dart';
import 'package:la3bob/core/comon/theme/app_color.dart';
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
        backgroundColor: AppColors.accent,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        title: Center(
          child: Text(
            "الملف الشخصي",
            style: TextStyle(fontSize: 18.dp, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.white),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddChildScreen()),
              );
              if (result == true) bloc.add(const ForceReload());
            },
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.backgroundStart, AppColors.backgroundMiddle, AppColors.backgroundEnd],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: BlocListener<PorfileBloc, PorfileState>(
          listener: (context, state) {
            if (state is PorfileSuccess) {
              showAppToast(message: state.message, type: ToastType.success);
              if (state.message == 'تم تسجيل الخروج بنجاح' ||
                  state.message == 'تم حذف الحساب بنجاح. نأمل أن نراك مرة أخرى قريبًا!') {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            }
            if (state is PorfileError) {
              showAppToast(message: state.failure.message, type: ToastType.failure);
            }
            if (state is PorfileChildrenLoaded && state.accessStatus == AccessStatus.denied) {
              Navigator.of(context).pop();
            }
            if (state is PorfileChildSelected) {
              showAppToast(message: 'تم اختيار الطفل ${state.selectedChild.name} بنجاح!', type: ToastType.success);
              Navigator.of(context).pop(true);
            }
          },
          child: BlocBuilder<PorfileBloc, PorfileState>(
            builder: (context, state) {
              if (state is PorfileLoading) {
                return Center(child: CircularProgressIndicator(color: AppColors.accent, strokeWidth: 3));
              }

              final children = state is PorfileChildrenLoaded ? state.children : [];
              final isLoaded = state is PorfileChildrenLoaded;
              final isLockActive = isLoaded ? (state as PorfileChildrenLoaded).isChildLockModeActive : false;
              final isSettingsProtected = isLoaded ? (state as PorfileChildrenLoaded).isSettingsProtected : false;
              final selectedChildId = isLoaded ? (state as PorfileChildrenLoaded).selectedChildId : null;
              final parentUser = isLoaded ? (state as PorfileChildrenLoaded).currentParentUser : null;
              final parentName = parentUser?.name ?? 'ولي الأمر';
              final parentEmail = parentUser?.email ?? 'غير متوفر';
              final selectedChild = selectedChildId != null && children.isNotEmpty
                  ? children.cast().firstWhere((c) => c.id == selectedChildId, orElse: () => null)
                  : null;

              return ListView(
                padding: EdgeInsets.all(4.w),
                children: [
                  Card(
                    elevation: 8,
                    shadowColor: AppColors.accent.withValues(alpha: .4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [AppColors.accent, AppColors.accent.withValues(alpha: .85)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: EdgeInsets.all(5.w),
                      child: Row(
                        children: [
                          Container(
                            width: 18.w,
                            height: 18.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                            ),
                            child: Center(child: Text('👨‍👧‍👦', style: TextStyle(fontSize: 8.w))),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(parentName, style: TextStyle(fontSize: 16.dp, fontWeight: FontWeight.bold, color: Colors.white)),
                                SizedBox(height: 0.5.h),
                                Row(
                                  children: [
                                    Icon(Icons.email_outlined, color: Colors.white70, size: 4.w),
                                    SizedBox(width: 1.w),
                                    Expanded(child: Text(parentEmail, style: TextStyle(fontSize: 10.dp, color: Colors.white70), overflow: TextOverflow.ellipsis)),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: .2), borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.child_care, color: Colors.white, size: 4.w),
                                      SizedBox(width: 1.w),
                                      Text('${children.length} أطفال', style: TextStyle(fontSize: 9.dp, color: Colors.white, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  if (selectedChild != null)
                    Card(
                      elevation: 4,
                      shadowColor: Colors.green.withValues(alpha: .3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.green.shade400, width: 2),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.5.w),
                              decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                              child: Icon(Icons.child_care, color: Colors.green.shade700, size: 7.w),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green, size: 4.w),
                                      SizedBox(width: 1.w),
                                      Text('الطفل النشط', style: TextStyle(fontSize: 9.dp, color: Colors.green.shade700, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                  Text(selectedChild.name, style: TextStyle(fontSize: 14.dp, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                  Text('العمر: ${selectedChild.age} سنوات', style: TextStyle(fontSize: 10.dp, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            Icon(Icons.star, color: Colors.amber, size: 6.w),
                          ],
                        ),
                      ),
                    ),

                  if (selectedChild != null) SizedBox(height: 2.h),

                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(color: Colors.blue.withValues(alpha: .15), borderRadius: BorderRadius.circular(10)),
                        child: Icon(CupertinoIcons.shield_fill, color: Colors.blue, size: 5.w),
                      ),
                      SizedBox(width: 2.w),
                      Text('أدوات الرقابة الأبوية', style: TextStyle(fontSize: 13.dp, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.5.w),
                                decoration: BoxDecoration(
                                  color: (isSettingsProtected ? Colors.green.shade700 : Colors.grey).withValues(alpha: .15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(isSettingsProtected ? CupertinoIcons.hand_raised_fill : CupertinoIcons.hand_raised,
                                    color: isSettingsProtected ? Colors.green.shade700 : Colors.grey, size: 5.w),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(isSettingsProtected ? "حماية البصمة مفعلة" : "تفعيل حماية الدخول",
                                        style: TextStyle(fontSize: 12.dp, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                    Text("المصادقة البيومترية عند دخول الإعدادات", style: TextStyle(fontSize: 9.dp, color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                              Switch.adaptive(value: isSettingsProtected, activeColor: Colors.green, onChanged: (val) {
                                if (isLoaded) bloc.add(SaveSettingsProtectionEvent(isProtected: val));
                              }),
                            ],
                          ),
                        ),
                        Divider(height: 1, indent: 15.w),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.5.w),
                                decoration: BoxDecoration(
                                  color: (isLockActive ? Colors.green.shade700 : Colors.grey).withValues(alpha: .15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(isLockActive ? CupertinoIcons.lock_fill : CupertinoIcons.lock_open,
                                    color: isLockActive ? Colors.green.shade700 : Colors.grey, size: 5.w),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(isLockActive ? "وضع القفل مفعل" : "تفعيل وضع القفل",
                                        style: TextStyle(fontSize: 12.dp, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                    Text("تثبيت التطبيق على الشاشة لمنع الخروج", style: TextStyle(fontSize: 9.dp, color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                              Switch.adaptive(value: isLockActive, activeColor: Colors.green, onChanged: (val) => bloc.add(ToggleChildLockMode(val))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.5.h),

                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(color: Colors.purple.withValues(alpha: .15), borderRadius: BorderRadius.circular(10)),
                        child: Icon(CupertinoIcons.person_2_fill, color: Colors.purple, size: 5.w),
                      ),
                      SizedBox(width: 2.w),
                      Text('ملفات الأطفال (${children.length})', style: TextStyle(fontSize: 13.dp, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: children.isEmpty
                        ? Padding(
                            padding: EdgeInsets.all(6.w),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4.w),
                                  decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                                  child: Icon(Icons.child_care, size: 10.w, color: Colors.grey.shade400),
                                ),
                                SizedBox(height: 2.h),
                                Text('لا يوجد أطفال مسجلون', style: TextStyle(fontSize: 13.dp, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                Text('اضغط على زر الإضافة أعلاه', style: TextStyle(fontSize: 10.dp, color: AppColors.textSecondary)),
                              ],
                            ),
                          )
                        : Column(
                            children: children.asMap().entries.map((entry) {
                              final index = entry.key;
                              final child = entry.value;
                              final isSelected = child.id == selectedChildId;
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () => bloc.add(SelectChild(child)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(2.5.w),
                                            decoration: BoxDecoration(
                                              color: isSelected ? Colors.green.shade50 : Colors.grey.shade100,
                                              borderRadius: BorderRadius.circular(12),
                                              border: isSelected ? Border.all(color: Colors.green, width: 2) : null,
                                            ),
                                            child: Icon(CupertinoIcons.person_fill, color: isSelected ? Colors.green.shade700 : Colors.grey, size: 5.w),
                                          ),
                                          SizedBox(width: 3.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(child.name, style: TextStyle(fontSize: 13.dp, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                                    if (isSelected) ...[
                                                      SizedBox(width: 2.w),
                                                      Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                                                        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                                                        child: Text('مختار', style: TextStyle(fontSize: 8.dp, color: Colors.white, fontWeight: FontWeight.bold)),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                                Text('العمر: ${child.age} سنوات', style: TextStyle(fontSize: 10.dp, color: AppColors.textSecondary)),
                                                if (child.intersets != null && (child.intersets as List).isNotEmpty)
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 0.8.h),
                                                    child: Wrap(
                                                      spacing: 1.w,
                                                      children: (child.intersets as List<String>).take(3).map((i) => Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                                                        decoration: BoxDecoration(color: AppColors.categoryChipBackground, borderRadius: BorderRadius.circular(8)),
                                                        child: Text(i, style: TextStyle(fontSize: 8.dp, color: AppColors.textPrimary)),
                                                      )).toList(),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            icon: Icon(CupertinoIcons.ellipsis, color: Colors.grey.shade600),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            onSelected: (value) async {
                                              if (value == 'edit') {
                                                final result = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => UpdateChildScreen(child: child)));
                                                if (result == true) bloc.add(const ForceReload());
                                              } else if (value == 'delete') {
                                                showDeleteConfirmationDialog(context: context, itemName: "ملف الطفل ${child.name}", onConfirm: () => bloc.add(DeleteChild(child.id)));
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 5.w), SizedBox(width: 2.w), const Text('تعديل')])),
                                              PopupMenuItem(value: 'delete', child: Row(children: [Icon(CupertinoIcons.delete, color: Colors.red, size: 5.w), SizedBox(width: 2.w), const Text('حذف', style: TextStyle(color: Colors.red))])),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (index < children.length - 1) Divider(height: 1, indent: 15.w),
                                ],
                              );
                            }).toList(),
                          ),
                  ),

                  SizedBox(height: 2.5.h),

                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(color: Colors.red.withValues(alpha: .15), borderRadius: BorderRadius.circular(10)),
                        child: Icon(Icons.manage_accounts, color: Colors.red, size: 5.w),
                      ),
                      SizedBox(width: 2.w),
                      Text('إدارة الحساب', style: TextStyle(fontSize: 13.dp, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => showDeleteConfirmationDialog(context: context, itemName: "حسابك", onConfirm: () => bloc.add(const DeleteAcount())),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2.5.w),
                                  decoration: BoxDecoration(color: Colors.red.shade400.withValues(alpha: .15), borderRadius: BorderRadius.circular(12)),
                                  child: Icon(CupertinoIcons.delete, color: Colors.red.shade400, size: 5.w),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(child: Text("حذف الحساب", style: TextStyle(fontSize: 12.dp, fontWeight: FontWeight.w600, color: Colors.red.shade400))),
                                Icon(Icons.arrow_forward_ios, size: 4.w, color: Colors.grey.shade400),
                              ],
                            ),
                          ),
                        ),
                        Divider(height: 1, indent: 15.w),
                        InkWell(
                          onTap: () => showLogoutConfirmationDialog(context: context, onConfirmLogout: () => bloc.add(const LogoutRequested())),
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2.5.w),
                                  decoration: BoxDecoration(color: Colors.red.shade700.withValues(alpha: .15), borderRadius: BorderRadius.circular(12)),
                                  child: Icon(Icons.logout_rounded, color: Colors.red.shade700, size: 5.w),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(child: Text("تسجيل الخروج", style: TextStyle(fontSize: 12.dp, fontWeight: FontWeight.bold, color: Colors.red.shade700))),
                                Icon(Icons.arrow_forward_ios, size: 4.w, color: Colors.grey.shade400),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
