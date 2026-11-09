import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/widgets/scan/camera_controls.dart';

void main() {
  Future<void> pumpControls(
    WidgetTester tester, {
    required VoidCallback onGallery,
    VoidCallback? onCapture,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CameraControls(
            canCapture: true,
            canSwitch: true,
            onCapture: onCapture ?? () {},
            onSwitch: () {},
            onGallery: onGallery,
          ),
        ),
      ),
    );
  }

  testWidgets('tombol kiri membuka galeri', (tester) async {
    var opened = 0;
    await pumpControls(tester, onGallery: () => opened++);

    await tester.tap(find.byIcon(Icons.photo_library_outlined));
    await tester.pump();

    expect(opened, 1);
  });

  testWidgets('tombol kiri memakai ikon galeri, bukan ikon lama', (
    tester,
  ) async {
    await pumpControls(tester, onGallery: () {});

    expect(find.byIcon(Icons.photo_library_outlined), findsOneWidget);
    expect(find.byIcon(Icons.dry_cleaning_outlined), findsNothing);
  });

  testWidgets('tombol kiri punya label aksesibilitas', (tester) async {
    await pumpControls(tester, onGallery: () {});

    expect(find.bySemanticsLabel('Buka galeri'), findsOneWidget);
  });

  testWidgets('shutter tetap memanggil aksi kamera', (tester) async {
    var captured = 0;
    await pumpControls(tester, onGallery: () {}, onCapture: () => captured++);

    await tester.tap(find.bySemanticsLabel('Take picture'));
    await tester.pump();

    expect(captured, 1);
  });
}
