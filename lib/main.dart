import 'package:flutter/material.dart';
import 'package:la3bob/core/setup/setup.dart';
import 'package:la3bob/features/auth/presentation/pages/signup_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dwdyzumorfwynnainszz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR3ZHl6dW1vcmZ3eW5uYWluc3p6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM2MzgyMTMsImV4cCI6MjA3OTIxNDIxM30.s8VBthQuIynlqbi7AOVxgRuVASBMT2oZ-O2fyzCODys',
  );

  configureDependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignupScreen(),
    );
  }
}
