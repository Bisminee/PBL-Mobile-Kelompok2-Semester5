import 'package:flutter/material.dart';

import '../../config/app_text_styles.dart';
import '../common/responsive.dart';

/// Panel hitam di bawah preview kamera: tile kiri (dekorasi), tombol shutter,
/// dan tombol ganti kamera.
///
/// Hanya tampilan; aksi dikirim lewat callback dari `CameraScreen`.
class CameraControls extends StatelessWidget {
  const CameraControls({
    super.key,
    required this.canCapture,
    required this.canSwitch,
    required this.onCapture,
    required this.onSwitch,
  });

  /// Shutter aktif hanya saat kamera siap.
  final bool canCapture;

  /// Tombol ganti kamera aktif jika perangkat punya lebih dari satu kamera.
  final bool canSwitch;

  final VoidCallback onCapture;
  final VoidCallback onSwitch;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 36),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ContentWidth(
              maxWidth: 420,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _leftTile(),
                  _shutter(),
                  _switchButton(),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'FOTO PAKAIAN',
              style: AppTextStyles.mono(10, color: Colors.white70, ls: 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _leftTile() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(Icons.dry_cleaning_outlined, size: 34),
    );
  }

  Widget _shutter() {
    return Semantics(
      button: true,
      label: 'Take picture',
      child: GestureDetector(
        onTap: canCapture ? onCapture : null,
        child: Opacity(
          opacity: canCapture ? 1 : 0.4,
          child: Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: const DecoratedBox(
              decoration:
                  BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            ),
          ),
        ),
      ),
    );
  }

  Widget _switchButton() {
    return Semantics(
      button: true,
      label: 'Switch camera',
      child: GestureDetector(
        onTap: canSwitch ? onSwitch : null,
        child: Opacity(
          opacity: canSwitch ? 1 : 0.4,
          child: Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Color(0xFF1D1D1F),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.cached, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
