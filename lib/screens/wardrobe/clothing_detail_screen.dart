import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../models/garment.dart';
import '../../models/garment_labels.dart';
import '../../services/providers.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/circle_icon_button.dart';
import '../../widgets/common/garment_photo.dart';
import '../../widgets/common/responsive.dart';

/// Detail satu pakaian di lemari. Pakaian dikirim lewat `extra` dari go_router.
class ClothingDetailScreen extends ConsumerWidget {
  const ClothingDetailScreen({super.key, this.garment});

  final Garment? garment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final g = garment;
    if (g == null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Pakaian tidak ditemukan.', style: AppTextStyles.title),
                  const SizedBox(height: 16),
                  AppButton(label: 'Kembali', onPressed: () => context.pop()),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Layar lebar: foto di kiri, detail di kanan.
          if (constraints.maxWidth >= Breakpoints.expanded) {
            return SafeArea(
              child: ContentWidth(
                maxWidth: 1040,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _hero(context, g, wide: true)),
                      const SizedBox(width: 32),
                      Expanded(
                        child: SingleChildScrollView(
                          child: _details(context, ref, g, wide: true),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: ContentWidth(
              maxWidth: 640,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _hero(context, g, wide: false),
                  _details(context, ref, g, wide: false),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _hero(BuildContext context, Garment g, {required bool wide}) {
    final stack = Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: GarmentPhoto(
            imagePath: g.imagePath,
            kind: clothingKindOf(g.garmentType, g.slot),
            dark: g.isDark,
            radius: 0,
            iconSize: 170,
            background: Colors.transparent,
          ),
        ),
        Positioned(
          top: 12,
          left: 20,
          child: CircleIconButton(
            icon: Icons.chevron_left,
            background: Colors.white,
            onPressed: () => context.pop(),
          ),
        ),
        const Positioned(
          top: 12,
          right: 20,
          child: CircleIconButton(
            icon: Icons.edit_outlined,
            background: Colors.white,
          ),
        ),
      ],
    );

    return Container(
      height: wide ? 520 : 400,
      width: double.infinity,
      // Foto persegi dipotong mengikuti sudut membulat.
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.secondaryBg,
        borderRadius: wide
            ? BorderRadius.circular(28)
            : const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: wide ? stack : SafeArea(child: stack),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Garment g,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus dari lemari?'),
        content: Text(
          '${g.title} akan dihapus dari lemari dan tidak masuk rekomendasi lagi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    ref.read(wardrobeProvider.notifier).remove(g.id);
    if (context.mounted) context.pop();
  }

  Widget _details(
    BuildContext context,
    WidgetRef ref,
    Garment g, {
    required bool wide,
  }) {
    final conf = g.confidence;
    final added = g.addedAt;
    return Padding(
      padding: wide
          ? const EdgeInsets.fromLTRB(0, 8, 0, 24)
          : const EdgeInsets.fromLTRB(24, 22, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(g.category.toUpperCase(), style: AppTextStyles.mono(10)),
          const SizedBox(height: 4),
          Text(g.title, style: AppTextStyles.h1),
          const SizedBox(height: 4),
          if (added != null)
            Text(
              'Ditambahkan ${formatDateId(added)}',
              style: AppTextStyles.label.copyWith(fontSize: 12),
            ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _Row('Jenis', Text(typeLabel(g.garmentType))),
                const Divider(height: 1, color: AppColors.border),
                _Row(
                  'Warna',
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: g.colorValue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        g.colorName,
                        style: AppTextStyles.title.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),
                _Row('Formalitas', Text(formalityLabel(g.formality))),
                const Divider(height: 1, color: AppColors.border),
                _Row('Style', Text(styleLabel(g.style))),
                const Divider(height: 1, color: AppColors.border),
                _Row(
                  'Detection confidence',
                  conf == null
                      ? const Text('-')
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 44,
                              height: 3,
                              child: Stack(
                                children: [
                                  Container(color: AppColors.border),
                                  FractionallySizedBox(
                                    widthFactor: conf.clamp(0.0, 1.0),
                                    child: Container(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${(conf * 100).round()}%',
                              style: AppTextStyles.title.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          AppButton(
            label: 'Gunakan untuk Rekomendasi',
            icon: Icons.auto_awesome,
            onPressed: () => context.push(AppRoutes.recommendation),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Hapus dari Lemari',
            icon: Icons.delete_outline,
            style: AppButtonStyle.outlined,
            height: 50,
            onPressed: () => _confirmDelete(context, ref, g),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);
  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySecondary),
        DefaultTextStyle(
          style: AppTextStyles.title.copyWith(fontSize: 14),
          child: value,
        ),
      ],
    ),
  );
}
