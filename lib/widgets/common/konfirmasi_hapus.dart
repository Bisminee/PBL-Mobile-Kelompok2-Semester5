import 'package:flutter/material.dart';

/// Dialog konfirmasi sebelum menghapus. Mengembalikan true bila pengguna menekan Hapus.
Future<bool> konfirmasiHapus(
  BuildContext context, {
  required String judul,
  required String isi,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(judul),
      content: Text(isi),
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
  return ok == true;
}
