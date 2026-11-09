import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../config/app_assets.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../services/auth_listenable.dart';
import '../../services/auth_service.dart';
import '../../services/providers.dart';
import '../../services/user_repository.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/responsive.dart';

/// Halaman masuk dengan Google.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final AuthService _authService = AuthService();
  final UserRepository _userRepository = UserRepository();
  bool _loading = false;
  String? _error;

  Future<void> _signInWithGoogle() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final credential = await _authService.signInWithGoogle();
      final user = credential.user;
      if (user == null) {
        throw StateError('Firebase tidak mengembalikan data pengguna.');
      }

      try {
        await _userRepository.ensureProfile(user);
      } catch (error) {
        // Login tetap dilanjutkan walau penulisan profil gagal, misalnya
        // karena aturan Firestore belum diatur.
        debugPrint('Gagal menyimpan profil pengguna: $error');
      }

      ref
          .read(authProvider.notifier)
          .setUser(
            AppUser(
              name:
                  user.displayName ??
                  user.email?.split('@').first ??
                  'Pengguna',
              email: user.email ?? '',
              photoUrl: user.photoURL,
            ),
          );

      // Tandai login lebih dulu, baru pindah halaman. Kalau menunggu aliran
      // authStateChanges, GoRouter bisa menganggap belum login dan
      // mengembalikan pengguna ke halaman ini.
      authListenable.setSignedIn(true);

      if (!mounted) return;
      context.go(AppRoutes.home);
    } on AuthCancelledException {
      if (!mounted) return;
      setState(() => _error = null);
    } on GoogleSignInException catch (error) {
      if (!mounted) return;
      final pesan =
          'Login Google gagal (${error.code.name}). '
          '${error.description ?? 'Tidak ada keterangan dari Google.'}';
      setState(() => _error = pesan);
      _tampilkanError(pesan);
      debugPrint(
        'GoogleSignInException: code=${error.code} '
        'description=${error.description} details=${error.details}',
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      final pesan = _pesanError(error);
      setState(() => _error = pesan);
      _tampilkanError(pesan);
      debugPrint('Login Firebase gagal: ${error.code} ${error.message}');
    } catch (error) {
      if (!mounted) return;
      const pesan = 'Gagal masuk. Periksa koneksi lalu coba lagi.';
      setState(() => _error = pesan);
      _tampilkanError(pesan);
      debugPrint('Login gagal: $error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Error juga ditampilkan sebagai snackbar agar tidak terlewat.
  void _tampilkanError(String pesan) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(pesan)));
  }

  String _pesanError(FirebaseAuthException error) {
    switch (error.code) {
      case 'network-request-failed':
        return 'Tidak ada koneksi internet.';
      case 'missing-id-token':
        return 'Konfigurasi Firebase belum benar. Periksa SHA-1 aplikasi.';
      case 'account-exists-with-different-credential':
        return 'Email ini sudah terdaftar dengan metode login lain.';
      default:
        return 'Gagal masuk: ${error.message ?? error.code}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ContentWidth(
            maxWidth: 440,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(AppAssets.logo, width: 40, height: 40),
                    ),
                    const SizedBox(width: 10),
                    Text('Sera-Z', style: AppTextStyles.h3),
                  ],
                ),
                const SizedBox(height: 40),
                Text('Selamat datang\nkembali', style: AppTextStyles.display),
                const SizedBox(height: 10),
                Text(
                  'Masuk untuk melanjutkan ke lemarimu.',
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: 36),
                Text(
                  'Masuk memakai akun Google. Login email dan password belum tersedia.',
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: 20),
                AppButton(
                  label: _loading ? 'Memproses...' : 'Masuk dengan Google',
                  onPressed: _loading ? null : _signInWithGoogle,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.accent,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  'Sementara hanya login Google yang aktif.',
                  style: AppTextStyles.label.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text('atau', style: AppTextStyles.label),
                    ),
                    const Expanded(child: Divider(color: AppColors.border)),
                  ],
                ),
                const SizedBox(height: 20),
                AppButton(
                  label: 'Buat Akun Baru',
                  style: AppButtonStyle.outlined,
                  onPressed: () => context.push(AppRoutes.signup),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Text.rich(
                    TextSpan(
                      style: AppTextStyles.label.copyWith(fontSize: 11),
                      children: [
                        const TextSpan(text: 'Dengan masuk, kamu menyetujui '),
                        TextSpan(
                          text: 'Syarat & Ketentuan',
                          style: AppTextStyles.labelBold.copyWith(fontSize: 11),
                        ),
                        const TextSpan(text: '\ndan '),
                        TextSpan(
                          text: 'Kebijakan Privasi',
                          style: AppTextStyles.labelBold.copyWith(fontSize: 11),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
