import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/garment.dart';
import '../services/providers.dart';
import '../widgets/placeholders.dart';

class WardrobeScreen extends ConsumerWidget {
  const WardrobeScreen({super.key});

  static const _filters = ['Semua', 'Atasan', 'Bawahan', 'Luaran'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(wardrobeProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selamat Datang !',
                        style: TextStyle(color: Colors.grey)),
                    Text(
                      'Lemari Saya',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () => context.push('/camera'),
                child: const Text('+ Tambah'),
              ),
            ],
          ),
          const Divider(height: 32),
          const SectionHeader(
              title: 'Outfit Tersimpan', actionLabel: 'Tampilkan Semua'),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(child: _SavedOutfitCard()),
              SizedBox(width: 12),
              Expanded(child: _SavedOutfitCard()),
              SizedBox(width: 12),
              Expanded(child: _SavedOutfitCard()),
            ],
          ),
          const SizedBox(height: 24),
          SectionHeader(title: 'Item Pakaian (${items.length})'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final f in _filters)
                Chip(
                  label: Text(f),
                  backgroundColor: Colors.grey.shade200,
                  side: BorderSide.none,
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (items.isEmpty)
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: List.generate(
                6,
                (_) => const PlaceholderBox(radius: 12),
              ),
            )
          else
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                for (final item in items) _ItemTile(item: item),
              ],
            ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('Tampilkan Semua >'),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({required this.item});

  final Garment item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: PlaceholderBox(
            radius: 12,
            color: item.colorValue.withValues(alpha: 0.55),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${item.category} • ${item.colorName}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}

class _SavedOutfitCard extends StatelessWidget {
  const _SavedOutfitCard();

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 3 / 4,
      child: PlaceholderBox(radius: 12),
    );
  }
}
