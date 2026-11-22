// File pengujian untuk memvalidasi stabilitas pemetaan 14 palet warna.
// Memastikan output warna dari ekstraktor diterjemahkan ke UI dengan konsisten.
import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/services/color_extractor.dart';
import 'package:sera_z/services/color_palette.dart';

void main() {
  group('Palet 14 warna', () {
    test('berisi 14 nama unik', () {
      expect(colorPalette14.length, 14);
      expect(colorPalette14.toSet().length, 14);
    });

    test('memetakan seluruh keluarga warna dan alias Inggris ke nama palet', () {
      expect(paletteNameForFamily('black'), 'hitam');
      expect(paletteNameForFamily('white'), 'putih');
      expect(paletteNameForFamily('gray'), 'abu-abu');
      expect(paletteNameForFamily('grey'), 'abu-abu');
      expect(paletteNameForFamily('beige'), 'krem');
      expect(paletteNameForFamily('cream'), 'krem');
      expect(paletteNameForFamily('brown'), 'cokelat');
      expect(paletteNameForFamily('red'), 'merah');
      expect(paletteNameForFamily('maroon'), 'merah');
      expect(paletteNameForFamily('pink'), 'pink');
      expect(paletteNameForFamily('orange'), 'oranye');
      expect(paletteNameForFamily('yellow'), 'kuning');
      expect(paletteNameForFamily('green'), 'hijau');
      expect(paletteNameForFamily('sage'), 'hijau army');
      expect(paletteNameForFamily('army green'), 'hijau army');
      expect(paletteNameForFamily('blue'), 'biru muda');
      expect(paletteNameForFamily('denim'), 'biru muda');
      expect(paletteNameForFamily('light blue'), 'biru muda');
      expect(paletteNameForFamily('navy'), 'navy');
      expect(paletteNameForFamily('purple'), 'ungu');
    });

    test('idempoten untuk seluruh 14 nama palet bahasa Indonesia', () {
      for (final name in colorPalette14) {
        expect(paletteNameForFamily(name), name);
        expect(isPaletteName(name), isTrue);
      }
    });

    test('semua hasil pemetaan keluarga yang dikenal ada di palet', () {
      for (final family in [
        'black',
        'white',
        'gray',
        'grey',
        'beige',
        'cream',
        'brown',
        'red',
        'maroon',
        'pink',
        'orange',
        'yellow',
        'green',
        'sage',
        'army green',
        'blue',
        'denim',
        'light blue',
        'navy',
        'purple',
      ]) {
        expect(isPaletteName(paletteNameForFamily(family)), isTrue);
      }
    });

    test('keluarga tidak dikenal dan fallback other dikembalikan apa adanya', () {
      expect(paletteNameForFamily('unknown'), 'unknown');
      expect(isPaletteName('unknown'), isFalse);

      expect(paletteNameForFamily('other'), 'other');
      expect(isPaletteName('other'), isFalse);

      expect(paletteNameForFamily(''), '');
      expect(isPaletteName(''), isFalse);
    });

    test('ColorResult memetakan family ke paletteName secara konsisten', () {
      final navy = ColorResult('navy', '#000080', const {'navy': 1.0});
      expect(navy.paletteName, 'navy');

      final denim = ColorResult('denim', '#2F5D9E', const {'denim': 1.0});
      expect(denim.paletteName, 'biru muda');

      final fallback = ColorResult('other', '#9E9E9E', const {});
      expect(fallback.paletteName, 'other');
    });
  });
}