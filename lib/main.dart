import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/app_router.dart';
import 'config/app_theme.dart';
import 'services/camera_service.dart';
import 'services/garment_classifier.dart';
import 'services/local_db.dart';
import 'services/outfit_engine.dart';
import 'services/providers.dart';

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
  final engine = await _loadEngine();
  runApp(
    ProviderScope(
      overrides: [engineProvider.overrideWithValue(engine)],
      child: const SeraZApp(),
    ),
  );
}

/// Memuat model deteksi dan tabel ML. Mengembalikan null bila gagal, supaya app tetap terbuka
/// (mis. di web atau desktop, tempat tflite_flutter dan sqflite tidak tersedia).
Future<OutfitEngine?> _loadEngine() async {
  if (kIsWeb) return null;
  try {
    final classifier = await GarmentClassifier.load();
    final engine = OutfitEngine(classifier, LocalDb.instance);
    await engine.preload();
    return engine;
  } catch (e, st) {
    debugPrint('Engine ML gagal dimuat: $e\n$st');
    return null;
  }
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
