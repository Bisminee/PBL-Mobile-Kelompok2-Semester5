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

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PlaceholderBox(
                height: 260,
                radius: 16,
                color: selected.top.colorValue.withValues(alpha: 0.55),
                child: const Text('gambar',
                    style: TextStyle(color: Colors.black54)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selected.title,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selected.subtitle,
                    style:
                        TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      PillTag(label: selected.top.category),
                      const SizedBox(width: 8),
                      PillTag(label: selected.bottom.category),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ColorDot(
                          color: selected.top.colorValue,
                          label: selected.top.colorName),
                      const SizedBox(width: 16),
                      ColorDot(
                          color: selected.bottom.colorValue,
                          label: selected.bottom.colorName),
                    ],
                  ),
                ],
              ),
            ),
            const TabBar(
              tabs: [
                Tab(text: 'Warna'),
                Tab(text: 'Styling'),
                Tab(text: 'Lemari'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _infoCard('Skor kecocokan: ${selected.scorePercent}%',
                      selected.reasons.join('\n• ')),
                  _infoCard('Rekomendasi Styling', selected.subtitle),
                  _infoCard('Simpan ke Lemari',
                      'Tambahkan paduan ini ke Lemari Saya.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String body) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(body, style: const TextStyle(height: 1.5)),
          ],
        ),
      ),
    );
  }
}
