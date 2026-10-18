import 'package:flutter/material.dart';

import '../config/app_colors.dart';

enum ClothingKind { top, bottom, shoes, shirt, outer }

/// Placeholder gambar pakaian. Ganti isi `build` dengan `Image.asset(...)`
/// atau `Image.network(...)` saat foto asli sudah tersedia.
class ClothingThumb extends StatelessWidget {
  const ClothingThumb({
    super.key,
    required this.kind,
    this.dark = true,
    this.radius = 16,
    this.iconSize = 44,
    this.background = AppColors.secondaryBg,
  });

  final ClothingKind kind;
  final bool dark;
  final double radius;
  final double iconSize;
  final Color background;

  IconData get _icon {
    switch (kind) {
      case ClothingKind.top:
        return Icons.checkroom;
      case ClothingKind.shirt:
        return Icons.dry_cleaning_outlined;
      case ClothingKind.bottom:
        return Icons.straighten;
      case ClothingKind.shoes:
        return Icons.directions_walk;
      case ClothingKind.outer:
        return Icons.layers_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: Icon(
        _icon,
        size: iconSize,
        color: dark ? AppColors.darkSecondary : const Color(0xFFD2D2D6),
      ),
    );
  }
}
