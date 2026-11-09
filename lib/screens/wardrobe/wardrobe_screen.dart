import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../models/garment_labels.dart';
import '../../services/providers.dart';
import '../../widgets/common/garment_photo.dart';
import '../../widgets/common/pill_chip.dart';
import '../../widgets/common/responsive.dart';
import '../../widgets/outfit/saved_outfit_card.dart';
import '../../widgets/wardrobe/clothing_grid_card.dart';

/// Tab Lemari: daftar pakaian dari SQLite dengan filter kategori,
/// plus sub-tab berisi outfit yang sudah disimpan pengguna.
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

  final TextEditingController _search = TextEditingController();
  String _filter = 'Semua';

  /// Filter formalitas untuk outfit tersimpan. Null = semua.
  String? _outfitFormality;

  /// false = daftar pakaian, true = daftar outfit tersimpan.
  bool _showOutfits = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(wardrobeProvider);
    final kueri = _search.text.trim().toLowerCase();

    // Item terbaru tampil paling atas.
    final list = all.reversed.where((g) {
      final cocokKategori = _filter == 'Semua' || g.category == _filter;
      final cocokTeks =
          kueri.isEmpty ||
          g.title.toLowerCase().contains(kueri) ||
          g.category.toLowerCase().contains(kueri) ||
          g.colorName.toLowerCase().contains(kueri);
      return cocokKategori && cocokTeks;
    }).toList();

    final outfits = ref.watch(savedOutfitsProvider);
    final semuaOutfit = outfits.valueOrNull ?? const [];
    final outfitTersaring = semuaOutfit.where((o) {
      final cocokTeks =
          kueri.isEmpty ||
          o.title.toLowerCase().contains(kueri) ||
          o.name.toLowerCase().contains(kueri);
      final cocokFormalitas =
          _outfitFormality == null || o.formality == _outfitFormality;
      return cocokTeks && cocokFormalitas;
    }).toList();

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
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _TabButton(
                    label: 'Pakaian',
                    selected: !_showOutfits,
                    onTap: () => setState(() => _showOutfits = false),
                  ),
                  const SizedBox(width: 8),
                  _TabButton(
                    label: 'Outfit Tersimpan',
                    selected: _showOutfits,
                    onTap: () => setState(() => _showOutfits = true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _SearchField(
                controller: _search,
                hint: _showOutfits ? 'Cari outfit' : 'Cari pakaian',
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 14),
            if (_showOutfits) ...[
              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    PillChip(
                      label: 'Semua',
                      selected: _outfitFormality == null,
                      onTap: () => setState(() => _outfitFormality = null),
                    ),
                    for (final f in formalityValues) ...[
                      const SizedBox(width: 8),
                      PillChip(
                        label: formalityLabel(f),
                        selected: _outfitFormality == f,
                        onTap: () => setState(() => _outfitFormality = f),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: outfits.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, _) => Center(
                    child: Text(
                      'Daftar outfit belum bisa dimuat.',
                      style: AppTextStyles.bodySecondary,
                    ),
                  ),
                  data: (_) => outfitTersaring.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              semuaOutfit.isEmpty
                                  ? 'Belum ada outfit tersimpan. Buka rekomendasi, '
                                        'lalu tekan "Simpan Outfit" pada detail paduan.'
                                  : 'Tidak ada outfit yang cocok dengan pencarian atau filter ini.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodySecondary,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(
                            24,
                            0,
                            24,
                            context.isExpanded ? 32 : 120,
                          ),
                          itemCount: outfitTersaring.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, i) =>
                              SavedOutfitCard(outfit: outfitTersaring[i]),
                        ),
                ),
              ),
            ] else ...[
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
                                : 'Tidak ada pakaian yang cocok dengan pencarian atau filter ini.',
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
                            colorValue: g.colorValue,
                            kind: clothingKindOf(g.garmentType, g.slot),
                            dark: g.isDark,
                            imagePath: g.imagePath,
                            onTap: () => context.push(
                              AppRoutes.clothingDetail,
                              extra: g,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Kotak pencarian yang benar-benar menyaring daftar di bawahnya.
class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.secondaryBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: AppTextStyles.body.copyWith(fontSize: 15),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: AppTextStyles.bodySecondary,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                controller.clear();
                onChanged('');
              },
              child: const Icon(Icons.close, size: 18),
            ),
        ],
      ),
    );
  }
}

/// Dua pilihan di atas daftar: pakaian atau outfit tersimpan.
class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : AppColors.secondaryBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelBold.copyWith(
              color: selected ? Colors.white : AppColors.textPrimary,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
