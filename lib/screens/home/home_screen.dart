import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../models/garment.dart';
import '../../models/garment_labels.dart';
import '../../services/providers.dart';
import '../../services/recommender.dart';
import '../../widgets/common/garment_photo.dart';
import '../../widgets/common/responsive.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/home/home_hero_banner.dart';
import '../../widgets/home/recommendation_card.dart';

/// Tab Home: sapaan, banner foto pakaian, ringkasan lemari, dan rekomendasi.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tablet / laptop: daftar horizontal diganti grid yang membungkus ke bawah,
    // karena mouse/trackpad kurang nyaman untuk scroll horizontal.
    final wide = context.isMediumUp;
    final now = DateTime.now();
    final user = ref.watch(authProvider);
    final wardrobe = ref.watch(wardrobeProvider);
    final outfits = ref.watch(recommendationsProvider).take(5).toList();

    final miniItems = <Widget>[
      for (final g in wardrobe.reversed.take(6))
        _MiniItem(
          g,
          onTap: () => context.push(AppRoutes.clothingDetail, extra: g),
        ),
    ];

    final recommendations = <Widget>[
      for (final o in outfits)
        RecommendationCard(
          title: o.title,
          matchLabel: 'SKOR ${(o.score * 100).round()}',
          score: (o.score * 100).round(),
          description: describeOutfit(o),
          onTap: () => context.push(AppRoutes.detail, extra: o),
        ),
    ];

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: context.isExpanded ? 32 : 120),
        child: ContentWidth(
          maxWidth: 1040,
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
                          Text(
                            formatDayDateId(now),
                            style: AppTextStyles.mono(11),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            greetingId(now.hour),
                            style: AppTextStyles.label,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Siap menentukan\noutfit hari ini?',
                            style: AppTextStyles.h1.copyWith(fontSize: 26),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.profile),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: AppColors.secondaryBg,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          user?.initials ?? '?',
                          style: AppTextStyles.title,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: HomeHeroBanner(
                  height: wide ? 340 : 400,
                  onCamera: () => context.push(AppRoutes.camera),
                  onGallery: () => context.push(AppRoutes.cameraPreview),
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SectionHeader(
                  title: 'Lemari Saya',
                  subtitle: '${wardrobe.length} item pakaian',
                  actionLabel: 'Lihat Semua',
                  onAction: () => context.go(AppRoutes.wardrobe),
                ),
              ),
              const SizedBox(height: 14),
              if (miniItems.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Lemari masih kosong. Foto pakaianmu lewat kamera.',
                    style: AppTextStyles.bodySecondary,
                  ),
                )
              else if (wide)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Wrap(runSpacing: 12, children: miniItems),
                )
              else
                SizedBox(
                  height: 130,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: miniItems,
                  ),
                ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SectionHeader(
                  title: 'Rekomendasi Untukmu',
                  subtitle: 'Dipadukan dari lemarimu',
                  actionLabel: 'Lihat Semua',
                  onAction: () => context.push(AppRoutes.recommendation),
                ),
              ),
              const SizedBox(height: 14),
              if (recommendations.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Butuh minimal satu atasan dan satu bawahan di lemari untuk membuat rekomendasi.',
                    style: AppTextStyles.bodySecondary,
                  ),
                )
              else if (wide)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: recommendations,
                  ),
                )
              else
                SizedBox(
                  height: 330,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      for (var i = 0; i < recommendations.length; i++) ...[
                        if (i > 0) const SizedBox(width: 12),
                        recommendations[i],
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniItem extends StatelessWidget {
  const _MiniItem(this.garment, {required this.onTap});
  final Garment garment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 96,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 96,
                width: 96,
                child: GarmentPhoto(
                  imagePath: garment.imagePath,
                  kind: clothingKindOf(garment.garmentType, garment.slot),
                  dark: garment.isDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                garment.title,
                style: AppTextStyles.labelBold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
