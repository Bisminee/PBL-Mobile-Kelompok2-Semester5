import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../common/clothing_thumb.dart';

/// Satu baris item (nama, kategori, warna) di detail outfit.
class OutfitItemRow extends StatelessWidget {
  const OutfitItemRow({
    super.key,
    required this.name,
    required this.meta,
    required this.badge,
    required this.kind,
    required this.dark,
    this.badgeFilled = false,
  });

  final String name;
  final String meta;
  final String badge;
  final bool badgeFilled;
  final ClothingKind kind;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(children: [
        SizedBox(
            width: 52,
            height: 52,
            child: ClothingThumb(kind: kind, dark: dark, radius: 12, iconSize: 24)),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTextStyles.title.copyWith(fontSize: 15)),
              const SizedBox(height: 2),
              Text(meta, style: AppTextStyles.label),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: badgeFilled ? AppColors.accent : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: badgeFilled ? AppColors.accent : AppColors.border),
          ),
          child: Text(badge,
              style: AppTextStyles.mono(9,
                  color: badgeFilled ? Colors.white : AppColors.textPrimary, ls: 0.8)),
        ),
      ]),
    );
  }
}
