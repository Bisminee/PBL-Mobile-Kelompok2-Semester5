import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:sera_z/services/photo_intake.dart';

void main() {
  group('normalizePhoto', () {
    test('mengembalikan null untuk data yang bukan gambar', () {
      expect(normalizePhoto(Uint8List.fromList([1, 2, 3, 4])), isNull);
    });

    test('membatasi sisi terpanjang tanpa mengubah rasio', () {
      final source = img.Image(width: 3000, height: 1500);
      final result = normalizePhoto(img.encodeJpg(source));

      expect(result, isNotNull);
      final decoded = img.decodeImage(result!)!;
      expect(decoded.width, 2048);
      expect(decoded.height, 1024);
    });

    test('tidak memperbesar gambar yang sudah kecil', () {
      final source = img.Image(width: 800, height: 600);
      final result = normalizePhoto(img.encodeJpg(source))!;
      final decoded = img.decodeImage(result)!;

      expect(decoded.width, 800);
      expect(decoded.height, 600);
    });

    test('membatasi gambar potret berdasarkan tinggi', () {
      final source = img.Image(width: 1500, height: 3000);
      final result = normalizePhoto(img.encodeJpg(source))!;
      final decoded = img.decodeImage(result)!;

      expect(decoded.width, 1024);
      expect(decoded.height, 2048);
    });
  });
}
