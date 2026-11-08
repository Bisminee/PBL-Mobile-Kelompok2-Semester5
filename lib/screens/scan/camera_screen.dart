import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../services/camera_service.dart';
import '../../services/gallery_service.dart';
import '../../widgets/scan/camera_controls.dart';
import '../../widgets/scan/camera_overlay.dart';

/// Layar kamera. Tampilan dari desain Sera-Z; logika kamera (inisialisasi,
/// lifecycle, ganti kamera, ambil foto, penanganan error) dari versi `lib`.
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  int _cameraIndex = 0;
  bool _isInitializing = false;
  String? _errorMessage;

  /// off -> auto -> torch -> off. Torch berarti lampu menyala terus.
  FlashMode _flashMode = FlashMode.off;

  List<CameraDescription> get _cameras => CameraService.cameras;

  bool get _canCapture {
    final controller = _controller;
    return controller != null &&
        controller.value.isInitialized &&
        !_isInitializing;
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
      // Terapkan ulang mode flash setelah kamera siap atau setelah ganti kamera.
      await _applyFlash(controller);
    } on CameraException catch (e) {
      _errorMessage = _describeError(e);
    }

    if (mounted) {
      setState(() => _isInitializing = false);
    }
  }

  Future<void> _takePicture() async {
    final controller = _controller;
    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture) {
      return;
    }

    try {
      final XFile file = await controller.takePicture();
      if (!mounted) return;
      // Foto baru ditambahkan ke lemari setelah dikonfirmasi di halaman
      // pratinjau ("Gunakan Foto"). Layar kamera diganti, bukan ditumpuk,
      // supaya kamera dilepas dan bisa dibuka lagi saat "Ambil Ulang".
      context.pushReplacement(AppRoutes.cameraPreview, extra: file.path);
    } on CameraException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_describeError(e))));
    }
  }

  /// Pilih foto yang sudah ada di galeri, lalu langsung ke pratinjau.
  Future<void> _pickFromGallery() async {
    try {
      final path = await GalleryService.pick();
      if (!mounted || path == null) return;
      context.pushReplacement(AppRoutes.cameraPreview, extra: path);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            kDebugMode
                ? 'Gagal membuka galeri.\n$error'
                : 'Gagal membuka galeri. Coba lagi.',
          ),
        ),
      );
      debugPrint('Galeri gagal dibuka: $error');
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2 || _isInitializing) return;
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    await _initializeCamera(_cameras[_cameraIndex]);
  }

  /// Menerapkan mode flash ke controller. Beberapa kamera depan tidak punya
  /// lampu, jadi kegagalan diabaikan dan mode dikembalikan ke off.
  Future<void> _applyFlash(CameraController controller) async {
    try {
      await controller.setFlashMode(_flashMode);
    } on CameraException {
      _flashMode = FlashMode.off;
      try {
        await controller.setFlashMode(FlashMode.off);
      } on CameraException {
        // Perangkat tidak mendukung flash sama sekali.
      }
    }
  }

  /// Ganti mode flash: mati -> otomatis -> menyala terus.
  Future<void> _cycleFlash() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    final berikut = switch (_flashMode) {
      FlashMode.off => FlashMode.auto,
      FlashMode.auto => FlashMode.torch,
      _ => FlashMode.off,
    };

    setState(() => _flashMode = berikut);
    await _applyFlash(controller);

    if (!mounted) return;
    final pesan = switch (_flashMode) {
      FlashMode.auto => 'Flash otomatis.',
      FlashMode.torch => 'Flash menyala.',
      _ => 'Flash mati.',
    };
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(pesan), duration: const Duration(seconds: 1)),
      );
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
            onGallery: _pickFromGallery,
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
