import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/widgets/scan/camera_overlay.dart';

void main() {
  Future<void> pumpOverlay(
    WidgetTester tester, {
    required FlashMode mode,
    required VoidCallback onFlash,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CameraOverlay(
            onClose: () {},
            flashMode: mode,
            onFlash: onFlash,
          ),
        ),
      ),
    );
  }

  testWidgets('tombol flash memanggil aksi dan menunjukkan mode', (
    tester,
  ) async {
    var pressed = 0;
    await pumpOverlay(tester, mode: FlashMode.off, onFlash: () => pressed++);

    expect(find.byIcon(Icons.flash_off), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Nyalakan flash otomatis'));
    await tester.pump();
    expect(pressed, 1);
  });

  testWidgets('mode flash otomatis memakai ikon flash auto', (tester) async {
    await pumpOverlay(tester, mode: FlashMode.auto, onFlash: () {});
    expect(find.byIcon(Icons.flash_auto), findsOneWidget);
    expect(find.bySemanticsLabel('Nyalakan flash terus'), findsOneWidget);
  });
}
