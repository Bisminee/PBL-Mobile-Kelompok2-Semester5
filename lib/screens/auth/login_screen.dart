import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_assets.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../services/providers.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/responsive.dart';

/// Halaman masuk. Saat ini belum memvalidasi akun (placeholder).
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

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
                Row(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(AppAssets.logo, width: 40, height: 40),
                  ),
                  const SizedBox(width: 10),
                  Text('Sera-Z', style: AppTextStyles.h3),
                ]),
                const SizedBox(height: 40),
                Text('Selamat datang\nkembali', style: AppTextStyles.display),
                const SizedBox(height: 10),
                Text('Masuk untuk melanjutkan ke lemarimu.',
                    style: AppTextStyles.bodySecondary),
                const SizedBox(height: 36),
                const AppTextField(
                    label: 'Email',
                    hint: 'fala@email.com',
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 20),
                const AppTextField(
                    label: 'Password', hint: 'Masukkan password', isPassword: true),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('Lupa password?',
                      style: AppTextStyles.labelBold.copyWith(fontSize: 13)),
                ),
                const SizedBox(height: 28),
                AppButton(
                  label: 'Masuk',
                  onPressed: () {
                    ref.read(authProvider.notifier).signIn();
                    context.go(AppRoutes.home);
                  },
                ),
                const SizedBox(height: 20),
                Row(children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text('atau', style: AppTextStyles.label),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ]),
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
                            style: AppTextStyles.labelBold.copyWith(fontSize: 11)),
                        const TextSpan(text: '\ndan '),
                        TextSpan(
                            text: 'Kebijakan Privasi',
                            style: AppTextStyles.labelBold.copyWith(fontSize: 11)),
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
