import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sera_z/main.dart';

void main() {
  testWidgets('App starts on the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: SeraZApp()));

    expect(find.text('Hello!'), findsOneWidget);
    expect(find.text('Welcome to Sera-Z'), findsOneWidget);
    expect(find.text('Login'), findsWidgets);
  });

  testWidgets('Login navigates to Home', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: SeraZApp()));

    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Rekomendasi terbaru'), findsOneWidget);
    expect(find.text('Bisma Adhiaksa'), findsOneWidget);
  });
}
