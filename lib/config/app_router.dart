import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/outfit/detail_screen.dart';
import '../screens/outfit/recommendation_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/scan/analyzing_screen.dart';
import '../screens/scan/camera_preview_screen.dart';
import '../screens/scan/camera_screen.dart';
import '../screens/scan/detection_result_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/wardrobe/clothing_detail_screen.dart';
import '../screens/wardrobe/wardrobe_screen.dart';
import '../widgets/layout/main_shell.dart';
import 'app_routes.dart';
import '../services/auth_listenable.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>();

/// Semua rute aplikasi. Path-nya ada di [AppRoutes].
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  refreshListenable: authListenable,
  redirect: (context, state) {
    final signedIn = authListenable.isSignedIn;
    final location = state.matchedLocation;
    final onAuthScreen =
        location == AppRoutes.login || location == AppRoutes.signup;
    final onPublicScreen =
        location == AppRoutes.splash || location == AppRoutes.onboarding;

    if (!signedIn && !onAuthScreen && !onPublicScreen) {
      return AppRoutes.login;
    }
    if (signedIn && onAuthScreen) {
      return AppRoutes.home;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.camera,
      builder: (context, state) => const CameraScreen(),
    ),
    GoRoute(
      path: AppRoutes.cameraPreview,
      builder: (context, state) =>
          CameraPreviewScreen(imagePath: state.extra as String?),
    ),
    GoRoute(
      path: AppRoutes.analyzing,
      builder: (context, state) => const AnalyzingScreen(),
    ),
    GoRoute(
      path: AppRoutes.detectionResult,
      builder: (context, state) => const DetectionResultScreen(),
    ),
    GoRoute(
      path: AppRoutes.recommendation,
      builder: (context, state) => const RecommendationScreen(),
    ),
    GoRoute(
      path: AppRoutes.detail,
      builder: (context, state) => const DetailScreen(),
    ),
    GoRoute(
      path: AppRoutes.clothingDetail,
      builder: (context, state) => const ClothingDetailScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.wardrobe,
              builder: (context, state) => const WardrobeScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
