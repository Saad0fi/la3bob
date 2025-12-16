import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:la3bob/features/auth/presentation/pages/login_screen.dart';
import 'package:la3bob/features/auth/presentation/pages/signup_screen.dart';
import 'package:la3bob/features/auth/presentation/pages/verification_screen.dart';
import 'package:la3bob/features/games/presentation/pages/colors_game_screen.dart';
import 'package:la3bob/features/games/presentation/pages/game_home_screen.dart';
import 'package:la3bob/features/games/presentation/pages/letters_game_screen.dart';
import 'package:la3bob/features/games/presentation/pages/matching_game_screen.dart';
import 'package:la3bob/features/games/presentation/pages/numbers_game_screen.dart';
import 'package:la3bob/features/games/presentation/pages/jump_page.dart';
import 'package:la3bob/features/games/presentation/pages/simon_says_page.dart';
import 'package:la3bob/features/games/presentation/pages/freeze_page.dart';
import 'package:la3bob/features/navigation_bar/presentation/screens/navigation_bar.dart';
import 'package:la3bob/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:la3bob/features/profiles/domain/entities/child_entity.dart';
import 'package:la3bob/features/profiles/presentation/screens/add_child_screen.dart';
import 'package:la3bob/features/profiles/presentation/screens/profile_screen.dart';
import 'package:la3bob/features/profiles/presentation/screens/update_child_screen.dart';
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
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
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
      path: '/update-child',
      builder: (context, state) {
        final child = state.extra as ChildEntity;
        return UpdateChildScreen(child: child);
      },
    ),
    GoRoute(path: '/profile', builder: (context, state) => ProfileScreen()),
    GoRoute(
      path: '/video-player',
      builder: (context, state) {
        final video = state.extra as VideoEntity;
        return VideoPlayerScreen(video: video);
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => NavigationBarScreen(child: child),
      routes: [
        GoRoute(
          path: '/tabs/videos',
          builder: (context, state) => const VideoHomeScreen(),
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
            GoRoute(
              path: 'matching',
              builder: (context, state) => const MatchingGameScreen(),
            ),
            GoRoute(
              path: 'jump',
              builder: (context, state) => const JumpGamePage(),
            ),
            GoRoute(
              path: 'simon_says',
              builder: (context, state) => const SimonSaysGamePage(),
            ),
            GoRoute(
              path: 'freeze',
              builder: (context, state) => const FreezeGamePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
