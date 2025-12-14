import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la3bob/core/config/setup.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:la3bob/core/di/injection.dart';
import 'package:la3bob/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:la3bob/features/profiles/domain/usecase/profile_usecase.dart';
import 'package:la3bob/features/profiles/presentation/bloc/porfile_bloc.dart';
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
    return BlocProvider(
      create: (_) =>
          PorfileBloc(getIt<ProfileUsecase>(), getIt<AuthUseCases>()),
      child: MaterialApp(
        locale: Locale('ar'),
        supportedLocales: [Locale('ar', 'SA'), Locale('en', 'US')],

        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
