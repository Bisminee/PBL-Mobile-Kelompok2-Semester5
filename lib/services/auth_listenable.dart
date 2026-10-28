import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Pendengar status login yang bisa dipakai GoRouter sebagai `refreshListenable`.
///
/// GoRouter membutuhkan objek [Listenable] agar rute dihitung ulang saat status
/// login berubah. Kelas ini menjembatani aliran `authStateChanges()` Firebase.
class AuthListenable extends ChangeNotifier {
  AuthListenable() {
    _bind();
  }

  StreamSubscription<User?>? _subscription;
  bool _signedIn = false;

  bool get isSignedIn => _signedIn;

  void _bind() {
    try {
      _signedIn = FirebaseAuth.instance.currentUser != null;
      _subscription = FirebaseAuth.instance.authStateChanges().listen((user) {
        final next = user != null;
        if (next == _signedIn) return;
        _signedIn = next;
        notifyListeners();
      });
    } catch (error) {
      // Firebase belum dikonfigurasi (misalnya saat widget test).
      debugPrint('Status login tidak tersedia: $error');
      _signedIn = false;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

/// Satu instance untuk seluruh aplikasi.
final AuthListenable authListenable = AuthListenable();
