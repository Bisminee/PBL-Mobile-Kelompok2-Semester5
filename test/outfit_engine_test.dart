import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:sera_z/services/garment_classifier.dart';
import 'package:sera_z/services/local_db.dart';
import 'package:sera_z/services/outfit_engine.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _FakeClassifier implements GarmentClassifier {
  _FakeClassifier(this.predictions);

  final List<Prediction> predictions;

  @override
  List<String> get labels => predictions.map((p) => p.label).toList();

  @override
  List<Prediction> predictInput(Float32List input, {int k = 3}) =>
      predictions.take(k).toList();

  @override
  void close() {}
}

Uint8List _solidBlackPng() {
  final image = img.Image(width: 16, height: 16);
  return Uint8List.fromList(img.encodePng(image));
}

Future<Database> _createTestDb() async {
  final db = await databaseFactoryFfi.openDatabase(
    inMemoryDatabasePath,
    options: OpenDatabaseOptions(singleInstance: false),
  );
  await db.execute(
    'CREATE TABLE ref_garment_type ('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'name TEXT NOT NULL, garment_type TEXT UNIQUE, slot TEXT NOT NULL)',
  );
  await db.execute(
    'CREATE TABLE ml_pair_score ('
    'type_a TEXT, color_a TEXT, type_b TEXT, color_b TEXT, score REAL)',
  );
  await db.execute(
    'CREATE TABLE ml_formality ('
    'garment_type TEXT, color_family TEXT, gender TEXT, age_group TEXT, '
    'pred TEXT, p_non_formal REAL, p_semi_formal REAL, p_formal REAL)',
  );
  await db.execute(
    'CREATE TABLE ml_style ('
    'garment_type TEXT, color_family TEXT, gender TEXT, age_group TEXT, '
    'style TEXT, prob REAL)',
  );
  await db.execute(
    'CREATE TABLE wardrobe_item ('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'image_path TEXT, garment_type TEXT, slot TEXT, color_family TEXT, '
    'color_hex TEXT, detection_conf REAL, formality TEXT, style TEXT)',
  );
  await db.execute(
    'CREATE TABLE catalog_item ('
    'garment_type TEXT, color_family TEXT, slot TEXT, '
    'formality TEXT, gender TEXT, age_group TEXT)',
  );

  await db.insert('ref_garment_type', {
    'name': 't_shirt',
    'garment_type': 't_shirt',
    'slot': 'top',
  });
  await db.insert('ref_garment_type', {
    'name': 'shirt',
    'garment_type': 'shirt',
    'slot': 'top',
  });
  await db.insert('ref_garment_type', {
    'name': 'pants',
    'garment_type': 'pants',
    'slot': 'bottom',
  });
  await db.insert('ref_garment_type', {
    'name': 'shoes',
    'garment_type': 'shoes',
    'slot': 'shoes',
  });

  // 4 skor pasangan atasan-bawahan (0.30, 0.35, 0.40, 0.45) + 1 skor non-bawahan (0.99)
  await db.insert('ml_pair_score', {
    'type_a': 't_shirt',
    'color_a': 'black',
    'type_b': 'pants',
    'color_b': 'blue',
    'score': 0.30,
  });
  await db.insert('ml_pair_score', {
    'type_a': 't_shirt',
    'color_a': 'black',
    'type_b': 'pants',
    'color_b': 'black',
    'score': 0.35,
  });
  await db.insert('ml_pair_score', {
    'type_a': 'shirt',
    'color_a': 'black',
    'type_b': 'pants',
    'color_b': 'gray',
    'score': 0.40,
  });
  await db.insert('ml_pair_score', {
    'type_a': 'shirt',
    'color_a': 'white',
    'type_b': 'pants',
    'color_b': 'black',
    'score': 0.45,
  });
  await db.insert('ml_pair_score', {
    'type_a': 't_shirt',
    'color_a': 'black',
    'type_b': 'shoes',
    'color_b': 'white',
    'score': 0.99,
  });

  await db.insert('ml_formality', {
    'garment_type': 't_shirt',
    'color_family': 'black',
    'gender': 'male',
    'age_group': 'adult',
    'pred': 'non_formal',
    'p_non_formal': 0.9,
    'p_semi_formal': 0.08,
    'p_formal': 0.02,
  });
  await db.insert('ml_formality', {
    'garment_type': 'shirt',
    'color_family': 'black',
    'gender': 'male',
    'age_group': 'adult',
    'pred': 'formal',
    'p_non_formal': 0.05,
    'p_semi_formal': 0.25,
    'p_formal': 0.70,
  });

  for (final entry in [
    ('casual', 0.6),
    ('minimalist', 0.25),
    ('streetwear', 0.1),
    ('sporty', 0.05),
  ]) {
    await db.insert('ml_style', {
      'garment_type': 't_shirt',
      'color_family': 'black',
      'gender': 'male',
      'age_group': 'adult',
      'style': entry.$1,
      'prob': entry.$2,
    });
  }
  await db.insert('ml_style', {
    'garment_type': 'shirt',
    'color_family': 'black',
    'gender': 'male',
    'age_group': 'adult',
    'style': 'elegant',
    'prob': 0.8,
  });

  return db;
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
  });

  group('Detection model', () {
    test(
      'isConfident aktif hanya saat confidence >= 0.97 dan bukan manual',
      () {
        const high = Detection(
          type: 't_shirt',
          slot: 'top',
          color: 'black',
          colorHex: '#000000',
          formality: 'non_formal',
          confidence: confidentThreshold,
          alternatives: [],
          styles: [
            {'style': 'casual', 'prob': 0.8},
          ],
          colorShare: {'black': 1.0},
        );
        expect(high.isConfident, isTrue);
        expect(high.topStyle, 'casual');

        final low = Detection(
          type: 't_shirt',
          slot: 'top',
          color: 'black',
          colorHex: '#000000',
          formality: 'non_formal',
          confidence: 0.969,
          alternatives: const [],
          styles: const [],
          colorShare: const {'black': 1.0},
        );
        expect(low.isConfident, isFalse);
        expect(low.topStyle, isNull);

        final corrected = high.copyWith(type: 'shirt', manual: true);
        expect(corrected.isConfident, isFalse);
        expect(corrected.type, 'shirt');
      },
    );

    test('isRecognized memakai ambang 70 persen', () {
      Detection detection(double confidence, {bool manual = false}) =>
          Detection(
            type: 't_shirt',
            slot: 'top',
            color: 'black',
            colorHex: '#000000',
            formality: 'non_formal',
            confidence: confidence,
            alternatives: const [],
            styles: const [],
            colorShare: const {'black': 1.0},
            manual: manual,
          );

      expect(detection(0.699).isRecognized, isFalse);
      expect(detection(0.70).isRecognized, isTrue);
      expect(detection(0.10, manual: true).isRecognized, isTrue);
    });
  });

  group('Slot & formalitas outfit', () {
    late Database db;
    late OutfitEngine engine;

    setUp(() async {
      db = await _createTestDb();
      engine = OutfitEngine(
        _FakeClassifier(const []),
        LocalDb.withDatabase(db),
      );
    });

    tearDown(() async => db.close());

    test('missingSlots mengembalikan slot wajib lalu opsional', () {
      expect(engine.missingSlots(const []), [
        'top',
        'bottom',
        'shoes',
        'outer',
        'bag',
      ]);
      expect(
        engine.missingSlots([
          {'slot': 'top'},
          {'slot': 'shoes'},
        ]),
        ['bottom', 'outer', 'bag'],
      );
    });

    test('missingSlots pada dress (onepiece) tidak meminta top dan bottom', () {
      expect(
        engine.missingSlots([
          {'slot': 'onepiece'},
        ]),
        ['shoes', 'outer', 'bag'],
      );
    });

    test('outfitFormality mengikuti item inti paling santai', () {
      final formalWithSandals = [
        {'slot': 'top', 'formality': 'formal'},
        {'slot': 'bottom', 'formality': 'formal'},
        {'slot': 'shoes', 'formality': 'non_formal'},
      ];
      expect(engine.outfitFormality(formalWithSandals), 'non_formal');

      final formalCoreCasualBag = [
        {'slot': 'top', 'formality': 'formal'},
        {'slot': 'bottom', 'formality': 'semi_formal'},
        {'slot': 'shoes', 'formality': 'formal'},
        {'slot': 'bag', 'formality': 'non_formal'},
      ];
      expect(engine.outfitFormality(formalCoreCasualBag), 'semi_formal');
    });
  });

  group('Skor pasangan & persentil', () {
    late Database db;
    late OutfitEngine engine;

    setUp(() async {
      db = await _createTestDb();
      engine = OutfitEngine(
        _FakeClassifier(const []),
        LocalDb.withDatabase(db),
      );
    });

    tearDown(() async => db.close());

    test('sebelum preload, topBottomPercentile mengembalikan skor mentah', () {
      expect(engine.pairScore('t_shirt', 'black', 'pants', 'blue'), isNull);
      expect(engine.topBottomPercentile(0.42), 0.42);
    });

    test(
      'setelah preload, pairScore dan persentil top-bottom akurat',
      () async {
        await engine.preload();

        expect(engine.pairScore('t_shirt', 'black', 'pants', 'blue'), 0.30);
        expect(engine.pairScore('shirt', 'white', 'pants', 'black'), 0.45);
        expect(engine.pairScore('dress', 'red', 'shoes', 'black'), isNull);

        // Hanya 4 pasangan top-bottom yang dihitung (0.30, 0.35, 0.40, 0.45);
        // skor 0.99 (top-shoes) tidak ikut menggeser persentil.
        expect(engine.topBottomPercentile(0.30), closeTo(0.25, 1e-9));
        expect(engine.topBottomPercentile(0.40), closeTo(0.75, 1e-9));
        expect(engine.topBottomPercentile(0.45), closeTo(1.00, 1e-9));
      },
    );
  });

  group('Analisis gambar, koreksi tipe, & rekomendasi', () {
    late Database db;
    late OutfitEngine engine;

    setUp(() async {
      db = await _createTestDb();
      final classifier = _FakeClassifier(const [
        Prediction('t_shirt', 0.98),
        Prediction('shirt', 0.015),
        Prediction('polo', 0.005),
      ]);
      engine = OutfitEngine(classifier, LocalDb.withDatabase(db));
    });

    tearDown(() async => db.close());

    test('analyze melempar StateError untuk byte gambar tidak valid', () async {
      expect(
        () => engine.analyze(Uint8List.fromList([1, 2, 3]), gender: 'male'),
        throwsStateError,
      );
    });

    test('analyze & withType menghitung ulang formalitas dan style', () async {
      final detected = await engine.analyze(_solidBlackPng(), gender: 'male');
      expect(detected.type, 't_shirt');
      expect(detected.slot, 'top');
      expect(detected.color, 'black');
      expect(detected.formality, 'non_formal');
      expect(detected.isConfident, isTrue);
      expect(detected.styles.length, 3);
      expect(detected.topStyle, 'casual');

      final corrected = await engine.withType(
        detected,
        'shirt',
        gender: 'male',
      );
      expect(corrected.type, 'shirt');
      expect(corrected.slot, 'top');
      expect(corrected.color, 'black');
      expect(corrected.formality, 'formal');
      expect(corrected.topStyle, 'elegant');
      expect(corrected.manual, isTrue);
      expect(corrected.isConfident, isFalse);
    });

    test('recommend mengembalikan saran untuk slot kosong', () async {
      final topId = await db.insert('wardrobe_item', {
        'image_path': '/tmp/kaos.jpg',
        'garment_type': 't_shirt',
        'slot': 'top',
        'color_family': 'black',
        'detection_conf': 0.98,
        'formality': 'non_formal',
      });
      await db.insert('catalog_item', {
        'garment_type': 'pants',
        'color_family': 'blue',
        'slot': 'bottom',
        'formality': 'non_formal',
        'gender': 'male',
        'age_group': 'adult',
      });

      final recs = await engine.recommend(
        [
          {'id': topId, 'slot': 'top', 'formality': 'non_formal'},
        ],
        targetFormality: 'non_formal',
        gender: 'male',
      );

      expect(recs.keys, containsAll(['bottom', 'shoes', 'outer', 'bag']));
      expect(recs['bottom'], hasLength(1));
      expect(recs['bottom']!.first['garment_type'], 'pants');
      expect(recs['bottom']!.first['color_family'], 'blue');
    });
  });
}
