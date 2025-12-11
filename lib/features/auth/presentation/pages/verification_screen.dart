import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:la3bob/core/comon/helper_function/toast_helper.dart';
import 'package:la3bob/features/auth/presentation/bloc/auth_bloc/cubit/auth_cubit.dart';
import 'package:la3bob/features/auth/presentation/bloc/timer_bloc/cubit/timer_cubit.dart';
import 'package:la3bob/features/auth/presentation/bloc/timer_bloc/cubit/timer_state.dart';
import 'package:la3bob/features/navigation_bar/presentation/screens/navigation_bar.dart';
import 'package:la3bob/features/profiles/presentation/screens/add_child_screen.dart';
import 'package:pinput/pinput.dart';

final GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();

class VerificationScreen extends StatelessWidget {
  final String email;

  const VerificationScreen({required this.email, super.key});

  @override
  Widget build(BuildContext context) {
    // إعدادات الثيم ل Pinput
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.blue, width: 2),
      borderRadius: BorderRadius.circular(16),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: Colors.blue.shade50,
      ),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetIt.I<AuthCubit>()),
        //  هنا التايمر كيوبت المسؤول عن التايمر TimerCubit وبدء العداد
        BlocProvider(create: (context) => TimerCubit()..startTimer()),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('تأكيد الرمز')),
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthenticatedWithChildren) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const NavigationBarScreen()),
                (route) => false,
              );
            } else if (state is AuthenticatedNoChildren) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AddChildScreen()),
                (route) => false,
              );
            } else if (state is Authenticated) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const NavigationBarScreen()),
                (route) => false,
              );
            } else if (state is AuthFailureState) {
              showAppToast(
                message: state.failure.message,
                type: ToastType.failure,
              );
              //  مسح الرمز عند الخطأ باستخدام الفورم كي
              _otpFormKey.currentState?.reset();
            } else if (state is OtpSent) {
              showAppToast(
                message: "تم إعادة ارسال الرمز بنجاح",
                type: ToastType.success,
              );
              // إعادة تشغيل المؤقت عند وصول تأكيد الإرسال
              context.read<TimerCubit>().startTimer();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Form(
                key: _otpFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'التحقق من البريد الإلكتروني',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'لقد أرسلنا الرمز إلى\n$email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 40),

                    //  فيلد ال Pinput (يستمع لحالة التحميل من AuthCubit)
                    BlocBuilder<AuthCubit, AuthState>(
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

                    const SizedBox(height: 40),

                    //  زر إعادة الإرسال والمؤقت (يستمع لـ TimerCubit)
                    BlocBuilder<TimerCubit, TimerState>(
                      builder: (context, timerState) {
                        // التحقق من حالة انتهاء العداد
                        final canResend = timerState is TimerFinished;
                        final seconds = timerState.duration;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'لم يصلك الرمز؟ ',
                              style: TextStyle(color: Colors.grey),
                            ),

                            if (canResend)
                              TextButton(
                                onPressed: () {
                                  // استدعاء إعادة الإرسال
                                  context.read<AuthCubit>().signIn(
                                    email: email,
                                  );
                                  // سيبدأ العداد من جديد عبر BlocListener عندما يصل OtpSent
                                },
                                child: const Text(
                                  'إعادة إرسال',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )
                            else
                              Text(
                                'إعادة الإرسال خلال $seconds ثانية',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
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
    );
  }
}
