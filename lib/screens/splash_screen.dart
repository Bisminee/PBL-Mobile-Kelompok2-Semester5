import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/app_assets.dart';
import '../config/app_routes.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../widgets/orbit_rings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) context.go(AppRoutes.onboarding);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: OrbitRings()),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(AppAssets.logo, width: 72, height: 72, fit: BoxFit.cover),
                ),
                const SizedBox(height: 20),
                Text('Sera-Z', style: AppTextStyles.display.copyWith(fontSize: 40)),
                const SizedBox(height: 10),
                Text('FASHION INTELLIGENCE', style: AppTextStyles.mono(10, ls: 3)),
              ],
            ),
          ),
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 24, height: 2, color: AppColors.textPrimary),
                  Container(width: 24, height: 2, color: AppColors.border),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
