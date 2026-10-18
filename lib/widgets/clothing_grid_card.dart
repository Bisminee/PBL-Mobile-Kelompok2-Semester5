import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import 'clothing_thumb.dart';

class ClothingGridCard extends StatelessWidget {
  const ClothingGridCard({
    super.key,
    required this.name,
    required this.category,
    required this.colorName,
    required this.colorDark,
    required this.kind,
    required this.dark,
    this.onTap,
  });

  final String name;
  final String category;
  final String colorName;
  final bool colorDark;
  final ClothingKind kind;
  final bool dark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: SizedBox(width: double.infinity, child: ClothingThumb(kind: kind, dark: dark, iconSize: 52))),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title.copyWith(fontSize: 14)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Text(category, style: AppTextStyles.label.copyWith(fontSize: 11)),
                    Text('  ·  ', style: AppTextStyles.label.copyWith(fontSize: 11)),
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: colorDark ? AppColors.darkSecondary : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(colorName, style: AppTextStyles.label.copyWith(fontSize: 11)),
                  ]),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
