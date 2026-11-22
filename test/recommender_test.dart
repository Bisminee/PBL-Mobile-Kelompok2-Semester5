import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/models/garment.dart';
import 'package:sera_z/models/outfit.dart';
import 'package:sera_z/models/saved_outfit.dart';
import 'package:sera_z/services/recommender.dart';

Garment _g(int id, String type, String slot, String color, String formality) =>
    Garment.fromRow({
      'id': id,
      'garment_type': type,
      'slot': slot,
      'color_family': color,
      'formality': formality,
    });

void main() {
  group('colorRelation', () {
    test('kasus dasar', () {
      expect(colorRelation('red', 'red'), 'Monokrom');
      expect(colorRelation('black', 'white'), 'Netral');
      expect(colorRelation('black', 'red'), 'Netral + aksen');
      expect(colorRelation('red', 'blue'), 'Kontras');
      expect(colorRelation(null, 'red'), 'Netral');
    });
  });

  group('buildOutfits', () {
    final wardrobe = [
      _g(1, 't_shirt', 'top', 'black', 'non_formal'),
      _g(2, 'shirt', 'top', 'white', 'formal'),
      _g(3, 'pants', 'bottom', 'blue', 'semi_formal'),
      _g(4, 'shoes', 'shoes', 'white', 'non_formal'),
    ];

    // Skor tiruan: kemeja putih + celana biru paling tinggi; kombinasi kaos hitam tidak ada di tabel.
    double? fakePair(String ta, String ca, String tb, String cb) =>
        ta == 'shirt' ? 0.5 : null;

    test('hanya atasan x bawahan yang punya skor, diurut menurun', () {
      final out = buildOutfits(
        wardrobe: wardrobe,
        pairScore: fakePair,
        toPercentile: (raw) => raw,
      );
      expect(out.length, 1);
      expect(out.first.id, '2-3');
      expect(out.first.score, 0.5);
    });

    test('formalitas outfit = yang terendah dari kedua item', () {
      final out = buildOutfits(
        wardrobe: wardrobe,
        pairScore: (a, b, c, d) => 0.4,
        toPercentile: (raw) => raw,
      );
      final kemeja = out.firstWhere((o) => o.id == '2-3');
      expect(kemeja.formality, 'semi_formal');
      final kaos = out.firstWhere((o) => o.id == '1-3');
      expect(kaos.formality, 'non_formal');
    });

    test('limit memotong hasil dan urutan memakai skor mentah', () {
      final out = buildOutfits(
        wardrobe: wardrobe,
        pairScore: (ta, ca, tb, cb) => ta == 'shirt' ? 0.9 : 0.3,
        toPercentile: (raw) => 0.1,
        limit: 1,
      );
      expect(out.length, 1);
      expect(out.first.id, '2-3');
    });

    test('tiga alasan dalam urutan warna, formalitas, skor', () {
      final out = buildOutfits(
        wardrobe: wardrobe,
        pairScore: (a, b, c, d) => 0.4,
        toPercentile: (raw) => 0.87,
      );
      expect(out.first.reasons.length, 3);
      expect(out.first.reasons.last, contains('87%'));
    });

    test('lemari tanpa bawahan tidak menghasilkan outfit', () {
      final out = buildOutfits(
        wardrobe: [wardrobe[0]],
        pairScore: (a, b, c, d) => 0.4,
        toPercentile: (raw) => raw,
      );
      expect(out, isEmpty);
    });
  });

  group('rekomendasi per piece', () {
    final wardrobe = [
      _g(1, 't_shirt', 'top', 'black', 'non_formal'),
      _g(2, 'pants', 'bottom', 'blue', 'semi_formal'),
      _g(3, 'shorts', 'bottom', 'white', 'non_formal'),
      _g(4, 'skirt', 'bottom', 'red', 'semi_formal'),
      _g(5, 'shoes', 'shoes', 'white', 'non_formal'),
    ];

    test('setiap atasan dan bawahan mendapat maksimal tiga outfit', () {
      final groups = buildRecommendationGroups(
        wardrobe: wardrobe,
        pairScore: (a, b, c, d) => 0.4,
        toPercentile: (raw) => raw,
      );

      expect(groups.length, 4);
      expect(groups.first.anchor.id, '1');
      expect(groups.first.outfits.length, 3);
      expect(groups[1].anchor.id, '2');
      expect(groups[1].outfits.single.id, '1-2');
    });

    test('skor pasangan menentukan urutan tiga outfit', () {
      final groups = buildRecommendationGroups(
        wardrobe: wardrobe,
        pairScore: (ta, ca, tb, cb) {
          if (tb == 'pants') return 0.9;
          if (tb == 'shorts') return 0.7;
          return 0.5;
        },
        toPercentile: (raw) => raw,
      );

      final top = groups.firstWhere((g) => g.anchor.id == '1');
      expect(top.outfits.map((o) => o.bottom.id).toList(), ['2', '3', '4']);
    });

    test('outfit yang sudah tersimpan bisa dikenali', () {
      final outfit = Outfit(
        id: '1-2',
        title: 'Hitam + Biru',
        subtitle: 'Semi formal',
        top: wardrobe[0],
        bottom: wardrobe[1],
        score: 0.8,
        reasons: const [],
      );
      final saved = SavedOutfit(
        id: 1,
        name: 'Hitam + Biru',
        formality: 'semi_formal',
        score: 0.8,
        createdAt: DateTime(2026),
        items: [wardrobe[1], wardrobe[0]],
      );

      expect(isOutfitSaved(outfit, [saved]), isTrue);
      expect(isOutfitSaved(outfit, const []), isFalse);
    });
  });

  group('buildRuleOutfits (fallback E7.5)', () {
    final wardrobe = [
      _g(1, 't_shirt', 'top', 'black', 'non_formal'),
      _g(2, 'pants', 'bottom', 'white', 'semi_formal'),
      _g(3, 'shoes', 'shoes', 'white', 'non_formal'),
    ];

    test('menghasilkan outfit tanpa bantuan model', () {
      final out = buildRuleOutfits(wardrobe: wardrobe);
      expect(out, isNotEmpty);
      expect(out.first.id, '1-2');
      expect(out.first.score, inInclusiveRange(0, 1));
      expect(out.first.reasons.length, 3);
      expect(out.first.reasons.last, contains('aturan harmoni'));
    });

    test('lemari tanpa atasan atau bawahan menghasilkan daftar kosong', () {
      expect(buildRuleOutfits(wardrobe: [wardrobe[0]]), isEmpty);
      expect(buildRuleOutfits(wardrobe: [wardrobe[1]]), isEmpty);
    });
  });
}
