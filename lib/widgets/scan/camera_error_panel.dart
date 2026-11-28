import 'package:flutter/material.dart';

import '../../config/app_text_styles.dart';

/// Isi layar kamera saat kamera tidak bisa dipakai: pesan error dan aksi
/// pemulihan. Dipisah dari `CameraScreen` agar teks dan tombolnya bisa diuji
/// tanpa perangkat kamera.
class CameraErrorPanel extends StatelessWidget {
  const CameraErrorPanel({
    super.key,
    required this.message,
    required this.showSettings,
    this.onOpenSettings,
    this.onRefresh,
  });

  final String message;

  /// True bila error disebabkan izin kamera ditolak.
  final bool showSettings;

  final VoidCallback? onOpenSettings;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.no_photography, size: 64, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: Colors.white),
            ),
            if (showSettings) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onOpenSettings,
                icon: const Icon(Icons.settings, color: Colors.white),
                label: const Text(
                  'Buka Pengaturan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            if (onRefresh != null) ...[
              const SizedBox(height: 4),
              TextButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  'Muat Ulang',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
