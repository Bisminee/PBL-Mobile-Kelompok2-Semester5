import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/models/garment.dart';
import 'package:sera_z/models/garment_labels.dart';

void main() {
  test('fromRow membaca satu baris wardrobe_item', () {
    final g = Garment.fromRow({
      'id': 3,
      'image_path': '/foto.jpg',
      'garment_type': 't_shirt',
      'slot': 'top',
      'color_family': 'black',
      'color_hex': '#112233',
      'detection_conf': 0.98,
      'formality': 'non_formal',
      'style': 'casual',
      'created_at': '2026-10-31 14:00:00',
    });
    expect(g.id, '3');
    expect(g.category, 'Atasan');
    expect(g.title, 'Kaos Hitam');
    expect(g.colorValue, const Color(0xFF112233));
    expect(g.confidence, 0.98);
    expect(g.addedAt!.toUtc(), DateTime.utc(2026, 10, 31, 14));
  });

  test('tanpa color_hex memakai warna keluarga', () {
    final g = Garment.fromRow({
      'id': 1,
      'garment_type': 'pants',
      'slot': 'bottom',
      'color_family': 'blue',
    });
    expect(g.colorValue, colorOfFamily('blue'));
    expect(g.addedAt, isNull);
    expect(g.category, 'Bawahan');
  });

  test('toEngineRow memakai id numerik', () {
    final g = Garment.fromRow({
      'id': 7,
      'garment_type': 'shoes',
      'slot': 'shoes',
      'color_family': 'white',
      'formality': 'semi_formal',
    });
    expect(g.toEngineRow(), {
      'id': 7,
      'slot': 'shoes',
      'garment_type': 'shoes',
      'color_family': 'white',
      'formality': 'semi_formal',
    });
  });

  test('isDark membedakan warna gelap dan terang', () {
    const dark = Garment(
      id: '1',
      category: 'Atasan',
      colorName: 'Hitam',
      colorValue: Color(0xFF111111),
    );
    const light = Garment(
      id: '2',
      category: 'Atasan',
      colorName: 'Putih',
      colorValue: Color(0xFFF5F5F5),
    );
    expect(dark.isDark, isTrue);
    expect(light.isDark, isFalse);
  });
}

