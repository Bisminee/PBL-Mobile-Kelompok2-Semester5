import 'package:flutter/services.dart';

/// Membuka halaman pengaturan aplikasi di perangkat.
///
/// Implementasi saat ini hanya ada di Android (lihat `MainActivity.kt`).
/// Platform lain mengembalikan `false` supaya layar kamera bisa memberi tahu
/// pengguna bahwa pengaturan tidak bisa dibuka.
class AppSettingsService {
  AppSettingsService._();

  static const _channel = MethodChannel('sera_z/app_settings');

  static Future<bool> open() async {
    try {
      await _channel.invokeMethod<void>('open');
      return true;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
