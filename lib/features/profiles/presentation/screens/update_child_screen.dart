import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:la3bob/core/comon/helper_function/toast_helper.dart';
import 'package:la3bob/core/comon/theme/app_color.dart';
import 'package:la3bob/core/di/injection.dart';
import 'package:la3bob/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:la3bob/features/profiles/domain/entities/child_entity.dart';
import 'package:la3bob/features/profiles/domain/usecase/profile_usecase.dart';
import 'package:la3bob/features/profiles/presentation/bloc/porfile_bloc.dart';
import 'package:la3bob/features/profiles/presentation/widgets/interests_selector.dart';

class UpdateChildScreen extends StatelessWidget {
  final ChildEntity child;

  const UpdateChildScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final Set<String> selectedInterests = {...child.intersets};

    return BlocProvider(
      create: (_) =>
          PorfileBloc(getIt<ProfileUsecase>(), getIt<AuthUseCases>())
            ..add(PopulateChildForm(child)),
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
              'تعديل بيانات الطفل',
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
                Navigator.of(context).pop(true);
              } else if (state is PorfileError) {
                showAppToast(
                  message: state.failure.message,
                  type: ToastType.failure,
                );
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
                        CircularProgressIndicator(
                          color: AppColors.accent,
                          strokeWidth: 3,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'جاري الحفظ...',
                          style: TextStyle(
                            fontSize: 12.dp,
                            color: AppColors.textSecondary,
                          ),
                        ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4.w),
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
                                SizedBox(height: 2.h),
                                Text(
                                  'تعديل بيانات ${child.name}',
                                  style: TextStyle(
                                    fontSize: 16.dp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  'قم بتحديث معلومات الطفل',
                                  style: TextStyle(
                                    fontSize: 10.dp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        TextFormField(
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          controller: bloc.nameController,
                          enabled: !isLoading,
                          decoration: InputDecoration(
                            labelText: 'اسم الطفل',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.accent,
                                width: 2,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: AppColors.accent,
                            ),
                          ),
                          textDirection: TextDirection.rtl,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'الرجاء إدخال اسم الطفل';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 2.h),
                        TextFormField(
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          controller: bloc.ageController,
                          enabled: !isLoading,
                          decoration: InputDecoration(
                            labelText: 'عمر الطفل',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.accent,
                                width: 2,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.cake_outlined,
                              color: AppColors.accent,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          textDirection: TextDirection.rtl,
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
                                        message:
                                            'الرجاء اختيار اهتمام واحد على الأقل',
                                        type: ToastType.failure,
                                      );
                                      return;
                                    }
                                    bloc.intersetsController.text =
                                        selectedInterests.join(', ');
                                    bloc.add(
                                      UpdateChildForm(
                                        childId: child.id,
                                        childName: bloc.nameController.text
                                            .trim(),
                                        childAge: bloc.ageController.text
                                            .trim(),
                                        childIntersets: bloc
                                            .intersetsController
                                            .text
                                            .trim(),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save_outlined, size: 6.w),
                              SizedBox(width: 2.w),
                              Text(
                                'حفظ التعديلات',
                                style: TextStyle(
                                  fontSize: 14.dp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
