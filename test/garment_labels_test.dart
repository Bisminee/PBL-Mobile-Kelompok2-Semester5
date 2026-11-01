import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/models/garment_labels.dart';

void main() {
  group('label', () {
    test('typeLabel dan fallback', () {
      expect(typeLabel('t_shirt'), 'Kaos');
      expect(typeLabel('tidak_ada'), 'tidak_ada');
      expect(typeLabel(null), '-');
    });

    test('categoryOfSlot menggabungkan headwear, bag, accessory', () {
      expect(categoryOfSlot('top'), 'Atasan');
      expect(categoryOfSlot('headwear'), 'Aksesori');
      expect(categoryOfSlot('bag'), 'Aksesori');
      expect(categoryOfSlot(null), 'Aksesori');
    });

    test('slotOfType memetakan jenis ke slot', () {
      expect(slotOfType['pants'], 'bottom');
      expect(slotOfType['shoes'], 'shoes');
      expect(slotOfType['dress'], 'onepiece');
    });
  });

  group('formalitas', () {
    test('lowerFormality memilih level terendah', () {
      expect(lowerFormality('formal', 'semi_formal'), 'semi_formal');
      expect(lowerFormality('formal', 'formal'), 'formal');
      expect(lowerFormality('non_formal', 'formal'), 'non_formal');
    });

    test('nilai tak dikenal dianggap non_formal', () {
      expect(lowerFormality(null, 'formal'), 'non_formal');
    });
  });

  group('warna', () {
    test('colorFromHex membaca #RRGGBB', () {
      expect(colorFromHex('#FF0000'), const Color(0xFFFF0000));
      expect(colorFromHex('00ff00'), const Color(0xFF00FF00));
    });

    test('hex salah jatuh ke abu-abu', () {
      expect(colorFromHex('xyz'), colorOfFamily('other'));
      expect(colorFromHex('#12345'), colorOfFamily('other'));
      expect(colorFromHex(null), colorOfFamily('other'));
    });
  });

  group('tanggal', () {
    test('formatDateId dan formatDateShortId', () {
      final d = DateTime(2026, 10, 31);
      expect(formatDateId(d), '31 Oktober 2026');
      expect(formatDateShortId(d), '31 OKT 2026');
    });

    test('formatDayDateId memakai nama hari Indonesia', () {
      // 1 November 2026 jatuh pada hari Minggu.
      expect(formatDayDateId(DateTime(2026, 11, 1)), 'Minggu, 1 Nov');
      expect(formatDayDateId(DateTime(2026, 5, 4)), 'Senin, 4 Mei');
    });

    test('greetingId menurut jam', () {
      expect(greetingId(7), 'Selamat pagi,');
      expect(greetingId(12), 'Selamat siang,');
      expect(greetingId(16), 'Selamat sore,');
      expect(greetingId(21), 'Selamat malam,');
    });
  });
}
