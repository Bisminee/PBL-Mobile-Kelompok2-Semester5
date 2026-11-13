import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/models/garment.dart';
import 'package:sera_z/widgets/outfit/outfit_compact_card.dart';

Garment _g(int id, String type, String slot) => Garment.fromRow({
  'id': id,
  'garment_type': type,
  'slot': slot,
  'color_family': 'black',
  'formality': 'non_formal',
});

void main() {
  Future<void> pumpCard(
    WidgetTester tester, {
    int? rank,
    VoidCallback? onTap,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: OutfitCompactCard(
              title: 'Hitam + Hitam',
              score: 85,
              rank: rank,
              items: 'Kaos \u00b7 Celana',
              description: 'Deskripsi singkat',
              reasons: const ['Alasan warna', 'Alasan formalitas'],
              tags: const ['Non Formal'],
              top: _g(1, 't_shirt', 'top'),
              bottom: _g(2, 'pants', 'bottom'),
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('menampilkan peringkat dan skor', (tester) async {
    await pumpCard(tester, rank: 2);

    expect(find.text('#2 \u00b7 85% MATCH'), findsOneWidget);
  });

  testWidgets('tanpa peringkat hanya menampilkan skor', (tester) async {
    await pumpCard(tester);

    expect(find.text('85% MATCH'), findsOneWidget);
  });

  testWidgets('alasan tersembunyi sampai Kenapa cocok dibuka', (tester) async {
    await pumpCard(tester);
    expect(find.textContaining('Alasan warna'), findsNothing);

    await tester.tap(find.text('Kenapa cocok?'));
    await tester.pump();

    expect(find.text('\u2022 Alasan warna'), findsOneWidget);
    expect(find.text('\u2022 Alasan formalitas'), findsOneWidget);

    await tester.tap(find.text('Kenapa cocok?'));
    await tester.pump();

    expect(find.textContaining('Alasan warna'), findsNothing);
  });

  testWidgets('membuka alasan tidak memicu onTap kartu', (tester) async {
    var dibuka = 0;
    await pumpCard(tester, onTap: () => dibuka++);

    await tester.tap(find.text('Kenapa cocok?'));
    await tester.pump();

    expect(dibuka, 0);
  });
}
