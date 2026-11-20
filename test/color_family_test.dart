import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/services/color_family.dart';
import 'package:sera_z/services/color_harmony.dart';

void main() {
  group('16 keluarga warna', () {
    test('berisi 16 keluarga unik', () {
      expect(ColorFamily.values.length, 16);
      expect(ColorFamily.values.map((f) => f.key).toSet().length, 16);
    });

    test('setiap keluarga punya label, hex, dan tone', () {
      for (final family in ColorFamily.values) {
        expect(family.label, isNotEmpty);
        expect(family.hex, inInclusiveRange(0x000000, 0xFFFFFFFF));
        expect(ColorTone.values.contains(family.tone), isTrue);
      }
    });

    test('keluarga netral ditandai dengan benar', () {
      final neutral = ColorFamily.values
          .where((f) => f.isNeutral)
          .map((f) => f.key)
          .toSet();

      expect(neutral, {'black', 'white', 'gray', 'cream', 'brown', 'navy'});
    });
  });

  group('Pencocokan warna terdekat', () {
    test('hitam, putih, dan abu-abu dikenali', () {
      expect(nearestColorFamily(const Color(0xFF000000)), ColorFamily.black);
      expect(nearestColorFamily(const Color(0xFFFFFFFF)), ColorFamily.white);
      expect(nearestColorFamily(const Color(0xFF808080)), ColorFamily.gray);
    });

    test('warna acuan dikenali sebagai dirinya sendiri', () {
      for (final family in ColorFamily.values) {
        expect(nearestColorFamily(family.color), family);
      }
    });

    test('biru tua masuk navy, bukan blue', () {
      expect(nearestColorFamily(const Color(0xFF1A237E)), ColorFamily.navy);
      expect(nearestColorFamily(const Color(0xFF2F5D9E)), ColorFamily.blue);
    });

    test('warna turunan tetap masuk keluarga yang tepat', () {
      expect(nearestColorFamily(const Color(0xFFF7EBD3)), ColorFamily.cream);
      expect(nearestColorFamily(const Color(0xFF009688)), ColorFamily.teal);
      expect(nearestColorFamily(const Color(0xFF708238)), ColorFamily.olive);
    });
  });

  group('Harmoni antar keluarga', () {
    test('hitam dan putih termasuk monokromatik netral', () {
      final result = evaluateFamilyHarmony(
        ColorFamily.black,
        ColorFamily.white,
      );
      expect(result.rule, HarmonyRule.monochromatic);
      expect(result.score, greaterThanOrEqualTo(0.8));
    });

    test('hitam dan merah termasuk netral', () {
      final result = evaluateFamilyHarmony(ColorFamily.black, ColorFamily.red);
      expect(result.rule, HarmonyRule.neutral);
    });

    test('navy dan krem termasuk netral', () {
      final result = evaluateFamilyHarmony(ColorFamily.navy, ColorFamily.cream);
      expect(result.rule, HarmonyRule.neutral);
    });

    test('merah dan hijau tidak termasuk aturan harmoni utama', () {
      final result = evaluateFamilyHarmony(ColorFamily.red, ColorFamily.green);
      expect(result.rule, HarmonyRule.none);
      expect(result.score, lessThan(0.5));
    });
  });
}
