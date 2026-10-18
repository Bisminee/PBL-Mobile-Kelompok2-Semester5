import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/circle_icon_button.dart';
import '../../widgets/common/clothing_thumb.dart';
import '../../widgets/common/corner_frame.dart';
import '../../widgets/common/match_ring.dart';
import '../../widgets/common/responsive.dart';
import '../../widgets/scan/color_composition_bar.dart';
import '../../widgets/scan/info_grid.dart';

/// Hasil deteksi jenis, style, dan warna pakaian.
class DetectionResultScreen extends StatelessWidget {
  const DetectionResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ContentWidth(
            maxWidth: 560,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleIconButton(
                        icon: Icons.chevron_left, onPressed: () => context.pop()),
                    Text('Hasil Deteksi', style: AppTextStyles.title),
                    const CircleIconButton(icon: Icons.ios_share),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  height: 250,
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBg,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: CornerFrame(
                    color: const Color(0xFFB8B8BC),
                    cornerLength: 24,
                    child: const ClothingThumb(
                      kind: ClothingKind.top,
                      background: Colors.transparent,
                      iconSize: 110,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text('ATASAN · 27 SEP 2026', style: AppTextStyles.mono(10)),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kaos', style: AppTextStyles.display.copyWith(fontSize: 36)),
                          Text('Casual', style: AppTextStyles.bodySecondary.copyWith(fontSize: 15)),
                        ],
                      ),
                    ),
                    const MatchRing(
                        value: 94, size: 66, showPercent: true, caption: 'CONF', stroke: 4),
                  ],
                ),
                const SizedBox(height: 16),
                const InfoGrid(
                  cells: [
                    InfoCell('Jenis', 'Kaos'),
                    InfoCell('Style', 'Casual'),
                    InfoCell('Warna dominan', 'Hitam', dotColor: AppColors.darkSecondary),
                    InfoCell('Confidence', '94%'),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Komposisi warna', style: AppTextStyles.title.copyWith(fontSize: 14)),
                    Text('3 TONE', style: AppTextStyles.mono(10)),
                  ],
                ),
                const SizedBox(height: 10),
                const ColorCompositionBar(
                  segments: [
                    ColorSegment('Hitam', 78, AppColors.darkSecondary),
                    ColorSegment('Abu tua', 14, AppColors.textSecondary),
                    ColorSegment('Putih', 8, AppColors.border),
                  ],
                ),
                const SizedBox(height: 28),
                AppButton(
                  label: 'Lihat Rekomendasi',
                  trailingIcon: Icons.arrow_forward,
                  onPressed: () =>
                      context.push(AppRoutes.recommendation),
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Simpan ke Lemari',
                  style: AppButtonStyle.outlined,
                  onPressed: () => context.go(AppRoutes.home),
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
