import 'dart:io' show File;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../models/garment.dart';
import '../../services/providers.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/circle_icon_button.dart';
import '../../widgets/common/clothing_thumb.dart';
import '../../widgets/common/responsive.dart';

/// Pratinjau foto sebelum dipakai. "Gunakan Foto" menyimpannya ke lemari.
class CameraPreviewScreen extends ConsumerWidget {
  const CameraPreviewScreen({super.key, this.imagePath});

  /// Path foto dari kamera. Null jika dibuka tanpa foto (mis. tombol Galeri).
  final String? imagePath;

  void _usePhoto(BuildContext context, WidgetRef ref) {
    final path = imagePath;
    if (path != null) {
      // Placeholder attributes until Model 1 (type) and Module 2 (color) run.
      ref.read(wardrobeProvider.notifier).add(
            Garment(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              category: 'Atasan',
              colorName: 'merah',
              colorValue: const Color(0xFFB23A48),
              imagePath: path,
            ),
          );
    }
    context.pushReplacement(AppRoutes.analyzing);
  }

  Widget _photo(String path) {
    return SizedBox.expand(
      child: kIsWeb
          ? Image.network(path, fit: BoxFit.cover)
          : Image.file(File(path), fit: BoxFit.cover),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = imagePath;
    final fileName =
        path == null ? 'IMG_0927 · 3024×4032' : path.split(RegExp(r'[\\/]')).last;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ContentWidth(
            maxWidth: 560,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CircleIconButton(
                        icon: Icons.close,
                        background: const Color(0xFF1D1D1F),
                        iconColor: Colors.white,
                        onPressed: () => context.pop(),
                      ),
                    ),
                    Text('Pratinjau',
                        style: AppTextStyles.title.copyWith(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: path != null
                              ? _photo(path)
                              : Container(
                                  decoration: const BoxDecoration(
                                    gradient: RadialGradient(
                                      colors: [Colors.white, Color(0xFFBDBDC2)],
                                      radius: 0.9,
                                    ),
                                  ),
                                  child: const ClothingThumb(
                                    kind: ClothingKind.top,
                                    background: Colors.transparent,
                                    iconSize: 200,
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                              color: const Color(0xFF6E6E73),
                              borderRadius: BorderRadius.circular(16)),
                          child: Text(fileName,
                              style: AppTextStyles.mono(10, color: Colors.white, ls: 0.8)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: const [
                    _Check('Cahaya cukup'),
                    _Check('Fokus tajam'),
                    _Check('1 pakaian'),
                  ],
                ),
                const SizedBox(height: 28),
                Row(children: [
                  Expanded(
                    child: AppButton(
                      label: 'Ambil Ulang',
                      style: AppButtonStyle.outlined,
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: 'Gunakan Foto',
                      style: AppButtonStyle.white,
                      onPressed: () => _usePhoto(context, ref),
                    ),
                  ),
                ]),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Check extends StatelessWidget {
  const _Check(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1D1D1F),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.check, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(text, style: AppTextStyles.labelBold.copyWith(color: Colors.white)),
        ]),
      );
}
