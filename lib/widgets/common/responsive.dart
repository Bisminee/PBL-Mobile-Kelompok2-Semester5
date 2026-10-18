import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Batas lebar layar (mengikuti window size class Material 3).
class Breakpoints {
  Breakpoints._();

  /// Tablet potret ke atas.
  static const double medium = 600;

  /// Tablet lanskap / laptop ke atas.
  static const double expanded = 840;
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Lebar >= 600 (tablet, laptop).
  bool get isMediumUp => screenWidth >= Breakpoints.medium;

  /// Lebar >= 840 (tablet lanskap, laptop).
  bool get isExpanded => screenWidth >= Breakpoints.expanded;
}

/// Memusatkan konten dan membatasi lebar maksimumnya.
///
/// Di layar sempit (HP) konten tetap selebar layar; di layar lebar konten
/// berhenti di [maxWidth] dan berada di tengah. Letakkan di dalam
/// `SingleChildScrollView` agar scrollbar tetap di tepi layar.
class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child, this.maxWidth = 560});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.hasBoundedWidth
            ? math.min(constraints.maxWidth, maxWidth)
            : maxWidth;
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(width: width, child: child),
        );
      },
    );
  }
}
