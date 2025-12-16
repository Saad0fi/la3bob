import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';
import 'package:la3bob/core/comon/helper_function/toast_helper.dart';
import 'package:la3bob/core/comon/theme/app_color.dart';
import 'package:la3bob/core/di/injection.dart';
import 'package:la3bob/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:la3bob/features/profiles/domain/usecase/profile_usecase.dart';
import 'package:la3bob/features/profiles/presentation/bloc/porfile_bloc.dart';
import 'package:la3bob/features/profiles/presentation/widgets/interests_selector.dart';

class AddChildScreen extends StatelessWidget {
  const AddChildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final Set<String> selectedInterests = <String>{};

    return BlocProvider(
      create: (context) => PorfileBloc(getIt<ProfileUsecase>(), getIt<AuthUseCases>()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.accent,
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Center(
            child: Text(
              'إضافة طفل',
              style: TextStyle(
                fontSize: 18.dp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          actions: [SizedBox(width: 12.w)],
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
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop(true);
                } else {
                  context.go('/tabs/videos');
                }
              } else if (state is PorfileError) {
                showAppToast(message: state.failure.message, type: ToastType.failure);
              }
            },
            child: BlocBuilder<PorfileBloc, PorfileState>(
              builder: (context, state) {
                final bloc = context.read<PorfileBloc>();
                final isLoading = state is PorfileLoading;

                if (isLoading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.accent, strokeWidth: 3),
                        SizedBox(height: 2.h),
                        Text('جاري الإضافة...', style: TextStyle(fontSize: 12.dp, color: AppColors.textSecondary)),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 2.h),
                        Card(
                          elevation: 4,
                          shadowColor: AppColors.accent.withValues(alpha: .2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withValues(alpha: .15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.child_care, size: 12.w, color: AppColors.accent),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'معلومات الطفل',
                                  style: TextStyle(fontSize: 16.dp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  'أدخل بيانات الطفل لإضافته',
                                  style: TextStyle(fontSize: 10.dp, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        TextFormField(
                          controller: bloc.nameController,
                          enabled: !isLoading,
                          decoration: InputDecoration(
                            labelText: 'اسم الطفل',
                            hintText: 'أدخل اسم الطفل',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.accent, width: 2),
                            ),
                            prefixIcon: Icon(Icons.person, color: AppColors.accent),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'الرجاء إدخال اسم الطفل';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 2.h),
                        TextFormField(
                          controller: bloc.ageController,
                          enabled: !isLoading,
                          decoration: InputDecoration(
                            labelText: 'عمر الطفل',
                            hintText: 'أدخل عمر الطفل (3-12)',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.accent, width: 2),
                            ),
                            prefixIcon: Icon(Icons.cake, color: AppColors.accent),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'الرجاء إدخال عمر الطفل';
                            }
                            final age = int.tryParse(value);
                            if (age == null || age < 3 || age > 12) {
                              return 'الرجاء إدخال عمر صحيح (من 3 إلى 12)';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 2.h),
                        InterestsSelector(
                          selectedInterests: selectedInterests,
                          onChanged: (interests) {
                            selectedInterests
                              ..clear()
                              ..addAll(interests);
                          },
                        ),
                        SizedBox(height: 4.h),
                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    if (selectedInterests.isEmpty) {
                                      showAppToast(
                                        message: 'الرجاء اختيار اهتمام واحد على الأقل',
                                        type: ToastType.failure,
                                      );
                                      return;
                                    }
                                    bloc.intersetsController.text = selectedInterests.join(', ');
                                    bloc.add(
                                      SubmitChildForm(
                                        childName: bloc.nameController.text.trim(),
                                        childAge: bloc.ageController.text.trim(),
                                        childIntersets: bloc.intersetsController.text.trim(),
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            elevation: 4,
                            shadowColor: AppColors.accent.withValues(alpha: .4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline, size: 6.w),
                              SizedBox(width: 2.w),
                              Text('إضافة الطفل', style: TextStyle(fontSize: 14.dp, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
