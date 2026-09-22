import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/outfit.dart';
import '../services/providers.dart';
import '../widgets/placeholders.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final outfits = ref.watch(recommendationsProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Selamat Datang !',
                        style: TextStyle(color: Colors.grey)),
                    Text(
                      user?.name ?? 'Guest',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFE0E0E0),
                child: Text(
                  user?.initials ?? '?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const PlaceholderBox(height: 100, radius: 8),
          const SizedBox(height: 24),
          Row(
            children: const [
              Expanded(child: PlaceholderBox(height: 90, radius: 16)),
              SizedBox(width: 12),
              Expanded(child: PlaceholderBox(height: 90, radius: 16)),
              SizedBox(width: 12),
              Expanded(child: PlaceholderBox(height: 90, radius: 16)),
            ],
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Rekomendasi terbaru',
            actionLabel: 'Lihat semua',
            onAction: () => context.push('/recommendation'),
          ),
          const SizedBox(height: 12),
          if (outfits.isEmpty)
            Row(
              children: const [
                Expanded(child: _EmptyOutfitCard()),
                SizedBox(width: 12),
                Expanded(child: _EmptyOutfitCard()),
                SizedBox(width: 12),
                Expanded(child: _EmptyOutfitCard()),
              ],
            )
          else
            Row(
              children: [
                for (var i = 0; i < outfits.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  Expanded(child: _OutfitCard(outfit: outfits[i])),
                ],
              ],
            ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: const [
                PlaceholderBox(
                    height: 56, width: 56, radius: 12, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PlaceholderBox(height: 12, radius: 6),
                      SizedBox(height: 8),
                      PlaceholderBox(height: 12, width: 140, radius: 6),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _OutfitCard extends StatelessWidget {
  const _OutfitCard({required this.outfit});

  final Outfit outfit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlaceholderBox(
          height: 180,
          radius: 12,
          color: outfit.bottom.colorValue.withValues(alpha: 0.55),
        ),
        const SizedBox(height: 6),
        Text(
          outfit.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _EmptyOutfitCard extends StatelessWidget {
  const _EmptyOutfitCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        PlaceholderBox(height: 180, radius: 12),
        SizedBox(height: 6),
        PlaceholderBox(height: 16, radius: 6, color: Color(0xFFCFCFCF)),
      ],
    );
  }
}
