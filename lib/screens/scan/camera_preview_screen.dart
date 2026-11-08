import 'dart:io' show File;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../models/crop_args.dart';
import '../../models/scan_source.dart';
import '../../services/image_crop.dart';
import '../../services/providers.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/circle_icon_button.dart';
import '../../widgets/common/clothing_thumb.dart';
import '../../widgets/common/responsive.dart';
import 'gallery_pick.dart';

/// Pratinjau foto sebelum dipakai. "Gunakan Foto" memulai analisis; foto baru
/// masuk lemari setelah user menyimpan hasilnya di layar hasil deteksi.
class CameraPreviewScreen extends ConsumerStatefulWidget {
  const CameraPreviewScreen({
    super.key,
    this.imagePath,
    this.source = ScanSource.camera,
  });

  /// Path foto yang sudah disalin ke folder sementara aplikasi.
  final String? imagePath;

  /// Asal foto. Menentukan label tombol kiri dan perilaku saat memilih ulang.
  final ScanSource source;

  @override
  ConsumerState<CameraPreviewScreen> createState() =>
      _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends ConsumerState<CameraPreviewScreen> {
  late String? _path = widget.imagePath;
  late String? _originalPath = widget.imagePath;
  CropSpec? _spec;
  bool _picking = false;

  Future<void> _usePhoto() async {
    final path = _path;
    if (path == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ambil foto pakaian terlebih dahulu.')),
      );
      return;
    }
    ref.read(scanSessionProvider.notifier).start(path, source: widget.source);
    context.pushReplacement(AppRoutes.analyzing);
  }

  Future<void> _retake() async {
    if (widget.source != ScanSource.gallery) {
      context.pop();
      return;
    }
    if (_picking) return;
    setState(() => _picking = true);
    try {
      final path = await pickGalleryPhoto(context, ref);
      if (path != null && mounted) {
        setState(() {
          _path = path;
          _originalPath = path;
          _spec = null;
        });
      }
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  /// Membuka crop manual. Hanya tersedia untuk foto dari galeri.
  Future<void> _adjust() async {
    final original = _originalPath;
    if (original == null || _picking) return;
    final outcome = await context.push<CropOutcome>(
      AppRoutes.cropPhoto,
      extra: CropArgs(originalPath: original, initialSpec: _spec),
    );
    if (outcome == null || !mounted) return;
    setState(() {
      _path = outcome.path;
      _spec = outcome.spec;
    });
  }

  Widget _photo(String path) {
    return SizedBox.expand(
      child: kIsWeb
          ? Image.network(path, fit: BoxFit.cover)
          : Image.file(File(path), fit: BoxFit.cover),
    );
  }

  @override
  Widget build(BuildContext context) {
    final path = _path;
    final fileName = path == null
        ? 'Belum ada foto'
        : path.split(RegExp(r'[\\/]')).last;

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
                    Text(
                      'Pratinjau',
                      style: AppTextStyles.title.copyWith(color: Colors.white),
                    ),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6E6E73),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            fileName,
                            style: AppTextStyles.mono(
                              10,
                              color: Colors.white,
                              ls: 0.8,
                            ),
                          ),
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
                if (widget.source == ScanSource.gallery) ...[
                  TextButton.icon(
                    onPressed: _picking ? null : _adjust,
                    icon: const Icon(Icons.crop, size: 18, color: Colors.white),
                    label: Text(
                      'Sesuaikan area',
                      style: AppTextStyles.labelBold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: widget.source == ScanSource.gallery
                            ? 'Pilih Ulang'
                            : 'Ambil Ulang',
                        style: AppButtonStyle.outlined,
                        onPressed: _picking ? null : _retake,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        label: 'Gunakan Foto',
                        style: AppButtonStyle.white,
                        onPressed: _usePhoto,
                      ),
                    ),
                  ],
                ),
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
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check, size: 14, color: Colors.white),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTextStyles.labelBold.copyWith(color: Colors.white),
        ),
      ],
    ),
  );
}
