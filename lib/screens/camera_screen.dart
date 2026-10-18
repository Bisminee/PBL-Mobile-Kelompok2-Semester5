import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/app_routes.dart';
import '../config/app_text_styles.dart';
import '../services/camera_service.dart';
import '../widgets/circle_icon_button.dart';
import '../widgets/corner_frame.dart';

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
    const overlay = Color(0x99000000);

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
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8,
                        left: 20,
                        right: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleIconButton(
                              icon: Icons.close,
                              background: overlay,
                              iconColor: Colors.white,
                              onPressed: () => context.pop(),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                  color: overlay,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(children: [
                                const CircleAvatar(
                                    radius: 3, backgroundColor: Colors.white),
                                const SizedBox(width: 8),
                                Text('AI SCAN',
                                    style: AppTextStyles.mono(10,
                                        color: Colors.white)),
                              ]),
                            ),
                            const CircleIconButton(
                              icon: Icons.bolt,
                              background: overlay,
                              iconColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 64,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0x22000000), blurRadius: 10)
                              ],
                            ),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              const CircleAvatar(
                                  radius: 3, backgroundColor: Colors.black),
                              const SizedBox(width: 8),
                              Text('Kaos terdeteksi',
                                  style: AppTextStyles.labelBold),
                            ]),
                          ),
                        ),
                      ),
                      const Positioned.fill(
                        top: 92,
                        bottom: 70,
                        left: 28,
                        right: 28,
                        child: IgnorePointer(
                          child: CornerFrame(
                            color: Colors.white,
                            cornerLength: 42,
                            radius: 18,
                            child: SizedBox.expand(),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 24,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 9),
                            decoration: BoxDecoration(
                                color: const Color(0xFF6E6E73),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text('Posisikan pakaian di dalam frame',
                                style: AppTextStyles.labelBold
                                    .copyWith(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.black,
            padding: const EdgeInsets.fromLTRB(32, 24, 32, 36),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14)),
                        child:
                            const Icon(Icons.dry_cleaning_outlined, size: 34),
                      ),
                      Semantics(
                        button: true,
                        label: 'Take picture',
                        child: GestureDetector(
                          onTap: _canCapture ? _takePicture : null,
                          child: Opacity(
                            opacity: _canCapture ? 1 : 0.4,
                            child: Container(
                              width: 80,
                              height: 80,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 4),
                              ),
                              child: const DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Semantics(
                        button: true,
                        label: 'Switch camera',
                        child: GestureDetector(
                          onTap: _cameras.length < 2 ? null : _switchCamera,
                          child: Opacity(
                            opacity: _cameras.length < 2 ? 0.4 : 1,
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                  color: Color(0xFF1D1D1F),
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.cached,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text('FOTO PAKAIAN',
                      style: AppTextStyles.mono(10,
                          color: Colors.white70, ls: 2)),
                ],
              ),
            ),
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
