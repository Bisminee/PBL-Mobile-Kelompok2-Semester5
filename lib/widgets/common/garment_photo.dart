import 'dart:io' show File;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'clothing_thumb.dart';

/// Memilih ikon ClothingKind dari jenis dan slot hasil model.
/// Kemeja dan polo memakai ikon kemeja; slot lain di luar bawahan dan sepatu memakai ikon atasan.
ClothingKind clothingKindOf(String? type, String? slot) {
  if (type == 'shirt' || type == 'polo') return ClothingKind.shirt;
  return switch (slot) {
    'bottom' => ClothingKind.bottom,
    'shoes' => ClothingKind.shoes,
    _ => ClothingKind.top,
  };
}

/// Foto pakaian dari berkas. Bila path kosong atau berkas tidak terbaca, jatuh ke ikon ClothingThumb.
///
/// Mengisi seluruh ruang dari parent, jadi parent harus punya ukuran pasti
/// (SizedBox, Expanded, atau Positioned.fill).
class GarmentPhoto extends StatelessWidget {
  const GarmentPhoto({
    super.key,
    required this.imagePath,
    required this.kind,
    this.dark = false,
    this.radius = 16,
    this.iconSize = 40,
    this.background,
  });

  final String? imagePath;
  final ClothingKind kind;
  final bool dark;
  final double radius;
  final double iconSize;

  /// Latar ikon pengganti. Null = latar bawaan ClothingThumb.
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final path = imagePath;
    if (path == null || path.isEmpty) return _fallback();
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox.expand(
        child: kIsWeb
            ? Image.network(
                path,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _fallback(),
              )
            : Image.file(
                File(path),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _fallback(),
              ),
      ),
    );
  }

  Widget _fallback() {
    final bg = background;
    if (bg == null) {
      return ClothingThumb(
        kind: kind,
        dark: dark,
        radius: radius,
        iconSize: iconSize,
      );
    }
    return ClothingThumb(
      kind: kind,
      dark: dark,
      radius: radius,
      iconSize: iconSize,
      background: bg,
    );
  }
}
