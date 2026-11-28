import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/screens/scan/detection_result_screen.dart';
import 'package:sera_z/services/garment_classifier.dart';
import 'package:sera_z/services/outfit_engine.dart';
import 'package:sera_z/services/providers.dart';
import 'package:sera_z/widgets/common/pill_chip.dart';

class _FakeScanSession extends ScanSessionNotifier {
  _FakeScanSession(this.initial);

  final ScanSession initial;

  @override
  ScanSession build() => initial;
}

Detection _detection(String type) => Detection(
  type: type,
  slot: 'top',
  color: 'black',
  colorHex: '#1A1A1A',
  formality: 'non_formal',
  confidence: 0.99,
  alternatives: const [
    Prediction('t_shirt', 0.8),
    Prediction('shirt', 0.1),
    Prediction('longsleeve', 0.05),
  ],
  styles: const [
    {'style': 'casual', 'prob': 0.5},
  ],
  colorShare: const {'black': 1.0},
);

Future<void> _pump(WidgetTester tester, Detection detection) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        scanSessionProvider.overrideWith(
          () => _FakeScanSession(ScanSession(detection: detection)),
        ),
      ],
      child: const MaterialApp(home: DetectionResultScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

PillChip _chip(WidgetTester tester, String label) => tester
    .widgetList<PillChip>(find.byType(PillChip))
    .firstWhere((chip) => chip.label == label);

void main() {
  testWidgets('chip Lainnya aktif bila jenis di luar tiga alternatif', (
    tester,
  ) async {
    await _pump(tester, _detection('hoodie'));

    expect(_chip(tester, 'Lainnya…').selected, isTrue);
    expect(_chip(tester, 'Kaos').selected, isFalse);
  });

  testWidgets('chip Lainnya tidak aktif bila jenis ada di alternatif', (
    tester,
  ) async {
    await _pump(tester, _detection('t_shirt'));

    expect(_chip(tester, 'Lainnya…').selected, isFalse);
    expect(_chip(tester, 'Kaos').selected, isTrue);
  });
}
