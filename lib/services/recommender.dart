import 'package:flutter/material.dart';

import '../models/garment.dart';
import '../models/garment_labels.dart';
import '../models/outfit.dart';
import 'color_harmony.dart';

/// Warna yang mudah dipadukan dengan hampir semua warna lain.
const Set<String> neutralColors = {'black', 'white', 'gray', 'beige', 'brown'};

/// Skor pasangan mentah (0..1) untuk (jenis A, warna A, jenis B, warna B). Null bila tidak ada.
typedef PairScore =
    double? Function(String typeA, String colorA, String typeB, String colorB);

/// Hubungan dua warna: Monokrom, Netral, Netral + aksen, atau Kontras.
String colorRelation(String? a, String? b) {
  if (a == null || b == null) return 'Netral';
  if (a == b) return 'Monokrom';
  final na = neutralColors.contains(a);
  final nb = neutralColors.contains(b);
  if (na && nb) return 'Netral';
  if (na || nb) return 'Netral + aksen';
  return 'Kontras';
}

/// Membentuk outfit atasan + bawahan dari pakaian yang sudah ada di lemari, diurut skor pasangan model.
///
/// [toPercentile] mengubah skor mentah menjadi persentil (0..1) di antara semua kombinasi atasan-bawahan.
/// Outfit.score berisi persentil itu, bukan peluang bahwa outfit "benar".
/// Urutan Outfit.reasons selalu: warna, formalitas, skor. Layar detail memberi judul berdasarkan urutan ini.
/// Terusan (dress), luaran, dan tas belum membentuk outfit karena Outfit hanya memuat atasan + bawahan.
List<Outfit> buildOutfits({
  required List<Garment> wardrobe,
  required PairScore pairScore,
  required double Function(double raw) toPercentile,
  int limit = 10,
}) {
  bool siap(Garment g, String slot) =>
      g.slot == slot && g.garmentType != null && g.colorFamily != null;

  final tops = wardrobe.where((g) => siap(g, 'top')).toList();
  final bottoms = wardrobe.where((g) => siap(g, 'bottom')).toList();

  final hasil = <({double raw, Outfit outfit})>[];
  for (final t in tops) {
    for (final b in bottoms) {
      final raw = pairScore(
        t.garmentType!,
        t.colorFamily!,
        b.garmentType!,
        b.colorFamily!,
      );
      if (raw == null) continue;
      final pct = toPercentile(raw);
      final formality = lowerFormality(t.formality, b.formality);
      final harmony = ColorHarmony.evaluate(t.colorValue, b.colorValue);
      hasil.add((
        raw: raw,
        outfit: Outfit(
          id: '${t.id}-${b.id}',
          title: '${t.colorName} + ${b.colorName}',
          subtitle: formalityLabel(formality),
          top: t,
          bottom: b,
          score: pct,
          formality: formality,
          reasons: [
            '${harmony.label}: ${harmony.detail}',
            _formalityReason(t, b),
            'Skor pasangan lebih tinggi dari ${(pct * 100).round()}% kombinasi '
                'atasan-bawahan lain di data outfit stylist.',
          ],
        ),
      ));
    }
  }
  hasil.sort((a, b) => b.raw.compareTo(a.raw));
  return hasil.take(limit).map((e) => e.outfit).toList();
}

String _formalityReason(Garment t, Garment b) {
  if (t.formality == b.formality) {
    return 'Tingkat formalitas sama: ${formalityLabel(t.formality)}.';
  }
  return 'Formalitas berbeda (atasan ${formalityLabel(t.formality).toLowerCase()}, '
      'bawahan ${formalityLabel(b.formality).toLowerCase()}); outfit dihitung '
      '${formalityLabel(lowerFormality(t.formality, b.formality)).toLowerCase()}.';
}

/// Dua alasan pertama digabung sebagai deskripsi singkat untuk kartu.
String describeOutfit(Outfit o) => o.reasons.take(2).join(' ');

/// Placeholder recommendation logic.
///
/// Pairs the anchor garment with a few partner bottoms using simple
/// color-harmony heuristics. Tidak lagi dipakai recommendationsProvider (diganti buildOutfits);
/// dipertahankan agar kode lama yang memanggilnya tetap jalan.
List<Outfit> buildPlaceholderOutfits(Garment anchor) {
  const partners =
      <({String label, String colorName, Color color, String style})>[
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
