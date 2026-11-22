import 'package:camera/camera.dart' show FlashMode;
import 'package:flutter/material.dart';

import '../../config/app_text_styles.dart';
import '../common/circle_icon_button.dart';
import '../common/corner_frame.dart';

/// Lapisan di atas preview kamera: tombol tutup, label "AI SCAN",
/// bingkai sudut, dan petunjuk posisi pakaian.
///
/// Hanya tampilan; aksi kamera dikirim lewat callback dari `CameraScreen`.
class CameraOverlay extends StatelessWidget {
  const CameraOverlay({
    super.key,
    required this.onClose,
    required this.flashMode,
    required this.onFlash,
  });

  final VoidCallback onClose;
  final FlashMode flashMode;
  final VoidCallback onFlash;

  static const _dim = Color(0x99000000);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [_topBar(), _guideFrame(), _hint()]);
  }

  Widget _topBar() {
    return Positioned(
      top: 8,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleIconButton(
            icon: Icons.close,
            background: _dim,
            iconColor: Colors.white,
            onPressed: onClose,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _dim,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const CircleAvatar(radius: 3, backgroundColor: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'AI SCAN',
                  style: AppTextStyles.mono(10, color: Colors.white),
                ),
              ],
            ),
          ),
          Semantics(
            button: true,
            label: switch (flashMode) {
              FlashMode.off => 'Nyalakan flash otomatis',
              FlashMode.auto => 'Nyalakan flash terus',
              FlashMode.always => 'Matikan flash',
              FlashMode.torch => 'Matikan lampu',
            },
            child: CircleIconButton(
              icon: switch (flashMode) {
                FlashMode.off => Icons.flash_off,
                FlashMode.auto => Icons.flash_auto,
                FlashMode.always || FlashMode.torch => Icons.flash_on,
              },
              background: _dim,
              iconColor: Colors.white,
              onPressed: onFlash,
            ),
          ),
        ],
      ),
    );
  }

  Widget _guideFrame() {
    return const Positioned.fill(
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
    );
  }

  Widget _hint() {
    return Positioned(
      bottom: 24,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xFF6E6E73),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Posisikan pakaian di dalam frame',
            style: AppTextStyles.labelBold.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
