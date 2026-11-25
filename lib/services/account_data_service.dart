import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local_db.dart';
import 'photo_storage.dart';
import 'providers.dart';

/// Mengelola data lama dan pembersihan data milik satu akun.
class AccountDataService {
  AccountDataService(this._db);

  final LocalDb _db;

  Future<int> legacyCount() => _db.legacyDataCount();

  /// Klaim manual: foto disalin ke folder uid, lalu baris database diberi
  /// owner_uid. Foto lama baru dihapus setelah semua baris berhasil diklaim,
  /// sehingga proses yang terhenti di tengah tidak menghilangkan data.
  Future<void> claimLegacy(String uid) async {
    final items = await _db.legacyWardrobe();
    final oldPhotos = <String>[];
    for (final item in items) {
      final id = item['id'] as int;
      final oldPath = item['image_path'] as String?;
      var path = oldPath ?? '';
      if (oldPath != null && oldPath.isNotEmpty) {
        final copied = await PhotoStorage.copyLegacyFile(uid, oldPath);
        if (copied != null) {
          path = copied;
          oldPhotos.add(oldPath);
        }
      }
      await _db.claimLegacyWardrobeItem(id, ownerUid: uid, imagePath: path);
    }
    await _db.claimLegacyData(uid);
    for (final oldPath in oldPhotos) {
      await PhotoStorage.deleteFileIfOwned(oldPath);
    }
  }

  Future<void> deleteUserData(String uid) async {
    await _db.deleteUserData(uid);
    await PhotoStorage.deleteUserFolder(uid);
  }
}

final accountDataServiceProvider = Provider<AccountDataService>((ref) {
  return AccountDataService(ref.watch(localDbProvider));
});

final legacyDataCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final uid = ref.watch(activeUidProvider);
  if (uid == null) return 0;
  return ref.watch(accountDataServiceProvider).legacyCount();
});
