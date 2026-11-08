import 'dart:typed_data';

import 'package:flutter/material.dart' show Rect;
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:sera_z/services/image_crop.dart';

void main() {
  group('cropSpecFromRect', () {
    test('mengubah kotak piksel menjadi nilai 0..1', () {
      final spec = cropSpecFromRect(
        const Rect.fromLTWH(50, 25, 100, 50),
        200,
        100,
      );

      expect(spec.left, closeTo(0.25, 1e-9));
      expect(spec.top, closeTo(0.25, 1e-9));
      expect(spec.width, closeTo(0.5, 1e-9));
      expect(spec.height, closeTo(0.5, 1e-9));
    });

    test('menjepit kotak yang keluar dari batas gambar', () {
      final spec = cropSpecFromRect(
        const Rect.fromLTWH(180, 90, 100, 100),
        200,
        100,
      );

      expect(spec.left, closeTo(0.9, 1e-9));
      expect(spec.top, closeTo(0.9, 1e-9));
      expect(spec.width, closeTo(0.1, 1e-9));
      expect(spec.height, closeTo(0.1, 1e-9));
    });

    test('mengembalikan nilai penuh bila ukuran gambar tidak valid', () {
      final spec = cropSpecFromRect(const Rect.fromLTWH(0, 0, 10, 10), 0, 0);

      expect(spec.left, 0);
      expect(spec.top, 0);
      expect(spec.width, 1);
      expect(spec.height, 1);
    });
  });

  group('rotatePhoto', () {
    test('menukar lebar dan tinggi setelah diputar 90 derajat', () {
      final source = img.encodeJpg(img.Image(width: 120, height: 80));
      final rotated = rotatePhoto(source);

      expect(rotated, isNotNull);
      final decoded = img.decodeImage(rotated!)!;
      expect(decoded.width, 80);
      expect(decoded.height, 120);
    });

    test('mengembalikan null untuk data yang bukan gambar', () {
      expect(rotatePhoto(Uint8List.fromList([1, 2, 3])), isNull);
    });
  });

  group('shrinkCropped', () {
    test('mengecilkan hasil besar ke batas 1024', () {
      final source = img.encodeJpg(img.Image(width: 2048, height: 2048));
      final result = shrinkCropped(source)!;
      final decoded = img.decodeImage(result)!;

      expect(decoded.width, croppedPhotoSide);
      expect(decoded.height, croppedPhotoSide);
    });

    test('tidak memperbesar gambar yang lebih kecil', () {
      final source = img.encodeJpg(img.Image(width: 400, height: 400));
      final result = shrinkCropped(source)!;
      final decoded = img.decodeImage(result)!;

      expect(decoded.width, 400);
      expect(decoded.height, 400);
    });

    test('menjaga rasio gambar persegi panjang', () {
      final source = img.encodeJpg(img.Image(width: 3000, height: 1500));
      final result = shrinkCropped(source)!;
      final decoded = img.decodeImage(result)!;

      expect(decoded.width, 1024);
      expect(decoded.height, 512);
    });
  });

  group('imageSizeOf', () {
    test('membaca ukuran gambar', () {
      final source = img.encodePng(img.Image(width: 320, height: 240));
      final size = imageSizeOf(source);

      expect(size?.width, 320);
      expect(size?.height, 240);
    });

    test('mengembalikan null untuk data rusak', () {
      expect(imageSizeOf(Uint8List.fromList([9, 9, 9])), isNull);
    });
  });
}
