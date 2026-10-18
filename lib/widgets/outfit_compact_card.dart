import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import 'clothing_thumb.dart';
import 'match_ring.dart';
import 'pill_chip.dart';

/// Kartu outfit ringkas: thumbnail kiri, info kanan.
class OutfitCompactCard extends StatelessWidget {
  const OutfitCompactCard({
    super.key,
    required this.title,
    required this.score,
    required this.items,
    required this.description,
    required this.tags,
    this.onTap,
  });

  final String title;
  final int score;
  final String items;
  final String description;
  final List<String> tags;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 112,
                  height: 140,
                  child: Row(children: [
                    const Expanded(child: ClothingThumb(kind: ClothingKind.top, iconSize: 28)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(children: const [
                        Expanded(
                            child: SizedBox(
                                width: double.infinity,
                                child: ClothingThumb(kind: ClothingKind.bottom, dark: false))),
                        SizedBox(height: 6),
                        Expanded(
                            child: SizedBox(
                                width: double.infinity,
                                child: ClothingThumb(kind: ClothingKind.shoes))),
                      ]),
                    ),
                  ]),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(child: Text(title, style: AppTextStyles.h3)),
                        MatchRing(value: score, size: 30, stroke: 3),
                      ]),
                      Text('$score% MATCH', style: AppTextStyles.mono(10)),
                      const SizedBox(height: 6),
                      Text(items, style: AppTextStyles.label),
                      const SizedBox(height: 6),
                      Text(description,
                          style: AppTextStyles.body.copyWith(fontSize: 13)),
                      const SizedBox(height: 8),
                      Wrap(spacing: 6, runSpacing: 6, children: [
                        for (final t in tags) PillChip(label: t, small: true),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(children: [
                Expanded(child: Text('Kenapa cocok?', style: AppTextStyles.title.copyWith(fontSize: 14))),
                const Icon(Icons.keyboard_arrow_down),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
