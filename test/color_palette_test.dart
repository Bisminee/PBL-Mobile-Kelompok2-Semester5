import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/services/color_extractor.dart';
import 'package:sera_z/services/color_palette.dart';

void main() {
  group('Palet 14 warna', () {
    test('berisi 14 nama unik', () {
      expect(colorPalette14.length, 14);
      expect(colorPalette14.toSet().length, 14);
    });

    test('memetakan keluarga warna ke nama palet', () {
      expect(paletteNameForFamily('black'), 'hitam');
      expect(paletteNameForFamily('white'), 'putih');
      expect(paletteNameForFamily('gray'), 'abu-abu');
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
      expect(paletteNameForFamily('blue'), 'biru muda');
      expect(paletteNameForFamily('denim'), 'biru muda');
      expect(paletteNameForFamily('navy'), 'navy');
      expect(paletteNameForFamily('purple'), 'ungu');
    });

    test('semua hasil pemetaan ada di palet', () {
      for (final family in [
        'black',
        'white',
        'gray',
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
        'blue',
        'denim',
        'navy',
        'purple',
      ]) {
        expect(isPaletteName(paletteNameForFamily(family)), isTrue);
      }
    });

    test('keluarga tidak dikenal dikembalikan apa adanya', () {
      expect(paletteNameForFamily('unknown'), 'unknown');
      expect(isPaletteName('unknown'), isFalse);
    });

    test('ColorResult memakai nama palet', () {
      final result = ColorResult('navy', '#000080', const {'navy': 1.0});
      expect(result.paletteName, 'navy');
    });
  });
}
