import 'package:flutter/material.dart';

/// A single clothing item stored in the user's wardrobe.
///
/// Attributes are placeholders for now; Model 1 (type) and Module 2 (color)
/// will populate them once integrated.
class Garment {
  const Garment({
    required this.id,
    required this.category,
    required this.colorName,
    required this.colorValue,
    this.imagePath,
    this.style,
  });

  final String id;

  /// Functional category: Atasan, Bawahan, Luaran, Terusan, Alas kaki.
  final String category;
  final String colorName;
  final Color colorValue;
  final String? imagePath;
  final String? style;
}
