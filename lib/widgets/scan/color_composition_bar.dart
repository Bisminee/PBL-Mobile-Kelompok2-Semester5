import 'package:flutter/material.dart';

import '../../config/app_text_styles.dart';

class ColorSegment {
  const ColorSegment(this.name, this.percent, this.color);
  final String name;
  final int percent;
  final Color color;
}

/// Bar proporsi warna + legenda di bawahnya.
class ColorCompositionBar extends StatelessWidget {
  const ColorCompositionBar({super.key, required this.segments});
  final List<ColorSegment> segments;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 10,
            child: Row(children: [
              for (final s in segments)
                Expanded(flex: s.percent, child: Container(color: s.color)),
            ]),
          ),
        ),
        const SizedBox(height: 10),
        Row(children: [
          for (final s in segments) ...[
            Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(color: s.color, shape: BoxShape.circle)),
            const SizedBox(width: 5),
            Text('${s.name} ${s.percent}%', style: AppTextStyles.label.copyWith(fontSize: 11)),
            const SizedBox(width: 14),
          ],
        ]),
      ],
    );
  }
}
