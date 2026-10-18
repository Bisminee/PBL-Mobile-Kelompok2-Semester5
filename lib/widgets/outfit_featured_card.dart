import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import 'app_button.dart';
import 'clothing_thumb.dart';
import 'match_ring.dart';
import 'pill_chip.dart';

/// Kartu besar "Paling Cocok" dengan panel "Kenapa cocok?" yang bisa dibuka.
class OutfitFeaturedCard extends StatefulWidget {
  const OutfitFeaturedCard({super.key, required this.onDetail});
  final VoidCallback onDetail;

  @override
  State<OutfitFeaturedCard> createState() => _OutfitFeaturedCardState();
}

class _OutfitFeaturedCardState extends State<OutfitFeaturedCard> {
  bool _open = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.textPrimary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 230,
            child: Row(children: [
              Expanded(
                child: Stack(
                  children: [
                    const Positioned.fill(
                        child: ClothingThumb(kind: ClothingKind.top, iconSize: 64)),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(16)),
                        child: Row(children: [
                          const Icon(Icons.auto_awesome, size: 12, color: Colors.white),
                          const SizedBox(width: 5),
                          Text('Paling Cocok',
                              style: AppTextStyles.labelBold
                                  .copyWith(color: Colors.white, fontSize: 11)),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(children: const [
                  Expanded(
                      child: SizedBox(
                          width: double.infinity,
                          child: ClothingThumb(kind: ClothingKind.bottom, dark: false))),
                  SizedBox(height: 8),
                  Expanded(
                      child: SizedBox(
                          width: double.infinity,
                          child: ClothingThumb(kind: ClothingKind.shoes))),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Monochrome Casual', style: AppTextStyles.h2),
                        const SizedBox(height: 2),
                        Text('94% MATCH', style: AppTextStyles.mono(10)),
                      ],
                    ),
                  ),
                  const MatchRing(value: 94, size: 52, stroke: 4),
                ]),
                const SizedBox(height: 10),
                Text('Kaos · Celana · Sneakers', style: AppTextStyles.bodySecondary),
                const SizedBox(height: 10),
                Text('Perpaduan warna netral menciptakan tampilan yang clean dan seimbang.',
                    style: AppTextStyles.body.copyWith(fontSize: 15)),
                const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 8, children: const [
                  PillChip(label: 'Color Harmony', icon: Icons.water_drop_outlined, small: true),
                  PillChip(label: 'Your Wardrobe', icon: Icons.checkroom_outlined, small: true),
                ]),
                const SizedBox(height: 14),
                const Divider(color: AppColors.border, height: 1),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _open = !_open),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(children: [
                      Expanded(child: Text('Kenapa cocok?', style: AppTextStyles.title)),
                      Icon(_open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                    ]),
                  ),
                ),
                if (_open) ...const [
                  _Metric('Kompatibilitas warna', 96,
                      'Hitam dan putih membentuk kontras monokrom yang selalu seimbang.'),
                  _Metric('Kategori pakaian', 92,
                      'Kaos, celana panjang, dan sneakers membentuk outfit yang lengkap.'),
                  _Metric('Kesesuaian style', 90,
                      'Ketiganya bergaya casual, cocok untuk kampus dan aktivitas harian.'),
                ],
                const SizedBox(height: 6),
                AppButton(label: 'Lihat Detail', onPressed: widget.onDetail),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric(this.title, this.value, this.desc);
  final String title;
  final int value;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: Text(title, style: AppTextStyles.title.copyWith(fontSize: 14))),
            Text('$value%', style: AppTextStyles.labelBold.copyWith(fontSize: 13)),
          ]),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: 4,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
            ),
          ),
          const SizedBox(height: 8),
          Text(desc, style: AppTextStyles.bodySecondary.copyWith(fontSize: 13)),
        ],
      ),
    );
  }
}
