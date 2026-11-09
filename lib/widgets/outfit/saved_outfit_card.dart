import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../../models/garment_labels.dart';
import '../../models/saved_outfit.dart';
import '../common/garment_photo.dart';

/// Kartu satu outfit tersimpan: thumbnail item, nama paduan, formalitas, skor.
///
/// Dipakai di layar Outfit Tersimpan dan sub-tab Lemari. Dibuat aman dari
/// overflow dengan Expanded + Wrap, karena jumlah item bisa lebih dari dua.
class SavedOutfitCard extends StatelessWidget {
  const SavedOutfitCard({super.key, required this.outfit});

  final SavedOutfit outfit;

  @override
  Widget build(BuildContext context) {
    final persen = (outfit.score * 100).round();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.secondaryBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final g in outfit.items)
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: GarmentPhoto(
                          imagePath: g.imagePath,
                          kind: clothingKindOf(g.garmentType, g.slot),
                          dark: g.isDark,
                          radius: 12,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text('$persen%', style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            outfit.title,
            style: AppTextStyles.labelBold,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${formalityLabel(outfit.formality)} · ${formatDateId(outfit.createdAt)}',
            style: AppTextStyles.mono(10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
