import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/services/color_harmony.dart';

void main() {
  group('Konversi warna', () {
    test('putih → L hampir 100 dan chroma hampir 0', () {
      final lch = ColorHarmony.toLch(const Color(0xFFFFFFFF));
      expect(lch.l, closeTo(100, 0.5));
      expect(lch.c, lessThan(1));
    });

    test('hitam → L hampir 0', () {
      final lch = ColorHarmony.toLch(const Color(0xFF000000));
      expect(lch.l, closeTo(0, 0.5));
    });

    test('hue merah dan biru berbeda jauh', () {
      final red = ColorHarmony.toLch(const Color(0xFFFF0000));
      final blue = ColorHarmony.toLch(const Color(0xFF0000FF));
      expect(ColorHarmony.hueDistance(red.h, blue.h), greaterThan(90));
    });
  });

  group('Jarak hue', () {
    test('melingkar dengan benar (350° vs 10° = 20°)', () {
      expect(ColorHarmony.hueDistance(350, 10), closeTo(20, 1e-9));
    });

    test('maksimum 180°', () {
      expect(ColorHarmony.hueDistance(0, 180), closeTo(180, 1e-9));
      expect(ColorHarmony.hueDistance(0, 200), closeTo(160, 1e-9));
    });
  });

  group('Aturan harmoni (CIELCh)', () {
    test('komplementer: selisih 180°', () {
      const a = LchColor(50, 40, 0);
      const b = LchColor(50, 40, 180);
      final r = ColorHarmony.evaluateLch(a, b);
      expect(r.rule, HarmonyRule.complementary);
      expect(r.score, greaterThanOrEqualTo(0.8));
    });

    test('analog: selisih sekitar 20°', () {
      const a = LchColor(50, 40, 0);
      const b = LchColor(50, 40, 20);
      final r = ColorHarmony.evaluateLch(a, b);
      expect(r.rule, HarmonyRule.analogous);
    });

    test('monokromatik: selisih hue sangat kecil', () {
      const a = LchColor(50, 40, 0);
      const b = LchColor(55, 38, 5);
      final r = ColorHarmony.evaluateLch(a, b);
      expect(r.rule, HarmonyRule.monochromatic);
      expect(r.score, greaterThan(0.9));
    });

    test('netral + berwarna → neutral (parity)', () {
      const neutral = LchColor(60, 2, 0);
      const chromatic = LchColor(50, 40, 120);
      final r = ColorHarmony.evaluateLch(neutral, chromatic);
      expect(r.rule, HarmonyRule.neutral);
    });

    test('kedua akromatik dengan kontras terang → monokromatik skor tinggi', () {
      const black = LchColor(0, 0, 0);
      const white = LchColor(100, 0, 0);
      final r = ColorHarmony.evaluateLch(black, white);
      expect(r.rule, HarmonyRule.monochromatic);
      expect(r.score, greaterThanOrEqualTo(0.99));
    });

    test('tanpa aturan saat selisih hue 60°', () {
      const a = LchColor(50, 40, 0);
      const b = LchColor(50, 40, 60);
      final r = ColorHarmony.evaluateLch(a, b);
      expect(r.rule, HarmonyRule.none);
      expect(r.score, lessThan(0.5));
    });
  });

  group('Evaluasi warna nyata', () {
    test('hitam vs putih → monokromatik (sesuai desain)', () {
      final r = ColorHarmony.evaluate(
        const Color(0xFF000000),
        const Color(0xFFFFFFFF),
      );
      expect(r.rule, HarmonyRule.monochromatic);
      expect(r.label, 'Monochromatic');
    });

    test('hitam vs merah → neutral', () {
      final r = ColorHarmony.evaluate(
        const Color(0xFF000000),
        const Color(0xFFFF0000),
      );
      expect(r.rule, HarmonyRule.neutral);
    });
  });

  group('Outfit (n warna)', () {
    test('tiga warna menghasilkan skor 0–1 dan aturan valid', () {
      final r = ColorHarmony.evaluateOutfit(const [
        Color(0xFF000000),
        Color(0xFFFFFFFF),
        Color(0xFF000000),
      ]);
      expect(r.score, inInclusiveRange(0, 1));
      expect(HarmonyRule.values.contains(r.rule), isTrue);
      expect(r.detail, isNotEmpty);
    });

    test('satu warna → skor 1', () {
      final r = ColorHarmony.evaluateOutfit(const [Color(0xFF123456)]);
      expect(r.score, 1);
    });

    test('outfit kosong → skor 0', () {
      final r = ColorHarmony.evaluateOutfit(const []);
      expect(r.score, 0);
    });
  });

  group('Ambang dapat diubah', () {
    test('memperketat ambang analog membuat selisih 25° tidak lagi analog', () {
      const a = LchColor(50, 40, 0);
      const b = LchColor(50, 40, 25);
      expect(
        ColorHarmony.evaluateLch(a, b).rule,
        HarmonyRule.analogous,
      );
      final strict = ColorHarmony.evaluateLch(
        a,
        b,
        thresholds: const HarmonyThresholds(analogousHue: 20),
      );
      expect(strict.rule, isNot(HarmonyRule.analogous));
    });
  });
}
