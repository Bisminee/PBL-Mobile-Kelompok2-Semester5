import 'package:file_selector/file_selector.dart' as file_selector;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// Membuka galeri HP untuk memilih satu foto pakaian.
///
/// Dipakai oleh tombol "Galeri" di Home, tombol galeri di layar kamera, dan
/// layar pratinjau ketika dibuka tanpa foto.
///
/// Ada dua jalur: `image_picker` (jalur utama) dan `file_selector`
/// (Storage Access Framework). Jalur kedua dipakai bila yang pertama gagal,
/// misalnya karena aplikasi galeri bawaan perangkat tidak merespons.
class GalleryService {
  GalleryService._();

  static final ImagePicker _picker = ImagePicker();

  static const _tipeGambar = file_selector.XTypeGroup(
    label: 'Gambar',
    mimeTypes: <String>['image/*'],
    extensions: <String>['jpg', 'jpeg', 'png', 'webp'],
  );

  /// Mengembalikan path foto yang dipilih, atau null bila pengguna membatalkan.
  /// Melempar error hanya bila kedua jalur gagal.
  static Future<String?> pick() async {
    Object? errorPertama;
    try {
      final foto = await _picker.pickImage(
        source: ImageSource.gallery,
        // Turunkan sedikit ukuran agar decode dan inferensi di HP lebih cepat.
        maxWidth: 2000,
        imageQuality: 92,
      );
      return foto?.path;
    } catch (error) {
      errorPertama = error;
      debugPrint('image_picker gagal membuka galeri: $error');
    }

    try {
      final berkas = await file_selector.openFile(
        acceptedTypeGroups: const [_tipeGambar],
      );
      return berkas?.path;
    } catch (error) {
      debugPrint('file_selector gagal membuka galeri: $error');
      // Laporkan error pertama karena itu penyebab aslinya.
      throw errorPertama;
    }
  }
}
