// SQLite: menyimpan data user (wardrobe_item, outfit) dan membaca tabel hasil ML
// (ml_formality, ml_style, ml_pair_score, catalog_item) dari fashion_app.db.
// Asset: assets/db/fashion_app.db (didaftarkan di pubspec.yaml).
import 'dart:io';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/garment.dart';
import '../models/saved_outfit.dart';

class LocalDb {
  LocalDb._();
  static final LocalDb instance = LocalDb._();

  /// Memakai database yang sudah terbuka, mis. database sementara pada test.
  @visibleForTesting
  LocalDb.withDatabase(Database database) : _opening = Future.value(database);

  static const _assetPath = 'assets/db/fashion_app.db';

  // Asset hanya disalin SEKALI, saat file belum ada di perangkat. Bila fashion_app.db di asset
  // diganti (model baru), uninstall aplikasi dulu. Wardrobe user ikut hilang karena satu file.
  // Untuk rilis, pisahkan data user dan tabel ML menjadi dua file DB.
  // Versi 2 menambah tabel app_preference untuk pengaturan lokal profil.
  // Versi 3 menambah tabel recommendation_history untuk riwayat rekomendasi.
  // Versi 4 menambah lima warna baru ke ref_color agar edit atribut bisa
  // memakai 16 keluarga warna.
  // Versi 5 memisahkan data pengguna per akun dengan owner_uid.
  // Catatan: versi 1 adalah skema di assets/db/fashion_app.db.
  static const _version = 5;

  // Satu Future dipakai bersama: pemanggil pertama (preload engine dan WardrobeNotifier jalan
  // hampir bersamaan) tidak boleh sama-sama menyalin file asset.
  Future<Database>? _opening;

  Future<Database> get db => _opening ??= _open();

