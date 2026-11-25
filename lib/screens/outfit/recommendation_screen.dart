import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../models/garment.dart';
import '../../models/garment_labels.dart';
import '../../models/outfit.dart';
import '../../models/saved_outfit.dart';
import '../../services/providers.dart';
import '../../services/recommender.dart';
import '../../widgets/common/circle_icon_button.dart';
import '../../widgets/common/garment_photo.dart';
import '../../widgets/common/pill_chip.dart';
import '../../widgets/common/responsive.dart';
import '../../widgets/outfit/outfit_compact_card.dart';

/// Daftar rekomendasi outfit per piece di lemari.
///
/// Setiap atasan atau bawahan mendapat maksimal tiga outfit terbaik. Bila
/// [anchor] diisi, halaman hanya menampilkan rekomendasi untuk piece itu.
class RecommendationScreen extends ConsumerStatefulWidget {
  const RecommendationScreen({super.key, this.anchor});

  final Garment? anchor;

  @override
  ConsumerState<RecommendationScreen> createState() =>
      _RecommendationScreenState();
}

class _RecommendationScreenState extends ConsumerState<RecommendationScreen> {
  // null = semua formalitas.
  String? _formality;

  List<RecommendationGroup> _visibleGroups(
    List<RecommendationGroup> groups,
    List<SavedOutfit> saved,
  ) {
    final anchor = widget.anchor;
    return [
      for (final group in groups)
        if (anchor == null || group.anchor.id == anchor.id)
          RecommendationGroup(
            anchor: group.anchor,
            outfits: group.outfits
                .where(
                  (o) =>
                      (_formality == null || o.formality == _formality) &&
                      !isOutfitSaved(o, saved),
                )
                .toList(),
          ),
    ].where((group) => group.outfits.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(recommendationGroupsProvider);
    final savedState = ref.watch(savedOutfitsProvider);
    final saved = savedState.isLoading
        ? const <SavedOutfit>[]
        : (savedState.valueOrNull ?? const <SavedOutfit>[]);
    final visible = _visibleGroups(groups, saved);
    final engineReady = ref.watch(engineProvider) != null;
    final anchor = widget.anchor;

    void openDetail(Outfit o) => context.push(AppRoutes.detail, extra: o);

    Widget card(Outfit o, int rank) => OutfitCompactCard(
      title: o.title,
      score: (o.score * 100).round(),
      rank: rank,
      items:
          '${typeLabel(o.top.garmentType)} · ${typeLabel(o.bottom.garmentType)}',
      description: describeOutfit(o),
      reasons: o.reasons,
      tags: [formalityLabel(o.formality), 'Lemariku'],
      top: o.top,
      bottom: o.bottom,
      onTap: () => openDetail(o),
    );

    Widget groupSection(RecommendationGroup group) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 52,
              height: 52,
              child: GarmentPhoto(
                imagePath: group.anchor.imagePath,
                kind: clothingKindOf(
                  group.anchor.garmentType,
                  group.anchor.slot,
                ),
                dark: group.anchor.isDark,
                radius: 14,
                iconSize: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(group.anchor.title, style: AppTextStyles.title),
                  Text(
                    '${group.anchor.category} · ${group.outfits.length} rekomendasi',
                    style: AppTextStyles.mono(10),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < group.outfits.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          card(group.outfits[i], i + 1),
        ],
      ],
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ContentWidth(
            maxWidth: 760,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleIconButton(
                      icon: Icons.chevron_left,
                      onPressed: () => context.pop(),
                    ),
                    Row(
                      children: [
                        CircleIconButton(
                          icon: Icons.history,
                          onPressed: () =>
                              context.push(AppRoutes.recommendationHistory),
                        ),
                        const SizedBox(width: 8),
                        const CircleIconButton(icon: Icons.tune),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Rekomendasi Outfit', style: AppTextStyles.display),
                const SizedBox(height: 6),
                Text(
                  anchor == null
                      ? 'Tiga outfit terbaik untuk setiap pakaian di lemarimu.'
                      : 'Rekomendasi outfit untuk ${anchor.title}.',
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: 14),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      PillChip(
                        label: 'Semua',
                        selected: _formality == null,
                        onTap: () => setState(() => _formality = null),
                      ),
                      for (final f in formalityValues) ...[
                        const SizedBox(width: 8),
                        PillChip(
                          label: formalityLabel(f),
                          selected: f == _formality,
                          onTap: () => setState(() => _formality = f),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    '${visible.fold<int>(0, (n, g) => n + g.outfits.length)} REKOMENDASI DITEMUKAN',
                    style: AppTextStyles.mono(10),
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Text(
                    'Angka skor adalah posisi pasangan dibanding semua kombinasi atasan-bawahan '
                    'di data stylist, bukan peluang outfit ini benar.',
                    style: AppTextStyles.label.copyWith(fontSize: 11),
                  ),
                ),
                const SizedBox(height: 18),
                if (visible.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 40,
                      horizontal: 8,
                    ),
                    child: Text(
                      _emptyMessage(
                        anchor: anchor,
                        engineReady: engineReady,
                        groups: groups,
                      ),
                      style: AppTextStyles.bodySecondary,
                    ),
                  )
                else
                  for (var i = 0; i < visible.length; i++) ...[
                    if (i > 0) const SizedBox(height: 26),
                    groupSection(visible[i]),
                  ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _emptyMessage({
    required Garment? anchor,
    required bool engineReady,
    required List<RecommendationGroup> groups,
  }) {
    if (anchor != null && anchor.slot != 'top' && anchor.slot != 'bottom') {
      return 'Item ini belum punya pasangan outfit. Rekomendasi saat ini '
          'tersedia untuk atasan dan bawahan.';
    }
    if (anchor != null &&
        !groups.any((group) => group.anchor.id == anchor.id)) {
      return 'Belum ada pasangan untuk ${anchor.title}. Tambahkan atasan atau '
          'bawahan lain ke lemari.';
    }
    if (!engineReady) {
      return 'Rekomendasi hanya tersedia di Android dan iOS.';
    }
    if (groups.isEmpty) {
      return 'Tambahkan minimal satu atasan dan satu bawahan ke lemari untuk '
          'melihat rekomendasi.';
    }
    return 'Semua rekomendasi dengan filter ini sudah disimpan atau tidak '
        'tersedia.';
  }
}
