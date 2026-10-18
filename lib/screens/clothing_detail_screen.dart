import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/app_routes.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../widgets/app_button.dart';
import '../widgets/circle_icon_button.dart';
import '../widgets/clothing_thumb.dart';

class ClothingDetailScreen extends StatelessWidget {
  const ClothingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 400,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.secondaryBg,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              child: SafeArea(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const ClothingThumb(
                        kind: ClothingKind.top,
                        background: Colors.transparent,
                        iconSize: 170),
                    Positioned(
                      top: 12,
                      left: 20,
                      child: CircleIconButton(
                        icon: Icons.chevron_left,
                        background: Colors.white,
                        onPressed: () => context.pop(),
                      ),
                    ),
                    const Positioned(
                      top: 12,
                      right: 20,
                      child: CircleIconButton(icon: Icons.edit_outlined, background: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Atasan', style: AppTextStyles.mono(10)),
                  const SizedBox(height: 4),
                  Text('Kaos Hitam Polos', style: AppTextStyles.h1),
                  const SizedBox(height: 4),
                  Text('Ditambahkan 27 September 2026',
                      style: AppTextStyles.label.copyWith(fontSize: 12)),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(children: [
                      const _Row('Kategori', Text('Kaos', style: TextStyle(fontWeight: FontWeight.w700))),
                      const Divider(height: 1, color: AppColors.border),
                      _Row(
                        'Warna',
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                  color: AppColors.darkSecondary, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Text('Hitam', style: AppTextStyles.title.copyWith(fontSize: 14)),
                        ]),
                      ),
                      const Divider(height: 1, color: AppColors.border),
                      const _Row('Style', Text('Casual', style: TextStyle(fontWeight: FontWeight.w700))),
                      const Divider(height: 1, color: AppColors.border),
                      _Row(
                        'Detection confidence',
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          Container(width: 44, height: 3, color: AppColors.textPrimary),
                          const SizedBox(width: 10),
                          Text('94%', style: AppTextStyles.title.copyWith(fontSize: 14)),
                        ]),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 22),
                  AppButton(
                    label: 'Gunakan untuk Rekomendasi',
                    icon: Icons.auto_awesome,
                    onPressed: () =>
                        context.push(AppRoutes.recommendation),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Hapus dari Lemari',
                    icon: Icons.delete_outline,
                    style: AppButtonStyle.outlined,
                    height: 50,
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);
  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodySecondary),
            DefaultTextStyle(style: AppTextStyles.title.copyWith(fontSize: 14), child: value),
          ],
        ),
      );
}
