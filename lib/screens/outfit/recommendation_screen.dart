import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../models/garment_labels.dart';
import '../../models/outfit.dart';
import '../../services/providers.dart';
import '../../services/recommender.dart';
import '../../widgets/common/circle_icon_button.dart';
import '../../widgets/common/pill_chip.dart';
import '../../widgets/common/responsive.dart';
import '../../widgets/outfit/outfit_compact_card.dart';

/// Daftar rekomendasi outfit atasan + bawahan dari lemari user, diurut skor pasangan model.
class RecommendationScreen extends ConsumerStatefulWidget {
  const RecommendationScreen({super.key});

  @override
  ConsumerState<RecommendationScreen> createState() =>
      _RecommendationScreenState();
}

class _RecommendationScreenState extends ConsumerState<RecommendationScreen> {
  // null = semua formalitas.
  String? _formality;

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(recommendationsProvider);
    final engineReady = ref.watch(engineProvider) != null;
    final list = _formality == null
        ? all
        : all.where((o) => o.formality == _formality).toList();

    void openDetail(Outfit o) => context.push(AppRoutes.detail, extra: o);

    Widget card(Outfit o) => OutfitCompactCard(
      title: o.title,
      score: (o.score * 100).round(),
      items:
          '${typeLabel(o.top.garmentType)} · ${typeLabel(o.bottom.garmentType)}',
      description: describeOutfit(o),
      tags: [formalityLabel(o.formality), 'Lemarimu'],
      onTap: () => openDetail(o),
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ContentWidth(
            maxWidth: 1040,
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
                    const CircleIconButton(icon: Icons.tune),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Rekomendasi Outfit', style: AppTextStyles.display),
                const SizedBox(height: 6),
                Text(
                  'Ditemukan berdasarkan pakaian yang kamu miliki.',
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
                    '${list.length} OUTFIT DITEMUKAN',
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
                const SizedBox(height: 14),
                if (list.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 40,
                      horizontal: 8,
                    ),
                    child: Text(
                      !engineReady
                          ? 'Rekomendasi hanya tersedia di Android dan iOS.'
                          : all.isEmpty
                          ? 'Tambahkan minimal satu atasan dan satu bawahan ke lemari untuk melihat rekomendasi.'
                          : 'Tidak ada outfit dengan formalitas ini.',
                      style: AppTextStyles.bodySecondary,
                    ),
                  )
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      const gap = 14.0;
                      // Layar lebar: dua kolom; layar sempit: satu kolom.
                      if (constraints.maxWidth >= 720) {
                        final w = (constraints.maxWidth - gap) / 2;
                        return Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            for (final o in list)
                              SizedBox(width: w, child: card(o)),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          for (var i = 0; i < list.length; i++) ...[
                            if (i > 0) const SizedBox(height: gap),
                            card(list[i]),
                          ],
                        ],
                      );
                    },
                  ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
