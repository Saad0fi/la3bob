import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:la3bob/core/comon/helper_function/error_snackbar.dart';
import 'package:la3bob/core/comon/widgets/custom_input_decoration.dart';
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
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is OtpSent) {
              context.go('/verify', extra: _email);
            } else if (state is AuthFailureState) {
              showErrorSnackbar(context, state.failure.message);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'لعبوب',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'أدخل بريدك الإلكتروني لتسجيل الدخول',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 60),

                      const Text(
                        'البريد الإلكتروني',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 8),

                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: customInputDecoration(
                          'أدخل بريدك الإلكتروني',
                          'البريد الإلكتروني',
                        ),
                        onChanged: (value) => _email = value,
                        validator: (value) =>
                            value!.isEmpty || !value.contains('@')
                            ? 'الرجاء إدخال بريد إلكتروني صحيح'
                            : null,
                      ),
                      const SizedBox(height: 50),

                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          final isSubmitting = state is AuthLoading;

                          return ElevatedButton(
                            onPressed: isSubmitting
                                ? null
                                : () => _submitLogin(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              minimumSize: const Size(double.infinity, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 0,
                            ),
                            child: isSubmitting
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'تسجيل الدخول',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                      // الانتقال لإنشاء حساب
                      TextButton(
                        onPressed: () {
                          context.go('/signup');
                        },
                        child: const Text(
                          'ليس لديك حساب؟ إنشاء حساب',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  // دالة إرسال النموذج (_submitLogin)

  void _submitLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<AuthCubit>().signIn(email: _email.trim());
    }
  }
}
