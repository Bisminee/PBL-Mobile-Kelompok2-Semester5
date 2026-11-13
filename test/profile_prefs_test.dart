import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/services/profile_prefs.dart';

void main() {
  group('normalizeDisplayName', () {
    test('memangkas spasi di awal dan akhir', () {
      expect(normalizeDisplayName('  Abim Mustawa  '), 'Abim Mustawa');
    });

    test('merapikan spasi ganda', () {
      expect(normalizeDisplayName('Abim   Mustawa'), 'Abim Mustawa');
    });

    test('menolak nama kosong', () {
      expect(normalizeDisplayName('   '), isNull);
      expect(normalizeDisplayName(''), isNull);
    });

    test('memotong nama yang terlalu panjang', () {
      final hasil = normalizeDisplayName('a' * 100);
      expect(hasil, isNotNull);
      expect(hasil!.length, maxDisplayNameLength);
    });
  });

  group('preferensi notifikasi', () {
    test('nilai kosong memakai bawaan true', () {
      expect(parseBoolPreference(null), isTrue);
      expect(parseBoolPreference(null, fallback: false), isFalse);
    });

    test('membaca true dan false', () {
      expect(parseBoolPreference('true'), isTrue);
      expect(parseBoolPreference('false'), isFalse);
      expect(parseBoolPreference('1'), isTrue);
      expect(parseBoolPreference('0'), isFalse);
    });

    test('nilai asing kembali ke fallback', () {
      expect(parseBoolPreference('mungkin', fallback: false), isFalse);
      expect(parseBoolPreference('', fallback: true), isTrue);
    });

    test('encode dan parse konsisten', () {
      for (final nilai in [true, false]) {
        expect(parseBoolPreference(encodeBoolPreference(nilai)), nilai);
      }
    });
  });
}
