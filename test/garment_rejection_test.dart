import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/services/outfit_engine.dart';

/// Membuat Detection tiruan tanpa menjalankan model atau database.
Detection _deteksi({
  required String type,
  required double confidence,
  bool manual = false,
}) {
  return Detection(
    type: type,
    slot: 'top',
    color: 'black',
    colorHex: '#000000',
    formality: 'non_formal',
    confidence: confidence,
    alternatives: const [],
    styles: const [],
    colorShare: const {'black': 1},
    manual: manual,
  );
}

void main() {
  group('Detection.isGarment', () {
    test('kelas other selalu ditolak', () {
      expect(
        _deteksi(type: notGarmentType, confidence: 0.99).isGarment,
        isFalse,
      );
    });

    test('pakaian dengan confidence tinggi diterima', () {
      expect(_deteksi(type: 'tshirt', confidence: 0.96).isGarment, isTrue);
    });

    test('confidence di bawah batas ditolak', () {
      expect(
        _deteksi(
          type: 'tshirt',
          confidence: minimumGarmentConfidence - 0.01,
        ).isGarment,
        isFalse,
      );
    });

    test('koreksi manual user selalu diterima', () {
      expect(
        _deteksi(type: 'shirt', confidence: 0.10, manual: true).isGarment,
        isTrue,
      );
    });

    test('manual tidak menyelamatkan kelas other', () {
      // User tidak bisa memilih "other" dari daftar, tetapi bila datanya
      // somehow bertipe other, tetap dianggap bukan pakaian.
      expect(
        _deteksi(
          type: notGarmentType,
          confidence: 0.99,
          manual: true,
        ).isGarment,
        isFalse,
      );
    });
  });
}
