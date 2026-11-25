import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sera_z/services/local_db.dart';
import 'package:sera_z/services/providers.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Memastikan pergantian akun memuat ulang data dari database, bukan memakai
/// cache akun sebelumnya.
class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier(this.initialUid);

  final String? initialUid;

  @override
  AppUser? build() => initialUid == null
      ? null
      : AppUser(
          name: initialUid!,
          email: '$initialUid@test.local',
          uid: initialUid,
        );
}

void main() {
  sqfliteFfiInit();
  final factory = databaseFactoryFfi;

  late Directory folder;
  late Database database;
  late LocalDb dao;

  setUp(() async {
    folder = await Directory.systemTemp.createTemp('account_scope_test');
    final path = p.join(folder.path, 'fashion_app.db');
    await File('assets/db/fashion_app.db').copy(path);
    database = await factory.openDatabase(path, options: LocalDb.openOptions);
    dao = LocalDb.withDatabase(database);
  });

  tearDown(() async {
    await database.close();
    await folder.delete(recursive: true);
  });

  test(
    'lemari berganti saat uid berubah dan kembali ke data akun semula',
    () async {
      Future<int> tambah(String uid, String type) => dao.insertWardrobeItem(
        ownerUid: uid,
        imagePath: '/foto/$uid-$type.jpg',
        type: type,
        slot: type == 'pants' ? 'bottom' : 'top',
        color: 'black',
        colorHex: '#1A1A1A',
        confidence: 0.9,
        formality: 'non_formal',
      );

      final a = await tambah('akun-a', 't_shirt');
      await tambah('akun-b', 'pants');

      final container = ProviderContainer(
        overrides: [
          localDbProvider.overrideWithValue(dao),
          authProvider.overrideWith(() => _FakeAuthNotifier('akun-a')),
        ],
      );
      addTearDown(container.dispose);
      final sub = container.listen(wardrobeProvider, (_, _) {});
      addTearDown(sub.close);

      await _tunggu(() => container.read(wardrobeProvider).isNotEmpty);
      expect(container.read(wardrobeProvider).map((g) => g.id), ['$a']);

      container
          .read(authProvider.notifier)
          .setUser(
            const AppUser(uid: 'akun-b', name: 'Akun B', email: 'b@test.local'),
          );
      await _tunggu(
        () => container
            .read(wardrobeProvider)
            .any((g) => g.garmentType == 'pants'),
      );
      expect(container.read(wardrobeProvider).map((g) => g.garmentType), [
        'pants',
      ]);

      container
          .read(authProvider.notifier)
          .setUser(
            const AppUser(uid: 'akun-a', name: 'Akun A', email: 'a@test.local'),
          );
      await _tunggu(() => container.read(wardrobeProvider).isNotEmpty);
      expect(container.read(wardrobeProvider).map((g) => g.id), ['$a']);
    },
  );
}

Future<void> _tunggu(bool Function() selesai) async {
  for (var i = 0; i < 50; i++) {
    if (selesai()) return;
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
  fail('Data tidak selesai dimuat.');
}
