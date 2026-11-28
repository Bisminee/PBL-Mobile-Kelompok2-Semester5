import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/widgets/common/pill_chip.dart';

void main() {
  testWidgets('chip panjang memendek tanpa overflow di layar 320 px', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(24),
            child: Wrap(children: [PillChip(label: 'Kaos lengan panjang')]),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('chip tetap jalan di daftar horizontal', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [PillChip(label: 'Kaos lengan panjang')],
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Kaos lengan panjang'), findsOneWidget);
  });
}
