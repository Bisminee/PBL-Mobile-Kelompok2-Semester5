import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sera_z/main.dart';

void main() {
  testWidgets('App boots and shows the splash screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SeraZApp()));
    await tester.pump();

    expect(find.text('Sera-Z'), findsWidgets);
    expect(find.text('FASHION INTELLIGENCE'), findsOneWidget);

    // Lewati timer splash (2 detik) agar tidak ada timer tersisa saat tes
    // selesai, lalu pastikan navigasi ke onboarding berjalan tanpa error.
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
