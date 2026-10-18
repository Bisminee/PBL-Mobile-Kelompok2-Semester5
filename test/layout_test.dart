import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sera_z/main.dart';
import 'package:sera_z/screens/detail_screen.dart';
import 'package:sera_z/screens/home_screen.dart';
import 'package:sera_z/screens/login_screen.dart';
import 'package:sera_z/screens/recommendation_screen.dart';
import 'package:sera_z/screens/signup_screen.dart';
import 'package:sera_z/screens/wardrobe_screen.dart';

/// Ukuran layar uji: ponsel kecil, ponsel umum, layar pendek, dan jendela web.
const _sizes = <String, Size>{
  'kecil 360x640': Size(360, 640),
  'pendek 360x520': Size(360, 520),
  'ponsel 412x915': Size(412, 915),
  'web pendek 800x520': Size(800, 520),
};

Future<void> _setSize(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

Widget _page(Widget child) =>
    ProviderScope(child: MaterialApp(home: Scaffold(body: child)));

/// Router pada app bersifat global, jadi posisi bisa berbeda antar test.
/// Helper ini memastikan kita berakhir di halaman Lemari.
Future<void> _openWardrobe(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: SeraZApp()));
  await tester.pumpAndSettle();

  final loginButton = find.widgetWithText(FilledButton, 'Login');
  if (loginButton.evaluate().isNotEmpty) {
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
  }

  final lemari = find.text('Lemari');
  if (lemari.evaluate().isNotEmpty) {
    await tester.tap(lemari.last);
    await tester.pumpAndSettle();
  }
}

void main() {
  for (final entry in _sizes.entries) {
    final size = entry.value;
    final label = entry.key;

    testWidgets('Wardrobe tidak overflow ($label)', (tester) async {
      await _setSize(tester, size);
      await tester.pumpWidget(_page(const WardrobeScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Home tidak overflow ($label)', (tester) async {
      await _setSize(tester, size);
      await tester.pumpWidget(_page(const HomeScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Rekomendasi tidak overflow ($label)', (tester) async {
      await _setSize(tester, size);
      await tester.pumpWidget(_page(const RecommendationScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Detail tidak overflow ($label)', (tester) async {
      await _setSize(tester, size);
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const DetailScreen())),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Login tidak overflow ($label)', (tester) async {
      await _setSize(tester, size);
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const LoginScreen())),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Sign up tidak overflow ($label)', (tester) async {
      await _setSize(tester, size);
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const SignUpScreen())),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Shell + bottom nav tidak overflow (ponsel)', (tester) async {
    await _setSize(tester, const Size(412, 915));
    await _openWardrobe(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Shell + bottom nav tidak overflow (jendela pendek)',
      (tester) async {
    await _setSize(tester, const Size(800, 520));
    await _openWardrobe(tester);
    expect(tester.takeException(), isNull);
  });
}
