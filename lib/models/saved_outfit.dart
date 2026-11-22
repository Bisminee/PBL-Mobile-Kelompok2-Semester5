import 'garment.dart';
import 'garment_labels.dart';
import 'outfit.dart';

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

  /// Judul siap tampil. Nama yang diedit pengguna dipakai lebih dulu; data
  /// lama yang namanya kosong tetap memakai susunan item.
  String get title {
    if (name.trim().isNotEmpty) return name;
    if (items.isEmpty) return 'Outfit tersimpan';
    return items.map((g) => g.title).join(' + ');
  }

  /// Bentuk [Outfit] agar bisa dibuka di layar detail outfit yang sudah ada.
  /// Null bila item atasan atau bawahan tidak lengkap.
  Outfit? toOutfit() {
    final top = items.where((g) => g.slot == 'top').firstOrNull;
    final bottom = items.where((g) => g.slot == 'bottom').firstOrNull;
    if (top == null || bottom == null) return null;
    return Outfit(
      id: 'saved-$id',
      title: title,
      subtitle: formalityLabel(formality),
      top: top,
      bottom: bottom,
      score: score,
      formality: formality,
      reasons: [
        'Outfit tersimpan pada ${formatDateId(createdAt)}.',
        'Formalitas ${formalityLabel(formality).toLowerCase()}.',
      ],
    );
  }
}
