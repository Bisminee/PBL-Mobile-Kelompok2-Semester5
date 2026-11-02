import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../../models/garment.dart';
import '../../models/garment_labels.dart';
import '../../models/outfit.dart';
import '../../services/providers.dart';
import '../../services/recommender.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/circle_icon_button.dart';
import '../../widgets/common/garment_photo.dart';
import '../../widgets/common/match_ring.dart';
import '../../widgets/common/responsive.dart';
import '../../widgets/outfit/outfit_item_row.dart';

/// Detail satu outfit: item, harmoni warna, alasan, dan saran item pelengkap.
/// Outfit dikirim lewat `extra` dari go_router.
class DetailScreen extends ConsumerStatefulWidget {
  const DetailScreen({super.key, this.outfit});

  final Outfit? outfit;

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  bool _saved = false;

  static const _reasonTitles = ['Harmoni warna', 'Formalitas', 'Skor pasangan'];

  Future<void> _saveOutfit(Outfit o) async {
    if (_saved) return;
    final ids = [
      int.tryParse(o.top.id),
      int.tryParse(o.bottom.id),
    ].whereType<int>().toList();
    if (ids.length < 2) return;
    try {
      await ref
          .read(localDbProvider)
          .saveOutfit(o.title, o.formality ?? 'non_formal', o.score, ids);
      if (!mounted) return;
      setState(() => _saved = true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Outfit disimpan.')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan outfit. Coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.outfit;
    if (o == null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Outfit tidak ditemukan.', style: AppTextStyles.title),
                  const SizedBox(height: 16),
                  AppButton(label: 'Kembali', onPressed: () => context.pop()),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final pct = (o.score * 100).round();
    final relation = colorRelation(o.top.colorFamily, o.bottom.colorFamily);
    final suggestions = ref.watch(suggestionsProvider(o));

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
              child: ContentWidth(
                maxWidth: 720,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleIconButton(
                          icon: Icons.chevron_left,
                          onPressed: () => context.pop(),
                        ),
                        const CircleIconButton(icon: Icons.more_horiz),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      height: 230,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.textPrimary),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: _photo(o.top)),
                          const SizedBox(width: 8),
                          Expanded(child: _photo(o.bottom)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('OUTFIT DARI LEMARIMU', style: AppTextStyles.mono(10)),
                    const SizedBox(height: 4),
                    Text(o.title, style: AppTextStyles.display),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        MatchRing(value: pct, size: 40),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Skor $pct', style: AppTextStyles.title),
                              Text(
                                'Posisi di antara semua kombinasi atasan-bawahan',
                                style: AppTextStyles.label,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: AppColors.border, height: 1),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          _Fact('Color Harmony', relation),
                          const VerticalDivider(
                            width: 1,
                            color: AppColors.border,
                          ),
                          _Fact('Style', styleLabel(o.top.style)),
                          const VerticalDivider(
                            width: 1,
                            color: AppColors.border,
                          ),
                          _Fact('Formalitas', formalityLabel(o.formality)),
                        ],
                      ),
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Text('Items', style: AppTextStyles.h3),
                        const SizedBox(width: 6),
                        Text('2', style: AppTextStyles.mono(11)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    for (final g in [o.top, o.bottom])
                      OutfitItemRow(
                        name: g.title,
                        meta: '${g.category} · ${g.colorName}',
                        badge: 'LEMARI',
                        kind: clothingKindOf(g.garmentType, g.slot),
                        dark: g.isDark,
                      ),
                    const SizedBox(height: 22),
                    Text('Color Harmony', style: AppTextStyles.h3),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 72,
                            height: 40,
                            child: Stack(
                              children: [
                                _Swatch(0, o.top.colorValue),
                                _Swatch(28, o.bottom.colorValue),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(relation, style: AppTextStyles.title),
                                Text(
                                  '${o.top.colorName} · ${o.bottom.colorName}',
                                  style: AppTextStyles.label,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text('Kenapa cocok', style: AppTextStyles.h3),
                    const SizedBox(height: 12),
                    for (var i = 0; i < o.reasons.length; i++)
                      _Reason(
                        '0${i + 1}',
                        i < _reasonTitles.length ? _reasonTitles[i] : 'Catatan',
                        o.reasons[i],
                      ),
                    const SizedBox(height: 6),
                    Text('Pelengkap yang disarankan', style: AppTextStyles.h3),
                    const SizedBox(height: 4),
                    Text(
                      'Deskripsi dari katalog dataset, bukan foto produk.',
                      style: AppTextStyles.label.copyWith(fontSize: 11),
                    ),
                    const SizedBox(height: 12),
                    suggestions.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (_, _) => Text(
                        'Saran pelengkap belum bisa dimuat.',
                        style: AppTextStyles.bodySecondary,
                      ),
                      data: (map) => _Suggestions(map),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => _saveOutfit(o),
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(color: Color(0x33000000), blurRadius: 16),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _saved ? Icons.bookmark : Icons.bookmark_border,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _saved ? 'Tersimpan' : 'Simpan Outfit',
                        style: AppTextStyles.button.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _photo(Garment g) => GarmentPhoto(
    imagePath: g.imagePath,
    kind: clothingKindOf(g.garmentType, g.slot),
    dark: g.isDark,
    iconSize: 50,
  );
}

/// Saran per slot kosong (sepatu, luaran, tas), maksimal tiga per slot.
class _Suggestions extends StatelessWidget {
  const _Suggestions(this.data);
  final Map<String, List<Map<String, dynamic>>> data;

  @override
  Widget build(BuildContext context) {
    final rows = data.entries.where((e) => e.value.isNotEmpty).toList();
    if (rows.isEmpty) {
      return Text(
        'Belum ada saran untuk kombinasi ini.',
        style: AppTextStyles.bodySecondary,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final e in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    slotLabel(e.key),
                    style: AppTextStyles.title.copyWith(fontSize: 14),
                  ),
                ),
                Expanded(
                  child: Text(
                    e.value
                        .map(
                          (m) =>
                              '${typeLabel(m['garment_type'] as String?)} ${colorLabel(m['color_family'] as String?).toLowerCase()}',
                        )
                        .join(', '),
                    style: AppTextStyles.bodySecondary.copyWith(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.label.copyWith(fontSize: 10)),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.labelBold.copyWith(fontSize: 13)),
        ],
      ),
    ),
  );
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.left, this.color);
  final double left;
  final Color color;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
    ),
  );
}

class _Reason extends StatelessWidget {
  const _Reason(this.no, this.title, this.desc);
  final String no;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 30, child: Text(no, style: AppTextStyles.mono(11))),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.title.copyWith(fontSize: 15)),
              const SizedBox(height: 2),
              Text(
                desc,
                style: AppTextStyles.bodySecondary.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
