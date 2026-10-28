import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'user_repository.dart';

/// Login pengguna dibatalkan sendiri oleh pengguna.
class AuthCancelledException implements Exception {
  const AuthCancelledException();

  @override
  String toString() => 'Login dibatalkan';
}

/// Penghapusan akun membutuhkan login ulang karena sesi sudah lama.
class AuthReauthRequiredException implements Exception {
  const AuthReauthRequiredException();

  @override
  String toString() => 'Silakan login ulang sebelum menghapus akun';
}

/// Tidak ada pengguna yang sedang login.
class AuthNotSignedInException implements Exception {
  const AuthNotSignedInException();

  @override
  String toString() => 'Belum ada pengguna yang login';
}

/// Layanan autentikasi Firebase dengan Google Sign-In.
///
/// Alur: Google Sign-In menghasilkan ID token, lalu token itu ditukar menjadi
/// sesi Firebase. Sesi Firebase disimpan otomatis oleh SDK, sehingga pemanggilan
/// ulang tidak diperlukan selama pengguna belum keluar.
class AuthService {
  AuthService({FirebaseAuth? auth, UserRepository? userRepository})
      : _auth = auth ?? FirebaseAuth.instance,
        _userRepository = userRepository ?? UserRepository();

  final FirebaseAuth _auth;
  final UserRepository _userRepository;
  static bool _googleInitialized = false;

  /// Google Sign-In versi 7 wajib diinisialisasi sekali sebelum dipakai.
  static Future<void> ensureGoogleInitialized() async {
    if (_googleInitialized) return;
    await GoogleSignIn.instance.initialize();
    _googleInitialized = true;
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Membuka dialog Google lalu mendaftarkan sesi ke Firebase.
  Future<UserCredential> signInWithGoogle() async {
    await ensureGoogleInitialized();

    final GoogleSignInAccount account;
    try {
      account = await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthCancelledException();
      }
      rethrow;
    }

    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw FirebaseAuthException(
        code: 'missing-id-token',
        message: 'Google tidak memberikan ID token. Periksa SHA-1 dan '
            'konfigurasi Firebase.',
      );
    }

    final credential = GoogleAuthProvider.credential(idToken: idToken);
    return _auth.signInWithCredential(credential);
  }

  /// Keluar dari Firebase dan Google.
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }

  /// Menghapus profil di Firestore lalu menghapus akun Firebase.
  ///
  /// Firebase mewajibkan login ulang bila sesi sudah lama. Kondisi itu
  /// dilempar sebagai [AuthReauthRequiredException] agar UI bisa memberi tahu
  /// pengguna, bukan menampilkan error mentah.
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AuthNotSignedInException();
    }

    await _userRepository.deleteProfile(user.uid);

    try {
      await user.delete();
    } on FirebaseAuthException catch (error) {
      if (error.code == 'requires-recent-login') {
        throw const AuthReauthRequiredException();
      }
      rethrow;
    }
  }
}
