import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../services/providers.dart';
import '../../widgets/common/garment_photo.dart';
import '../../widgets/common/pill_chip.dart';
import '../../widgets/common/responsive.dart';
import '../../widgets/wardrobe/clothing_grid_card.dart';

/// Tab Lemari: daftar pakaian dari SQLite dengan filter kategori.
class WardrobeScreen extends ConsumerStatefulWidget {
  const WardrobeScreen({super.key});

  @override
  ConsumerState<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends ConsumerState<WardrobeScreen> {
  // Nilai filter sama dengan Garment.category (lihat categoryOfSlot).
  static const _filters = [
    'Semua',
    'Atasan',
    'Bawahan',
    'Terusan',
    'Luaran',
    'Sepatu',
    'Aksesori',
  ];

  String _filter = 'Semua';

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(wardrobeProvider);
    // Item terbaru tampil paling atas.
    final list = all.reversed
        .where((g) => _filter == 'Semua' || g.category == _filter)
        .toList();

    return SafeArea(
      bottom: false,
      child: ContentWidth(
        maxWidth: 1040,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lemari Saya',
                          style: AppTextStyles.display.copyWith(fontSize: 30),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${all.length} item pakaian',
                          style: AppTextStyles.label,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.camera),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Cari pakaian',
                            style: AppTextStyles.bodySecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.tune, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _filters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, i) => PillChip(
                  label: _filters[i],
                  selected: _filters[i] == _filter,
                  onTap: () => setState(() => _filter = _filters[i]),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: list.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          all.isEmpty
                              ? 'Lemari masih kosong. Tekan tombol + untuk memotret pakaian pertamamu.'
                              : 'Tidak ada pakaian di kategori ini.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySecondary,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.fromLTRB(
                        24,
                        0,
                        24,
                        context.isExpanded ? 32 : 120,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.78,
                          ),
                      itemCount: list.length,
                      itemBuilder: (_, i) {
                        final g = list[i];
                        return ClothingGridCard(
                          name: g.title,
                          category: g.category,
                          colorName: g.colorName,
                          colorDark: g.isDark,
                          kind: clothingKindOf(g.garmentType, g.slot),
                          dark: g.isDark,
                          onTap: () =>
                              context.push(AppRoutes.clothingDetail, extra: g),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
