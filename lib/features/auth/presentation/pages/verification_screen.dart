import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:la3bob/core/comon/helper_function/toast_helper.dart';
import 'package:la3bob/core/comon/theme/app_color.dart';
import 'package:la3bob/features/auth/presentation/bloc/auth_bloc/cubit/auth_cubit.dart';
import 'package:la3bob/features/auth/presentation/bloc/timer_bloc/cubit/timer_cubit.dart';
import 'package:la3bob/features/auth/presentation/bloc/timer_bloc/cubit/timer_state.dart';
import 'package:pinput/pinput.dart';

final GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();

class VerificationScreen extends StatelessWidget {
  final String email;

  const VerificationScreen({required this.email, super.key});

  @override
  Widget build(BuildContext context) {
    // إعدادات الثيم ل Pinput
    final defaultPinTheme = PinTheme(
      width: 12.w,
      height: 14.w,
      textStyle: TextStyle(
        fontSize: 20.dp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: AppColors.categoryChipBackground.withValues(alpha: .3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.categoryChipBackground),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primary, width: 2),
      borderRadius: BorderRadius.circular(14),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: AppColors.categoryChipBackground.withValues(alpha: .5),
        border: Border.all(color: AppColors.primary),
      ),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetIt.I<AuthCubit>()),
        //  هنا التايمر كيوبت المسؤول عن التايمر TimerCubit وبدء العداد
        BlocProvider(create: (context) => TimerCubit()..startTimer()),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.accent,
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.go('/login'),
          ),
          title: Center(
            child: Text(
              "تأكيد الرمز",
              style: TextStyle(
                fontSize: 18.dp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          actions: [SizedBox(width: 12.w)],
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
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
              if (state is AuthenticatedWithChildren) {
                context.go('/tabs/videos');
              } else if (state is AuthenticatedNoChildren) {
                context.go('/add-child');
              } else if (state is Authenticated) {
                context.go('/tabs/videos');
              } else if (state is AuthFailureState) {
                showAppToast(
                  message: state.failure.message,
                  type: ToastType.failure,
                );
                _otpFormKey.currentState?.reset();
              } else if (state is OtpSent) {
                showAppToast(
                  message: "تم إعادة ارسال الرمز بنجاح",
                  type: ToastType.success,
                );
                context.read<TimerCubit>().startTimer();
              }
            },
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Form(
                    key: _otpFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // الأيقونة
                        Container(
                          width: 25.w,
                          height: 25.w,
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
                            child: Text('📧', style: TextStyle(fontSize: 12.w)),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        Text(
                          'التحقق من البريد الإلكتروني',
                          style: TextStyle(
                            fontSize: 20.dp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        SizedBox(height: 1.h),

                        Text(
                          'لقد أرسلنا الرمز إلى',
                          style: TextStyle(
                            fontSize: 12.dp,
                            color: AppColors.textSecondary,
                          ),
                        ),

                        SizedBox(height: 0.5.h),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.categoryChipBackground,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            email,
                            style: TextStyle(
                              fontSize: 12.dp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),

                        SizedBox(height: 4.h),

                        // كارت إدخال الرمز
                        Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(5.w),
                            child: Column(
                              children: [
                                Text(
                                  'أدخل رمز التحقق',
                                  style: TextStyle(
                                    fontSize: 14.dp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),

                                SizedBox(height: 3.h),

                                //  فيلد ال Pinput (يستمع لحالة التحميل من AuthCubit)
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: BlocBuilder<AuthCubit, AuthState>(
                                    builder: (context, state) {
                                      final isLoading = state is AuthLoading;
                                      return Pinput(
                                        length: 6,
                                        defaultPinTheme: defaultPinTheme,
                                        focusedPinTheme: focusedPinTheme,
                                        submittedPinTheme: submittedPinTheme,
                                        pinputAutovalidateMode:
                                            PinputAutovalidateMode.onSubmit,
                                        onCompleted: (pin) {
                                          if (!isLoading) {
                                            context.read<AuthCubit>().verifyOtp(
                                              email: email,
                                              token: pin,
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),

                                SizedBox(height: 3.h),

                                BlocBuilder<AuthCubit, AuthState>(
                                  builder: (context, state) {
                                    if (state is AuthLoading) {
                                      return Column(
                                        children: [
                                          const CircularProgressIndicator(
                                            color: AppColors.primary,
                                          ),
                                          SizedBox(height: 1.h),
                                          Text(
                                            'جاري التحقق...',
                                            style: TextStyle(
                                              fontSize: 12.dp,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 4.h),

                        //  زر إعادة الإرسال والمؤقت (يستمع لـ TimerCubit)
                        BlocBuilder<TimerCubit, TimerState>(
                          builder: (context, timerState) {
                            // التحقق من حالة انتهاء العداد
                            final canResend = timerState is TimerFinished;
                            final seconds = timerState.duration;

                            return Column(
                              children: [
                                Text(
                                  'لم يصلك الرمز؟',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12.dp,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                if (canResend)
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      context.read<AuthCubit>().signIn(
                                        email: email,
                                      );
                                    },
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('إعادة إرسال الرمز'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                        vertical: 1.5.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                      vertical: 1.5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.categoryChipBackground
                                          .withValues(alpha: .5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.timer,
                                          size: 5.w,
                                          color: AppColors.textSecondary,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          'إعادة الإرسال خلال $seconds ثانية',
                                          style: TextStyle(
                                            fontSize: 12.dp,
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          },
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
      ),
    );
  }
}
