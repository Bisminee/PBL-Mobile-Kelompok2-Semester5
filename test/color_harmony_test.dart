import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/services/color_harmony.dart';

void main() {
  group('Konversi warna & LchColor', () {
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

    test('isAchromatic memakai perbandingan ketat c < threshold', () {
      expect(const LchColor(50, 4.99, 0).isAchromatic(5.0), isTrue);
      expect(const LchColor(50, 5.0, 0).isAchromatic(5.0), isFalse);
    });

    test('LchColor.toString memformat L, C, dan h satu desimal', () {
      const lch = LchColor(50.12, 20.34, 180.56);
      expect(lch.toString(), 'LchColor(L: 50.1, C: 20.3, h: 180.6)');
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

    test('menangani sudut negatif dan lebih dari 360°', () {
      expect(ColorHarmony.hueDistance(-10, 10), closeTo(20, 1e-9));
      expect(ColorHarmony.hueDistance(370, 10), closeTo(0, 1e-9));
    });
  });

  group('Aturan harmoni & boundary (CIELCh)', () {
    test('komplementer: selisih 180° dan batas tepat 150°', () {
      const a = LchColor(50, 40, 0);
      const exact180 = LchColor(50, 40, 180);
      const boundary150 = LchColor(50, 40, 150);

      final r180 = ColorHarmony.evaluateLch(a, exact180);
      expect(r180.rule, HarmonyRule.complementary);
      expect(r180.score, closeTo(1.0, 1e-9));

      final r150 = ColorHarmony.evaluateLch(a, boundary150);
      expect(r150.rule, HarmonyRule.complementary);
      expect(r150.score, closeTo(0.8, 1e-9));
    });

    test('di luar toleransi komplementer (selisih 149°) → none', () {
      const a = LchColor(50, 40, 0);
      const b = LchColor(50, 40, 149);
      final r = ColorHarmony.evaluateLch(a, b);
      expect(r.rule, HarmonyRule.none);
      expect(r.score, closeTo(0.35, 1e-9));
    });

    test('analog: selisih 20° dan batas tepat 30°', () {
      const a = LchColor(50, 40, 0);
      final r20 = ColorHarmony.evaluateLch(a, const LchColor(50, 40, 20));
      expect(r20.rule, HarmonyRule.analogous);
      expect(r20.score, closeTo(0.9, 1e-9));

      final r30 = ColorHarmony.evaluateLch(a, const LchColor(50, 40, 30));
      expect(r30.rule, HarmonyRule.analogous);
      expect(r30.score, closeTo(0.8, 1e-9));
    });

    test('monokromatik: selisih 0° (skor 1.0) dan batas tepat 10° (skor 0.85)', () {
      const a = LchColor(50, 40, 0);
      final r0 = ColorHarmony.evaluateLch(a, const LchColor(60, 35, 0));
      expect(r0.rule, HarmonyRule.monochromatic);
      expect(r0.score, closeTo(1.0, 1e-9));

      final r10 = ColorHarmony.evaluateLch(a, const LchColor(50, 40, 10));
      expect(r10.rule, HarmonyRule.monochromatic);
      expect(r10.score, closeTo(0.85, 1e-9));
    });

    test('simetri netral + berwarna dan berwarna + netral → neutral (0.85)', () {
      const neutral = LchColor(60, 2, 0);
      const chromatic = LchColor(50, 40, 120);

      final r1 = ColorHarmony.evaluateLch(neutral, chromatic);
      final r2 = ColorHarmony.evaluateLch(chromatic, neutral);

      expect(r1.rule, HarmonyRule.neutral);
      expect(r1.score, closeTo(0.85, 1e-9));
      expect(r2.rule, HarmonyRule.neutral);
      expect(r2.score, closeTo(0.85, 1e-9));
    });

    test('kedua akromatik: kontras terang tinggi (1.0) vs kecerahan sama (0.8)', () {
      const black = LchColor(0, 0, 0);
      const white = LchColor(100, 0, 0);
      const midGray = LchColor(50, 1, 0);

      final highContrast = ColorHarmony.evaluateLch(black, white);
      expect(highContrast.rule, HarmonyRule.monochromatic);
      expect(highContrast.score, greaterThanOrEqualTo(0.99));

      final identicalGray = ColorHarmony.evaluateLch(midGray, midGray);
      expect(identicalGray.rule, HarmonyRule.monochromatic);
      expect(identicalGray.score, closeTo(0.8, 1e-9));
    });
  });

  group('HarmonyResult label & format', () {
    test('semua HarmonyRule memetakan label UI dengan benar', () {
      expect(
        const HarmonyResult(
          rule: HarmonyRule.monochromatic,
          score: 0.9,
          detail: '',
        ).label,
        'Monochromatic',
      );
      expect(
        const HarmonyResult(
          rule: HarmonyRule.analogous,
          score: 0.85,
          detail: '',
        ).label,
        'Analogous',
      );
      expect(
        const HarmonyResult(
          rule: HarmonyRule.complementary,
          score: 0.85,
          detail: '',
        ).label,
        'Complementary',
      );
      expect(
        const HarmonyResult(
          rule: HarmonyRule.neutral,
          score: 0.85,
          detail: '',
        ).label,
        'Neutral',
      );
      expect(
        const HarmonyResult(
          rule: HarmonyRule.none,
          score: 0.35,
          detail: '',
        ).label,
        'Kontras Tinggi',
      );
    });

    test('toString memformat label, persentase dibulatkan, dan detail', () {
      const res = HarmonyResult(
        rule: HarmonyRule.complementary,
        score: 0.896,
        detail: 'Warna berlawanan',
      );
      expect(res.toString(), 'Complementary (90%) — Warna berlawanan');
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
    test('tiga warna akromatik menghasilkan skor 0–1 dan aturan valid', () {
      final r = ColorHarmony.evaluateOutfit(const [
        Color(0xFF000000),
        Color(0xFFFFFFFF),
        Color(0xFF000000),
      ]);
      expect(r.score, inInclusiveRange(0, 1));
      expect(HarmonyRule.values.contains(r.rule), isTrue);
      expect(r.detail, isNotEmpty);
    });

    test('aturan mayoritas menang pada 3 warna (2 neutral vs 1 none)', () {
      final r = ColorHarmony.evaluateOutfit(const [
        Color(0xFF000000), // netral
        Color(0xFFFF0000), // merah
        Color(0xFF0000FF), // biru
      ]);
      expect(r.rule, HarmonyRule.neutral);
    });

    test('seri jumlah aturan (1 analogous, 1 complementary, 1 none) dimenangkan skor tertinggi', () {
      // Merah (h≈40°), Oranye (h≈61.3°), Cyan (h≈196.4°)
      // (Merah, Oranye) = analogous (~0.89)
      // (Merah, Cyan) = complementary (~0.84)
      // (Oranye, Cyan) = none (0.35)
      final r = ColorHarmony.evaluateOutfit(const [
        Color(0xFFFF0000),
        Color(0xFFFF7F00),
        Color(0xFF00FFFF),
      ]);
      expect(r.rule, HarmonyRule.analogous);
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
      expect(ColorHarmony.evaluateLch(a, b).rule, HarmonyRule.analogous);
      final strict = ColorHarmony.evaluateLch(
        a,
        b,
        thresholds: const HarmonyThresholds(analogousHue: 20),
      );
      expect(strict.rule, isNot(HarmonyRule.analogous));
    });

    test('memperketat achromaticChroma mengubah warna chroma rendah jadi berwarna', () {
      const lowChroma = LchColor(50, 3, 0);
      const chromatic = LchColor(50, 40, 0);
      expect(
        ColorHarmony.evaluateLch(lowChroma, chromatic).rule,
        HarmonyRule.neutral,
      );
      final strict = ColorHarmony.evaluateLch(
        lowChroma,
        chromatic,
        thresholds: const HarmonyThresholds(achromaticChroma: 2),
      );
      expect(strict.rule, HarmonyRule.monochromatic);
    });
  });
}