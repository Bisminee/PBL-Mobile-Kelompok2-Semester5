import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/outfit.dart';
import '../services/providers.dart';
import '../widgets/placeholders.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key, this.outfit});

  /// The outfit selected from the recommendation list (may be null on deep link).
  final Outfit? outfit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendations = ref.watch(recommendationsProvider);
    final selected = outfit ??
        (recommendations.isNotEmpty ? recommendations.first : null);

    if (selected == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Tidak ada detail untuk ditampilkan.')),
      );
    }

    // Tinggi gambar menyesuaikan layar agar tidak overflow di layar pendek.
    final screenHeight = MediaQuery.sizeOf(context).height;
    final imageHeight = (screenHeight * 0.30).clamp(170.0, 280.0);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(),
        body: MaxWidthBox(
          child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: _Header(outfit: selected, imageHeight: imageHeight),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarHeader(
                const TabBar(
                  tabs: [
                    Tab(text: 'Warna'),
                    Tab(text: 'Styling'),
                    Tab(text: 'Lemari'),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              _infoCard('Skor kecocokan: ${selected.scorePercent}%',
                  selected.reasons.join('\n• ')),
              _infoCard('Rekomendasi Styling', selected.subtitle),
              _infoCard('Simpan ke Lemari',
                  'Tambahkan paduan ini ke Lemari Saya.'),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _infoCard(String title, String body) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(body, style: const TextStyle(height: 1.5)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.outfit, required this.imageHeight});

  final Outfit outfit;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: PlaceholderBox(
            height: imageHeight,
            radius: 16,
            color: outfit.top.colorValue.withValues(alpha: 0.55),
            child: const Text('gambar', style: TextStyle(color: Colors.black54)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                outfit.title,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                outfit.subtitle,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  PillTag(label: outfit.top.category),
                  PillTag(label: outfit.bottom.category),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  ColorDot(
                      color: outfit.top.colorValue,
                      label: outfit.top.colorName),
                  ColorDot(
                      color: outfit.bottom.colorValue,
                      label: outfit.bottom.colorName),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Keeps the TabBar visible while the header scrolls away.
class _TabBarHeader extends SliverPersistentHeaderDelegate {
  const _TabBarHeader(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarHeader oldDelegate) =>
      oldDelegate.tabBar != tabBar;
}
