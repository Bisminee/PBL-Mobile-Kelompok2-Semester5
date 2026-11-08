import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../config/app_text_styles.dart';
import '../../models/crop_args.dart';
import '../../services/image_crop.dart';
import '../../services/photo_intake.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/circle_icon_button.dart';

/// Halaman crop manual untuk foto dari galeri. Rasio dikunci 1:1 agar area
/// yang dilihat pengguna sama dengan input model.
class CropScreen extends StatefulWidget {
  const CropScreen({super.key, required this.args});

  final CropArgs args;

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  final CropController _controller = CropController();

  Uint8List? _image;
  Uint8List? _originalImage;
  int _width = 0;
  int _height = 0;
  int _originalWidth = 0;
  int _originalHeight = 0;
  CropSpec _spec = CropSpec.full;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _spec = widget.args.initialSpec ?? CropSpec.full;
    _load();
  }

  Future<void> _load() async {
    try {
      final bytes = await File(widget.args.originalPath).readAsBytes();
      final size = await compute(imageSizeOf, bytes);
      if (!mounted) return;
      if (size == null) {
        setState(() => _error = 'Foto tidak bisa dibaca.');
        return;
      }
      setState(() {
        _image = bytes;
        _originalImage = bytes;
        _width = size.width;
        _height = size.height;
        _originalWidth = size.width;
        _originalHeight = size.height;
      });
    } catch (_) {
      if (mounted) setState(() => _error = 'Foto tidak bisa dibaca.');
    }
  }

  Future<void> _rotate() async {
    final image = _image;
    if (image == null || _busy) return;
    setState(() => _busy = true);
    try {
      final rotated = await compute(rotatePhoto, image);
      if (!mounted) return;
      if (rotated == null) {
        _toast('Foto gagal diputar. Coba lagi.');
        return;
      }
      final size = await compute(imageSizeOf, rotated);
      if (!mounted) return;
      if (size == null) {
        _toast('Foto gagal diputar. Coba lagi.');
        return;
      }
      setState(() {
        _image = rotated;
        _width = size.width;
        _height = size.height;
        // Kotak crop direset oleh controller, jadi simpan nilai yang sama.
        _spec = CropSpec.full;
      });
      _controller.image = rotated;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _reset() {
    final original = _originalImage;
    if (original == null || _busy) return;
    setState(() {
      _image = original;
      _width = _originalWidth;
      _height = _originalHeight;
      _spec = CropSpec.full;
    });
    _controller.image = original;
  }

  Future<void> _apply() async {
    if (_image == null || _busy) return;
    setState(() => _busy = true);
    _controller.crop();
  }

  Future<void> _onCropped(CropResult result) async {
    if (!mounted) return;
    switch (result) {
      case CropSuccess(:final croppedImage):
        final shrunk = await compute(shrinkCropped, croppedImage);
        if (!mounted) return;
        if (shrunk == null) {
          _fail('Foto gagal dipotong. Coba lagi.');
          return;
        }
        final path = await _writeTemp(shrunk);
        if (!mounted) return;
        if (path == null) {
          _fail('Foto gagal disimpan. Coba lagi.');
          return;
        }
        context.pop(CropOutcome(path: path, spec: _spec));
      case CropFailure():
        _fail('Foto gagal dipotong. Coba lagi.');
    }
  }

  Future<String?> _writeTemp(Uint8List bytes) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final folder = Directory(p.join(dir.path, scanTempFolder));
      await folder.create(recursive: true);
      final file = File(
        p.join(
          folder.path,
          'crop_${DateTime.now().microsecondsSinceEpoch}.jpg',
        ),
      );
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } catch (_) {
      return null;
    }
  }

  void _fail(String message) {
    _toast(message);
    if (mounted) setState(() => _busy = false);
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Kotak awal mengikuti crop terakhir, dipetakan ke posisi gambar di layar.
  Rect _initialRect(Rect viewportRect, Rect imageRect) {
    final spec = _spec;
    if (spec.left == 0 &&
        spec.top == 0 &&
        spec.width == 1 &&
        spec.height == 1) {
      return viewportRect;
    }
    return Rect.fromLTWH(
      imageRect.left + spec.left * imageRect.width,
      imageRect.top + spec.top * imageRect.height,
      spec.width * imageRect.width,
      spec.height * imageRect.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final image = _image;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Stack(
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
                    'Sesuaikan Foto',
                    style: AppTextStyles.title.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _error != null
                  ? Center(
                      child: Text(
                        _error!,
                        style: AppTextStyles.body.copyWith(color: Colors.white),
                      ),
                    )
                  : image == null
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        Crop(
                          image: image,
                          controller: _controller,
                          aspectRatio: 1,
                          interactive: true,
                          baseColor: Colors.black,
                          maskColor: Colors.black54,
                          radius: 12,
                          initialRectBuilder: InitialRectBuilder.withBuilder(
                            _initialRect,
                          ),
                          onMoved: (viewportRect, imageRect) {
                            if (_width <= 0 || _height <= 0) return;
                            _spec = cropSpecFromRect(
                              imageRect,
                              _width,
                              _height,
                            );
                          },
                          onCropped: _onCropped,
                        ),
                        if (_busy)
                          const Positioned(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
            ),
            const SizedBox(height: 10),
            Text(
              'Geser dan cubit untuk mengatur area. Rasio 1:1.',
              style: AppTextStyles.mono(10, color: Colors.white70),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _IconAction(
                      icon: Icons.rotate_right,
                      label: 'Putar',
                      onPressed: _busy ? null : _rotate,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _IconAction(
                      icon: Icons.restart_alt,
                      label: 'Reset',
                      onPressed: _busy ? null : _reset,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Batal',
                      style: AppButtonStyle.white,
                      onPressed: _busy ? null : () => context.pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: 'Gunakan',
                      style: AppButtonStyle.white,
                      onPressed: _busy || image == null ? null : _apply,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFF1D1D1F),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.labelBold.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
