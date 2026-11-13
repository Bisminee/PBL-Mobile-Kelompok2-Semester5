import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../../models/garment.dart';
import '../common/garment_photo.dart';
import '../common/match_ring.dart';
import '../common/pill_chip.dart';

/// Kartu outfit ringkas: thumbnail foto item di kiri, info di kanan.
/// Baris "Kenapa cocok?" bisa dibuka untuk menampilkan seluruh [reasons].
class OutfitCompactCard extends StatefulWidget {
  const OutfitCompactCard({
    super.key,
    required this.title,
    required this.score,
    required this.items,
    required this.description,
    required this.reasons,
    required this.tags,
    required this.top,
    required this.bottom,
    this.rank,
    this.onTap,
  });

  final String title;
  final int score;
  final String items;
  final String description;

  /// Alasan kecocokan lengkap, ditampilkan saat "Kenapa cocok?" dibuka.
  final List<String> reasons;
  final List<String> tags;

  /// Peringkat (mulai 1) pada daftar yang sedang tampil. Null = tidak ditampilkan.
  final int? rank;

  /// Item yang dipadukan, dipakai untuk menampilkan foto asli.
  final Garment top;
  final Garment bottom;
  final VoidCallback? onTap;

  @override
  State<OutfitCompactCard> createState() => _OutfitCompactCardState();
}

class _OutfitCompactCardState extends State<OutfitCompactCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final top = widget.top;
    final bottom = widget.bottom;
    final score = widget.score;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 112,
                  height: 140,
                  child: Column(
                    children: [
                      Expanded(
                        child: GarmentPhoto(
                          imagePath: top.imagePath,
                          kind: clothingKindOf(top.garmentType, top.slot),
                          dark: top.isDark,
                          iconSize: 28,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: GarmentPhoto(
                          imagePath: bottom.imagePath,
                          kind: clothingKindOf(bottom.garmentType, bottom.slot),
                          dark: bottom.isDark,
                          iconSize: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(widget.title, style: AppTextStyles.h3),
                          ),
                          MatchRing(value: score, size: 30, stroke: 3),
                        ],
                      ),
                      Text(
                        widget.rank == null
                            ? '$score% MATCH'
                            : '#${widget.rank} · $score% MATCH',
                        style: AppTextStyles.mono(10),
                      ),
                      const SizedBox(height: 6),
                      Text(widget.items, style: AppTextStyles.label),
                      const SizedBox(height: 6),
                      Text(
                        widget.description,
                        style: AppTextStyles.body.copyWith(fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final t in widget.tags)
                            PillChip(label: t, small: true),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, color: AppColors.border),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Kenapa cocok?',
                        style: AppTextStyles.title.copyWith(fontSize: 14),
                      ),
                    ),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                  ],
                ),
              ),
            ),
            if (_expanded)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final r in widget.reasons)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          '• $r',
                          style: AppTextStyles.body.copyWith(fontSize: 13),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
