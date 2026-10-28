import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_text_styles.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/circle_icon_button.dart';
import '../../widgets/common/responsive.dart';

/// Halaman buat akun. Saat ini belum menyimpan data (placeholder).
class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                CircleIconButton(
                  icon: Icons.chevron_left,
                  size: 52,
                  onPressed: () => context.pop(),
                ),
                const SizedBox(height: 16),
                Text('Buat akun', style: AppTextStyles.display),
                const SizedBox(height: 10),
                Text('Simpan lemarimu dan dapatkan\nrekomendasi yang personal.',
                    style: AppTextStyles.bodySecondary),
                const SizedBox(height: 24),
                const AppTextField(label: 'Nama', hint: 'Nama lengkap'),
                const SizedBox(height: 18),
                const AppTextField(
                    label: 'Email',
                    hint: 'fala@email.com',
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 18),
                const AppTextField(
                  label: 'Password',
                  hint: 'Buat password',
                  isPassword: true,
                  helper: 'Minimal 8 karakter, kombinasi huruf dan angka.',
                ),
                const SizedBox(height: 18),
                const AppTextField(
                    label: 'Konfirmasi Password',
                    hint: 'Ulangi password',
                    isPassword: true),
                const SizedBox(height: 40),
                AppButton(
                  label: 'Daftar',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Pendaftaran email belum aktif. Gunakan login Google.',
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),
                Center(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Column(children: [
                      Text('Sudah punya akun?', style: AppTextStyles.bodySecondary),
                      const SizedBox(height: 2),
                      Text('Masuk', style: AppTextStyles.labelBold.copyWith(fontSize: 14)),
                    ]),
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
