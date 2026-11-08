import 'package:flutter/material.dart';

import '../models/garment.dart';
import '../models/outfit.dart';
import 'color_harmony.dart';

/// Logika murni untuk tab Detail outfit (E8.5). Dipisah dari widget agar bisa
/// diuji tanpa merender layar.

/// "#RRGGBB" dari sebuah Color, untuk ditampilkan di tab Warna.
String hexOf(Color c) {
  String two(double v) =>
      (v * 255).round().clamp(0, 255).toRadixString(16).padLeft(2, '0');
  return '#${two(c.r)}${two(c.g)}${two(c.b)}'.toUpperCase();
}

/// Satu item lemari pengganti beserta hasil harmoninya dengan pasangan outfit.
typedef Alternative = ({Garment garment, HarmonyResult harmony});

/// Item lain di lemari yang bisa menggantikan bagian [slot] ('top' atau
/// 'bottom') pada [outfit], diurut dari harmoni warna tertinggi terhadap
/// pasangannya. Item yang sedang dipakai outfit tidak ikut.
///
/// Memakai aturan harmoni, bukan skor model, supaya tetap tersedia saat model
/// belum termuat dan tidak perlu memanggil engine untuk setiap item.
List<Alternative> wardrobeAlternatives({
  required List<Garment> wardrobe,
  required Outfit outfit,
  required String slot,
  int limit = 3,
}) {
  final current = slot == 'top' ? outfit.top : outfit.bottom;
  final partner = slot == 'top' ? outfit.bottom : outfit.top;
  final hasil = <Alternative>[
    for (final g in wardrobe)
      if (g.slot == slot && g.id != current.id)
        (
          garment: g,
          harmony: ColorHarmony.evaluate(g.colorValue, partner.colorValue),
        ),
  ];
  hasil.sort((a, b) => b.harmony.score.compareTo(a.harmony.score));
  return hasil.take(limit).toList();
}

/// Ringkasan gaya: satu label bila atasan dan bawahan sama, dua label bila
/// berbeda, "-" bila keduanya belum punya data gaya.
String styleSummary(
  String? top,
  String? bottom,
  String Function(String?) label,
) {
  if (top == null && bottom == null) return '-';
  if (top == null || bottom == null || top == bottom) {
    return label(top ?? bottom);
  }
  return '${label(top)} + ${label(bottom)}';
}

/// Persen keyakinan deteksi ("87%"), atau null bila item ditambah manual.
String? confidenceText(double? conf) =>
    conf == null ? null : '${(conf * 100).round()}%';
