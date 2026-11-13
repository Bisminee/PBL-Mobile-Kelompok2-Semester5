import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sera_z/services/local_db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Test lapisan data (DAO). Memakai salinan `assets/db/fashion_app.db` yang
/// dibuka dengan konfigurasi dan migrasi yang sama seperti di aplikasi.
void main() {
  sqfliteFfiInit();
  final factory = databaseFactoryFfi;
  const asset = 'assets/db/fashion_app.db';

  late Directory folder;
  late Database database;
  late LocalDb dao;

  setUp(() async {
    folder = await Directory.systemTemp.createTemp('local_db_test');
    final path = p.join(folder.path, 'fashion_app.db');
    await File(asset).copy(path);
    database = await factory.openDatabase(path, options: LocalDb.openOptions);
    dao = LocalDb.withDatabase(database);
  });

  tearDown(() async {
    await database.close();
    await folder.delete(recursive: true);
  });

  Future<int> tambah({
    String type = 't_shirt',
    String slot = 'top',
    String color = 'black',
    String formality = 'non_formal',
  }) => dao.insertWardrobeItem(
    imagePath: '/foto/$type-$color.jpg',
    type: type,
    slot: slot,
    color: color,
    confidence: 0.9,
    formality: formality,
  );

  Future<bool> adaTabel(Database d, String nama) async => (await d.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
    [nama],
  )).isNotEmpty;

  group('lemari', () {
    test('insert lalu wardrobe mengembalikan item urut id naik', () async {
      final a = await tambah();
      final b = await tambah(type: 'pants', slot: 'bottom', color: 'blue');

      final rows = await dao.wardrobe();

      expect(rows.map((r) => r['id']), [a, b]);
      expect(rows.first['garment_type'], 't_shirt');
      expect(rows.last['slot'], 'bottom');
    });

    test('deleteWardrobeItem menghapus item yang dipilih saja', () async {
      final a = await tambah();
      final b = await tambah(type: 'pants', slot: 'bottom');

      await dao.deleteWardrobeItem(a);

      final rows = await dao.wardrobe();
      expect(rows.map((r) => r['id']), [b]);
    });

    test('formalitas di luar tiga nilai yang sah ditolak database', () async {
      expect(() => tambah(formality: 'sangat_formal'), throwsException);
    });
  });

  group('outfit tersimpan', () {
    test('saveOutfit lalu savedOutfits, terbaru lebih dulu', () async {
      final atas = await tambah();
      final bawah1 = await tambah(type: 'pants', slot: 'bottom');
      final bawah2 = await tambah(type: 'shorts', slot: 'bottom');

      await dao.saveOutfit('Pertama', 'non_formal', 0.8, [atas, bawah1]);
      await dao.saveOutfit('Kedua', 'formal', 0.6, [atas, bawah2]);

      final hasil = await dao.savedOutfits();
      expect(hasil.map((o) => o.name), ['Kedua', 'Pertama']);
      expect(hasil.first.formality, 'formal');
      expect(hasil.first.score, 0.6);
      expect(
        hasil.first.items.map((g) => g.id),
        containsAll(['$atas', '$bawah2']),
      );
      expect(hasil.last.items.length, 2);
    });

    test('outfitSaved mengenali susunan sama tanpa peduli urutan', () async {
      final atas = await tambah();
      final bawah = await tambah(type: 'pants', slot: 'bottom');
      final lain = await tambah(type: 'skirt', slot: 'bottom');
      await dao.saveOutfit('Paduan', 'non_formal', 0.5, [atas, bawah]);

      expect(await dao.outfitSaved([bawah, atas]), isTrue);
      expect(await dao.outfitSaved([atas, lain]), isFalse);
      expect(await dao.outfitSaved([atas]), isFalse);
    });

    test('menghapus item lemari ikut menghapus keterkaitan outfit', () async {
      final atas = await tambah();
      final bawah = await tambah(type: 'pants', slot: 'bottom');
      await dao.saveOutfit('Paduan', 'non_formal', 0.5, [atas, bawah]);

      await dao.deleteWardrobeItem(bawah);

      final hasil = await dao.savedOutfits();
      expect(hasil.single.items.map((g) => g.id), ['$atas']);
    });
  });

  group('riwayat rekomendasi', () {
    Future<void> catat(int atas, int bawah, {String judul = 'Paduan'}) =>
        dao.logRecommendation(
          topId: atas,
          bottomId: bawah,
          title: judul,
          formality: 'semi_formal',
          score: 0.7,
        );

    test('kosong sebelum ada yang dicatat', () async {
      expect(await dao.recommendationHistory(), isEmpty);
    });

    test(
      'tercatat dengan item, formalitas, dan skor; terbaru lebih dulu',
      () async {
        final atas = await tambah();
        final bawah1 = await tambah(type: 'pants', slot: 'bottom');
        final bawah2 = await tambah(type: 'shorts', slot: 'bottom');

        await catat(atas, bawah1, judul: 'Lama');
        await catat(atas, bawah2, judul: 'Baru');

        final hasil = await dao.recommendationHistory();
        expect(hasil.map((o) => o.name), ['Baru', 'Lama']);
        expect(hasil.first.formality, 'semi_formal');
        expect(hasil.first.score, 0.7);
        expect(hasil.first.items.map((g) => g.id), ['$atas', '$bawah2']);
      },
    );

    test(
      'pasangan yang sama tidak digandakan dan naik ke paling atas',
      () async {
        final atas = await tambah();
        final bawah1 = await tambah(type: 'pants', slot: 'bottom');
        final bawah2 = await tambah(type: 'shorts', slot: 'bottom');

        await catat(atas, bawah1, judul: 'A');
        await catat(atas, bawah2, judul: 'B');
        await catat(atas, bawah1, judul: 'A');

        final hasil = await dao.recommendationHistory();
        expect(hasil.map((o) => o.name), ['A', 'B']);
      },
    );

    test('limit membatasi jumlah riwayat', () async {
      final atas = await tambah();
      for (var i = 0; i < 3; i++) {
        final bawah = await tambah(type: 'pants', slot: 'bottom');
        await catat(atas, bawah, judul: 'Paduan $i');
      }

      final hasil = await dao.recommendationHistory(limit: 2);
      expect(hasil.map((o) => o.name), ['Paduan 2', 'Paduan 1']);
    });

    test('riwayat ikut hilang saat item lemari dihapus', () async {
      final atas = await tambah();
      final bawah = await tambah(type: 'pants', slot: 'bottom');
      await catat(atas, bawah);

      await dao.deleteWardrobeItem(atas);

      expect(await dao.recommendationHistory(), isEmpty);
    });

    test('riwayat tetap ada setelah database dibuka ulang', () async {
      final atas = await tambah();
      final bawah = await tambah(type: 'pants', slot: 'bottom');
      await catat(atas, bawah);
      final path = database.path;
      await database.close();

      database = await factory.openDatabase(path, options: LocalDb.openOptions);
      dao = LocalDb.withDatabase(database);

      expect((await dao.recommendationHistory()).length, 1);
    });
  });

  group('preferensi', () {
    test('null bila belum diatur, lalu nilai terakhir yang berlaku', () async {
      expect(await dao.preference('notifikasi'), isNull);

      await dao.setPreference('notifikasi', 'on');
      await dao.setPreference('notifikasi', 'off');

      expect(await dao.preference('notifikasi'), 'off');
    });
  });

  group('lookup ML', () {
    test(
      'predictFormality memakai nilai awal bila kombinasi tidak ada',
      () async {
        final r = await dao.predictFormality(
          'tidak_ada',
          'tidak_ada',
          'male',
          'adult',
        );

        expect(r['pred'], 'non_formal');
        expect(r['p_non_formal'], 1.0);
      },
    );

    test('predictFormality dan predictStyles membaca tabel asset', () async {
      final baris = (await database.rawQuery(
        'SELECT garment_type, color_family, gender, age_group, pred '
        'FROM ml_formality LIMIT 1',
      )).single;
      final args = [
        baris['garment_type'] as String,
        baris['color_family'] as String,
        baris['gender'] as String,
        baris['age_group'] as String,
      ];

      final formalitas = await dao.predictFormality(
        args[0],
        args[1],
        args[2],
        args[3],
      );
      final gaya = await dao.predictStyles(args[0], args[1], args[2], args[3]);

      expect(formalitas['pred'], baris['pred']);
      expect(gaya, isNotEmpty);
      final prob = gaya.map((r) => r['prob'] as double).toList();
      expect(prob, [...prob]..sort((a, b) => b.compareTo(a)));
    });

    test('recommendForSlot kosong bila belum ada item terpilih', () async {
      final r = await dao.recommendForSlot(
        selectedIds: const [],
        slot: 'shoes',
        formality: 'non_formal',
        gender: 'unisex',
        age: 'adult',
      );

      expect(r, isEmpty);
    });
  });

  group('migrasi skema', () {
    test('database asset baru langsung punya tabel baru', () async {
      expect(await adaTabel(database, 'app_preference'), isTrue);
      expect(await adaTabel(database, 'recommendation_history'), isTrue);
    });

    test('versi 2 ditingkatkan tanpa menghilangkan data lama', () async {
      final path = p.join(folder.path, 'lama.db');
      await File(asset).copy(path);
      final lama = await factory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 2,
          onCreate: (d, _) => d.execute(
            'CREATE TABLE app_preference ('
            'key TEXT PRIMARY KEY, value TEXT NOT NULL)',
          ),
        ),
      );
      await lama.insert('app_preference', {'key': 'k', 'value': 'v'});
      expect(await adaTabel(lama, 'recommendation_history'), isFalse);
      await lama.close();

      final baru = await factory.openDatabase(
        path,
        options: LocalDb.openOptions,
      );
      addTearDown(baru.close);

      expect(await adaTabel(baru, 'recommendation_history'), isTrue);
      expect(await LocalDb.withDatabase(baru).preference('k'), 'v');
    });
  });
}
