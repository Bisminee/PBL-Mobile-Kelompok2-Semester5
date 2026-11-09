import '../models/garment.dart';
import '../models/garment_labels.dart';

/// Urutan kategori di Home. Tetap, agar kartu tidak berpindah saat data berubah.
const List<String> kategoriHome = [
  'Atasan',
  'Bawahan',
  'Terusan',
  'Luaran',
  'Sepatu',
  'Aksesori',
];

/// Menghitung jumlah item lemari per kategori tampilan.
/// Kategori diturunkan dari `slot` lewat [categoryOfSlot].
Map<String, int> countByCategory(List<Garment> items) {
  final hasil = <String, int>{};
  for (final g in items) {
    final kategori = categoryOfSlot(g.slot);
    hasil[kategori] = (hasil[kategori] ?? 0) + 1;
  }
  return hasil;
}
