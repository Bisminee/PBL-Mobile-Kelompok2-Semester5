import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../services/camera_service.dart';
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
      // pratinjau ("Gunakan Foto"); "Ambil Ulang" kembali ke sini.
      context.push(AppRoutes.cameraPreview, extra: file.path);
    } on CameraException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_describeError(e))),
      );
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2 || _isInitializing) return;
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    await _initializeCamera(_cameras[_cameraIndex]);
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
                  child: CameraOverlay(onClose: () => context.pop()),
                ),
              ],
            ),
          ),
          CameraControls(
            canCapture: _canCapture,
            canSwitch: _cameras.length >= 2,
            onCapture: _takePicture,
            onSwitch: _switchCamera,
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
                  label: const Text('Refresh',
                      style: TextStyle(color: Colors.white)),
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
          child: CircularProgressIndicator(color: Colors.white));
    }

    return Center(
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      ),
    );
  }
}
