// SQLite: menyimpan data user (wardrobe_item, outfit) dan membaca tabel hasil ML
// (ml_formality, ml_style, ml_pair_score, catalog_item) dari fashion_app.db.
// Asset: assets/db/fashion_app.db (didaftarkan di pubspec.yaml).
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/garment.dart';
import '../models/saved_outfit.dart';

class LocalDb {
  LocalDb._();
  static final LocalDb instance = LocalDb._();

  static const _assetPath = 'assets/db/fashion_app.db';

  // Asset hanya disalin SEKALI, saat file belum ada di perangkat. Bila fashion_app.db di asset
  // diganti (model baru), uninstall aplikasi dulu. Wardrobe user ikut hilang karena satu file.
  // Untuk rilis, pisahkan data user dan tabel ML menjadi dua file DB.
  // Versi 2 menambah tabel app_preference untuk pengaturan lokal profil.
  // Catatan: versi 1 adalah skema di assets/db/fashion_app.db.
  static const _version = 2;

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
      version: _version,
      onConfigure: (d) => d.execute('PRAGMA foreign_keys = ON'),
      // Database dari asset sudah berisi skema versi 1. Tabel baru ditambahkan
      // lewat onUpgrade (pengguna lama) atau onCreate (pemasangan baru, karena
      // user_version di asset masih 0).
      onCreate: (d, versi) async {
        await d.execute(
          'CREATE TABLE IF NOT EXISTS app_preference ('
          'key TEXT PRIMARY KEY, value TEXT NOT NULL)',
        );
      },
      onUpgrade: (d, versiLama, versiBaru) async {
        if (versiLama < 2) {
          await d.execute(
            'CREATE TABLE IF NOT EXISTS app_preference ('
            'key TEXT PRIMARY KEY, value TEXT NOT NULL)',
          );
        }
      },
    );
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

  /// Urut id naik: item terbaru ada di akhir daftar (sesuai WardrobeNotifier.latest).
  Future<List<Map<String, dynamic>>> wardrobe() async =>
      (await db).query('wardrobe_item', orderBy: 'id ASC');

  Future<void> deleteWardrobeItem(int id) async =>
      (await db).delete('wardrobe_item', where: 'id = ?', whereArgs: [id]);

  Future<int> saveOutfit(
    String name,
    String formality,
    double score,
    List<int> itemIds,
  ) async {
    final d = await db;
    return d.transaction((t) async {
      final id = await t.insert('outfit', {
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
  Future<bool> outfitSaved(List<int> itemIds) async {
    if (itemIds.length < 2) return false;
    final d = await db;
    final rows = await d.rawQuery(
      'SELECT outfit_id, wardrobe_item_id FROM outfit_item',
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

  /// Semua outfit tersimpan, terbaru lebih dulu, beserta item lemari di dalamnya.
  Future<List<SavedOutfit>> savedOutfits() async {
    final d = await db;
    final outfits = await d.query('outfit', orderBy: 'id DESC');
    if (outfits.isEmpty) return <SavedOutfit>[];

    final rows = await d.rawQuery(
      'SELECT oi.outfit_id, w.* FROM outfit_item oi '
      'JOIN wardrobe_item w ON w.id = oi.wardrobe_item_id '
      'ORDER BY oi.outfit_id DESC',
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

  // ---------- Pengaturan lokal (mis. preferensi notifikasi) ----------

  Future<String?> preference(String key) async {
    final d = await db;
    final rows = await d.query(
      'app_preference',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first['value'] as String?;
  }

  Future<void> setPreference(String key, String value) async {
    final d = await db;
    await d.insert('app_preference', {
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
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