  Future<Database> _open() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'fashion_app.db');
    if (!await File(path).exists()) {
      final data = await rootBundle.load(_assetPath);
      await File(path).writeAsBytes(data.buffer.asUint8List(), flush: true);
    }
    return openDatabase(
      path,
      version: openOptions.version,
      onConfigure: openOptions.onConfigure,
      onCreate: openOptions.onCreate,
      onUpgrade: openOptions.onUpgrade,
    );
  }

  /// Konfigurasi pembukaan database. Dipisah agar test memakai migrasi yang sama.
  ///
  /// Database dari asset sudah berisi skema versi 1. Tabel baru ditambahkan
  /// lewat onUpgrade (pengguna lama) atau onCreate (pemasangan baru, karena
  /// user_version di asset masih 0).
  @visibleForTesting
  static final OpenDatabaseOptions openOptions = OpenDatabaseOptions(
    version: _version,
    onConfigure: (d) => d.execute('PRAGMA foreign_keys = ON'),
    onCreate: (d, versi) => _buatTabelBaru(d, 0, versi),
    onUpgrade: _buatTabelBaru,
  );

  static Future<void> _buatTabelBaru(
    Database d,
    int versiLama,
    int versiBaru,
  ) async {
    if (versiLama < 2) {
      await d.execute(
        'CREATE TABLE IF NOT EXISTS app_preference ('
        'key TEXT PRIMARY KEY, value TEXT NOT NULL)',
      );
    }
    if (versiLama < 3) {
      // Satu baris per pasangan atasan-bawahan; dilihat lagi berarti baris baru
      // menggantikan yang lama sehingga urutan id menunjukkan yang terbaru.
      await d.execute(
        'CREATE TABLE IF NOT EXISTS recommendation_history ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'top_item_id INTEGER NOT NULL REFERENCES wardrobe_item(id) ON DELETE CASCADE, '
        'bottom_item_id INTEGER NOT NULL REFERENCES wardrobe_item(id) ON DELETE CASCADE, '
        'title TEXT NOT NULL, '
        'target_formality TEXT NOT NULL, '
        'match_score REAL, '
        "created_at TEXT NOT NULL DEFAULT (datetime('now')), "
        'UNIQUE (top_item_id, bottom_item_id))',
      );
    }
    if (versiLama < 4) {
      const colors = {
        'cream': '#F2E3C6',
        'maroon': '#7B1F2B',
        'olive': '#6B8E23',
        'teal': '#00897B',
        'navy': '#1A237E',
      };
      for (final entry in colors.entries) {
        await d.insert('ref_color', {
          'color_family': entry.key,
          'hex': entry.value,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }
    if (versiLama < 5) {
      for (final table in [
        'wardrobe_item',
        'outfit',
        'recommendation_history',
      ]) {
        final columns = await d.rawQuery('PRAGMA table_info($table)');
        final hasOwner = columns.any((c) => c['name'] == 'owner_uid');
        if (!hasOwner) {
          await d.execute('ALTER TABLE $table ADD COLUMN owner_uid TEXT');
        }
        await d.execute(
          "UPDATE $table SET owner_uid = '__legacy__' "
          'WHERE owner_uid IS NULL OR owner_uid = \'\'',
        );
      }

      // app_preference lama memakai key sebagai primary key. Tabel baru
      // memakai pasangan (owner_uid, key) agar preferensi tidak tercampur.
      await d.execute(
        'CREATE TABLE IF NOT EXISTS app_preference_v5 ('
        'owner_uid TEXT NOT NULL, '
        'key TEXT NOT NULL, '
        'value TEXT NOT NULL, '
        'PRIMARY KEY (owner_uid, key))',
      );
      final prefs = await d.query('app_preference');
      for (final row in prefs) {
        await d.insert('app_preference_v5', {
          'owner_uid': '__legacy__',
          'key': row['key'],
          'value': row['value'],
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
      await d.execute('DROP TABLE app_preference');
      await d.execute('ALTER TABLE app_preference_v5 RENAME TO app_preference');

      await d.execute(
        'CREATE INDEX IF NOT EXISTS idx_wardrobe_owner '
        'ON wardrobe_item(owner_uid)',
      );
      await d.execute(
        'CREATE INDEX IF NOT EXISTS idx_outfit_owner ON outfit(owner_uid)',
      );
      await d.execute(
        'CREATE INDEX IF NOT EXISTS idx_history_owner '
        'ON recommendation_history(owner_uid)',
      );
    }
  }

  // ---------- Lookup ML (hasil model sklearn yang sudah dihitung untuk semua kombinasi) ----------

  /// Prediksi formalitas: non_formal | semi_formal | formal beserta probabilitasnya.
  Future<Map<String, dynamic>> predictFormality(
    String type,
    String color,
    String gender,
    String age,
  ) async {
    final d = await db;
    final r = await d.rawQuery(
      'SELECT pred, p_non_formal, p_semi_formal, p_formal FROM ml_formality '
      'WHERE garment_type=? AND color_family=? AND gender=? AND age_group=?',
      [type, color, gender, age],
    );
    if (r.isEmpty) {
      return {
        'pred': 'non_formal',
        'p_non_formal': 1.0,
        'p_semi_formal': 0.0,
        'p_formal': 0.0,
      };
    }
    return r.first;
  }

  /// Top-3 style (casual, minimalist, ...) beserta probabilitas, terurut menurun.
  Future<List<Map<String, dynamic>>> predictStyles(
    String type,
    String color,
    String gender,
    String age,
  ) async {
    final d = await db;
    return d.rawQuery(
      'SELECT style, prob FROM ml_style '
      'WHERE garment_type=? AND color_family=? AND gender=? AND age_group=? ORDER BY prob DESC',
      [type, color, gender, age],
    );
  }

  // ---------- Data user ----------

  Future<int> insertWardrobeItem({
    String ownerUid = 'default',
    required String imagePath,
    required String type,
    required String slot,
    required String color,
    String? colorHex,
    required double confidence,
    required String formality,
    String? style,
  }) async {
    final d = await db;
    return d.insert('wardrobe_item', {
      'owner_uid': ownerUid,
      'image_path': imagePath,
      'garment_type': type,
      'slot': slot,
      'color_family': color,
      'color_hex': colorHex,
      'detection_conf': confidence,
      'formality': formality,
      'style': style,
    });
  }

  /// Memperbarui atribut pakaian tanpa mengubah foto dan tanggal ditambahkan.
  Future<void> updateWardrobeItem({
    required int id,
    String ownerUid = 'default',
    required String type,
    required String slot,
    required String color,
    required String colorHex,
    required String formality,
    String? style,
  }) async {
    final d = await db;
    await d.update(
      'wardrobe_item',
      {
        'garment_type': type,
        'slot': slot,
        'color_family': color,
        'color_hex': colorHex,
        'formality': formality,
        'style': style,
      },
      where: 'id = ? AND owner_uid = ?',
      whereArgs: [id, ownerUid],
    );
  }

  /// Urut id naik: item terbaru ada di akhir daftar (sesuai WardrobeNotifier.latest).
  Future<List<Map<String, dynamic>>> wardrobe({
    String ownerUid = 'default',
  }) async => (await db).query(
    'wardrobe_item',
    where: 'owner_uid = ?',
    whereArgs: [ownerUid],
    orderBy: 'id ASC',
  );

  Future<void> deleteWardrobeItem(
    int id, {
    String ownerUid = 'default',
  }) async => (await db).delete(
    'wardrobe_item',
    where: 'id = ? AND owner_uid = ?',
    whereArgs: [id, ownerUid],
  );

  Future<int> saveOutfit(
    String name,
    String formality,
    double score,
    List<int> itemIds, {
    String ownerUid = 'default',
  }) async {
    final d = await db;
    return d.transaction((t) async {
      final id = await t.insert('outfit', {
        'owner_uid': ownerUid,
        'name': name,
        'target_formality': formality,
        'match_score': score,
      });
      for (final w in itemIds) {
        await t.insert('outfit_item', {'outfit_id': id, 'wardrobe_item_id': w});
      }
      return id;
    });
  }

  /// True bila sudah ada outfit tersimpan dengan susunan item yang sama.
  /// Dipakai agar tombol "Simpan Outfit" tidak membuat duplikat.
  Future<bool> outfitSaved(
    List<int> itemIds, {
    String ownerUid = 'default',
  }) async {
    if (itemIds.length < 2) return false;
    final d = await db;
    final rows = await d.rawQuery(
      'SELECT oi.outfit_id, oi.wardrobe_item_id '
      'FROM outfit_item oi JOIN outfit o ON o.id = oi.outfit_id '
      'WHERE o.owner_uid = ?',
      [ownerUid],
    );
    final perOutfit = <int, Set<int>>{};
    for (final r in rows) {
      perOutfit
          .putIfAbsent(r['outfit_id'] as int, () => <int>{})
          .add(r['wardrobe_item_id'] as int);
    }
    final target = itemIds.toSet();
    return perOutfit.values.any(
      (s) => s.length == target.length && s.containsAll(target),
    );
  }

  /// Mengubah nama dan formalitas outfit tersimpan tanpa mengubah itemnya.
  Future<void> updateSavedOutfit(
    int id, {
    String ownerUid = 'default',
    required String name,
    required String formality,
  }) async {
    final d = await db;
    await d.update(
      'outfit',
      {'name': name.trim(), 'target_formality': formality},
      where: 'id = ? AND owner_uid = ?',
      whereArgs: [id, ownerUid],
    );
  }

  /// Menghapus satu outfit tersimpan. Item lemari tidak ikut dihapus.
  Future<void> deleteSavedOutfit(int id, {String ownerUid = 'default'}) async {
    final d = await db;
    await d.transaction((t) async {
      final owned = await t.query(
        'outfit',
        columns: ['id'],
        where: 'id = ? AND owner_uid = ?',
        whereArgs: [id, ownerUid],
        limit: 1,
      );
      if (owned.isEmpty) return;
      await t.delete('outfit_item', where: 'outfit_id = ?', whereArgs: [id]);
      await t.delete(
        'outfit',
        where: 'id = ? AND owner_uid = ?',
        whereArgs: [id, ownerUid],
      );
    });
  }

  /// Semua outfit tersimpan, terbaru lebih dulu, beserta item lemari di dalamnya.
  Future<List<SavedOutfit>> savedOutfits({String ownerUid = 'default'}) async {
    final d = await db;
    final outfits = await d.query(
      'outfit',
      where: 'owner_uid = ?',
      whereArgs: [ownerUid],
      orderBy: 'id DESC',
    );
    if (outfits.isEmpty) return <SavedOutfit>[];

    final rows = await d.rawQuery(
      'SELECT oi.outfit_id, w.* FROM outfit_item oi '
      'JOIN outfit o ON o.id = oi.outfit_id '
      'JOIN wardrobe_item w ON w.id = oi.wardrobe_item_id '
      'WHERE o.owner_uid = ? '
      'ORDER BY oi.outfit_id DESC',
      [ownerUid],
    );
    final itemsPerOutfit = <int, List<Garment>>{};
    for (final row in rows) {
      final id = row['outfit_id'] as int;
      itemsPerOutfit
          .putIfAbsent(id, () => <Garment>[])
          .add(Garment.fromRow(row));
    }

    return [
      for (final o in outfits)
        SavedOutfit(
          id: o['id'] as int,
          name: o['name'] as String,
          formality: o['target_formality'] as String,
          score: (o['match_score'] as num?)?.toDouble() ?? 0,
          createdAt:
              DateTime.tryParse((o['created_at'] as String?) ?? '') ??
              DateTime.now(),
          items: itemsPerOutfit[o['id']] ?? const <Garment>[],
        ),
    ];
  }

  // ---------- Riwayat rekomendasi ----------

  /// Mencatat bahwa pengguna melihat rekomendasi atasan + bawahan ini.
  /// Pasangan yang sama tidak digandakan; catatan lama diganti yang terbaru.
  Future<void> logRecommendation({
    String ownerUid = 'default',
    required int topId,
    required int bottomId,
    required String title,
    required String formality,
    required double score,
  }) async {
    final d = await db;
    await d.insert('recommendation_history', {
      'owner_uid': ownerUid,
      'top_item_id': topId,
      'bottom_item_id': bottomId,
      'title': title,
      'target_formality': formality,
      'match_score': score,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Riwayat rekomendasi, terbaru lebih dulu. Item yang sudah dihapus dari
  /// lemari ikut hilang dari riwayat.
  Future<List<SavedOutfit>> recommendationHistory({
    String ownerUid = 'default',
    int limit = 50,
  }) async {
    final d = await db;
    final rows = await d.query(
      'recommendation_history',
      where: 'owner_uid = ?',
      whereArgs: [ownerUid],
      orderBy: 'id DESC',
      limit: limit,
    );
    if (rows.isEmpty) return <SavedOutfit>[];

    final ids = {
      for (final r in rows) ...[
        r['top_item_id'] as int,
        r['bottom_item_id'] as int,
      ],
    }.toList();
    final items = await d.query(
      'wardrobe_item',
      where:
          'owner_uid = ? AND id IN (${List.filled(ids.length, '?').join(',')})',
      whereArgs: [ownerUid, ...ids],
    );
    final byId = {for (final r in items) r['id'] as int: Garment.fromRow(r)};

    return [
      for (final r in rows)
        SavedOutfit(
          id: r['id'] as int,
          name: r['title'] as String,
          formality: r['target_formality'] as String,
          score: (r['match_score'] as num?)?.toDouble() ?? 0,
          createdAt:
              DateTime.tryParse((r['created_at'] as String?) ?? '') ??
              DateTime.now(),
          items: [
            byId[r['top_item_id']],
            byId[r['bottom_item_id']],
          ].whereType<Garment>().toList(),
        ),
    ];
  }

  // ---------- Pengaturan lokal (mis. preferensi notifikasi) ----------

  Future<String?> preference(String key, {String ownerUid = 'default'}) async {
    final d = await db;
    final rows = await d.query(
      'app_preference',
      where: 'owner_uid = ? AND key = ?',
      whereArgs: [ownerUid, key],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first['value'] as String?;
  }

  Future<void> setPreference(
    String key,
    String value, {
    String ownerUid = 'default',
  }) async {
    final d = await db;
    await d.insert('app_preference', {
      'owner_uid': ownerUid,
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Jumlah data lama yang belum memiliki pemilik akun.
  Future<int> legacyDataCount() async {
    final d = await db;
    final rows = await d.rawQuery(
      "SELECT "
      "(SELECT COUNT(*) FROM wardrobe_item WHERE owner_uid = '__legacy__') + "
      "(SELECT COUNT(*) FROM outfit WHERE owner_uid = '__legacy__') + "
      "(SELECT COUNT(*) FROM recommendation_history WHERE owner_uid = '__legacy__') "
      'AS n',
    );
    return (rows.first['n'] as num?)?.toInt() ?? 0;
  }

  /// Item lama yang belum memiliki pemilik akun.
  Future<List<Map<String, dynamic>>> legacyWardrobe() async => (await db).query(
    'wardrobe_item',
    where: "owner_uid = '__legacy__'",
    orderBy: 'id ASC',
  );

  /// Memindahkan satu item lama ke akun dan memperbarui path fotonya.
  Future<void> claimLegacyWardrobeItem(
    int id, {
    String ownerUid = 'default',
    required String imagePath,
  }) async {
    final d = await db;
    await d.update(
      'wardrobe_item',
      {'owner_uid': ownerUid, 'image_path': imagePath},
      where: "id = ? AND owner_uid = '__legacy__'",
      whereArgs: [id],
    );
  }

  /// Memindahkan seluruh data lama ke akun yang sedang login.
  Future<void> claimLegacyData(String ownerUid) async {
    final d = await db;
    await d.transaction((t) async {
      for (final table in [
        'wardrobe_item',
        'outfit',
        'recommendation_history',
        'app_preference',
      ]) {
        await t.update(table, {
          'owner_uid': ownerUid,
        }, where: "owner_uid = '__legacy__'");
      }
    });
  }

  /// Menghapus seluruh data milik satu akun. Tabel referensi dan ML tidak disentuh.
  Future<void> deleteUserData(String ownerUid) async {
    final d = await db;
    await d.transaction((t) async {
      final outfits = await t.query(
        'outfit',
        columns: ['id'],
        where: 'owner_uid = ?',
        whereArgs: [ownerUid],
      );
      for (final row in outfits) {
        await t.delete(
          'outfit_item',
          where: 'outfit_id = ?',
          whereArgs: [row['id']],
        );
      }
      await t.delete('outfit', where: 'owner_uid = ?', whereArgs: [ownerUid]);
      await t.delete(
        'recommendation_history',
        where: 'owner_uid = ?',
        whereArgs: [ownerUid],
      );
      await t.delete(
        'wardrobe_item',
        where: 'owner_uid = ?',
        whereArgs: [ownerUid],
      );
      await t.delete(
        'app_preference',
        where: 'owner_uid = ?',
        whereArgs: [ownerUid],
      );
    });
  }

  /// Saran item untuk satu slot yang belum ada, diurut rata-rata skor pasangan terhadap item terpilih.
  /// Gender 'unisex' berarti tidak memfilter gender; selain itu katalog pria/wanita + unisex.
  Future<List<Map<String, dynamic>>> recommendForSlot({
    required List<int> selectedIds,
    required String slot,
    required String formality,
    required String gender,
    required String age,
    int k = 3,
  }) async {
    if (selectedIds.isEmpty) return [];
    final d = await db;
    final ph = List.filled(selectedIds.length, '?').join(',');
    final filterGender = gender != 'unisex';
    return d.rawQuery(
      '''
      SELECT c.garment_type, c.color_family, AVG(p.score) AS score
      FROM catalog_item c
      JOIN wardrobe_item w ON w.id IN ($ph)
      JOIN ml_pair_score p ON p.type_a=w.garment_type AND p.color_a=w.color_family
                          AND p.type_b=c.garment_type AND p.color_b=c.color_family
      WHERE c.slot=? AND c.formality=? ${filterGender ? "AND c.gender IN (?, 'unisex')" : ''} AND c.age_group=?
      GROUP BY c.garment_type, c.color_family ORDER BY score DESC LIMIT ?''',
      [...selectedIds, slot, formality, if (filterGender) gender, age, k],
    );
  }
}
