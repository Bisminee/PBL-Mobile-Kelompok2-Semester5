import 'dart:math' as math;
import 'dart:ui' show Color;

import 'color_harmony.dart';

/// Tingkat kecerahan keluarga warna.
enum ColorTone { light, medium, dark }

/// 16 keluarga warna acuan untuk harmoni.
///
/// Nilai HEX adalah titik acuan awal. Warna hasil ekstraksi gambar akan
/// dibandingkan ke titik terdekat memakai jarak CIELAB, bukan RGB mentah.
enum ColorFamily {
  black('black', 'Hitam', 0xFF1A1A1A, ColorTone.dark, true),
  white('white', 'Putih', 0xFFF5F5F5, ColorTone.light, true),
  gray('gray', 'Abu-abu', 0xFF808080, ColorTone.medium, true),
  cream('cream', 'Krem', 0xFFF2E3C6, ColorTone.light, true),
  brown('brown', 'Cokelat', 0xFF6B4423, ColorTone.dark, true),
  red('red', 'Merah', 0xFFC62828, ColorTone.medium, false),
  maroon('maroon', 'Maroon', 0xFF7B1F2B, ColorTone.dark, false),
  pink('pink', 'Pink', 0xFFE8A0BF, ColorTone.light, false),
  orange('orange', 'Oranye', 0xFFE67E22, ColorTone.medium, false),
  yellow('yellow', 'Kuning', 0xFFE6C229, ColorTone.light, false),
  green('green', 'Hijau', 0xFF3E7C4F, ColorTone.medium, false),
  olive('olive', 'Olive', 0xFF6B8E23, ColorTone.medium, false),
  teal('teal', 'Teal', 0xFF00897B, ColorTone.medium, false),
  blue('blue', 'Biru', 0xFF2F5D9E, ColorTone.medium, false),
  navy('navy', 'Navy', 0xFF1A237E, ColorTone.dark, true),
  purple('purple', 'Ungu', 0xFF6A1B9A, ColorTone.dark, false);

  const ColorFamily(this.key, this.label, this.hex, this.tone, this.isNeutral);

  final String key;
  final String label;
  final int hex;
  final ColorTone tone;
  final bool isNeutral;

  Color get color => Color(hex);

  /// Kode HEX untuk disimpan di `color_hex`, mis. `#1A237E`.
  String get hexCode =>
      '#${(hex & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

  /// Nama keluarga berdasarkan kode, mis. `navy`.
  static ColorFamily? byKey(String key) {
    for (final family in ColorFamily.values) {
      if (family.key == key) return family;
    }
    return null;
  }

  /// Kode lama tetap bisa dipilih setelah migrasi 16 warna.
  static ColorFamily? byKeyOrAlias(String key) =>
      byKey(key) ??
      switch (key) {
        'beige' => cream,
        'grey' => gray,
        _ => null,
      };
}

/// Keluarga warna terdekat dari sebuah warna gambar.
///
/// Memakai jarak Euclidean di ruang CIELAB. Hue tidak dipakai langsung agar
/// warna netral dan warna gelap tidak salah dipetakan hanya karena hue tidak
/// stabil pada saturasi rendah.
ColorFamily nearestColorFamily(Color color) {
  final target = ColorHarmony.toLch(color);
  var best = ColorFamily.black;
  var bestDistance = double.infinity;

  for (final family in ColorFamily.values) {
    final reference = ColorHarmony.toLch(family.color);
    final distance = _labDistance(target, reference);
    if (distance < bestDistance) {
      bestDistance = distance;
      best = family;
    }
  }
  return best;
}

/// Evaluasi harmoni antara dua keluarga warna acuan.
HarmonyResult evaluateFamilyHarmony(
  ColorFamily a,
  ColorFamily b, {
  HarmonyThresholds thresholds = ColorHarmony.defaults,
}) {
  final lchA = ColorHarmony.toLch(a.color);
  final lchB = ColorHarmony.toLch(b.color);

  // Dua keluarga netral tetapi berbeda terang/gelap, mis. navy dan krem.
  // Keduanya tetap dianggap netral meskipun chroma krem berada di atas ambang
  // akromatik.
  final bothNeutral = a.isNeutral && b.isNeutral;
  final bothAchromatic =
      lchA.isAchromatic(thresholds.achromaticChroma) &&
      lchB.isAchromatic(thresholds.achromaticChroma);

  if (bothNeutral && !bothAchromatic) {
    return const HarmonyResult(
      rule: HarmonyRule.neutral,
      score: 0.9,
      detail: 'Dua warna netral dengan perbedaan terang dan gelap.',
    );
  }

  if (!bothNeutral && (a.isNeutral || b.isNeutral)) {
    return const HarmonyResult(
      rule: HarmonyRule.neutral,
      score: 0.85,
      detail: 'Warna netral dipadukan dengan warna berwarna.',
    );
  }

  return ColorHarmony.evaluateLch(lchA, lchB, thresholds: thresholds);
}

/// Jarak CIELAB antara dua warna LCh.
double _labDistance(LchColor a, LchColor b) {
  final aA = a.c * math.cos(a.h * math.pi / 180);
  final aB = a.c * math.sin(a.h * math.pi / 180);
  final bA = b.c * math.cos(b.h * math.pi / 180);
  final bB = b.c * math.sin(b.h * math.pi / 180);
  final dl = a.l - b.l;
  final da = aA - bA;
  final db = aB - bB;
  return math.sqrt(dl * dl + da * da + db * db);
}
