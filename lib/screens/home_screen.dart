import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/app_routes.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../widgets/clothing_thumb.dart';
import '../widgets/section_header.dart';
import '../widgets/home_hero_banner.dart';
import '../widgets/recommendation_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Minggu, 27 Sep', style: AppTextStyles.mono(11)),
                        const SizedBox(height: 10),
                        Text('Good Morning,', style: AppTextStyles.label),
                        const SizedBox(height: 4),
                        Text('Siap menentukan\noutfit hari ini?',
                            style: AppTextStyles.h1.copyWith(fontSize: 26)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.profile),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                          color: AppColors.secondaryBg, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: Text('F', style: AppTextStyles.title),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: HomeHeroBanner(
                onCamera: () => context.push(AppRoutes.camera),
                onGallery: () =>
                    context.push(AppRoutes.cameraPreview),
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SectionHeader(
                title: 'Lemari Saya',
                subtitle: '12 item pakaian',
                actionLabel: 'Lihat Semua',
                onAction: () {},
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 130,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: const [
                  _MiniItem('Kaos Hitam', ClothingKind.top, true),
                  _MiniItem('Kemeja Putih', ClothingKind.shirt, false),
                  _MiniItem('Chino Putih', ClothingKind.bottom, false),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SectionHeader(
                title: 'Rekomendasi Untukmu',
                subtitle: 'Dipadukan dari lemarimu',
                actionLabel: 'Lihat Semua',
                onAction: () =>
                    context.push(AppRoutes.recommendation),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 330,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  RecommendationCard(
                    title: 'Casual Monochrome',
                    matchLabel: '94% COCOK',
                    score: 94,
                    description:
                        'Kaos hitam dan celana putih memberi kontras tegas, tetap santai untuk kampus.',
                    onTap: () => context.push(AppRoutes.detail),
                  ),
                  const SizedBox(width: 12),
                  RecommendationCard(
                    title: 'Soft Neutral',
                    matchLabel: '88% COCOK',
                    score: 88,
                    description: 'Tone lembut dengan sentuhan netral yang nyaman dipakai harian.',
                    onTap: () => context.push(AppRoutes.detail),
                  ),
                ],
              ),
            ),
<<<<<<< Updated upstream
          ),
          const SizedBox(height: 80),
        ],
=======
          ],
        ),
>>>>>>> Stashed changes
      ),
    );
  }
}

class _MiniItem extends StatelessWidget {
  const _MiniItem(this.name, this.kind, this.dark);
  final String name;
  final ClothingKind kind;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: SizedBox(
        width: 96,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 96,
              width: 96,
              child: ClothingThumb(kind: kind, dark: dark, iconSize: 40),
            ),
            const SizedBox(height: 6),
            Text(name, style: AppTextStyles.labelBold, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
