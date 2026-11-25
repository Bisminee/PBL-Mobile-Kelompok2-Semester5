import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../config/app_routes.dart';
import '../models/garment_labels.dart';
import '../models/saved_outfit.dart';
import 'providers.dart';

enum _SavedOutfitAction { view, edit, delete }

/// Menu tekan lama untuk outfit tersimpan: lihat detail, edit, atau hapus.
Future<void> showSavedOutfitActions(
  BuildContext context,
  WidgetRef ref,
  SavedOutfit outfit,
) async {
  final action = await showModalBottomSheet<_SavedOutfitAction>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              outfit.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text('Pilih tindakan untuk outfit ini'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.visibility_outlined),
            title: const Text('Lihat detail'),
            onTap: () => Navigator.of(ctx).pop(_SavedOutfitAction.view),
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Edit'),
            onTap: () => Navigator.of(ctx).pop(_SavedOutfitAction.edit),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Hapus'),
            onTap: () => Navigator.of(ctx).pop(_SavedOutfitAction.delete),
          ),
        ],
      ),
    ),
  );
  if (action == null || !context.mounted) return;

  switch (action) {
    case _SavedOutfitAction.view:
      _openDetail(context, outfit);
      break;
    case _SavedOutfitAction.edit:
      await _editOutfit(context, ref, outfit);
      break;
    case _SavedOutfitAction.delete:
      await _deleteOutfit(context, ref, outfit);
      break;
  }
}

/// Membuka detail outfit tersimpan memakai layar detail outfit yang sudah ada.
void openSavedOutfitDetail(BuildContext context, SavedOutfit outfit) {
  _openDetail(context, outfit);
}

void _openDetail(BuildContext context, SavedOutfit outfit) {
  final converted = outfit.toOutfit();
  if (converted == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Detail belum bisa dibuka karena item outfit tidak lengkap.',
        ),
      ),
    );
    return;
  }
  context.push(AppRoutes.detail, extra: converted);
}

Future<void> _editOutfit(
  BuildContext context,
  WidgetRef ref,
  SavedOutfit outfit,
) async {
  final controller = TextEditingController(text: outfit.name);
  var formality = outfit.formality;

  final result = await showDialog<({String name, String formality})>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDialogState) => AlertDialog(
        title: const Text('Edit outfit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nama outfit',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: formality,
              decoration: const InputDecoration(
                labelText: 'Formalitas',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final f in formalityValues)
                  DropdownMenuItem(value: f, child: Text(formalityLabel(f))),
              ],
              onChanged: (value) {
                if (value != null) setDialogState(() => formality = value);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              Navigator.of(ctx).pop((
                name: name.isEmpty ? outfit.title : name,
                formality: formality,
              ));
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    ),
  );
  controller.dispose();
  if (result == null || !context.mounted) return;

  final uid = ref.read(activeUidProvider);
  if (uid == null || !context.mounted) return;
  try {
    await ref
        .read(localDbProvider)
        .updateSavedOutfit(
          outfit.id,
          ownerUid: uid,
          name: result.name,
          formality: result.formality,
        );
    await ref.read(userPreferenceServiceProvider).refreshFromOutfits(uid);
    ref.invalidate(savedOutfitsProvider);
    ref.invalidate(userPreferencesProvider);
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Outfit diperbarui.')));
  } catch (_) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gagal memperbarui outfit. Coba lagi.')),
    );
  }
}

Future<void> _deleteOutfit(
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
  if (ok != true || !context.mounted) return;

  final uid = ref.read(activeUidProvider);
  if (uid == null) return;
  try {
    await ref.read(localDbProvider).deleteSavedOutfit(outfit.id, ownerUid: uid);
    await ref.read(userPreferenceServiceProvider).refreshFromOutfits(uid);
    ref.invalidate(savedOutfitsProvider);
    ref.invalidate(userPreferencesProvider);
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Outfit dihapus.')));
  } catch (_) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gagal menghapus outfit. Coba lagi.')),
    );
  }
}
