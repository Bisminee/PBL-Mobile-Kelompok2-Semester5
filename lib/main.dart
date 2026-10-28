import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/app_router.dart';
import 'config/app_theme.dart';
import 'services/camera_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  // Firebase dimuat dari google-services.json pada Android. Bila berkas itu
  // belum ada, aplikasi tetap bisa dibuka untuk pengembangan UI, tetapi login
  // Google tidak akan berfungsi.
  try {
    await Firebase.initializeApp();
  } catch (error) {
    debugPrint('Firebase belum dikonfigurasi: $error');
  }

  await CameraService.init();
  runApp(const ProviderScope(child: SeraZApp()));
}

class SeraZApp extends StatelessWidget {
  const SeraZApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sera-Z',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: appRouter,
    );
  }
}
