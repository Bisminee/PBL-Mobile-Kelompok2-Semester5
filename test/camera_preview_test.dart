import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:sera_z/models/scan_source.dart';
import 'package:sera_z/screens/scan/camera_preview_screen.dart';

void main() {
  late Directory tempDir;
  late String photoPath;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('sera_z_preview_test');
    photoPath = p.join(tempDir.path, 'foto.png');
    final bytes = img.encodePng(img.Image(width: 8, height: 8));
    await File(photoPath).writeAsBytes(bytes);
  });

  tearDownAll(() async {
    await tempDir.delete(recursive: true);
  });

  Future<void> pumpPreview(WidgetTester tester, ScanSource source) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: CameraPreviewScreen(imagePath: photoPath, source: source),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('sumber galeri menampilkan tombol Pilih Ulang', (tester) async {
    await pumpPreview(tester, ScanSource.gallery);
    expect(find.text('Pilih Ulang'), findsOneWidget);
    expect(find.text('Ambil Ulang'), findsNothing);
    expect(find.text('Sesuaikan area'), findsOneWidget);
  });

  testWidgets('sumber kamera menampilkan tombol Ambil Ulang', (tester) async {
    await pumpPreview(tester, ScanSource.camera);
    expect(find.text('Ambil Ulang'), findsOneWidget);
    expect(find.text('Pilih Ulang'), findsNothing);
    expect(find.text('Sesuaikan area'), findsNothing);
  });

  testWidgets('kedua sumber menampilkan tombol Gunakan Foto', (tester) async {
    await pumpPreview(tester, ScanSource.gallery);
    expect(find.text('Gunakan Foto'), findsOneWidget);
  });
}
