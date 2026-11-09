import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/models/garment.dart';
import 'package:sera_z/services/home_summary.dart';

Garment _item(String id, String? slot) => Garment(
  id: id,
  category: 'Atasan',
  colorName: 'Hitam',
  colorValue: Colors.black,
  slot: slot,
);

void main() {
  group('countByCategory', () {
    test('lemari kosong menghasilkan peta kosong', () {
      expect(countByCategory(const []), isEmpty);
    });

    test('menghitung item per kategori dari slot', () {
      final hasil = countByCategory([
        _item('1', 'top'),
        _item('2', 'top'),
        _item('3', 'bottom'),
        _item('4', 'shoes'),
      ]);

      expect(hasil['Atasan'], 2);
      expect(hasil['Bawahan'], 1);
      expect(hasil['Sepatu'], 1);
      expect(hasil.containsKey('Terusan'), isFalse);
    });

    test('slot tidak dikenal masuk Aksesori', () {
      final hasil = countByCategory([_item('1', 'topi')]);
      expect(hasil['Aksesori'], 1);
    });

    test('kategoriHome tidak memuat kategori di luar daftar', () {
      for (final kategori in countByCategory([
        _item('1', 'top'),
        _item('2', 'bottom'),
        _item('3', 'onepiece'),
        _item('4', 'outer'),
        _item('5', 'shoes'),
        _item('6', 'hat'),
      ]).keys) {
        expect(kategoriHome, contains(kategori));
      }
    });
  });
}
