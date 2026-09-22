import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/outfit.dart';
import '../services/providers.dart';
import '../widgets/placeholders.dart';

class RecommendationScreen extends ConsumerWidget {
  const RecommendationScreen({super.key});

  @override
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
}

class _PairCard extends StatelessWidget {
  const _PairCard({
    required this.number,
    required this.outfit,
    required this.onDetail,
  });

  final int number;
  final Outfit outfit;
  final VoidCallback onDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text('$number',
                          style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(outfit.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(outfit.subtitle,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54)),
                        ],
                      ),
                    ),
                    Text('${outfit.scorePercent}%',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ColorDot(
                        color: outfit.top.colorValue,
                        label: outfit.top.colorName),
                    const SizedBox(width: 16),
                    ColorDot(
                        color: outfit.bottom.colorValue,
                        label: outfit.bottom.colorName),
                  ],
                ),
                const SizedBox(height: 12),
                for (final reason in outfit.reasons)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text('• $reason',
                        style: const TextStyle(fontSize: 13, height: 1.4)),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Outfit disimpan')),
                    );
                  },
                  child: const Text('Simpan'),
                ),
              ),
              const SizedBox(height: 40, child: VerticalDivider(width: 1)),
              Expanded(
                child: TextButton(
                  onPressed: onDetail,
                  child: const Text('Detail'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
