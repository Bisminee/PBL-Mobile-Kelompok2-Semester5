import 'package:flutter/material.dart';

import '../models/garment.dart';
import '../models/outfit.dart';

/// Placeholder recommendation logic.
///
/// Pairs the anchor garment with a few partner bottoms using simple
/// color-harmony heuristics. To be replaced by Model 3 (MLP) + harmony rules.
List<Outfit> buildPlaceholderOutfits(Garment anchor) {
  const partners = <({String label, String colorName, Color color, String style})>[
    (
      label: 'Non Formal',
      colorName: 'cokelat',
      color: Color(0xFF6D4C41),
      style: 'Gothic',
    ),
    (
      label: 'Formal',
      colorName: 'navy',
      color: Color(0xFF1A237E),
      style: 'Classic',
    ),
    (
      label: 'Smart Casual',
      colorName: 'krem',
      color: Color(0xFFD7CCC8),
      style: 'Minimal',
    ),
  ];

  const scores = [0.92, 0.85, 0.78];

  return [
    for (var i = 0; i < partners.length; i++)
      Outfit(
        id: '${anchor.id}-pair-$i',
        title: partners[i].label,
        subtitle: partners[i].style,
        top: anchor,
        bottom: Garment(
          id: '${anchor.id}-bottom-$i',
          category: 'Bawahan',
          colorName: partners[i].colorName,
          colorValue: partners[i].color,
        ),
        score: scores[i],
        reasons: [
          'Harmoni warna ${anchor.colorName} dengan ${partners[i].colorName}',
          'Kategori atasan–bawahan cocok',
        ],
      ),
  ];
}
