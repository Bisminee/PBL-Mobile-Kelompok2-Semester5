import 'package:flutter/material.dart';

import '../config/app_text_styles.dart';

/// Banner besar "Temukan outfit yang cocok".
/// Ganti `_bg` dengan foto asli: `Image.asset('assets/images/hero.jpg', fit: BoxFit.cover)`.
class HomeHeroBanner extends StatelessWidget {
  const HomeHeroBanner({super.key, required this.onCamera, required this.onGallery});

  final VoidCallback onCamera;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: SizedBox(
        height: 400,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const _Bg(),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xCC000000)],
                  stops: [0.4, 1],
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Temukan outfit\nyang cocok',
                      style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 26)),
                  const SizedBox(height: 6),
                  Text('Foto pakaianmu dan biarkan Sera-Z\nmenemukan kombinasinya.',
                      style: AppTextStyles.body.copyWith(color: Colors.white)),
                  const SizedBox(height: 16),
                  Row(children: [
                    _PillBtn(
                        label: 'Foto Pakaian',
                        icon: Icons.photo_camera_outlined,
                        dark: true,
                        onTap: onCamera),
                    const SizedBox(width: 10),
                    _PillBtn(
                        label: 'Galeri',
                        icon: Icons.image_outlined,
                        dark: false,
                        onTap: onGallery),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bg extends StatelessWidget {
  const _Bg();

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFBDBDC2), Color(0xFF3A3A3D)],
          ),
        ),
      );
}

class _PillBtn extends StatelessWidget {
  const _PillBtn({required this.label, required this.icon, required this.dark, required this.onTap});

  final String label;
  final IconData icon;
  final bool dark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = dark ? Colors.white : Colors.black;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: dark ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyles.labelBold.copyWith(color: fg, fontSize: 13)),
        ]),
      ),
    );
  }
}
