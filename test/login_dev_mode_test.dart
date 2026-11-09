import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/screens/auth/login_screen.dart';

/// Regresi: layar login dulu melempar [core/no-app] saat dibuat tanpa Firebase,
/// sehingga pengguna tidak bisa masuk sama sekali. Sekarang layar harus tetap
/// tampil dan menawarkan mode uji.
void main() {
  testWidgets(
    'login menampilkan pintu masuk mode uji saat Firebase belum ada',
    (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginScreen())),
      );
      await tester.pump();

      expect(find.text('MODE UJI TANPA FIREBASE'), findsOneWidget);
      expect(find.text('Masuk tanpa akun'), findsOneWidget);
    },
  );
}
