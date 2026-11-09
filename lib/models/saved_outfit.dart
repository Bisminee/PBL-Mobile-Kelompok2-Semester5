import 'garment.dart';

/// Satu paduan outfit yang sudah disimpan pengguna.
///
/// Berbeda dari [Outfit] yang dihitung ulang dari lemari, kelas ini adalah
/// data yang benar-benar tersimpan di tabel `outfit` + `outfit_item`.
class SavedOutfit {
  const SavedOutfit({
    required this.id,
    required this.name,
    required this.formality,
    required this.score,
    required this.createdAt,
    required this.items,
  });

  final int id;
  final String name;

  /// non_formal | semi_formal | formal
  final String formality;

  /// Skor pasangan saat outfit disimpan (0..1).
  final double score;
  final DateTime createdAt;
  final List<Garment> items;

  /// Judul siap tampil, mis. "Kaos Hitam + Celana Panjang Biru".
  String get title {
    if (items.isEmpty) return name;
    return items.map((g) => g.title).join(' + ');
  }
}
