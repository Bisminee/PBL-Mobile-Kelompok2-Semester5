import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../config/app_colors.dart';

/// Lingkaran konsentris + titik orbit pada splash screen.
class OrbitRings extends StatelessWidget {
  const OrbitRings({super.key});

  @override
  Widget build(BuildContext context) => CustomPaint(painter: _OrbitPainter());
}

class _OrbitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    // Pakai sisi terpendek agar lingkaran tidak membesar tak terkendali di layar lebar.
    final s = size.shortestSide;
    final line = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(c, s * 0.78, line);
    canvas.drawCircle(c, s * 0.52, line);

    // lingkaran putus-putus
    final dashR = s * 0.28;
    const dashCount = 60;
    for (var i = 0; i < dashCount; i++) {
      final a = (i / dashCount) * math.pi * 2;
      canvas.drawArc(Rect.fromCircle(center: c, radius: dashR), a,
          math.pi * 2 / dashCount * 0.5, false, line);
    }

    // titik orbit
    const angle = -math.pi / 2 + 0.2;
    final dot = c + Offset(math.cos(angle), math.sin(angle)) * (s * 0.52);
    canvas.drawCircle(dot, 4, Paint()..color = AppColors.textPrimary);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
