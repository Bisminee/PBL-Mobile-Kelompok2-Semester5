import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/models/garment.dart';
import 'package:sera_z/models/saved_outfit.dart';
import 'package:sera_z/screens/outfit/saved_outfits_screen.dart';
import 'package:sera_z/services/providers.dart';

Garment _g(int id, String type, String slot, String color) => Garment.fromRow({
  'id': id,
  'garment_type': type,
  'slot': slot,
  'color_family': color,
  'formality': 'non_formal',
});

void main() {
  testWidgets('menu ubah nama dan hapus bisa dibuka dari kartu outfit', (
    tester,
  ) async {
    final outfit = SavedOutfit(
      id: 1,
      name: 'Kaos Hitam + Celana Biru',
      formality: 'non_formal',
      score: 0.8,
      createdAt: DateTime(2026, 11, 1),
      items: [
        _g(1, 't_shirt', 'top', 'black'),
        _g(2, 'pants', 'bottom', 'blue'),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          savedOutfitsProvider.overrideWith((ref) async => [outfit]),
        ],
        child: const MaterialApp(home: SavedOutfitsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    expect(find.text('Ubah nama'), findsOneWidget);
    expect(find.text('Hapus'), findsOneWidget);

    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();
    expect(find.text('Hapus outfit ini?'), findsOneWidget);
  });
}
