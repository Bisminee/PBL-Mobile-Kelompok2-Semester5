import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_text_styles.dart';
import '../../models/saved_outfit.dart';
import '../../services/providers.dart';
import '../../services/saved_outfit_actions.dart';
import '../../widgets/common/circle_icon_button.dart';
import '../../widgets/common/responsive.dart';
import '../../widgets/outfit/saved_outfit_card.dart';

/// Daftar outfit yang pernah disimpan pengguna dari layar detail rekomendasi.
class SavedOutfitsScreen extends ConsumerWidget {
  const SavedOutfitsScreen({super.key});

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    SavedOutfit outfit,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus outfit tersimpan?'),
        content: Text('${outfit.title} akan dihapus dari outfit tersimpan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(localDbProvider).deleteSavedOutfit(outfit.id);
    ref.invalidate(savedOutfitsProvider);
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
                                onTap: () =>
                                    openSavedOutfitDetail(context, list[i]),
                                onLongPress: () => showSavedOutfitActions(
                                  context,
                                  ref,
                                  list[i],
                                ),
                                onDelete: () => _delete(context, ref, list[i]),
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
