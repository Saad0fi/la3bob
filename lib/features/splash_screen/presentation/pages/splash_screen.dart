import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:la3bob/core/di/injection.dart';
import 'package:la3bob/features/auth/presentation/bloc/auth_bloc/cubit/auth_cubit.dart';
import 'package:la3bob/features/auth/presentation/pages/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AuthCubit>()
            ..checkAuthStatus(), //  نستدعي الميثود اللي  تتحقق من وجود المستخدم
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          //  معالجة حالات الـ State والتنقل
          if (state is Authenticated) {
            // المستخدم مسجل انتقل إلى الشاشة الرئيسية
            context.go('/tabs/videos');
          } else if (state is Unauthenticated) {
            // المستخدم غير مسجل انتقل إلى شاشة تسجيل الدخول
            context.go('/login');
          }
        },
        //  عرض CircularProgressIndicator بينما يتم التحقق
        child: const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('جارِ التحقق من حالة المستخدم...'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
