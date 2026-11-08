import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/photo_intake.dart';
import '../../services/photo_source.dart';
import '../../services/providers.dart';

/// Memilih foto galeri, menyalinnya ke folder sementara aplikasi, lalu
/// mengembalikan path siap pratinjau. Null bila batal, ditolak, atau gagal.
Future<String?> pickGalleryPhoto(BuildContext context, WidgetRef ref) async {
  final picked = await ref.read(photoPickerProvider).pickFromGallery();
  if (!context.mounted) return null;

  switch (picked.status) {
    case PhotoPickStatus.cancelled:
      return null;
    case PhotoPickStatus.denied:
      await _showDenied(context);
      return null;
    case PhotoPickStatus.failed:
      _toast(context, picked.message ?? 'Gagal membuka galeri.');
      return null;
    case PhotoPickStatus.picked:
      return _prepare(context, picked.path!);
  }
}

/// Menyalin foto terpilih ke `scan_tmp` sambil menampilkan indikator singkat.
Future<String?> _prepare(BuildContext context, String sourcePath) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  var loadingShown = false;
  navigator.push(
    DialogRoute<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    ),
  );
  loadingShown = true;

  try {
    final bytes = await File(sourcePath).readAsBytes();
    final path = await PhotoIntake.prepare(bytes, prefix: 'gallery');
    if (path == null && context.mounted) {
      _toast(context, 'Foto tidak bisa dibaca. Coba foto lain.');
    }
    return path;
  } catch (_) {
    if (context.mounted) {
      _toast(context, 'Foto tidak bisa dibaca. Coba foto lain.');
    }
    return null;
  } finally {
    if (loadingShown) navigator.pop();
  }
}

Future<void> _showDenied(BuildContext context) => showDialog<void>(
  context: context,
  builder: (dialogContext) => AlertDialog(
    title: const Text('Akses galeri ditolak'),
    content: const Text(
      'Sera-Z tidak bisa membuka galeri. Buka Pengaturan > Aplikasi > '
      'Sera-Z > Izin, lalu aktifkan akses foto.',
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(dialogContext),
        child: const Text('Mengerti'),
      ),
    ],
  ),
);

void _toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
