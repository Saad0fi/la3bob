import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:la3bob/features/auth/presentation/pages/login_screen.dart';
import 'package:la3bob/features/auth/presentation/pages/signup_screen.dart';
import 'package:la3bob/features/auth/presentation/pages/verification_screen.dart';
import 'package:la3bob/features/games/presentation/pages/colors_game_screen.dart';
import 'package:la3bob/features/games/presentation/pages/game_home_screen.dart';
import 'package:la3bob/features/games/presentation/pages/letters_game_screen.dart';
import 'package:la3bob/features/games/presentation/pages/numbers_game_screen.dart';
import 'package:la3bob/features/navigation_bar/presentation/screens/navigation_bar.dart';
import 'package:la3bob/features/profiles/presentation/screens/add_child_screen.dart';
import 'package:la3bob/features/profiles/presentation/screens/profile_screen.dart';
import 'package:la3bob/features/splash_screen/presentation/pages/splash_screen.dart';
import 'package:la3bob/features/videos/domain/entities/video_entity.dart';
import 'package:la3bob/features/videos/presentation/screens/video_home_screen.dart';
import 'package:la3bob/features/videos/presentation/screens/video_player_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/verify',
      builder: (context, state) =>
          VerificationScreen(email: (state.extra as String?) ?? ''),
    ),
    GoRoute(
      path: '/add-child',
      builder: (context, state) => const AddChildScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => ProfileScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => NavigationBarScreen(child: child),
      routes: [
        GoRoute(
          path: '/tabs/videos',
          builder: (context, state) => const VideoHomeScreen(),
          routes: [
            GoRoute(
              path: 'player',
              builder: (context, state) {
                final video = state.extra as VideoEntity;
                return VideoPlayerScreen(video: video);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/tabs/games',
          builder: (context, state) => const GameHomeScreen(),
          routes: [
            GoRoute(
              path: 'letters',
              builder: (context, state) => const LettersGameScreen(),
            ),
            GoRoute(
              path: 'numbers',
              builder: (context, state) => const NumbersGameScreen(),
            ),
            GoRoute(
              path: 'colors',
              builder: (context, state) => const ColorsGameScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

