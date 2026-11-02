// SQLite: menyimpan data user (wardrobe_item, outfit) dan membaca tabel hasil ML
// (ml_formality, ml_style, ml_pair_score, catalog_item) dari fashion_app.db.
// Asset: assets/db/fashion_app.db (didaftarkan di pubspec.yaml).
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDb {
  LocalDb._();
  static final LocalDb instance = LocalDb._();

  static const _assetPath = 'assets/db/fashion_app.db';

  // Asset hanya disalin SEKALI, saat file belum ada di perangkat. Bila fashion_app.db di asset
  // diganti (model baru), uninstall aplikasi dulu. Wardrobe user ikut hilang karena satu file.
  // Untuk rilis, pisahkan data user dan tabel ML menjadi dua file DB.
  static const _version = 1;

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
