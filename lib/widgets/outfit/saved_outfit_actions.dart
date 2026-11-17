import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/saved_outfit.dart';
import '../../services/providers.dart';

/// Aksi ubah nama dan hapus untuk outfit tersimpan. Dipakai layar Outfit Tersimpan dan tab Lemari.
Future<void> ubahNamaOutfit(
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

Future<void> hapusOutfit(
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
