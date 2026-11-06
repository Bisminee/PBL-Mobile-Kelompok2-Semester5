// lib/services/color_extractor.dart
// Warna dominan dari PIKSEL (bukan ML). Dipakai karena YOLO11n-cls hanya memprediksi jenis pakaian.
// Hanya area tengah 50% yang dihitung supaya latar belakang foto tidak mendominasi.
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:image/image.dart' as img;

import 'color_palette.dart';

class ColorResult {
  final String
  family; // salah satu kosakata dataset: black, white, gray, beige, brown, blue, ...
  final String hex; // rata-rata RGB piksel di keluarga dominan
  final Map<String, double>
  share; // komposisi 0..1 (untuk color_composition_bar.dart)
  ColorResult(this.family, this.hex, this.share);

  /// Nama warna tampilan dari palet 14 warna.
  String get paletteName => paletteNameForFamily(family);
}

String rgbToFamily(int r, int g, int b) {
  final rf = r / 255, gf = g / 255, bf = b / 255;
  final mx = math.max(rf, math.max(gf, bf)),
      mn = math.min(rf, math.min(gf, bf));
  final v = mx, d = mx - mn, s = mx == 0 ? 0.0 : d / mx;
  double h = 0;
  if (d != 0) {
    if (mx == rf) {
      h = 60 * (((gf - bf) / d) % 6);
    } else if (mx == gf) {
      h = 60 * (((bf - rf) / d) + 2);
    } else {
      h = 60 * (((rf - gf) / d) + 4);
    }
  }
  if (h < 0) h += 360;
  if (v < 0.20) return 'black';
  if (s < 0.12) return v > 0.85 ? 'white' : (v < 0.30 ? 'black' : 'gray');
  if (h < 15 || h >= 345) {
    return (s < 0.45 && v > 0.75) ? 'pink' : (v < 0.45 ? 'brown' : 'red');
  }
  if (h < 45) return (v < 0.55) ? 'brown' : (s < 0.40 ? 'beige' : 'orange');
  if (h < 70) return s < 0.35 ? 'beige' : 'yellow';
  if (h < 170) return 'green';
  if (h < 260) return 'blue';
  if (h < 300) return 'purple';
  return 'pink';
}

/// Panggil lewat compute() / Isolate supaya UI tidak patah: compute(extractColor, bytes)
ColorResult extractColor(Uint8List imageBytes) {
  final src = img.decodeImage(imageBytes);
  if (src == null) return ColorResult('other', '#9E9E9E', const {});
  final small = img.copyResize(src, width: 96);
  final x0 = (small.width * .25).round(), x1 = (small.width * .75).round();
  final y0 = (small.height * .25).round(), y1 = (small.height * .75).round();
  final count = <String, int>{},
      sumR = <String, int>{},
      sumG = <String, int>{},
      sumB = <String, int>{};
  var total = 0;
  for (var y = y0; y < y1; y++) {
    for (var x = x0; x < x1; x++) {
      final px = small.getPixel(x, y);
      final r = px.r.toInt(), g = px.g.toInt(), b = px.b.toInt();
      final f = rgbToFamily(r, g, b);
      count[f] = (count[f] ?? 0) + 1;
      sumR[f] = (sumR[f] ?? 0) + r;
      sumG[f] = (sumG[f] ?? 0) + g;
      sumB[f] = (sumB[f] ?? 0) + b;
      total++;
    }
  }
  if (total == 0) return ColorResult('other', '#9E9E9E', const {});
  final top = count.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  final n = count[top]!;
  String h2(int v) => v.toRadixString(16).padLeft(2, '0');
  final hex =
      '#${h2(sumR[top]! ~/ n)}${h2(sumG[top]! ~/ n)}${h2(sumB[top]! ~/ n)}';
  return ColorResult(top, hex, {
    for (final e in count.entries) e.key: e.value / total,
  });
}
