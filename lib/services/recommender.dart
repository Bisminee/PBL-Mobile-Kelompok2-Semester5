import 'package:flutter/material.dart';

import '../models/garment.dart';
import '../models/garment_labels.dart';
import '../models/outfit.dart';
import '../models/saved_outfit.dart';
import 'color_harmony.dart';

/// Layanan penyusun rekomendasi pakaian (Recommender).
/// Mengelola algoritma pencocokan atasan dan bawahan menggunakan
/// skor dari model ML, harmoni warna, dan aturan tingkat formalitas.

/// Warna yang mudah dipadukan dengan hampir semua warna lain.
const Set<String> neutralColors = {
  'black',
  'white',
  'gray',
  'cream',
  'beige',
  'brown',
  'navy',
};

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

/// Rekomendasi cadangan saat model tidak tersedia.
///
/// Skor diambil dari aturan harmoni warna dan formalitas, bukan dari model.
/// Dipakai E7.5 agar layar rekomendasi tidak kosong ketika TFLite gagal dimuat.
List<Outfit> buildRuleOutfits({
  required List<Garment> wardrobe,
  int limit = 10,
}) {
  bool siap(Garment g, String slot) => g.slot == slot && g.colorFamily != null;

  final tops = wardrobe.where((g) => siap(g, 'top')).toList();
  final bottoms = wardrobe.where((g) => siap(g, 'bottom')).toList();

  final hasil = <({double score, Outfit outfit})>[];
  for (final t in tops) {
    for (final b in bottoms) {
      final harmony = ColorHarmony.evaluate(t.colorValue, b.colorValue);
      final formality = lowerFormality(t.formality, b.formality);
      hasil.add((
        score: harmony.score,
        outfit: Outfit(
          id: '${t.id}-${b.id}',
          title: '${t.colorName} + ${b.colorName}',
          subtitle: formalityLabel(formality),
          top: t,
          bottom: b,
          score: harmony.score,
          formality: formality,
          reasons: [
            '${harmony.label}: ${harmony.detail}',
            _formalityReason(t, b),
            'Skor dari aturan harmoni karena model belum termuat.',
          ],
        ),
      ));
    }
  }
  hasil.sort((a, b) => b.score.compareTo(a.score));
  return hasil.take(limit).map((e) => e.outfit).toList();
}

/// Tiga outfit terbaik untuk satu item, dipakai halaman rekomendasi per piece.
class RecommendationGroup {
  const RecommendationGroup({required this.anchor, required this.outfits});

  final Garment anchor;
  final List<Outfit> outfits;
}

/// Tiga pasangan terbaik untuk [anchor]. Hanya atasan dan bawahan yang punya
/// slot pasangan; sepatu, tas, dan aksesori belum membentuk outfit.
List<Outfit> buildOutfitsForAnchor({
  required Garment anchor,
  required List<Garment> wardrobe,
  required PairScore pairScore,
  required double Function(double raw) toPercentile,
  int limit = 3,
}) {
  bool siap(Garment g, String slot) =>
      g.slot == slot && g.garmentType != null && g.colorFamily != null;

  if (!siap(anchor, 'top') && !siap(anchor, 'bottom')) return const [];

  final partners = wardrobe.where((g) {
    if (anchor.slot == 'top') return siap(g, 'bottom');
    return siap(g, 'top');
  });

  final hasil = <({double raw, Outfit outfit})>[];
  for (final partner in partners) {
    final top = anchor.slot == 'top' ? anchor : partner;
    final bottom = anchor.slot == 'top' ? partner : anchor;
    final raw = pairScore(
      top.garmentType!,
      top.colorFamily!,
      bottom.garmentType!,
      bottom.colorFamily!,
    );
    if (raw == null) continue;
    final pct = toPercentile(raw);
    final harmony = ColorHarmony.evaluate(top.colorValue, bottom.colorValue);
    final formality = lowerFormality(top.formality, bottom.formality);
    hasil.add((
      raw: raw,
      outfit: Outfit(
        id: '${top.id}-${bottom.id}',
        title: '${top.colorName} + ${bottom.colorName}',
        subtitle: formalityLabel(formality),
        top: top,
        bottom: bottom,
        score: pct,
        formality: formality,
        reasons: [
          '${harmony.label}: ${harmony.detail}',
          _formalityReason(top, bottom),
          'Skor pasangan lebih tinggi dari ${(pct * 100).round()}% kombinasi '
              'atasan-bawahan lain di data outfit stylist.',
        ],
      ),
    ));
  }
  hasil.sort((a, b) => b.raw.compareTo(a.raw));
  return hasil.take(limit).map((e) => e.outfit).toList();
}

