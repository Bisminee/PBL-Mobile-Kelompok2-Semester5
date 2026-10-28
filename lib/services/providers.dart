import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/garment.dart';
import '../models/outfit.dart';
import 'recommender.dart';

/// Signed-in user (null = logged out). Local placeholder for the cloud profile.
class AppUser {
  const AppUser({required this.name, required this.email});

  final String name;
  final String email;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class AuthNotifier extends Notifier<AppUser?> {
  @override
  AppUser? build() {
    try {
      final subscription =
          FirebaseAuth.instance.authStateChanges().listen((user) {
        state = _fromFirebase(user);
      });
      ref.onDispose(subscription.cancel);
      return _fromFirebase(FirebaseAuth.instance.currentUser);
    } catch (error) {
      // Firebase belum dikonfigurasi; aplikasi tetap bisa dibuka.
      return null;
    }
  }

  /// Dipanggil setelah Firebase berhasil mengautentikasi pengguna.
  void setUser(AppUser? user) => state = user;

  void signOut() => state = null;

  static AppUser? _fromFirebase(User? user) {
    if (user == null) return null;
    final email = user.email ?? '';
    return AppUser(
      name: user.displayName ??
          (email.contains('@') ? email.split('@').first : 'Pengguna'),
      email: email,
    );
  }
}

final authProvider = NotifierProvider<AuthNotifier, AppUser?>(AuthNotifier.new);

/// The user's wardrobe ("Lemari Saya"), kept in memory for now (sqflite later).
class WardrobeNotifier extends Notifier<List<Garment>> {
  @override
  List<Garment> build() => <Garment>[];

  void add(Garment garment) => state = [...state, garment];

  void remove(String id) =>
      state = state.where((g) => g.id != id).toList();

  Garment? get latest => state.isEmpty ? null : state.last;
}

final wardrobeProvider =
    NotifierProvider<WardrobeNotifier, List<Garment>>(WardrobeNotifier.new);

/// Recommendations derived from the most recently added garment.
final recommendationsProvider = Provider<List<Outfit>>((ref) {
  final wardrobe = ref.watch(wardrobeProvider);
  if (wardrobe.isEmpty) return const <Outfit>[];
  return buildPlaceholderOutfits(wardrobe.last);
});
