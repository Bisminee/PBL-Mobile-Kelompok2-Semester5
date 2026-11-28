import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/models/garment.dart';
import 'package:sera_z/screens/wardrobe/clothing_detail_screen.dart';
import 'package:sera_z/widgets/common/pill_chip.dart';

const _garment = Garment(
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

Future<void> _openEdit(WidgetTester tester) async {
  await tester.pumpWidget(
    const ProviderScope(
      child: MaterialApp(home: ClothingDetailScreen(garment: _garment)),
    ),
  );
  await tester.pumpAndSettle();

  await tester.tap(find.byIcon(Icons.edit_outlined));
  await tester.pumpAndSettle();
}

PillChip _chip(WidgetTester tester, String label) => tester
    .widgetList<PillChip>(find.byType(PillChip))
    .firstWhere((chip) => chip.label == label);

void main() {
  testWidgets('tombol pensil membuka form edit atribut', (tester) async {
    await _openEdit(tester);

    expect(find.text('Edit Pakaian'), findsOneWidget);
    expect(find.text('Jenis pakaian'), findsOneWidget);
    expect(find.text('Warna'), findsAtLeastNWidgets(1));
    expect(find.text('Simpan'), findsOneWidget);
  });

  testWidgets('form edit memakai chip dengan pilihan aktif', (tester) async {
    await _openEdit(tester);

    expect(_chip(tester, 'Kaos').selected, isTrue);
    expect(_chip(tester, 'Hitam').selected, isTrue);
    expect(_chip(tester, 'Non formal').selected, isTrue);
    expect(_chip(tester, 'Casual').selected, isTrue);

    await tester.tap(find.text('Polo'));
    await tester.pumpAndSettle();

    expect(_chip(tester, 'Polo').selected, isTrue);
    expect(_chip(tester, 'Kaos').selected, isFalse);
  });

  testWidgets('form edit tidak overflow di layar 320 px', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _openEdit(tester);

    expect(tester.takeException(), isNull);
  });
}
