import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../widgets/common/circle_icon_button.dart';
import '../../widgets/common/pill_chip.dart';
import '../../widgets/common/responsive.dart';
import '../../widgets/outfit/outfit_compact_card.dart';
import '../../widgets/outfit/outfit_featured_card.dart';

/// Daftar rekomendasi outfit: satu kartu utama dan beberapa pilihan lain.
class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  static const _filters = ['Semua', 'Kampus', 'Santai', 'Hangout'];
  String _filter = 'Semua';

  @override
  Widget build(BuildContext context) {
    void openDetail() => context.push(AppRoutes.detail);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ContentWidth(
            maxWidth: 1040,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleIconButton(
                        icon: Icons.chevron_left, onPressed: () => context.pop()),
                    const CircleIconButton(icon: Icons.tune),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Rekomendasi Outfit', style: AppTextStyles.display),
                const SizedBox(height: 6),
                Text('Ditemukan berdasarkan pakaian yang kamu miliki.',
                    style: AppTextStyles.bodySecondary),
                const SizedBox(height: 14),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final f in _filters) ...[
                        PillChip(
                          label: f,
                          selected: f == _filter,
                          onTap: () => setState(() => _filter = f),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text('4 OUTFIT DITEMUKAN', style: AppTextStyles.mono(10)),
                ),
                const SizedBox(height: 14),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final featured = OutfitFeaturedCard(onDetail: openDetail);
                    final compacts = <Widget>[
                      OutfitCompactCard(
                        title: 'Clean Minimal',
                        score: 89,
                        items: 'Kaos · Jeans · Sneakers',
                        description:
                            'Abu denim melembutkan hitam, sneakers putih membuat tampilan ringan.',
                        tags: const ['Color Harmony', 'Your Wardrobe'],
                        onTap: openDetail,
                      ),
                      OutfitCompactCard(
                        title: 'Layered Neutral',
                        score: 86,
                        items: 'Coat · Kaos · Chino',
                        description:
                            'Coat abu menambah lapisan rapi di atas kaos hitam, pas untuk presentasi.',
                        tags: const ['Color Harmony', 'Layering'],
                        onTap: openDetail,
                      ),
                      OutfitCompactCard(
                        title: 'Tonal Street',
                        score: 81,
                        items: 'Kaos · Celana · Sneakers',
                        description:
                            'Tone hitam penuh terlihat tegas; sneakers putih jadi titik kontras.',
                        tags: const ['Your Wardrobe'],
                        onTap: openDetail,
                      ),
                    ];
                    Widget spaced(List<Widget> items) => Column(
                          children: [
                            for (var i = 0; i < items.length; i++) ...[
                              if (i > 0) const SizedBox(height: 14),
                              items[i],
                            ],
                          ],
                        );

                    // Layar lebar: kartu utama di kiri, pilihan lain di kanan.
                    if (constraints.maxWidth >= 720) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: featured),
                          const SizedBox(width: 16),
                          Expanded(child: spaced(compacts)),
                        ],
                      );
                    }
                    return spaced([featured, ...compacts]);
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
