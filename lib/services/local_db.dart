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
  // Versi 3: Menambahkan tabel master data (ref_garment_type dan ref_color) untuk tugas E8.6
  // Catatan: versi 1 adalah skema di assets/db/fashion_app.db.
  static const _version = 3;

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
        // Pembuatan tabel untuk versi 2
        await d.execute(
          'CREATE TABLE IF NOT EXISTS app_preference ('
          'key TEXT PRIMARY KEY, value TEXT NOT NULL)',
        );
        await _createMasterTables(d);
      },
      onUpgrade: (d, versiLama, versiBaru) async {
        // Jika sebelumnya pengguna berada di versi 1, jalankan migrasi versi 2
        if (versiLama < 2) {
          await d.execute(
            'CREATE TABLE IF NOT EXISTS app_preference ('
            'key TEXT PRIMARY KEY, value TEXT NOT NULL)',
          );
        }
        // Migrasi untuk pengguna lama yang akan naik ke versi 3 (Menambah master data)
        if (versiLama < 3) {
          await _createMasterTables(d);
        }
      },
    );
  }

  /// Membuat tabel master data (versi 3). Dipakai onCreate dan onUpgrade
  /// supaya skemanya hanya ditulis di satu tempat.
  Future<void> _createMasterTables(Database d) async {
    await d.execute(
      'CREATE TABLE IF NOT EXISTS ref_garment_type ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'name TEXT NOT NULL, slot TEXT NOT NULL)',
    );
    await d.execute(
      'CREATE TABLE IF NOT EXISTS ref_color ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'color_family TEXT NOT NULL, hex_code TEXT)',
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
  
  // ---------- Master data / Admin (E8.6) ----------
  // Tabel referensi ref_garment_type dan ref_color yang dikelola lewat halaman Admin.
 
  // Penanda di app_preference bahwa master data sudah pernah diisi awal.
  // Dengan penanda ini, data yang sengaja dihapus admin tidak muncul lagi.
  static const _seedKey = 'master_seeded';
 
  // Kode warna bawaan. Nama warna yang tidak ada di sini disimpan tanpa hex
  // dan bisa diisi admin lewat halaman Admin.
  static const _defaultHex = <String, String>{
    'black': '#000000',
    'white': '#FFFFFF',
    'gray': '#808080',
    'grey': '#808080',
    'beige': '#F5F5DC',
    'brown': '#8B4513',
    'red': '#D32F2F',
    'orange': '#F57C00',
    'yellow': '#FBC02D',
    'green': '#388E3C',
    'olive': '#808000',
    'blue': '#1976D2',
    'navy': '#1A237E',
    'purple': '#7B1FA2',
    'pink': '#EC407A',
  };
 
  // Cadangan bila catalog_item kosong atau tidak terbaca.
  // Urutan 9 kelas sama dengan urutan training model.
  static const _fallbackTypes = <String, String>{
    'dress': 'dress',
    'long_pants': 'bottom',
    'long_sleeve': 'top',
    'outerwear': 'outer',
    'shirt': 'top',
    'shoes': 'shoes',
    'shorts': 'bottom',
    'skirt': 'bottom',
    'tshirt': 'top',
  };
 
  /// Mengisi master data awal SATU KALI dari catalog_item (tabel hasil ML), agar nama
  /// tipe, slot, dan warna konsisten dengan model rekomendasi. Aman dipanggil berulang;
  /// dipanggil dari halaman Admin sebelum memuat data.
  Future<void> ensureMasterSeeded() async {
    final d = await db;
    final done = await d.query(
      'app_preference',
      where: 'key = ?',
      whereArgs: [_seedKey],
      limit: 1,
    );
    if (done.isNotEmpty) return;
 
    // Baca di luar transaksi; bila catalog_item bermasalah, pakai data cadangan.
    var types = <Map<String, dynamic>>[];
    var colors = <Map<String, dynamic>>[];
    try {
      types = await d.rawQuery(
        'SELECT DISTINCT garment_type AS name, slot FROM catalog_item '
        'ORDER BY garment_type',
      );
      colors = await d.rawQuery(
        'SELECT DISTINCT color_family FROM catalog_item ORDER BY color_family',
      );
    } catch (_) {
      // lanjut ke data cadangan
    }
 
    final typeRows = types.isNotEmpty
        ? [
            for (final t in types)
              {'name': t['name'] as String, 'slot': t['slot'] as String},
          ]
        : [
            for (final e in _fallbackTypes.entries)
              {'name': e.key, 'slot': e.value},
          ];
    final colorNames = colors.isNotEmpty
        ? [for (final c in colors) c['color_family'] as String]
        : _defaultHex.keys.where((k) => k != 'grey').toList();
 
    await d.transaction((t) async {
      // Isi hanya bila tabel masih kosong, agar tidak menimpa data yang sudah ada.
      final nType =
          Sqflite.firstIntValue(
            await t.rawQuery('SELECT COUNT(*) FROM ref_garment_type'),
          ) ??
          0;
      if (nType == 0) {
        for (final r in typeRows) {
          await t.insert('ref_garment_type', r);
        }
      }
      final nColor =
          Sqflite.firstIntValue(
            await t.rawQuery('SELECT COUNT(*) FROM ref_color'),
          ) ??
          0;
      if (nColor == 0) {
        for (final name in colorNames) {
          await t.insert('ref_color', {
            'color_family': name,
            'hex_code': _defaultHex[name.toLowerCase()],
          });
        }
      }
      await t.insert('app_preference', {
        'key': _seedKey,
        'value': '1',
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }
 
  // -- Tipe pakaian (ref_garment_type) --
 
  /// Semua tipe pakaian, urut nama.
  Future<List<Map<String, dynamic>>> getMasterGarmentTypes() async {
    final d = await db;
    return d.query('ref_garment_type', orderBy: 'name ASC');
  }
 
  /// True bila nama tipe sudah dipakai (huruf besar/kecil diabaikan).
  /// [exceptId] diisi saat mengubah data agar baris itu sendiri tidak dihitung.
  Future<bool> masterGarmentTypeExists(String name, {int? exceptId}) async {
    final d = await db;
    final rows = await d.query(
      'ref_garment_type',
      columns: ['id'],
      where: 'LOWER(name) = LOWER(?) AND id != ?',
      whereArgs: [name.trim(), exceptId ?? -1],
      limit: 1,
    );
    return rows.isNotEmpty;
  }
 
  /// Menambah tipe pakaian baru (contoh: name 'shirt', slot 'top').
  Future<int> insertMasterGarmentType(String name, String slot) async {
    final d = await db;
    return d.insert('ref_garment_type', {'name': name, 'slot': slot});
  }
 
  /// Mengubah nama dan slot tipe pakaian berdasarkan id.
  Future<int> updateMasterGarmentType(int id, String name, String slot) async {
    final d = await db;
    return d.update(
      'ref_garment_type',
      {'name': name, 'slot': slot},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
 
  /// Menghapus tipe pakaian berdasarkan id.
  Future<void> deleteMasterGarmentType(int id) async {
    final d = await db;
    await d.delete('ref_garment_type', where: 'id = ?', whereArgs: [id]);
  }
 
  // -- Warna (ref_color) --
 
  /// Semua warna, urut nama.
  Future<List<Map<String, dynamic>>> getMasterColors() async {
    final d = await db;
    return d.query('ref_color', orderBy: 'color_family ASC');
  }
 
  /// True bila nama warna sudah dipakai (huruf besar/kecil diabaikan).
  Future<bool> masterColorExists(String colorFamily, {int? exceptId}) async {
    final d = await db;
    final rows = await d.query(
      'ref_color',
      columns: ['id'],
      where: 'LOWER(color_family) = LOWER(?) AND id != ?',
      whereArgs: [colorFamily.trim(), exceptId ?? -1],
      limit: 1,
    );
    return rows.isNotEmpty;
  }
 
  /// Menambah warna baru (contoh: colorFamily 'red', hexCode '#D32F2F').
  Future<int> insertMasterColor(String colorFamily, String? hexCode) async {
    final d = await db;
    return d.insert('ref_color', {
      'color_family': colorFamily,
      'hex_code': hexCode,
    });
  }
 
  /// Mengubah nama dan kode hex warna berdasarkan id.
  Future<int> updateMasterColor(
    int id,
    String colorFamily,
    String? hexCode,
  ) async {
    final d = await db;
    return d.update(
      'ref_color',
      {'color_family': colorFamily, 'hex_code': hexCode},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
 
  /// Menghapus warna berdasarkan id.
  Future<void> deleteMasterColor(int id) async {
    final d = await db;
    await d.delete('ref_color', where: 'id = ?', whereArgs: [id]);
  }
}