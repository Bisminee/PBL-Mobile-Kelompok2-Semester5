import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/app_routes.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../widgets/clothing_thumb.dart';
import '../widgets/pill_chip.dart';
import '../widgets/clothing_grid_card.dart';

class _Item {
  const _Item(this.name, this.category, this.color, this.kind, this.dark);
  final String name;
  final String category;
  final String color;
  final ClothingKind kind;
  final bool dark;
}

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  static const _filters = ['Semua', 'Atasan', 'Bawahan', 'Sepatu'];
  static const _items = [
    _Item('Kaos Hitam Basic', 'Atasan', 'Hitam', ClothingKind.top, true),
    _Item('Sneakers Hitam', 'Sepatu', 'Hitam', ClothingKind.shoes, true),
    _Item('Chinos Putih', 'Bawahan', 'Putih', ClothingKind.bottom, false),
    _Item('Kemeja Putih', 'Atasan', 'Putih', ClothingKind.shirt, false),
  ];

  String _filter = 'Semua';

  @override
  Widget build(BuildContext context) {
    final list = _filter == 'Semua'
        ? _items
        : _items.where((e) => e.category == _filter).toList();

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lemari Saya', style: AppTextStyles.display.copyWith(fontSize: 30)),
                    const SizedBox(height: 4),
                    Text('12 item pakaian', style: AppTextStyles.label),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => context.push(AppRoutes.camera),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                      color: AppColors.accent, shape: BoxShape.circle),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(children: [
                    const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text('Cari pakaian', style: AppTextStyles.bodySecondary),
                  ]),
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
            ]),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => PillChip(
                label: _filters[i],
                selected: _filters[i] == _filter,
                onTap: () => setState(() => _filter = _filters[i]),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final e = list[i];
                return ClothingGridCard(
                  name: e.name,
                  category: e.category,
                  colorName: e.color,
                  colorDark: e.color == 'Hitam',
                  kind: e.kind,
                  dark: e.dark,
                  onTap: () => context.push(AppRoutes.clothingDetail),
                );
              },
            ),
          ),
<<<<<<< Updated upstream
          const SizedBox(height: 80),
=======
>>>>>>> Stashed changes
        ],
      ),
    );
  }
}
