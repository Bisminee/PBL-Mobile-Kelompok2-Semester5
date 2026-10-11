import 'dart:math' as math;
import 'dart:ui' show Color;

/// CIELCh color: lightness (L*), chroma (C*), hue angle (h°).
class LchColor {
  const LchColor(this.l, this.c, this.h);

  /// Lightness, 0–100.
  final double l;

  /// Chroma, 0 (achromatic) upward.
  final double c;

  /// Hue angle in degrees, 0–360 (undefined for achromatic colors → 0).
  final double h;

  bool isAchromatic(double chromaThreshold) => c < chromaThreshold;

  @override
  String toString() =>
      'LchColor(L: ${l.toStringAsFixed(1)}, C: ${c.toStringAsFixed(1)}, '
      'h: ${h.toStringAsFixed(1)})';
}

/// Tunable thresholds for the harmony rules (standard values by default).
///
/// Defaults follow common practice and Li et al. (2025):
/// achromatic chroma < 5, monochromatic Δhue ≤ 10°, analogous Δhue ≤ 30°,
/// complementary 180° ± 30°.
class HarmonyThresholds {
  const HarmonyThresholds({
    this.achromaticChroma = 5.0,
    this.monochromaticHue = 10.0,
    this.analogousHue = 30.0,
    this.complementaryTolerance = 30.0,
  });

  final double achromaticChroma;
  final double monochromaticHue;
  final double analogousHue;
  final double complementaryTolerance;
}

enum HarmonyRule { monochromatic, analogous, complementary, neutral, none }

/// Result of evaluating a color combination.
class HarmonyResult {
  const HarmonyResult({
    required this.rule,
    required this.score,
    required this.detail,
  });

  final HarmonyRule rule;

  /// Harmony score, 0–1 (higher = more harmonious).
  final double score;

  /// Short explanation for the UI / explainability layer.
  final String detail;

  /// Display label used on the "Color Harmony" row in the UI.
  String get label {
    switch (rule) {
      case HarmonyRule.monochromatic:
        return 'Monochromatic';
      case HarmonyRule.analogous:
        return 'Analogous';
      case HarmonyRule.complementary:
        return 'Complementary';
      case HarmonyRule.neutral:
        return 'Neutral';
      case HarmonyRule.none:
        return 'Kontras Tinggi';
    }
  }

  @override
  String toString() =>
      '$label (${(score * 100).round()}%) — $detail';
}

/// Color-harmony rules for outfit compatibility (task E6.4).
///
/// Pure logic (no trained model) used as:
/// - a feature for Model 3 (compatibility score),
/// - the explainability layer ("Color Harmony: Monochromatic"),
/// - the fallback scorer when Model 3 is unavailable.
class ColorHarmony {
  ColorHarmony._();

  static const HarmonyThresholds defaults = HarmonyThresholds();

  /// Evaluate a pair of colors.
  static HarmonyResult evaluate(
    Color a,
    Color b, {
    HarmonyThresholds thresholds = defaults,
  }) {
    return evaluateLch(toLch(a), toLch(b), thresholds: thresholds);
  }

  /// Evaluate a pair given raw CIELCh values (used by unit tests).
  static HarmonyResult evaluateLch(
    LchColor a,
    LchColor b, {
    HarmonyThresholds thresholds = defaults,
  }) {
    final aAchromatic = a.isAchromatic(thresholds.achromaticChroma);
    final bAchromatic = b.isAchromatic(thresholds.achromaticChroma);

    // Both neutral (black / white / gray): achromatic series.
    if (aAchromatic && bAchromatic) {
      final deltaL = (a.l - b.l).abs();
      final score = 0.8 + 0.2 * (deltaL / 60).clamp(0.0, 1.0);
      return HarmonyResult(
        rule: HarmonyRule.monochromatic,
        score: _clamp01(score),
        detail: 'Seri netral (hitam–putih–abu) tanpa warna.',
      );
    }

    // One neutral + one chromatic: achromatic–chromatic parity.
    if (aAchromatic || bAchromatic) {
      return const HarmonyResult(
        rule: HarmonyRule.neutral,
        score: 0.85,
        detail: 'Warna netral dipadukan dengan warna berwarna.',
      );
    }

    final delta = hueDistance(a.h, b.h);

    if (delta <= thresholds.monochromaticHue) {
      final score = 0.85 +
          0.15 * (1 - delta / math.max(thresholds.monochromaticHue, 1e-6));
      return HarmonyResult(
        rule: HarmonyRule.monochromatic,
        score: _clamp01(score),
        detail: 'Warna senada dengan perbedaan hue sangat kecil.',
      );
    }

    if (delta <= thresholds.analogousHue) {
      final span = math.max(
        thresholds.analogousHue - thresholds.monochromaticHue,
        1e-6,
      );
      final score = 0.8 +
          0.2 * (1 - ((delta - thresholds.monochromaticHue) / span).clamp(0.0, 1.0));
      return HarmonyResult(
        rule: HarmonyRule.analogous,
        score: _clamp01(score),
        detail: 'Warna berdekatan pada roda warna (analog).',
      );
    }

    final complementDiff = (delta - 180).abs();
    if (complementDiff <= thresholds.complementaryTolerance) {
      final score =
          0.8 + 0.2 * (1 - complementDiff / thresholds.complementaryTolerance);
      return HarmonyResult(
        rule: HarmonyRule.complementary,
        score: _clamp01(score),
        detail: 'Warna berlawanan pada roda warna (komplementer).',
      );
    }

    return const HarmonyResult(
      rule: HarmonyRule.none,
      score: 0.35,
      detail: 'Tidak ada aturan harmoni yang cocok (kontras tinggi).',
    );
  }

