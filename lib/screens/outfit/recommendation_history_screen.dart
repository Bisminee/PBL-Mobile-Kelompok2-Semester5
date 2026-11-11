import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_text_styles.dart';
import '../../services/providers.dart';
import '../../widgets/common/circle_icon_button.dart';
import '../../widgets/common/responsive.dart';
import '../../widgets/outfit/saved_outfit_card.dart';

/// Daftar rekomendasi yang pernah dibuka pengguna, terbaru lebih dulu.
class RecommendationHistoryScreen extends ConsumerWidget {
  const RecommendationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(recommendationHistoryProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ContentWidth(
            maxWidth: 720,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                CircleIconButton(
                  icon: Icons.chevron_left,
                  onPressed: () => context.pop(),
                ),
                const SizedBox(height: 16),
                Text('Riwayat Rekomendasi', style: AppTextStyles.display),
                const SizedBox(height: 6),
                Text(
                  'Paduan yang pernah kamu buka dari rekomendasi.',
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: 20),
                async.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, _) => Text(
                    'Riwayat belum bisa dimuat.',
                    style: AppTextStyles.bodySecondary,
                  ),
                  data: (list) => list.isEmpty
                      ? Text(
                          'Belum ada riwayat. Buka salah satu rekomendasi '
                          'untuk melihat detail paduannya.',
                          style: AppTextStyles.bodySecondary,
                        )
                      : Column(
                          children: [
                            for (var i = 0; i < list.length; i++) ...[
                              if (i > 0) const SizedBox(height: 12),
                              SavedOutfitCard(outfit: list[i]),
                            ],
                          ],
                        ),
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
