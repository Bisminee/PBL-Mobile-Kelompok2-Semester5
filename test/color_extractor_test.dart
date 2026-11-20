import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:sera_z/services/color_extractor.dart';

Uint8List _encodeSolid(int width, int height, int r, int g, int b) {
  final image = img.Image(width: width, height: height);
  for (final pixel in image) {
    pixel
      ..r = r
      ..g = g
      ..b = b;
  }
  return Uint8List.fromList(img.encodePng(image));
}

void main() {
  group('rgbToFamily', () {
    test('warna dasar dan akromatik (black, white, gray)', () {
      expect(rgbToFamily(0, 0, 0), 'black');
      expect(rgbToFamily(40, 10, 10), 'black'); // v < 0.20 meski ada hue
      expect(rgbToFamily(65, 65, 65), 'black'); // s < 0.12 dan v < 0.30
      expect(rgbToFamily(128, 128, 128), 'gray'); // s < 0.12 dan 0.30 <= v <= 0.85
      expect(rgbToFamily(255, 255, 255), 'white');
      expect(rgbToFamily(230, 225, 225), 'white'); // s < 0.12 dan v > 0.85
    });

    test('sektor merah: red, pink pastel, dan brown gelap', () {
      expect(rgbToFamily(200, 30, 30), 'red'); // hue ~0°
      expect(rgbToFamily(220, 20, 60), 'red'); // hue ~348° (>= 345°)
      expect(rgbToFamily(255, 180, 180), 'pink'); // s < 0.45 && v > 0.75
      expect(rgbToFamily(100, 20, 20), 'brown'); // v < 0.45
    });

    test('sektor oranye & kuning: brown, beige, orange, yellow', () {
      expect(rgbToFamily(120, 70, 20), 'brown'); // hue 30°, v < 0.55
      expect(rgbToFamily(220, 195, 160), 'beige'); // hue 35°, s < 0.40
      expect(rgbToFamily(240, 130, 20), 'orange'); // hue 30°, s >= 0.40
      expect(rgbToFamily(230, 225, 170), 'beige'); // hue 55°, s < 0.35
      expect(rgbToFamily(240, 220, 30), 'yellow'); // hue ~54°, s >= 0.35
    });

    test('sektor hijau, biru, ungu, dan magenta-pink', () {
      expect(rgbToFamily(40, 160, 60), 'green'); // hue 130°
      expect(rgbToFamily(30, 60, 200), 'blue'); // hue ~229°
      expect(rgbToFamily(150, 40, 200), 'purple'); // hue ~281°
      expect(rgbToFamily(220, 40, 160), 'pink'); // hue 320° (300..345)
    });
  });

  group('extractColor', () {
    test('mengembalikan fallback other saat byte gambar tidak valid', () {
      final res = extractColor(Uint8List.fromList([0, 1, 2, 3]));
      expect(res.family, 'other');
      expect(res.hex, '#9E9E9E');
      expect(res.share, isEmpty);
      expect(res.paletteName, 'other');
    });

    test('mengekstrak warna dominan, hex, dan paletteName dari gambar solid', () {
      final bytes = _encodeSolid(40, 40, 200, 30, 30);
      final res = extractColor(bytes);

      expect(res.family, 'red');
      expect(res.hex, '#c81e1e');
      expect(res.share, {'red': 1.0});
      expect(res.paletteName, 'merah');
    });

    test('hanya menghitung area tengah 50% sehingga background tepi terabaikan', () {
      // Gambar 96x96: 75% area luar putih, hanya kotak tengah 48x48 yang biru
      final image = img.Image(width: 96, height: 96);
      for (var y = 0; y < 96; y++) {
        for (var x = 0; x < 96; x++) {
          final isCenter = x >= 24 && x < 72 && y >= 24 && y < 72;
          final px = image.getPixel(x, y);
          if (isCenter) {
            px
              ..r = 30
              ..g = 60
              ..b = 200;
          } else {
            px
              ..r = 255
              ..g = 255
              ..b = 255;
          }
        }
      }

      final res = extractColor(Uint8List.fromList(img.encodePng(image)));
      expect(res.family, 'blue');
      expect(res.paletteName, 'biru muda');
      expect(res.share['blue'], closeTo(1.0, 1e-9));
      expect(res.share.containsKey('white'), isFalse);
    });

    test('menghitung rata-rata hex dominan dan proporsi share multi-warna', () {
      // Area tengah 48x48 (y: 24..72):
      // - 36 baris atas (75%): kombinasi dua gradasi merah (200,0,0) dan (240,40,40)
      // - 12 baris bawah (25%): hijau (40,160,60)
      final image = img.Image(width: 96, height: 96);
      for (var y = 0; y < 96; y++) {
        for (var x = 0; x < 96; x++) {
          final px = image.getPixel(x, y);
          if (y < 42) {
            px
              ..r = 200
              ..g = 0
              ..b = 0;
          } else if (y < 60) {
            px
              ..r = 240
              ..g = 40
              ..b = 40;
          } else {
            px
              ..r = 40
              ..g = 160
              ..b = 60;
          }
        }
      }

      final res = extractColor(Uint8List.fromList(img.encodePng(image)));
      expect(res.family, 'red');
      expect(res.hex, '#dc1414'); // rata-rata (220, 20, 20)
      expect(res.share['red'], closeTo(0.75, 1e-9));
      expect(res.share['green'], closeTo(0.25, 1e-9));
    });
  });
}