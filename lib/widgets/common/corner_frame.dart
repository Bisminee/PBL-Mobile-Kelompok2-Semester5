import 'package:flutter/material.dart';

/// Empat sudut "viewfinder" yang mengelilingi child (AI scan frame).
class CornerFrame extends StatelessWidget {
  const CornerFrame({
    super.key,
    required this.child,
    this.color = Colors.black,
    this.cornerLength = 36,
    this.thickness = 2,
    this.radius = 14,
    this.inset = 0,
  });

  final Widget child;
  final Color color;
  final double cornerLength;
  final double thickness;
  final double radius;
  final double inset;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _CornerPainter(color, cornerLength, thickness, radius, inset),
      child: child,
    );
  }
}

class _CornerPainter extends CustomPainter {
  _CornerPainter(this.color, this.len, this.t, this.r, this.inset);
  final Color color;
  final double len;
  final double t;
  final double r;
  final double inset;

  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = t
      ..strokeCap = StrokeCap.round;
    final l = inset, tp = inset, rt = s.width - inset, b = s.height - inset;

    Path corner(double x, double y, int dx, int dy) => Path()
      ..moveTo(x, y + dy * len)
      ..lineTo(x, y + dy * r)
      ..quadraticBezierTo(x, y, x + dx * r, y)
      ..lineTo(x + dx * len, y);

    canvas.drawPath(corner(l, tp, 1, 1), p);
    canvas.drawPath(corner(rt, tp, -1, 1), p);
    canvas.drawPath(corner(l, b, 1, -1), p);
    canvas.drawPath(corner(rt, b, -1, -1), p);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter old) =>
      old.color != color || old.len != len || old.t != t;
}
