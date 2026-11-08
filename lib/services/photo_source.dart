import 'package:flutter/services.dart' show PlatformException;
import 'package:image_picker/image_picker.dart';

/// Hasil pemilihan foto dari galeri.
enum PhotoPickStatus { picked, cancelled, denied, failed }

/// Hasil pemilihan foto. [path] hanya terisi saat status [PhotoPickStatus.picked].
class PhotoPickResult {
  const PhotoPickResult._(this.status, {this.path, this.message});

  const PhotoPickResult.picked(String path)
    : this._(PhotoPickStatus.picked, path: path);
  const PhotoPickResult.cancelled() : this._(PhotoPickStatus.cancelled);
  const PhotoPickResult.denied() : this._(PhotoPickStatus.denied);
  const PhotoPickResult.failed(String message)
    : this._(PhotoPickStatus.failed, message: message);

  final PhotoPickStatus status;
  final String? path;
  final String? message;
}

/// Sumber foto galeri. Dibuat sebagai antarmuka agar bisa diganti versi palsu
/// saat widget test, karena pemilih asli butuh plugin perangkat.
abstract class PhotoPicker {
  Future<PhotoPickResult> pickFromGallery();
}

/// Pemilih galeri memakai Android Photo Picker bawaan image_picker.
class GalleryPhotoPicker implements PhotoPicker {
  GalleryPhotoPicker({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<PhotoPickResult> pickFromGallery() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        // Model hanya membaca 224 px. Batas ini menjaga foto 48 MP tidak
        // menghabiskan memori saat decode dan crop.
        maxWidth: 2048,
        maxHeight: 2048,
      );
      if (file == null) return const PhotoPickResult.cancelled();
      return PhotoPickResult.picked(file.path);
    } on PlatformException catch (error) {
      final code = error.code.toLowerCase();
      if (code.contains('denied') || code.contains('permission')) {
        return const PhotoPickResult.denied();
      }
      return PhotoPickResult.failed(error.message ?? 'Gagal membuka galeri.');
    } catch (_) {
      return const PhotoPickResult.failed('Gagal membuka galeri.');
    }
  }
}
