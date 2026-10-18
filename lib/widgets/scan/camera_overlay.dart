import 'package:flutter/material.dart';

import '../../config/app_text_styles.dart';
import '../common/circle_icon_button.dart';
import '../common/corner_frame.dart';

/// Lapisan di atas preview kamera: tombol tutup, label "AI SCAN",
/// chip deteksi, bingkai sudut, dan petunjuk posisi pakaian.
///
/// Hanya tampilan; tidak punya logika kamera.
class CameraOverlay extends StatelessWidget {
  const CameraOverlay({super.key, required this.onClose});

  final VoidCallback onClose;

  static const _dim = Color(0x99000000);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _topBar(),
        _detectionChip(),
        _guideFrame(),
        _hint(),
      ],
    );
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
            child: Row(children: [
              const CircleAvatar(radius: 3, backgroundColor: Colors.white),
              const SizedBox(width: 8),
              Text('AI SCAN',
                  style: AppTextStyles.mono(10, color: Colors.white)),
            ]),
          ),
          // Flash: belum ada logikanya (sama seperti desain awal).
          const CircleIconButton(
            icon: Icons.bolt,
            background: _dim,
            iconColor: Colors.white,
          ),
        ],
      ),
    );
  }

  /// Chip "Kaos terdeteksi" masih tiruan sampai Model 1 (jenis pakaian) terpasang.
  Widget _detectionChip() {
    return Positioned(
      top: 64,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Color(0x22000000), blurRadius: 10),
            ],
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const CircleAvatar(radius: 3, backgroundColor: Colors.black),
            const SizedBox(width: 8),
            Text('Kaos terdeteksi', style: AppTextStyles.labelBold),
          ]),
        ),
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
