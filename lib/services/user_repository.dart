import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Menyimpan data pengguna ke Firestore.
///
/// Dokumen dibuat sekali saat login pertama:
/// - `users/{uid}`: data akun dasar
/// - `profiles/{uid}`: data profil yang bisa diubah pengguna
class UserRepository {
  UserRepository({FirebaseFirestore? firestore})
    : _firestoreOverride = firestore;

  // Sama seperti AuthService: jangan akses FirebaseFirestore.instance di
  // konstruktor agar layar login tetap bisa dibuka tanpa Firebase.
  final FirebaseFirestore? _firestoreOverride;

  FirebaseFirestore get _firestore =>
      _firestoreOverride ?? FirebaseFirestore.instance;

  /// Membuat dokumen pengguna bila belum ada. Tidak menimpa data lama.
  Future<void> ensureProfile(User user) async {
    final users = _firestore.collection('users').doc(user.uid);
    final snapshot = await users.get();
    if (snapshot.exists) return;

    final profiles = _firestore.collection('profiles').doc(user.uid);
    final now = FieldValue.serverTimestamp();
    final email = user.email ?? '';
    final displayName =
        user.displayName ??
        (email.contains('@') ? email.split('@').first : 'Pengguna');

    final batch = _firestore.batch();
    batch.set(users, {
      'uid': user.uid,
      'email': email,
      'display_name': displayName,
      'created_at': now,
      'last_login_at': now,
    });
    batch.set(profiles, {
      'uid': user.uid,
      'display_name': displayName,
      'photo_url': user.photoURL,
      'preferences': <String, dynamic>{},
      'created_at': now,
      'updated_at': now,
    });
    await batch.commit();
  }

  /// Memperbarui waktu login terakhir tanpa mengubah data profil.
  Future<void> touchLastLogin(User user) async {
    await _firestore.collection('users').doc(user.uid).update({
      'last_login_at': FieldValue.serverTimestamp(),
    });
  }

  /// Mengubah nama tampilan di `users/{uid}` dan `profiles/{uid}`.
  Future<void> updateDisplayName(String uid, String displayName) async {
    final now = FieldValue.serverTimestamp();
    final batch = _firestore.batch();
    batch.update(_firestore.collection('users').doc(uid), {
      'display_name': displayName,
      'updated_at': now,
    });
    batch.update(_firestore.collection('profiles').doc(uid), {
      'display_name': displayName,
      'updated_at': now,
    });
    await batch.commit();
  }

  /// Menghapus dokumen pengguna dan profil dari Firestore.
  Future<void> deleteProfile(String uid) async {
    final batch = _firestore.batch();
    batch.delete(_firestore.collection('users').doc(uid));
    batch.delete(_firestore.collection('profiles').doc(uid));
    await batch.commit();
  }
}
