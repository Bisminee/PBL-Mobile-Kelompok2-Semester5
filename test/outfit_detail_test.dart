import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/models/garment.dart';
import 'package:sera_z/models/garment_labels.dart';
import 'package:sera_z/models/outfit.dart';
import 'package:sera_z/screens/outfit/detail_screen.dart';
import 'package:sera_z/services/outfit_detail.dart';
import 'package:sera_z/services/providers.dart';

Garment _g(
  int id,
  String type,
  String slot,
  String color, {
  String formality = 'non_formal',
  String? style,
  double? conf,
}) => Garment.fromRow({
  'id': id,
  'garment_type': type,
  'slot': slot,
  'color_family': color,
  'formality': formality,
  'style': style,
  'detection_conf': conf,
});

final _top = _g(1, 't_shirt', 'top', 'black', style: 'casual', conf: 0.87);
final _bottom = _g(2, 'pants', 'bottom', 'blue', formality: 'semi_formal');
final _wardrobe = [
  _top,
  _bottom,
  _g(3, 'shirt', 'top', 'white', formality: 'formal'),
  _g(4, 't_shirt', 'top', 'red'),
  _g(5, 'shorts', 'bottom', 'beige'),
  _g(6, 'shoes', 'shoes', 'white'),
];

final _outfit = Outfit(
  id: '1-2',
  title: 'Hitam + Biru',
  subtitle: 'Non formal',
  top: _top,
  bottom: _bottom,
  score: 0.8,
  formality: 'non_formal',
  reasons: const [
    'Neutral: Warna netral dipadukan dengan warna berwarna.',
    'Formalitas berbeda.',
    'Skor pasangan lebih tinggi dari 80% kombinasi.',
  ],
);

class _FakeWardrobe extends WardrobeNotifier {
  @override
  List<Garment> build() => _wardrobe;
}

void main() {
  group('hexOf', () {
    test('format #RRGGBB huruf besar', () {
      expect(hexOf(const Color(0xFF1A2B3C)), '#1A2B3C');
      expect(hexOf(const Color(0xFF000000)), '#000000');
      expect(hexOf(const Color(0xFFFFFFFF)), '#FFFFFF');
    });
  });

  group('wardrobeAlternatives', () {
    test('hanya slot yang diminta, tanpa item outfit sendiri', () {
      final tops = wardrobeAlternatives(
        wardrobe: _wardrobe,
        outfit: _outfit,
        slot: 'top',
      );
      expect(tops.map((a) => a.garment.id), unorderedEquals(['3', '4']));

      final bottoms = wardrobeAlternatives(
        wardrobe: _wardrobe,
        outfit: _outfit,
        slot: 'bottom',
      );
      expect(bottoms.map((a) => a.garment.id), ['5']);
    });

    test('diurut menurun berdasarkan skor harmoni', () {
      final tops = wardrobeAlternatives(
        wardrobe: _wardrobe,
        outfit: _outfit,
        slot: 'top',
      );
      for (var i = 1; i < tops.length; i++) {
        expect(
          tops[i - 1].harmony.score,
          greaterThanOrEqualTo(tops[i].harmony.score),
        );
      }
    });

    test('limit dihormati dan lemari kosong aman', () {
      expect(
        wardrobeAlternatives(
          wardrobe: _wardrobe,
          outfit: _outfit,
          slot: 'top',
          limit: 1,
        ),
        hasLength(1),
      );
      expect(
        wardrobeAlternatives(wardrobe: const [], outfit: _outfit, slot: 'top'),
        isEmpty,
      );
    });
  });

  group('styleSummary dan confidenceText', () {
    test('styleSummary', () {
      expect(styleSummary(null, null, styleLabel), '-');
      expect(styleSummary('casual', null, styleLabel), styleLabel('casual'));
      expect(
        styleSummary('casual', 'casual', styleLabel),
        styleLabel('casual'),
      );
      expect(
        styleSummary('casual', 'minimalist', styleLabel),
        '${styleLabel('casual')} + ${styleLabel('minimalist')}',
      );
    });

    test('confidenceText', () {
      expect(confidenceText(null), isNull);
      expect(confidenceText(0.874), '87%');
    });
  });

  group('DetailScreen', () {
    Future<void> pump(WidgetTester tester) async {
      // Lebar 360 dp (HP kecil); tinggi dibuat besar agar seluruh isi tab
      // terbangun tanpa perlu menggulir.
      tester.view.physicalSize = const Size(1080, 7200);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [wardrobeProvider.overrideWith(_FakeWardrobe.new)],
          child: MaterialApp(home: DetailScreen(outfit: _outfit)),
        ),
      );
      await tester.pump();
    }

    testWidgets('tab Warna tampil lebih dulu dengan data warna item', (
      tester,
    ) async {
      await pump(tester);
      expect(find.text('Warna'), findsOneWidget);
      expect(find.text('Styling'), findsOneWidget);
      expect(find.text('Lemari'), findsOneWidget);
      expect(find.text('Warna per item'), findsOneWidget);
      expect(find.text(hexOf(_top.colorValue)), findsOneWidget);
      expect(find.text(hexOf(_bottom.colorValue)), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('tab Styling menampilkan formalitas dan alasan', (
      tester,
    ) async {
      await pump(tester);
      await tester.tap(find.text('Styling'));
      await tester.pumpAndSettle();
      expect(find.text('Formalitas bawahan'), findsOneWidget);
      expect(find.text(formalityLabel('semi_formal')), findsOneWidget);
      expect(find.text('Kenapa cocok'), findsOneWidget);
      expect(find.text(_outfit.reasons[1]), findsOneWidget);
      // Engine belum termuat di test, jadi saran pelengkap kosong.
      expect(find.text('Belum ada saran untuk kombinasi ini.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('tab Lemari menampilkan item dan alternatif dari lemari', (
      tester,
    ) async {
      await pump(tester);
      await tester.tap(find.text('Lemari'));
      await tester.pumpAndSettle();
      expect(find.text(_top.title), findsOneWidget);
      expect(find.textContaining('yakin 87%'), findsOneWidget);
      expect(find.text('Alternatif dari lemarimu'), findsOneWidget);
      expect(find.textContaining('Ganti atasan'), findsNWidgets(2));
      expect(find.textContaining('Ganti bawahan'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
