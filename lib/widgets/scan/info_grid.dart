import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';

class InfoCell {
  const InfoCell(this.label, this.value, {this.dotColor});
  final String label;
  final String value;
  final Color? dotColor;
}

/// Grid 2x2 bergaris (Jenis / Style / Warna dominan / Confidence).
class InfoGrid extends StatelessWidget {
  const InfoGrid({super.key, required this.cells});
  final List<InfoCell> cells; // 4 item

  @override
  Widget build(BuildContext context) {
    Widget cell(InfoCell c) => Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.label, style: AppTextStyles.label),
                const SizedBox(height: 6),
                Row(children: [
                  if (c.dotColor != null) ...[
                    Container(
                        width: 14,
                        height: 14,
                        decoration:
                            BoxDecoration(color: c.dotColor, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                  ],
                  Text(c.value, style: AppTextStyles.title),
                ]),
              ],
            ),
          ),
        );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: [
        IntrinsicHeight(
          child: Row(children: [
            cell(cells[0]),
            const VerticalDivider(width: 1, color: AppColors.border),
            cell(cells[1]),
          ]),
        ),
        const Divider(height: 1, color: AppColors.border),
        IntrinsicHeight(
          child: Row(children: [
            cell(cells[2]),
            const VerticalDivider(width: 1, color: AppColors.border),
            cell(cells[3]),
          ]),
        ),
      ]),
    );
  }
}
