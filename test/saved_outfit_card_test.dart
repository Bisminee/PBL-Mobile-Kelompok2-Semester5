import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/models/garment.dart';
import 'package:sera_z/models/saved_outfit.dart';
import 'package:sera_z/widgets/outfit/saved_outfit_card.dart';

void main() {
  const top = Garment(
    id: '1',
    category: 'Atasan',
    colorName: 'Hitam',
    colorValue: Color(0xFF1A1A1A),
    slot: 'top',
  );
  const bottom = Garment(
    id: '2',
    category: 'Bawahan',
    colorName: 'Biru',
    colorValue: Color(0xFF2F5D9E),
    slot: 'bottom',
  );

  testWidgets('kartu outfit bisa diketuk dan ditekan lama', (tester) async {
    var tapped = 0;
    var held = 0;
    final outfit = SavedOutfit(
      id: 1,
      name: 'Paduan',
      formality: 'non_formal',
      score: 0.9,
      createdAt: DateTime(2026, 11, 23),
      items: const [top, bottom],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SavedOutfitCard(
            outfit: outfit,
            onTap: () => tapped++,
            onLongPress: () => held++,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(SavedOutfitCard));
    await tester.pump();
    expect(tapped, 1);

    await tester.longPress(find.byType(SavedOutfitCard));
    await tester.pump();
    expect(held, 1);
  });
}
