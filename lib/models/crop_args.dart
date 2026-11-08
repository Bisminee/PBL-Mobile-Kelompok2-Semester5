import '../services/image_crop.dart';

/// Argumen rute halaman crop.
class CropArgs {
  const CropArgs({required this.originalPath, this.initialSpec});

  /// Foto asli di `scan_tmp` yang belum dipotong.
  final String originalPath;

  /// Kotak crop terakhir, dipakai saat pengguna menekan "Sesuaikan" lagi.
  final CropSpec? initialSpec;
}

/// Hasil halaman crop yang dikembalikan ke pratinjau.
class CropOutcome {
  const CropOutcome({required this.path, required this.spec});

  /// Path hasil crop di `scan_tmp`.
  final String path;
  final CropSpec spec;
}
