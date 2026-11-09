import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../common/clothing_thumb.dart';
import '../common/garment_photo.dart';

/// Kartu pakaian untuk grid di tab Lemari.
class ClothingGridCard extends StatelessWidget {
  const ClothingGridCard({
    super.key,
    required this.name,
    required this.category,
    required this.colorName,
    required this.colorValue,
    required this.kind,
    required this.dark,
    this.imagePath,
    this.onTap,
  });

  final String name;
  final String category;
  final String colorName;

  /// Warna asli hasil deteksi, dipakai untuk titik warna di kartu.
  final Color colorValue;
  final ClothingKind kind;
  final bool dark;

  /// Path foto asli hasil kamera. Null = pakai ikon pengganti.
  final String? imagePath;
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
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: GarmentPhoto(
                  imagePath: imagePath,
                  kind: kind,
                  dark: dark,
                  iconSize: 52,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.title.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.label.copyWith(fontSize: 11),
                        ),
                      ),
                      Text(
                        '  ·  ',
                        style: AppTextStyles.label.copyWith(fontSize: 11),
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: colorValue,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          colorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.label.copyWith(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
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
