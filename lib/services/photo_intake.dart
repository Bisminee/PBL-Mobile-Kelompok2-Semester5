import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show compute;
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Sisi terpanjang foto yang disimpan sementara. Model hanya butuh 224 px,
/// sedangkan layar detail butuh sekitar 1024 px.
const int maxPhotoSide = 2048;

/// Folder sementara untuk foto yang sedang diproses.
const String scanTempFolder = 'scan_tmp';

/// Membakar orientasi EXIF, membatasi sisi terpanjang ke [maxPhotoSide], lalu
/// menyimpan ulang sebagai JPEG. Mengembalikan null bila gambar tidak terbaca.
///
/// Fungsi top-level agar bisa dijalankan lewat compute(): decode foto kamera
/// 12 MP memakan 1-2 detik dan akan membekukan UI bila di isolate utama.
Uint8List? normalizePhoto(Uint8List bytes, {int maxSide = maxPhotoSide}) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return null;
  final src = img.bakeOrientation(decoded);
  final longest = math.max(src.width, src.height);
  final resized = longest <= maxSide
      ? src
      : img.copyResize(
          src,
          width: src.width >= src.height ? maxSide : null,
          height: src.height > src.width ? maxSide : null,
        );
  return img.encodeJpg(resized, quality: 92);
}

/// Menyimpan foto masuk ke folder sementara aplikasi.
///
/// Semua foto, baik dari kamera maupun galeri, disalin ke `scan_tmp` supaya
/// pratinjau dan analisis tidak bergantung pada path cache plugin yang bisa
/// dibersihkan sistem kapan saja.
class PhotoIntake {
  PhotoIntake._();

  static Future<String?> prepare(
    Uint8List bytes, {
    String prefix = 'orig',
  }) async {
    final normalized = await compute(normalizePhoto, bytes);
    if (normalized == null) return null;
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory(p.join(dir.path, scanTempFolder));
    await folder.create(recursive: true);
    final file = File(
      p.join(
        folder.path,
        '${prefix}_${DateTime.now().microsecondsSinceEpoch}.jpg',
      ),
    );
    await file.writeAsBytes(normalized, flush: true);
    return file.path;
  }
}
