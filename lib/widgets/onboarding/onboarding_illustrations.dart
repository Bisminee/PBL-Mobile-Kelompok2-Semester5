import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../common/clothing_thumb.dart';
import '../common/corner_frame.dart';
import '../common/match_ring.dart';

/// Slide 1: frame scan + chip "Kaos · Atasan" + chip warna.
class ScanIllustration extends StatelessWidget {
  const ScanIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 22,
          right: 22,
          child: _FloatChip(
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const _Dot(size: 6),
              const SizedBox(width: 8),
              Text('Kaos · Atasan', style: AppTextStyles.labelBold),
            ]),
          ),
        ),
        Positioned.fill(
          left: 48,
          right: 48,
          top: 56,
          bottom: 100,
          child: CornerFrame(
            cornerLength: 24,
            child: const ClothingThumb(
              kind: ClothingKind.top,
              background: Colors.transparent,
              iconSize: 110,
            ),
          ),
        ),
        Positioned(
          left: 40,
          bottom: 56,
          child: _FloatChip(
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const _Dot(size: 18, color: AppColors.darkSecondary),
              const SizedBox(width: 8),
              Text('Hitam', style: AppTextStyles.labelBold.copyWith(fontSize: 13)),
              const SizedBox(width: 8),
              Text('#1D1D1F', style: AppTextStyles.mono(10, ls: 0.4)),
            ]),
          ),
        ),
        Positioned(
          left: 40,
          bottom: 22,
          child: Row(children: [
            const _Dot(size: 5),
            const SizedBox(width: 8),
            Text('AI SCAN', style: AppTextStyles.mono(10)),
          ]),
        ),
        Positioned(
          right: 22,
          bottom: 22,
          child: Text('CONF 94%',
              style: AppTextStyles.mono(10, color: AppColors.textPrimary)),
        ),
      ],
    );
  }
}

/// Slide 2: tiga kartu (atasan, bawahan, sepatu) + ring 94% MATCH.
class MatchIllustration extends StatelessWidget {
  const MatchIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    Widget card(ClothingKind kind, bool dark, String label) => Container(
          width: 130,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(children: [
            Expanded(
              child: ClothingThumb(
                  kind: kind, dark: dark, background: Colors.transparent, iconSize: 56),
            ),
            Text(label, style: AppTextStyles.mono(9)),
            const SizedBox(height: 12),
          ]),
        );

    return Stack(
      children: [
        Positioned(left: 24, top: 80, child: card(ClothingKind.top, true, 'ATASAN')),
        Positioned(right: 24, top: 40, child: card(ClothingKind.bottom, false, 'BAWAHAN')),
        Positioned(
            right: 36,
            bottom: 36,
            child: card(ClothingKind.shoes, true, 'SEPATU')),
        Positioned(
          left: 0,
          right: 0,
          top: 150,
          child: Center(
            child: Container(
              width: 104,
              height: 104,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [
                BoxShadow(color: Color(0x14000000), blurRadius: 16),
              ]),
              child: const MatchRing(
                value: 94,
                size: 90,
                showPercent: true,
                caption: 'MATCH',
                stroke: 4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Slide 3: kartu outfit "Monochrome Casual".
class OutfitCardIllustration extends StatelessWidget {
  const OutfitCardIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Expanded(
              child: Row(children: [
                const Expanded(child: ClothingThumb(kind: ClothingKind.top, iconSize: 48)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(children: const [
                    Expanded(child: ClothingThumb(kind: ClothingKind.bottom, dark: false)),
                    SizedBox(height: 10),
                    Expanded(child: ClothingThumb(kind: ClothingKind.shoes)),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Monochrome Casual', style: AppTextStyles.title.copyWith(fontSize: 14)),
                      const SizedBox(height: 2),
                      Text('94% MATCH', style: AppTextStyles.mono(10)),
                    ],
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatChip extends StatelessWidget {
  const _FloatChip({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12)],
        ),
        child: child,
      );
}

class _Dot extends StatelessWidget {
  const _Dot({required this.size, this.color = AppColors.textPrimary});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}
