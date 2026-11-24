import 'dart:io' show File;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../models/scan_source.dart';
import '../../services/camera_service.dart';
import '../../services/photo_intake.dart';
import '../../widgets/scan/camera_controls.dart';
import '../../widgets/scan/camera_overlay.dart';
import 'gallery_pick.dart';

/// Layar kamera. Tampilan dari desain Sera-Z; logika kamera (inisialisasi,
/// lifecycle, ganti kamera, ambil foto, penanganan error) dari versi `lib`.
class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  int _cameraIndex = 0;
  bool _isInitializing = false;
  bool _isProcessing = false;
  String? _errorMessage;
  FlashMode _flashMode = FlashMode.off;

  List<CameraDescription> get _cameras => CameraService.cameras;

  bool get _canCapture {
    final controller = _controller;
    return controller != null &&
        controller.value.isInitialized &&
        !_isInitializing &&
        !_isProcessing;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (_cameras.isEmpty) {
      _errorMessage = 'No camera was found on this device.';
    } else {
      _initializeCamera(_cameras[_cameraIndex]);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _controller?.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed && _cameras.isNotEmpty) {
      _initializeCamera(_cameras[_cameraIndex]);
    }
  }

  Future<void> _initializeCamera(CameraDescription description) async {
    final previous = _controller;
    _controller = null;
    await previous?.dispose();

    if (mounted) {
      setState(() {
        _isInitializing = true;
        _errorMessage = null;
      });
    }

    final controller = CameraController(
      description,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await controller.initialize();
      _controller = controller;
      await _applyFlashMode(controller, _flashMode);
    } on CameraException catch (e) {
      _errorMessage = _describeError(e);
    }

    if (mounted) {
      setState(() => _isInitializing = false);
    }
  }

  /// Membuka pratinjau, lalu menghidupkan kembali kamera saat pengguna kembali
  /// dengan tombol Ambil Ulang. Controller lama bisa kehilangan preview setelah
  /// route kamera tertutup halaman lain.
  Future<void> _openPreview(String path, ScanSource source) async {
    await context.push(
      AppRoutes.cameraPreview,
      extra: PreviewArgs(path, source),
    );
    if (!mounted || _cameras.isEmpty) return;
    // Tunggu transisi pop selesai sebelum controller baru dipasang.
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted || _cameras.isEmpty) return;
    await _initializeCamera(_cameras[_cameraIndex]);
  }

  Future<void> _takePicture() async {
    final controller = _controller;
    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture ||
        _isProcessing) {
      return;
    }

    setState(() => _isProcessing = true);
    try {
      final XFile file = await controller.takePicture();
      final bytes = await File(file.path).readAsBytes();
      final path = await PhotoIntake.prepare(bytes, prefix: 'camera');
      if (!mounted) return;
      if (path == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto tidak bisa dibaca. Coba lagi.')),
        );
        return;
      }
      // Foto baru ditambahkan ke lemari setelah dikonfirmasi di halaman
      // pratinjau ("Gunakan Foto"); "Ambil Ulang" kembali ke sini.
      await _openPreview(path, ScanSource.camera);
    } on CameraException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_describeError(e))));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto tidak bisa dibaca. Coba lagi.')),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  /// Flash tidak tersedia di semua kamera (mis. kamera depan). Kegagalan
  /// pengaturan flash tidak boleh membuat preview kamera ikut gagal.
  Future<bool> _applyFlashMode(
    CameraController controller,
    FlashMode mode,
  ) async {
    try {
      await controller.setFlashMode(mode);
      return true;
    } on CameraException {
      return false;
    }
  }

  Future<void> _cycleFlash() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    final next = switch (_flashMode) {
      FlashMode.off => FlashMode.auto,
      FlashMode.auto => FlashMode.always,
      _ => FlashMode.off,
    };
    final ok = await _applyFlashMode(controller, next);
    if (!mounted) return;
    if (ok) {
      setState(() => _flashMode = next);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Flash tidak tersedia di kamera ini.')),
      );
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2 || _isInitializing) return;
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    await _initializeCamera(_cameras[_cameraIndex]);
  }

  /// Membuka galeri lalu lanjut ke pratinjau. Batal memilih tetap di kamera.
  Future<void> _openGallery() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    try {
      final path = await pickGalleryPhoto(context, ref);
      if (!mounted || path == null) return;
      await _openPreview(path, ScanSource.gallery);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  String _describeError(CameraException e) {
    switch (e.code) {
      case 'CameraAccessDenied':
      case 'CameraAccessDeniedWithoutPrompt':
        return 'Camera permission was denied. Please allow it in settings.';
      case 'CameraAccessRestricted':
        return 'Camera access is restricted on this device.';
      default:
        return 'Camera error: ${e.description ?? e.code}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(child: _buildPreview()),
                SafeArea(
                  bottom: false,
                  child: CameraOverlay(
                    onClose: () => context.pop(),
                    flashMode: _flashMode,
                    onFlash: _cycleFlash,
                  ),
                ),
              ],
            ),
          ),
          CameraControls(
            canCapture: _canCapture,
            canSwitch: _cameras.length >= 2,
            onCapture: _takePicture,
            onSwitch: _switchCamera,
            onGallery: _openGallery,
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.no_photography, size: 64, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(color: Colors.white),
              ),
              if (_cameras.isNotEmpty) ...[
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => _initializeCamera(_cameras[_cameraIndex]),
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text(
                    'Refresh',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    final controller = _controller;
    if (_isInitializing ||
        controller == null ||
        !controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    // Read the real camera size (sensor preview size, in landscape
    // coordinates) and size the preview panel to match it, so the image is
    // not squeezed. In portrait the width/height must be swapped.
    final Size? previewSize = controller.value.previewSize;
    final bool isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    final double cameraAspect;
    if (previewSize != null &&
        previewSize.width > 0 &&
        previewSize.height > 0) {
      cameraAspect = isPortrait
          ? previewSize.height / previewSize.width
          : previewSize.width / previewSize.height;
    } else {
      final double ratio = controller.value.aspectRatio;
      cameraAspect = isPortrait ? 1 / ratio : ratio;
    }

    // Fit the camera-sized panel into the available space (letterboxed).
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = width / cameraAspect;
        if (height > constraints.maxHeight) {
          height = constraints.maxHeight;
          width = height * cameraAspect;
        }
        return Center(
          child: SizedBox(
            width: width,
            height: height,
            child: CameraPreview(controller),
          ),
        );
      },
    );
  }
}
