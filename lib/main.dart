import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'config/app_routes.dart';
import 'config/app_theme.dart';
import 'screens/analyzing_screen.dart';
import 'screens/camera_preview_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/clothing_detail_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/detection_result_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/recommendation_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/wardrobe_screen.dart';
import 'services/camera_service.dart';
import 'widgets/main_shell.dart';
import 'widgets/max_width_box.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  await CameraService.init();
  runApp(const ProviderScope(child: SeraZApp()));
}

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
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

class SeraZApp extends StatelessWidget {
  const SeraZApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sera-Z',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: _router,
      builder: (context, child) => MaxWidthBox(child: child!),
    );
  }
}
