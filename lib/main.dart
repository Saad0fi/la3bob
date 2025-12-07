import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:la3bob/audio/audio_controller.dart';
import 'package:la3bob/core/config/setup.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:la3bob/features/auth/presentation/pages/login_screen.dart';
import 'package:logging/logging.dart';
import 'dart:developer' as dev;

Future<void> main() async {
  Logger.root.level = kDebugMode ? Level.FINE : Level.INFO;
  Logger.root.onRecord.listen((record) {
    dev.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
      zone: record.zone,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });

  final audioController = AudioController();
  await audioController.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  final soloud = SoLoud.instance;
  await soloud.init();
  final source = await soloud.loadAsset('assets/images/test.mp3');

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
      home: LoginScreen(),
    );
  }
}
