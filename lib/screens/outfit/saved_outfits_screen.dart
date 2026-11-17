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
import '../../widgets/outfit/saved_outfit_card.dart';

/// Daftar outfit yang pernah disimpan pengguna dari layar detail rekomendasi.
/// Pengguna bisa mengubah nama dan menghapus outfit dari sini.
class SavedOutfitsScreen extends ConsumerWidget {
  const SavedOutfitsScreen({super.key});

  void _bukaDetail(BuildContext context, SavedOutfit o) {
    final detail = outfitFromSaved(o);
    if (detail != null) context.push(AppRoutes.detail, extra: detail);
  }

  Future<void> _ubahNama(
    BuildContext context,
    WidgetRef ref,
    SavedOutfit o,
  ) async {
    final nama = await showDialog<String>(
      context: context,
      builder: (_) => _RenameDialog(nama: o.name),
    );
    if (nama == null || nama.isEmpty || nama == o.name) return;
    try {
      await ref.read(localDbProvider).renameOutfit(o.id, nama);
      ref.invalidate(savedOutfitsProvider);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengubah nama outfit.')),
      );
    }
  }

  Future<void> _hapus(
    BuildContext context,
    WidgetRef ref,
    SavedOutfit o,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus outfit ini?'),
        content: Text('"${o.name}" akan dihapus dari outfit tersimpan.'),
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
    try {
      await ref.read(localDbProvider).deleteOutfit(o.id);
      ref.invalidate(savedOutfitsProvider);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menghapus outfit.')));
    }
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
                                    _ubahNama(context, ref, list[i]),
                                onDelete: () => _hapus(context, ref, list[i]),
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

/// Dialog ubah nama. Controller dibuat dan dibuang di State agar tidak dipakai setelah dialog tertutup.
class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.nama});

  final String nama;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.nama,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Ubah nama outfit'),
    content: TextField(controller: _controller, autofocus: true, maxLength: 60),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Batal'),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
        child: const Text('Simpan'),
      ),
    ],
  );
}
