import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../common/clothing_thumb.dart';
import '../common/match_ring.dart';

/// Kartu rekomendasi outfit (collage 3 item + judul + skor).
class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    super.key,
    required this.title,
    required this.matchLabel,
    required this.score,
    required this.description,
    this.onTap,
  });

  final String title;
  final String matchLabel;
  final int score;
  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 170,
              child: Row(children: [
                const Expanded(child: ClothingThumb(kind: ClothingKind.top, iconSize: 48)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(children: const [
                    Expanded(child: ClothingThumb(kind: ClothingKind.bottom, dark: false)),
                    SizedBox(height: 8),
                    Expanded(child: ClothingThumb(kind: ClothingKind.shoes)),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.h3.copyWith(fontSize: 17)),
                    const SizedBox(height: 2),
                    Text(matchLabel, style: AppTextStyles.mono(10)),
                  ],
                ),
              ),
              MatchRing(value: score, size: 40),
            ]),
            const SizedBox(height: 8),
            Text(description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySecondary.copyWith(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