/// Versi fallback tanpa model: tiga pasangan terbaik dari harmoni warna.
List<Outfit> buildRuleOutfitsForAnchor({
  required Garment anchor,
  required List<Garment> wardrobe,
  int limit = 3,
}) {
  bool siap(Garment g, String slot) => g.slot == slot && g.colorFamily != null;
  if (!siap(anchor, 'top') && !siap(anchor, 'bottom')) return const [];

  final partners = wardrobe.where((g) {
    if (anchor.slot == 'top') return siap(g, 'bottom');
    return siap(g, 'top');
  });

  final hasil = <({double score, Outfit outfit})>[];
  for (final partner in partners) {
    final top = anchor.slot == 'top' ? anchor : partner;
    final bottom = anchor.slot == 'top' ? partner : anchor;
    final harmony = ColorHarmony.evaluate(top.colorValue, bottom.colorValue);
    final formality = lowerFormality(top.formality, bottom.formality);
    hasil.add((
      score: harmony.score,
      outfit: Outfit(
        id: '${top.id}-${bottom.id}',
        title: '${top.colorName} + ${bottom.colorName}',
        subtitle: formalityLabel(formality),
        top: top,
        bottom: bottom,
        score: harmony.score,
        formality: formality,
        reasons: [
          '${harmony.label}: ${harmony.detail}',
          _formalityReason(top, bottom),
          'Skor dari aturan harmoni karena model belum termuat.',
        ],
      ),
    ));
  }
  hasil.sort((a, b) => b.score.compareTo(a.score));
  return hasil.take(limit).map((e) => e.outfit).toList();
}

/// Kelompok rekomendasi untuk setiap piece di lemari. Satu piece maksimal
/// mendapat tiga outfit, sehingga daftar bisa berisi pasangan yang sama dari
/// sudut pandang atasan dan bawahan.
List<RecommendationGroup> buildRecommendationGroups({
  required List<Garment> wardrobe,
  required PairScore pairScore,
  required double Function(double raw) toPercentile,
  int perItem = 3,
}) {
  return [
    for (final anchor in wardrobe)
      if (anchor.slot == 'top' || anchor.slot == 'bottom')
        RecommendationGroup(
          anchor: anchor,
          outfits: buildOutfitsForAnchor(
            anchor: anchor,
            wardrobe: wardrobe,
            pairScore: pairScore,
            toPercentile: toPercentile,
            limit: perItem,
          ),
        ),
  ].where((g) => g.outfits.isNotEmpty).toList();
}

List<RecommendationGroup> buildRuleRecommendationGroups({
  required List<Garment> wardrobe,
  int perItem = 3,
}) {
  return [
    for (final anchor in wardrobe)
      if (anchor.slot == 'top' || anchor.slot == 'bottom')
        RecommendationGroup(
          anchor: anchor,
          outfits: buildRuleOutfitsForAnchor(
            anchor: anchor,
            wardrobe: wardrobe,
            limit: perItem,
          ),
        ),
  ].where((g) => g.outfits.isNotEmpty).toList();
}

/// True bila outfit dengan susunan item yang sama sudah tersimpan. Dipakai
/// untuk menghapus outfit dari daftar rekomendasi setelah disimpan.
bool isOutfitSaved(Outfit outfit, Iterable<SavedOutfit> saved) {
  final target = {outfit.top.id, outfit.bottom.id};
  return saved.any((s) {
    final items = s.items.map((g) => g.id).toSet();
    return items.length == target.length && items.containsAll(target);
  });
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
