import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:la3bob/core/utils/helper_function/error_snackbar.dart';
import 'package:la3bob/features/auth/presentation/bloc/auth_bloc/cubit/auth_cubit.dart';
import 'package:la3bob/features/auth/presentation/pages/verification_screen.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

String name = '';
String email = '';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<AuthCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('إنشاء حساب')),
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
            } else if (state is OtpSent) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => VerificationScreen(email: email),
                ),
              );
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
                    children: [
                      const Text(
                        'لعبوب',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('انضم إلى عالم لعبوب الممتع'),
                      const SizedBox(height: 40),

                      TextFormField(
                        decoration: const InputDecoration(labelText: 'الاسم'),
                        onChanged: (value) => name = value,
                        validator: (value) =>
                            value!.isEmpty ? 'الرجاء إدخال الاسم' : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'البريد الإلكتروني',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => email = value,
                        validator: (value) =>
                            value!.isEmpty || !value.contains('@')
                            ? 'الرجاء إدخال بريد إلكتروني صحيح'
                            : null,
                      ),
                      const SizedBox(height: 32),

                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          final isSubmitting = state is AuthLoading;

                          return ElevatedButton(
                            onPressed: isSubmitting
                                ? null
                                : () => _submitSignup(context),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: isSubmitting
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'إنشاء حساب',
                                    style: TextStyle(fontSize: 18),
                                  ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          // Navigator.of(context).pushReplacement(
                          //   MaterialPageRoute(builder: (_) => const LoginScreen()),
                          // );
                        },
                        child: const Text(
                          'لديك حساب بالفعل؟ تسجيل الدخول',
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

  //  إرسال النموذج (Submit Logic)
  void _submitSignup(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      context.read<AuthCubit>().signUp(email: email.trim(), name: name.trim());
    }
  }
}
