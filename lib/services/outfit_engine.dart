// Alur: foto -> (YOLO11n-cls) jenis + confidence -> (piksel) warna -> (SQLite ml_*) formalitas dan style
// -> skor pasangan -> saran item untuk slot yang kosong.
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show compute;

import '../models/garment_labels.dart';
import 'color_extractor.dart';
import 'garment_classifier.dart';
import 'local_db.dart';

/// Ambang confidence untuk menampilkan hasil tanpa peringatan.
///
/// Dari 661 gambar uji: confidence di atas 0,97 (494 gambar) akurat 94,5%, sedangkan di bawahnya
/// hanya sekitar 57%. Ambang ditentukan dari data uji yang sama, jadi angka 94,5% sedikit optimis.
const double confidentThreshold = 0.97;

class Detection {
  const Detection({
    required this.type,
    required this.slot,
    required this.color,
    required this.colorHex,
    required this.formality,
    required this.confidence,
    required this.alternatives,
    required this.styles,
    required this.colorShare,
    this.manual = false,
  });

  final String type;
  final String slot;
  final String color;
  final String colorHex;
  final String formality;
  final double confidence;
  final List<Prediction> alternatives;
  final List<Map<String, dynamic>> styles;
  final Map<String, double> colorShare;

  /// True bila user mengoreksi jenis pakaian, sehingga confidence model tidak lagi berlaku.
  final bool manual;

  String? get topStyle =>
      styles.isEmpty ? null : styles.first['style'] as String?;

  bool get isConfident => !manual && confidence >= confidentThreshold;

  Detection copyWith({
    String? type,
    String? slot,
    String? formality,
    List<Map<String, dynamic>>? styles,
    bool? manual,
  }) => Detection(
    type: type ?? this.type,
    slot: slot ?? this.slot,
    color: color,
    colorHex: colorHex,
    formality: formality ?? this.formality,
    confidence: confidence,
    alternatives: alternatives,
    styles: styles ?? this.styles,
    colorShare: colorShare,
    manual: manual ?? this.manual,
  );
}

class OutfitEngine {
  OutfitEngine(this.classifier, this.dbh);

  final GarmentClassifier classifier;
  final LocalDb dbh;

  // Skor pasangan disimpan di memori agar pembentukan outfit di provider bisa sinkron.
  final Map<String, double> _pair = {};
  final List<double> _topBottom = []; // semua skor atasan-bawahan, terurut naik

  /// Panggil sekali saat start, setelah engine dibuat. Membaca sekitar 51 ribu baris ml_pair_score.
  Future<void> preload() async {
    final d = await dbh.db;
    final slotRows = await d.rawQuery(
      'SELECT garment_type, slot FROM ref_garment_type',
    );
    final slot = {
      for (final r in slotRows)
        r['garment_type'] as String: r['slot'] as String,
    };
    final rows = await d.rawQuery(
      'SELECT type_a, color_a, type_b, color_b, score FROM ml_pair_score',
    );
    for (final r in rows) {
      final ta = r['type_a'] as String;
      final tb = r['type_b'] as String;
      final s = (r['score'] as num).toDouble();
      _pair['$ta|${r['color_a']}|$tb|${r['color_b']}'] = s;
      if (slot[ta] == 'top' && slot[tb] == 'bottom') _topBottom.add(s);
    }
    _topBottom.sort();
  }

  /// Skor mentah pasangan (0..1). Null bila kombinasi tidak ada di tabel.
  double? pairScore(String typeA, String colorA, String typeB, String colorB) =>
      _pair['$typeA|$colorA|$typeB|$colorB'];

  /// Persentil skor atasan-bawahan: porsi kombinasi lain yang skornya tidak lebih tinggi.
  /// Skor mentah berkisar sempit (sekitar 0,3 sampai 0,5) sehingga jelek bila ditampilkan sebagai persen.
  double topBottomPercentile(double s) {
    if (_topBottom.isEmpty) return s;
    var lo = 0;
    var hi = _topBottom.length;
    while (lo < hi) {
      final mid = (lo + hi) >> 1;
      if (_topBottom[mid] <= s) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    return lo / _topBottom.length;
  }

  /// [gender] 'male' | 'female' | 'unisex' dari profil user, [age] 'adult' | 'child'.
  Future<Detection> analyze(
    Uint8List bytes, {
    required String gender,
    String age = 'adult',
  }) async {
    // Decode berat dijalankan di isolate lain; keduanya paralel dan tidak menahan UI.
    final (input, color) = await (
      compute(preprocessForModel, bytes),
      compute(extractColor, bytes),
    ).wait;
    if (input == null) throw StateError('Gambar tidak bisa dibaca');

    final preds = classifier.predictInput(input, k: 3);
    final top = preds.first;
    final f = await dbh.predictFormality(top.label, color.family, gender, age);
    final s = await dbh.predictStyles(top.label, color.family, gender, age);
    return Detection(
      type: top.label,
      slot: slotOfType[top.label] ?? 'top',
      color: color.family,
      colorHex: color.hex,
      formality: f['pred'] as String,
      confidence: top.confidence,
      alternatives: preds,
      styles: s.take(3).toList(),
      colorShare: color.share,
    );
  }

  /// Dipakai saat user mengoreksi jenis: warna tetap, formalitas dan style dihitung ulang.
  Future<Detection> withType(
    Detection d,
    String type, {
    required String gender,
    String age = 'adult',
  }) async {
    final f = await dbh.predictFormality(type, d.color, gender, age);
    final s = await dbh.predictStyles(type, d.color, gender, age);
    return d.copyWith(
      type: type,
      slot: slotOfType[type] ?? 'top',
      formality: f['pred'] as String,
      styles: s.take(3).toList(),
      manual: true,
    );
  }

  /// Slot wajib yang belum terisi, lalu slot opsional. Dress menggantikan atasan dan bawahan.
  List<String> missingSlots(List<Map<String, dynamic>> items) {
    final have = items.map((e) => e['slot'] as String).toSet();
    final need = have.contains('onepiece')
        ? ['shoes']
        : ['top', 'bottom', 'shoes'];
    const optional = ['outer', 'bag'];
    return [
      ...need.where((s) => !have.contains(s)),
      ...optional.where((s) => !have.contains(s)),
    ];
  }

  /// Formalitas outfit = level terendah di antara item inti, supaya blazer dengan sandal tidak dianggap formal.
  String outfitFormality(List<Map<String, dynamic>> items) {
    const core = ['top', 'bottom', 'onepiece', 'shoes'];
    final inti = items.where((e) => core.contains(e['slot'])).toList();
    final src = inti.isEmpty ? items : inti;
    return src.map((e) => e['formality'] as String).reduce(lowerFormality);
  }

  /// Saran untuk semua slot kosong pada target formalitas tertentu.
  /// Item harus berasal dari database (field 'id' = int dari tabel wardrobe_item).
  Future<Map<String, List<Map<String, dynamic>>>> recommend(
    List<Map<String, dynamic>> items, {
    required String targetFormality,
    required String gender,
    String age = 'adult',
  }) async {
    final ids = items.map((e) => e['id'] as int).toList();
    final out = <String, List<Map<String, dynamic>>>{};
    for (final slot in missingSlots(items)) {
      out[slot] = await dbh.recommendForSlot(
        selectedIds: ids,
        slot: slot,
        formality: targetFormality,
        gender: gender,
        age: age,
      );
    }
    return out;
  }
}
