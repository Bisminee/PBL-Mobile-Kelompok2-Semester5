import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/app_routes.dart';
import '../config/app_text_styles.dart';
import '../widgets/circle_icon_button.dart';
import '../widgets/pill_chip.dart';
import '../widgets/outfit_featured_card.dart';
import '../widgets/outfit_compact_card.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
<<<<<<< Updated upstream
  Widget build(BuildContext context, WidgetRef ref) {
    final outfits = ref.watch(recommendationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rekomendasi Outfit',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              '${outfits.length} paduan outfit ditemukan',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: outfits.isEmpty
          ? _emptyState(context)
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _previewCard(outfits.first),
                const SizedBox(height: 24),
                const Text(
                  'Pilihan Paduan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                for (var i = 0; i < outfits.length; i++) ...[
                  if (i > 0) const SizedBox(height: 16),
                  _PairCard(
                    number: i + 1,
                    outfit: outfits[i],
                    onDetail: () =>
                        context.push('/detail', extra: outfits[i]),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _previewCard(Outfit outfit) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          PlaceholderBox(
            height: 72,
            width: 72,
            radius: 12,
            color: outfit.top.colorValue.withValues(alpha: 0.55),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Item terdeteksi: ${outfit.top.category}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('Warna dominan: ${outfit.top.colorName}',
                    style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.checkroom, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              'Belum ada item di lemari.\nAmbil foto pakaian untuk mulai.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.push('/camera'),
              child: const Text('Buka Kamera'),
            ),
          ],
        ),
      ),
    );
  }
=======
  State<RecommendationScreen> createState() => _RecommendationScreenState();
>>>>>>> Stashed changes
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
              OutfitFeaturedCard(onDetail: openDetail),
              const SizedBox(height: 14),
              OutfitCompactCard(
                title: 'Clean Minimal',
                score: 89,
                items: 'Kaos · Jeans · Sneakers',
                description: 'Abu denim melembutkan hitam, sneakers putih membuat tampilan ringan.',
                tags: const ['Color Harmony', 'Your Wardrobe'],
                onTap: openDetail,
              ),
              const SizedBox(height: 14),
              OutfitCompactCard(
                title: 'Layered Neutral',
                score: 86,
                items: 'Coat · Kaos · Chino',
                description: 'Coat abu menambah lapisan rapi di atas kaos hitam, pas untuk presentasi.',
                tags: const ['Color Harmony', 'Layering'],
                onTap: openDetail,
              ),
              const SizedBox(height: 14),
              OutfitCompactCard(
                title: 'Tonal Street',
                score: 81,
                items: 'Kaos · Celana · Sneakers',
                description: 'Tone hitam penuh terlihat tegas; sneakers putih jadi titik kontras.',
                tags: const ['Your Wardrobe'],
                onTap: openDetail,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
