import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:la3bob/audio/audio_controller.dart';
import 'package:la3bob/core/config/setup.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:la3bob/features/splash_screen/presentation/pages/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupAppDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      locale: Locale('ar'),
      supportedLocales: [Locale('ar', 'SA'), Locale('en', 'US')],

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