  /// Evaluate an outfit of `n` colors (all pairs averaged).
  static HarmonyResult evaluateOutfit(
    List<Color> colors, {
    HarmonyThresholds thresholds = defaults,
  }) {
    final list = colors.map(toLch).toList();

    if (list.isEmpty) {
      return const HarmonyResult(
        rule: HarmonyRule.none,
        score: 0,
        detail: 'Tidak ada warna untuk dinilai.',
      );
    }
    if (list.length == 1) {
      return const HarmonyResult(
        rule: HarmonyRule.monochromatic,
        score: 1,
        detail: 'Hanya satu warna.',
      );
    }

    final scores = <double>[];
    final ruleCount = <HarmonyRule, int>{};
    final ruleScore = <HarmonyRule, double>{};

    for (var i = 0; i < list.length; i++) {
      for (var j = i + 1; j < list.length; j++) {
        final r = evaluateLch(list[i], list[j], thresholds: thresholds);
        scores.add(r.score);
        ruleCount[r.rule] = (ruleCount[r.rule] ?? 0) + 1;
        ruleScore[r.rule] = (ruleScore[r.rule] ?? 0) + r.score;
      }
    }

    final avg = scores.reduce((a, b) => a + b) / scores.length;

    // Dominant rule: most frequent, tie broken by highest average score.
    var dominant = HarmonyRule.none;
    var bestCount = -1;
    var bestAvg = -1.0;
    ruleCount.forEach((rule, count) {
      final mean = (ruleScore[rule] ?? 0) / count;
      if (count > bestCount || (count == bestCount && mean > bestAvg)) {
        dominant = rule;
        bestCount = count;
        bestAvg = mean;
      }
    });

    return HarmonyResult(
      rule: dominant,
      score: _clamp01(avg),
      detail: 'Rata-rata ${scores.length} pasangan warna dalam outfit.',
    );
  }

  /// Shortest angular distance between two hue angles (0–180°).
  static double hueDistance(double h1, double h2) {
    final d = ((h1 - h2).abs()) % 360;
    return d > 180 ? 360 - d : d;
  }

  /// Convert a UI color (sRGB) to CIELCh.
  static LchColor toLch(Color color) {
    final argb = color.toARGB32();
    final r = ((argb >> 16) & 0xFF) / 255.0;
    final g = ((argb >> 8) & 0xFF) / 255.0;
    final b = (argb & 0xFF) / 255.0;

    final rl = _toLinear(r);
    final gl = _toLinear(g);
    final bl = _toLinear(b);

    // Linear sRGB → XYZ (D65)
    final x = 0.4124564 * rl + 0.3575761 * gl + 0.1804375 * bl;
    final y = 0.2126729 * rl + 0.7151522 * gl + 0.0721750 * bl;
    final z = 0.0193339 * rl + 0.1191920 * gl + 0.9503041 * bl;

    // XYZ → Lab (D65 reference white)
    final fx = _labF(x / 0.95047);
    final fy = _labF(y / 1.00000);
    final fz = _labF(z / 1.08883);

    final l = 116 * fy - 16;
    final a = 500 * (fx - fy);
    final bb = 200 * (fy - fz);

    final c = math.sqrt(a * a + bb * bb);
    var h = math.atan2(bb, a) * 180 / math.pi;
    if (h < 0) h += 360;

    return LchColor(l, c, h);
  }

  static double _toLinear(double channel) {
    if (channel <= 0.04045) return channel / 12.92;
    return math.pow((channel + 0.055) / 1.055, 2.4).toDouble();
  }

  static double _labF(double t) {
    const delta = 6 / 29;
    if (t > delta * delta * delta) {
      return math.pow(t, 1 / 3).toDouble();
    }
    return t / (3 * delta * delta) + 4 / 29;
  }

  static double _clamp01(double v) => v.clamp(0.0, 1.0);
}
