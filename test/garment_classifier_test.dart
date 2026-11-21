import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:sera_z/services/garment_classifier.dart';

Uint8List _encodeSolidPng(int width, int height, int r, int g, int b) {
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
  group('Konstanta & model Prediction', () {
    test('modelImageSize bernilai 224 sesuai spesifikasi YOLO11n-cls', () {
      expect(modelImageSize, 224);
    });

    test('Prediction menyimpan label dan confidence dengan benar', () {
      const pred = Prediction('t_shirt', 0.985);
      expect(pred.label, 't_shirt');
      expect(pred.confidence, 0.985);
    });
  });

  group('preprocessForModel', () {
    const plane = modelImageSize * modelImageSize;

    test('mengembalikan null untuk byte kosong atau gambar rusak', () {
      expect(preprocessForModel(Uint8List(0)), isNull);
      expect(preprocessForModel(Uint8List.fromList([1, 2, 3, 4, 5])), isNull);
    });

    test('menghasilkan tensor NCHW [1, 3, 224, 224] ternormalisasi 0..1', () {
      // Gunakan warna dengan nilai R, G, B berbeda agar urutan channel teruji
      final bytes = _encodeSolidPng(224, 224, 51, 102, 204);
      final tensor = preprocessForModel(bytes);

      expect(tensor, isNotNull);
      expect(tensor!.length, 3 * plane);

      const expectedR = 51 / 255.0; // 0.2
      const expectedG = 102 / 255.0; // 0.4
      const expectedB = 204 / 255.0; // 0.8

      // Cek titik awal, tengah, dan akhir tiap plane (R lalu G lalu B)
      for (final idx in [0, plane ~/ 2, plane - 1]) {
        expect(tensor[idx], closeTo(expectedR, 1e-6));
        expect(tensor[plane + idx], closeTo(expectedG, 1e-6));
        expect(tensor[2 * plane + idx], closeTo(expectedB, 1e-6));
      }
    });

    test('memetakan koordinat piksel row-major (y * 224 + x) dengan akurat', () {
      final image = img.Image(width: 224, height: 224);
      // Set piksel (0, 0) merah murni dan piksel (223, 223) hijau murni
      image.getPixel(0, 0)
        ..r = 255
        ..g = 0
        ..b = 0;
      image.getPixel(223, 223)
        ..r = 0
        ..g = 255
        ..b = 0;

      final tensor = preprocessForModel(
        Uint8List.fromList(img.encodePng(image)),
      )!;

      // Indeks 0 = (0, 0)
      expect(tensor[0], closeTo(1.0, 1e-6));
      expect(tensor[plane], closeTo(0.0, 1e-6));
      expect(tensor[2 * plane], closeTo(0.0, 1e-6));

      // Indeks plane - 1 = (223, 223)
      const last = plane - 1;
      expect(tensor[last], closeTo(0.0, 1e-6));
      expect(tensor[plane + last], closeTo(1.0, 1e-6));
      expect(tensor[2 * plane + last], closeTo(0.0, 1e-6));
    });

    test('resize sisi pendek ke 224 dan center crop pada gambar landscape', () {
      // 400x200 -> scale 1.12 -> 448x224 -> crop tengah x: 112..336 (asal x: 100..300)
      final image = img.Image(width: 400, height: 200);
      for (var y = 0; y < 200; y++) {
        for (var x = 0; x < 400; x++) {
          final isCenter = x >= 90 && x < 310;
          final px = image.getPixel(x, y);
          if (isCenter) {
            px
              ..r = 0
              ..g = 0
              ..b = 255;
          } else {
            px
              ..r = 255
              ..g = 0
              ..b = 0;
          }
        }
      }

      final tensor = preprocessForModel(
        Uint8List.fromList(img.encodePng(image)),
      )!;

      expect(tensor.length, 3 * plane);
      // Area tepi kiri/kanan (merah) harus terpotong habis, tersisa biru murni
      for (var i = 0; i < plane; i++) {
        expect(tensor[i], closeTo(0.0, 1e-6));
        expect(tensor[plane + i], closeTo(0.0, 1e-6));
        expect(tensor[2 * plane + i], closeTo(1.0, 1e-6));
      }
    });

    test('resize sisi pendek ke 224 dan center crop pada gambar portrait', () {
      // 200x400 -> scale 1.12 -> 224x448 -> crop tengah y: 112..336 (asal y: 100..300)
      final image = img.Image(width: 200, height: 400);
      for (var y = 0; y < 400; y++) {
        for (var x = 0; x < 200; x++) {
          final isCenter = y >= 90 && y < 310;
          final px = image.getPixel(x, y);
          if (isCenter) {
            px
              ..r = 0
              ..g = 255
              ..b = 0;
          } else {
            px
              ..r = 255
              ..g = 0
              ..b = 0;
          }
        }
      }

      final tensor = preprocessForModel(
        Uint8List.fromList(img.encodePng(image)),
      )!;

      expect(tensor.length, 3 * plane);
      // Area tepi atas/bawah (merah) harus terpotong habis, tersisa hijau murni
      for (var i = 0; i < plane; i++) {
        expect(tensor[i], closeTo(0.0, 1e-6));
        expect(tensor[plane + i], closeTo(1.0, 1e-6));
        expect(tensor[2 * plane + i], closeTo(0.0, 1e-6));
      }
    });

    test('melakukan upscale gambar kecil ke dimensi tensor 224x224', () {
      final bytes = _encodeSolidPng(32, 64, 255, 255, 255);
      final tensor = preprocessForModel(bytes);

      expect(tensor, isNotNull);
      expect(tensor!.length, 3 * plane);
      expect(tensor.every((v) => (v - 1.0).abs() < 1e-6), isTrue);
    });

    test('memperbaiki rotasi EXIF sebelum resize dan crop', () {
      // Gambar 40x20: sisi kiri merah, sisi kanan biru, dengan EXIF orientation 6 (90° CW).
      // Setelah bakeOrientation menjadi 20x40: bagian atas merah, bagian bawah biru.
      final image = img.Image(width: 40, height: 20);
      for (var y = 0; y < 20; y++) {
        for (var x = 0; x < 40; x++) {
          final px = image.getPixel(x, y);
          if (x < 20) {
            px
              ..r = 255
              ..g = 0
              ..b = 0;
          } else {
            px
              ..r = 0
              ..g = 0
              ..b = 255;
          }
        }
      }
      image.exif.imageIfd.orientation = 6;

      final jpgBytes = Uint8List.fromList(img.encodeJpg(image, quality: 100));
      final tensor = preprocessForModel(jpgBytes)!;

      // Piksel bagian atas-tengah (x=112, y=40) -> dominan merah
      const topIdx = 40 * modelImageSize + 112;
      expect(tensor[topIdx], greaterThan(0.9));
      expect(tensor[2 * plane + topIdx], lessThan(0.1));

      // Piksel bagian bawah-tengah (x=112, y=184) -> dominan biru
      const bottomIdx = 184 * modelImageSize + 112;
      expect(tensor[bottomIdx], lessThan(0.1));
      expect(tensor[2 * plane + bottomIdx], greaterThan(0.9));
    });
  });
}