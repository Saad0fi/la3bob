import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:la3bob/core/setup/setup.dart';
import 'package:la3bob/features/auth/presentation/pages/signup_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await GetStorage.init();

  final url = dotenv.env['urlSupa'];
  final anonKey = dotenv.env['keySupa'];

  await Supabase.initialize(url: url!, anonKey: anonKey!);

  configureDependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar', 'SA'), Locale('en', 'US')],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      debugShowCheckedModeBanner: false,
      home: SignupScreen(),
    );
  }
}
