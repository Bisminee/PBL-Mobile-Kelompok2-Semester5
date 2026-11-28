import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/screens/scan/camera_screen.dart';
import 'package:sera_z/services/camera_error.dart';
import 'package:sera_z/services/camera_service.dart';
import 'package:sera_z/widgets/scan/camera_error_panel.dart';

void main() {
  group('describeCameraError', () {
    test('izin ditolak memakai pesan Indonesia dan menandai pengaturan', () {
      for (final code in [
        'CameraAccessDenied',
        'CameraAccessDeniedWithoutPrompt',
      ]) {
        final info = describeCameraError(CameraException(code, 'denied'));

        expect(info.permissionDenied, isTrue);
        expect(info.message, contains('Izin kamera ditolak'));
        expect(info.message, isNot(contains('denied')));
      }
    });

    test('akses kamera dibatasi memakai pesan Indonesia', () {
      final info = describeCameraError(
        CameraException('CameraAccessRestricted', 'restricted'),
      );

      expect(info.permissionDenied, isFalse);
      expect(info.message, contains('dibatasi'));
    });

    test('error lain tidak membocorkan deskripsi berbahasa Inggris', () {
      final info = describeCameraError(
        CameraException('CameraInitializationError', 'Something failed'),
      );

      expect(info.permissionDenied, isFalse);
      expect(info.message, 'Kamera tidak bisa digunakan. Coba muat ulang.');
      expect(info.message, isNot(contains('Something failed')));
    });
  });

  group('CameraErrorPanel', () {
    Future<void> pump(
      WidgetTester tester, {
      required bool showSettings,
      VoidCallback? onOpenSettings,
      VoidCallback? onRefresh,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.black,
            body: CameraErrorPanel(
              message: 'Izin kamera ditolak.',
              showSettings: showSettings,
              onOpenSettings: onOpenSettings,
              onRefresh: onRefresh,
            ),
          ),
        ),
      );
    }

    testWidgets('menampilkan tombol Buka Pengaturan saat izin ditolak', (
      tester,
    ) async {
      var opened = 0;
      await pump(
        tester,
        showSettings: true,
        onOpenSettings: () => opened++,
        onRefresh: () {},
      );

      expect(find.text('Buka Pengaturan'), findsOneWidget);
      await tester.tap(find.text('Buka Pengaturan'));
      await tester.pump();

      expect(opened, 1);
    });

    testWidgets('tidak menampilkan Buka Pengaturan untuk error lain', (
      tester,
    ) async {
      await pump(tester, showSettings: false, onRefresh: () {});

      expect(find.text('Buka Pengaturan'), findsNothing);
      expect(find.text('Muat Ulang'), findsOneWidget);
    });

    testWidgets('tidak overflow di layar 320 px', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pump(
        tester,
        showSettings: true,
        onOpenSettings: () {},
        onRefresh: () {},
      );

      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('layar kamera tanpa kamera memakai pesan Indonesia', (
    tester,
  ) async {
    CameraService.cameras = [];
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: CameraScreen())),
    );
    await tester.pump();

    expect(
      find.text('Kamera tidak ditemukan di perangkat ini.'),
      findsOneWidget,
    );
    expect(find.textContaining('No camera'), findsNothing);
    expect(find.text('Buka Pengaturan'), findsNothing);
    expect(find.text('Muat Ulang'), findsNothing);
  });
}
