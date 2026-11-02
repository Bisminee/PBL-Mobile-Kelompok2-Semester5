import 'garment.dart';

/// A recommended pairing of a top and a bottom item.
class Outfit {
  const Outfit({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.top,
    required this.bottom,
    required this.score,
    required this.reasons,
    this.formality,
  });

  final String id;
  final String title;
  final String subtitle;
  final Garment top;
  final Garment bottom;

  /// 0..1. Untuk outfit dari model, ini persentil skor pasangan di antara semua kombinasi
  /// atasan-bawahan, bukan probabilitas bahwa outfit ini "benar".
  final double score;

  /// Urutan tetap untuk outfit dari model: warna, formalitas, skor.
  final List<String> reasons;

  /// non_formal | semi_formal | formal. Null untuk outfit placeholder.
  final String? formality;

  int get scorePercent => (score * 100).round();

  // Kunci family di providers.dart memakai Outfit; kesamaan berdasarkan id supaya
  // outfit yang dibangun ulang dengan isi sama tidak memicu pemuatan ulang.
  @override
  bool operator ==(Object other) => other is Outfit && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
