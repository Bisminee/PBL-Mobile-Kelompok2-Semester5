import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';

/// Lingkaran persentase (94 / 94% MATCH / CONF).
class MatchRing extends StatelessWidget {
  const MatchRing({
    super.key,
    required this.value,
    this.size = 52,
    this.caption,
    this.showPercent = false,
    this.stroke = 3,
  });

  final int value; // 0..100
  final double size;
  final String? caption;
  final bool showPercent;
  final double stroke;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(value / 100, stroke),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                showPercent ? '$value%' : '$value',
                style: AppTextStyles.h3.copyWith(fontSize: size * 0.28),
              ),
              if (caption != null)
                Text(caption!, style: AppTextStyles.mono(size * 0.13, ls: 0.6)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.progress, this.stroke);
  final double progress;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final r = rect.deflate(stroke / 2);
    final track = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    final arc = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;
    canvas.drawArc(r, 0, math.pi * 2, false, track);
    canvas.drawArc(r, -math.pi / 2, math.pi * 2 * progress, false, arc);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress || old.stroke != stroke;
}
