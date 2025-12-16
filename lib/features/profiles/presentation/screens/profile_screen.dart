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
            style: TextStyle(
              fontSize: 18.dp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.white),
            onPressed: () async {
              final result = await Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const AddChildScreen()));
              if (result == true) bloc.add(const ForceReload());
            },
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundStart,
              AppColors.backgroundMiddle,
              AppColors.backgroundEnd,
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: BlocListener<PorfileBloc, PorfileState>(
          listener: (context, state) {
            if (state is PorfileSuccess) {
              showAppToast(message: state.message, type: ToastType.success);
              if (state.message == 'تم تسجيل الخروج بنجاح' ||
                  state.message ==
                      'تم حذف الحساب بنجاح. نأمل أن نراك مرة أخرى قريبًا!') {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            }
            if (state is PorfileError) {
              showAppToast(
                message: state.failure.message,
                type: ToastType.failure,
              );
            }
            if (state is PorfileChildrenLoaded &&
                state.accessStatus == AccessStatus.denied) {
              Navigator.of(context).pop();
            }
            if (state is PorfileChildSelected) {
              showAppToast(
                message: 'تم اختيار الطفل ${state.selectedChild.name} بنجاح!',
                type: ToastType.success,
              );
              Navigator.of(context).pop(true);
            }
          },
          child: BlocBuilder<PorfileBloc, PorfileState>(
            builder: (context, state) {
              if (state is PorfileLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: AppColors.accent,
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'جاري التحميل...',
                        style: TextStyle(
                          fontSize: 12.dp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final children = state is PorfileChildrenLoaded
                  ? state.children
                  : [];
              final isLoaded = state is PorfileChildrenLoaded;
              final isLockActive = isLoaded
                  ? (state as PorfileChildrenLoaded).isChildLockModeActive
                  : false;
              final isSettingsProtected = isLoaded
                  ? (state as PorfileChildrenLoaded).isSettingsProtected
                  : false;
              final selectedChildId = isLoaded
                  ? (state as PorfileChildrenLoaded).selectedChildId
                  : null;
              final parentUser = isLoaded
                  ? (state as PorfileChildrenLoaded).currentParentUser
                  : null;
              final parentName = parentUser?.name ?? 'ولي الأمر';
              final parentEmail = parentUser?.email ?? 'غير متوفر';

              return ListView(
                padding: EdgeInsets.all(4.w),
                children: [
                  Card(
                    elevation: 6,
                    shadowColor: AppColors.accent.withValues(alpha: .3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.cardBackground,
                      ),
                      padding: EdgeInsets.all(5.w),
                      child: Row(
                        children: [
                          Container(
                            width: 18.w,
                            height: 18.w,
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: .2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.accent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '👨‍👧‍👦',
                                style: TextStyle(fontSize: 8.w),
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  parentName,
                                  style: TextStyle(
                                    fontSize: 16.dp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.email_outlined,
                                      color: AppColors.textSecondary,
                                      size: 4.w,
                                    ),
                                    SizedBox(width: 1.w),
                                    Expanded(
                                      child: Text(
                                        parentEmail,
                                        style: TextStyle(
                                          fontSize: 10.dp,
                                          color: AppColors.textSecondary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 3.w,
                                    vertical: 0.8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.child_care,
                                        color: Colors.white,
                                        size: 4.w,
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        '${children.length} أطفال',
                                        style: TextStyle(
                                          fontSize: 9.dp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
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

                  SizedBox(height: 2.5.h),

                  Padding(
                    padding: EdgeInsets.only(right: 1.w),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.5.w),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: .15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            CupertinoIcons.shield_fill,
                            color: AppColors.accent,
                            size: 5.w,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'أدوات الرقابة الأبوية',
                          style: TextStyle(
                            fontSize: 14.dp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Card(
                    elevation: 3,
                    shadowColor: AppColors.accent.withValues(alpha: .1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.5.w),
                                decoration: BoxDecoration(
                                  color: isSettingsProtected
                                      ? AppColors.accent.withValues(alpha: .2)
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: isSettingsProtected
                                      ? Border.all(
                                          color: AppColors.accent,
                                          width: 1.5,
                                        )
                                      : null,
                                ),
                                child: Icon(
                                  isSettingsProtected
                                      ? CupertinoIcons.hand_raised_fill
                                      : CupertinoIcons.hand_raised,
                                  color: isSettingsProtected
                                      ? AppColors.accent
                                      : Colors.grey,
                                  size: 5.5.w,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isSettingsProtected
                                          ? "حماية البصمة مفعلة"
                                          : "تفعيل حماية الدخول",
                                      style: TextStyle(
                                        fontSize: 12.dp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 0.3.h),
                                    Text(
                                      "المصادقة البيومترية عند دخول الإعدادات",
                                      style: TextStyle(
                                        fontSize: 9.dp,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch.adaptive(
                                value: isSettingsProtected,
                                activeColor: AppColors.accent,
                                onChanged: (val) {
                                  if (isLoaded)
                                    bloc.add(
                                      SaveSettingsProtectionEvent(
                                        isProtected: val,
                                      ),
                                    );
                                },
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          indent: 16.w,
                          endIndent: 4.w,
                          color: Colors.grey.shade200,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.5.w),
                                decoration: BoxDecoration(
                                  color: isLockActive
                                      ? AppColors.accent.withValues(alpha: .2)
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: isLockActive
                                      ? Border.all(
                                          color: AppColors.accent,
                                          width: 1.5,
                                        )
                                      : null,
                                ),
                                child: Icon(
                                  isLockActive
                                      ? CupertinoIcons.lock_fill
                                      : CupertinoIcons.lock_open,
                                  color: isLockActive
                                      ? AppColors.accent
                                      : Colors.grey,
                                  size: 5.5.w,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isLockActive
                                          ? "وضع القفل مفعل"
                                          : "تفعيل وضع القفل",
                                      style: TextStyle(
                                        fontSize: 12.dp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 0.3.h),
                                    Text(
                                      "تثبيت التطبيق على الشاشة لمنع الخروج",
                                      style: TextStyle(
                                        fontSize: 9.dp,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch.adaptive(
                                value: isLockActive,
                                activeColor: AppColors.accent,
                                onChanged: (val) =>
                                    bloc.add(ToggleChildLockMode(val)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.5.h),

                  Padding(
                    padding: EdgeInsets.only(right: 1.w),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.5.w),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: .15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            CupertinoIcons.person_2_fill,
                            color: AppColors.accent,
                            size: 5.w,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'ملفات الأطفال',
                          style: TextStyle(
                            fontSize: 14.dp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.5.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: .15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${children.length}',
                            style: TextStyle(
                              fontSize: 11.dp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Card(
                    elevation: 3,
                    shadowColor: AppColors.accent.withValues(alpha: .1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: children.isEmpty
                        ? Padding(
                            padding: EdgeInsets.all(8.w),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withValues(
                                      alpha: .15,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.child_care,
                                    size: 12.w,
                                    color: AppColors.accent,
                                  ),
                                ),
                                SizedBox(height: 2.5.h),
                                Text(
                                  'لا يوجد أطفال مسجلون',
                                  style: TextStyle(
                                    fontSize: 14.dp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  'اضغط على زر الإضافة أعلاه لإضافة طفل',
                                  style: TextStyle(
                                    fontSize: 10.dp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                        vertical: 1.5.h,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(2.5.w),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? AppColors.accent.withValues(
                                                      alpha: .2,
                                                    )
                                                  : Colors.grey.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: isSelected
                                                  ? Border.all(
                                                      color: AppColors.accent,
                                                      width: 2,
                                                    )
                                                  : null,
                                            ),
                                            child: Icon(
                                              CupertinoIcons.person_fill,
                                              color: isSelected
                                                  ? AppColors.accent
                                                  : Colors.grey,
                                              size: 5.w,
                                            ),
                                          ),
                                          SizedBox(width: 3.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      child.name,
                                                      style: TextStyle(
                                                        fontSize: 13.dp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors
                                                            .textPrimary,
                                                      ),
                                                    ),
                                                    if (isSelected) ...[
                                                      SizedBox(width: 2.w),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 2.w,
                                                              vertical: 0.3.h,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              AppColors.accent,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          'مختار',
                                                          style: TextStyle(
                                                            fontSize: 8.dp,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                                Text(
                                                  'العمر: ${child.age} سنوات',
                                                  style: TextStyle(
                                                    fontSize: 10.dp,
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                ),
                                                if (child.intersets != null &&
                                                    (child.intersets as List)
                                                        .isNotEmpty)
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      top: 0.8.h,
                                                    ),
                                                    child: Wrap(
                                                      spacing: 1.w,
                                                      children:
                                                          (child.intersets
                                                                  as List<
                                                                    String
                                                                  >)
                                                              .take(3)
                                                              .map(
                                                                (
                                                                  i,
                                                                ) => Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        2.w,
                                                                    vertical:
                                                                        0.3.h,
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                    color: AppColors
                                                                        .accent
                                                                        .withValues(
                                                                          alpha:
                                                                              .15,
                                                                        ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                  ),
                                                                  child: Text(
                                                                    i,
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          8.dp,
                                                                      color: AppColors
                                                                          .textPrimary,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                              .toList(),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            icon: Icon(
                                              CupertinoIcons.ellipsis,
                                              color: Colors.grey.shade600,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            onSelected: (value) async {
                                              if (value == 'edit') {
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
                                                if (result == true)
                                                  bloc.add(const ForceReload());
                                              } else if (value == 'delete') {
                                                showDeleteConfirmationDialog(
                                                  context: context,
                                                  itemName:
                                                      "ملف الطفل ${child.name}",
                                                  onConfirm: () => bloc.add(
                                                    DeleteChild(child.id),
                                                  ),
                                                );
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                value: 'edit',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.edit,
                                                      size: 5.w,
                                                      color: AppColors.accent,
                                                    ),
                                                    SizedBox(width: 2.w),
                                                    const Text('تعديل'),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 'delete',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons.delete,
                                                      color: AppColors.error,
                                                      size: 5.w,
                                                    ),
                                                    SizedBox(width: 2.w),
                                                    Text(
                                                      'حذف',
                                                      style: TextStyle(
                                                        color: AppColors.error,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (index < children.length - 1)
                                    Divider(
                                      height: 1,
                                      indent: 15.w,
                                      color: Colors.grey.shade200,
                                    ),
                                ],
                              );
                            }).toList(),
                          ),
                  ),

                  SizedBox(height: 2.5.h),

                  Padding(
                    padding: EdgeInsets.only(right: 1.w),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.5.w),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: .15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.manage_accounts,
                            color: AppColors.error,
                            size: 5.w,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'إدارة الحساب',
                          style: TextStyle(
                            fontSize: 14.dp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Card(
                    elevation: 3,
                    shadowColor: AppColors.error.withValues(alpha: .1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => showDeleteConfirmationDialog(
                            context: context,
                            itemName: "حسابك",
                            onConfirm: () => bloc.add(const DeleteAcount()),
                          ),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 2.h,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2.5.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withValues(
                                      alpha: .1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.delete,
                                    color: AppColors.error,
                                    size: 5.5.w,
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "حذف الحساب",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.error,
                                        ),
                                      ),
                                      SizedBox(height: 0.3.h),
                                      Text(
                                        "حذف جميع البيانات نهائياً",
                                        style: TextStyle(
                                          fontSize: 9.dp,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 4.w,
                                  color: Colors.grey.shade400,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          indent: 16.w,
                          endIndent: 4.w,
                          color: Colors.grey.shade200,
                        ),
                        InkWell(
                          onTap: () => showLogoutConfirmationDialog(
                            context: context,
                            onConfirmLogout: () =>
                                bloc.add(const LogoutRequested()),
                          ),
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(16),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2.5.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withValues(
                                      alpha: .1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.logout_rounded,
                                    color: AppColors.error,
                                    size: 5.5.w,
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Text(
                                    "تسجيل الخروج",
                                    style: TextStyle(
                                      fontSize: 12.dp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.error,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 4.w,
                                  color: Colors.grey.shade400,
                                ),
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
