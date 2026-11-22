import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/models/garment.dart';
import 'package:sera_z/screens/wardrobe/clothing_detail_screen.dart';

void main() {
  testWidgets('tombol pensil membuka form edit atribut', (tester) async {
    const garment = Garment(
      id: '1',
      category: 'Atasan',
      colorName: 'Hitam',
      colorValue: Color(0xFF1A1A1A),
      garmentType: 't_shirt',
      slot: 'top',
      colorFamily: 'black',
      formality: 'non_formal',
      style: 'casual',
    );

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: ClothingDetailScreen(garment: garment)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Edit Pakaian'), findsOneWidget);
    expect(find.text('Jenis pakaian'), findsOneWidget);
    expect(find.text('Warna'), findsAtLeastNWidgets(1));
    expect(find.text('Simpan'), findsOneWidget);
  });
}
