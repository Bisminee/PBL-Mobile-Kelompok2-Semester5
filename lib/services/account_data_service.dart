import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local_db.dart';
import 'photo_storage.dart';
import 'providers.dart';

/// Mengelola data lama dan pembersihan data milik satu akun.
class AccountDataService {
  AccountDataService(this._db);

  final LocalDb _db;

  Future<int> legacyCount() => _db.legacyDataCount();

  /// Klaim manual: foto dipindahkan ke folder uid, lalu baris database diberi
  /// owner_uid. Jika pemindahan foto gagal, path lama tetap dipakai agar data
  /// tidak hilang.
  Future<void> claimLegacy(String uid) async {
    final items = await _db.legacyWardrobe();
    for (final item in items) {
      final id = item['id'] as int;
      final oldPath = item['image_path'] as String?;
      var path = oldPath ?? '';
      if (oldPath != null && oldPath.isNotEmpty) {
        path = await PhotoStorage.moveLegacyFile(uid, oldPath) ?? oldPath;
      }
      await _db.claimLegacyWardrobeItem(id, ownerUid: uid, imagePath: path);
    }
    await _db.claimLegacyData(uid);
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
