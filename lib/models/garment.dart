import 'package:flutter/material.dart';

import 'garment_labels.dart';

/// A single clothing item stored in the user's wardrobe.
///
/// Field lama (id, category, colorName, colorValue, imagePath, style) tidak berubah,
/// jadi kode yang membuat Garment(...) tetap jalan. Field baru nullable dan diisi dari
/// hasil deteksi (YOLO11n-cls, warna dari piksel, tabel ML di SQLite).
class Garment {
  const Garment({
    required this.id,
    required this.category,
    required this.colorName,
    required this.colorValue,
    this.imagePath,
    this.style,
    this.garmentType,
    this.slot,
    this.colorFamily,
    this.confidence,
    this.formality,
    this.addedAt,
  });

  final String id;

  /// Kategori fungsional: Atasan, Bawahan, Terusan, Luaran, Sepatu, Aksesori.
  final String category;
  final String colorName;
  final Color colorValue;
  final String? imagePath;

  /// Kode style dari model (casual, minimalist, ...). Teks tampilan lewat styleLabel().
  final String? style;

  /// t_shirt, longsleeve, pants, shoes, dst. Sama dengan labels.txt model.
  final String? garmentType;

  /// top | bottom | outer | onepiece | shoes | headwear | bag | accessory
  final String? slot;

  /// black, white, gray, beige, ... (kosakata dataset)
  final String? colorFamily;

  /// Softmax top-1 dari model, 0..1. Belum terkalibrasi.
  final double? confidence;

  /// non_formal | semi_formal | formal
  final String? formality;

  final DateTime? addedAt;

  /// Nama singkat untuk kartu dan daftar, mis. "Kaos Hitam".
  String get title => garmentType == null
      ? '$category $colorName'
      : '${typeLabel(garmentType)} $colorName';

  /// Warna gelap dipakai UI untuk memilih latar tile yang kontras.
  bool get isDark => colorValue.computeLuminance() < 0.2;

  /// Dari satu baris tabel wardrobe_item di SQLite.
  factory Garment.fromRow(Map<String, Object?> m) {
    final family = (m['color_family'] as String?) ?? 'other';
    final slot = (m['slot'] as String?) ?? 'top';
    final created = m['created_at'] as String?;
    return Garment(
      id: '${m['id']}',
      category: categoryOfSlot(slot),
      colorName: colorLabel(family),
      colorValue: m['color_hex'] != null
          ? colorFromHex(m['color_hex'] as String?)
          : colorOfFamily(family),
      imagePath: m['image_path'] as String?,
      style: m['style'] as String?,
      garmentType: m['garment_type'] as String?,
      slot: slot,
      colorFamily: family,
      confidence: (m['detection_conf'] as num?)?.toDouble(),
      formality: m['formality'] as String?,
      // SQLite datetime('now') = UTC tanpa zona, mis. "2026-10-31 14:00:00".
      addedAt: created == null
          ? null
          : DateTime.tryParse('${created.replaceFirst(' ', 'T')}Z')?.toLocal(),
    );
  }

  /// Bentuk baris yang dibaca OutfitEngine.recommend. Hanya valid untuk item dari database (id numerik).
  Map<String, dynamic> toEngineRow() => {
    'id': int.parse(id),
    'slot': slot,
    'garment_type': garmentType,
    'color_family': colorFamily,
    'formality': formality,
  };
}
