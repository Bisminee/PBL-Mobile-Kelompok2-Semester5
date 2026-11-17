import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../models/saved_outfit.dart';
import '../../services/providers.dart';
import '../../services/recommender.dart';
import '../../widgets/common/circle_icon_button.dart';
import '../../widgets/common/responsive.dart';
import '../../widgets/outfit/saved_outfit_actions.dart';
import '../../widgets/outfit/saved_outfit_card.dart';

/// Daftar outfit yang pernah disimpan pengguna dari layar detail rekomendasi.
/// Pengguna bisa mengubah nama dan menghapus outfit dari sini.
class SavedOutfitsScreen extends ConsumerWidget {
  const SavedOutfitsScreen({super.key});

  void _bukaDetail(BuildContext context, SavedOutfit o) {
    final detail = outfitFromSaved(o);
    if (detail != null) context.push(AppRoutes.detail, extra: detail);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(savedOutfitsProvider);

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
                Text('Outfit Tersimpan', style: AppTextStyles.display),
                const SizedBox(height: 6),
                Text(
                  'Paduan yang sudah kamu simpan dari rekomendasi.',
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: 20),
                async.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, _) => Text(
                    'Daftar outfit belum bisa dimuat.',
                    style: AppTextStyles.bodySecondary,
                  ),
                  data: (list) => list.isEmpty
                      ? Text(
                          'Belum ada outfit tersimpan. Buka rekomendasi, '
                          'lalu tekan "Simpan Outfit" pada detail paduan.',
                          style: AppTextStyles.bodySecondary,
                        )
                      : Column(
                          children: [
                            for (var i = 0; i < list.length; i++) ...[
                              if (i > 0) const SizedBox(height: 12),
                              SavedOutfitCard(
                                outfit: list[i],
                                onTap: () => _bukaDetail(context, list[i]),
                                onRename: () =>
                                    ubahNamaOutfit(context, ref, list[i]),
                                onDelete: () =>
                                    hapusOutfit(context, ref, list[i]),
                              ),
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
