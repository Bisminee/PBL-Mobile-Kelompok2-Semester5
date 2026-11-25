import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Menyimpan foto pakaian per akun.
///
/// Di Android folder berada di penyimpanan eksternal khusus aplikasi:
/// `Android/data/<package>/files/wardrobe/<uid>`.
/// Folder ini tidak dipindai galeri dan tidak memerlukan izin storage.
class PhotoStorage {
  PhotoStorage._();

  static String safeUid(String uid) =>
      uid.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');

  static Future<Directory> _baseDirectory() async {
    if (!kIsWeb && Platform.isAndroid) {
      try {
        final external = await getExternalStorageDirectory();
        if (external != null) return external;
      } catch (_) {
        // Jatuh ke folder dokumen bila perangkat tidak menyediakan external.
      }
    }
    return getApplicationDocumentsDirectory();
  }

  static Future<Directory> wardrobeDirectory(String uid) async {
    final base = await _baseDirectory();
    final dir = Directory(p.join(base.path, 'wardrobe', safeUid(uid)));
    await dir.create(recursive: true);
    return dir;
  }

  static Future<String> save(
    String uid,
    String sourcePath, {
    String? extension,
  }) async {
    final dir = await wardrobeDirectory(uid);
    final ext = extension ?? p.extension(sourcePath);
    final name = '${DateTime.now().microsecondsSinceEpoch}$ext';
    final target = p.join(dir.path, name);
    await File(sourcePath).copy(target);
    return target;
  }

  /// Folder lama sebelum data dipisahkan per akun.
  static Future<Directory> legacyWardrobeDirectory() async {
    final base = await getApplicationDocumentsDirectory();
    return Directory(p.join(base.path, 'wardrobe'));
  }

  /// Menyalin foto lama tanpa menghapus sumbernya. Sumber baru dihapus setelah
  /// seluruh baris database berhasil diklaim, sehingga proses yang terhenti di
  /// tengah tidak menghilangkan foto.
  static Future<String?> copyLegacyFile(String uid, String oldPath) async {
    final source = File(oldPath);
    if (!await source.exists()) return null;
    try {
      return await save(uid, oldPath);
    } catch (_) {
      return null;
    }
  }

  static Future<void> deleteFileIfOwned(String path) async {
    final normalized = path.replaceAll('\\', '/');
    if (!normalized.contains('/wardrobe/')) return;
    final file = File(path);
    try {
      if (await file.exists()) await file.delete();
    } catch (_) {
      // File mungkin sudah dihapus atau sedang dipakai proses lain.
    }
  }

  static Future<void> deleteUserFolder(String uid) async {
    final base = await _baseDirectory();
    final dir = Directory(p.join(base.path, 'wardrobe', safeUid(uid)));
    if (await dir.exists()) await dir.delete(recursive: true);
  }
}
