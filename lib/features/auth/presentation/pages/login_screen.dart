import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:la3bob/core/comon/helper_function/toast_helper.dart';
import 'package:la3bob/core/comon/theme/app_color.dart';
import 'package:la3bob/features/auth/presentation/bloc/auth_bloc/cubit/auth_cubit.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
String _email = '';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<AuthCubit>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.accent,
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          title: Center(
            child: Text(
              "تسجيل الدخول",
              style: TextStyle(
                fontSize: 18.dp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
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
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is OtpSent) {
                context.go('/verify', extra: _email);
              } else if (state is AuthFailureState) {
                showAppToast(
                  message: state.failure.message,
                  type: ToastType.failure,
                );
              }
            },
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // الشعار
                        Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: .3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text('🎮', style: TextStyle(fontSize: 15.w)),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        Text(
                          'لعبوب',
                          style: TextStyle(
                            fontSize: 32.dp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        SizedBox(height: 1.h),

                        Text(
                          'أدخل بريدك الإلكتروني لتسجيل الدخول',
                          style: TextStyle(
                            fontSize: 12.dp,
                            color: AppColors.textSecondary,
                          ),
                        ),

                        SizedBox(height: 5.h),

                        Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(5.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'البريد الإلكتروني',
                                  style: TextStyle(
                                    fontSize: 13.dp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),

                                SizedBox(height: 1.5.h),

                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(fontSize: 14.dp),
                                  decoration: InputDecoration(
                                    hintText: 'example@email.com',
                                    hintStyle: TextStyle(
                                      color: AppColors.textSecondary.withValues(
                                        alpha: .5,
                                      ),
                                      fontSize: 12.dp,
                                    ),
                                    filled: true,
                                    fillColor: AppColors.categoryChipBackground
                                        .withValues(alpha: .3),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                        color: AppColors.primary,
                                        width: 2,
                                      ),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                      color: AppColors.primary,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                      vertical: 2.h,
                                    ),
                                  ),
                                  onChanged: (value) => _email = value,
                                  validator: (value) =>
                                      value!.isEmpty || !value.contains('@')
                                      ? 'الرجاء إدخال بريد إلكتروني صحيح'
                                      : null,
                                ),

                                SizedBox(height: 3.h),

                                BlocBuilder<AuthCubit, AuthState>(
                                  builder: (context, state) {
                                    final isSubmitting = state is AuthLoading;

                                    return SizedBox(
                                      width: double.infinity,
                                      height: 7.h,
                                      child: ElevatedButton(
                                        onPressed: isSubmitting
                                            ? null
                                            : () => _submitLogin(context),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                        ),
                                        child: isSubmitting
                                            ? SizedBox(
                                                width: 6.w,
                                                height: 6.w,
                                                child:
                                                    const CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 3,
                                                    ),
                                              )
                                            : Text(
                                                'تسجيل الدخول',
                                                style: TextStyle(
                                                  fontSize: 16.dp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ليس لديك حساب؟',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12.dp,
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go('/signup'),
                              child: Text(
                                'إنشاء حساب',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.dp,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<AuthCubit>().signIn(email: _email.trim());
    }
  }
}
