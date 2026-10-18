import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/circle_icon_button.dart';
import '../../widgets/common/clothing_thumb.dart';
import '../../widgets/common/responsive.dart';

/// Detail satu pakaian di lemari.
class ClothingDetailScreen extends StatelessWidget {
  const ClothingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      Expanded(child: _hero(context, wide: true)),
                      const SizedBox(width: 32),
                      Expanded(
                        child: SingleChildScrollView(
                          child: _details(context, wide: true),
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
                  _hero(context, wide: false),
                  _details(context, wide: false),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _hero(BuildContext context, {required bool wide}) {
    final stack = Stack(
      alignment: Alignment.center,
      children: [
        const ClothingThumb(
            kind: ClothingKind.top,
            background: Colors.transparent,
            iconSize: 170),
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
          child: CircleIconButton(icon: Icons.edit_outlined, background: Colors.white),
        ),
      ],
    );

    return Container(
      height: wide ? 520 : 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondaryBg,
        borderRadius: wide
            ? BorderRadius.circular(28)
            : const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: wide ? stack : SafeArea(child: stack),
    );
  }

  Widget _details(BuildContext context, {required bool wide}) {
    return Padding(
      padding: wide
          ? const EdgeInsets.fromLTRB(0, 8, 0, 24)
          : const EdgeInsets.fromLTRB(24, 22, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Atasan', style: AppTextStyles.mono(10)),
          const SizedBox(height: 4),
          Text('Kaos Hitam Polos', style: AppTextStyles.h1),
          const SizedBox(height: 4),
          Text('Ditambahkan 27 September 2026',
              style: AppTextStyles.label.copyWith(fontSize: 12)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(children: [
              const _Row('Kategori', Text('Kaos', style: TextStyle(fontWeight: FontWeight.w700))),
              const Divider(height: 1, color: AppColors.border),
              _Row(
                'Warna',
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                          color: AppColors.darkSecondary, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text('Hitam', style: AppTextStyles.title.copyWith(fontSize: 14)),
                ]),
              ),
              const Divider(height: 1, color: AppColors.border),
              const _Row('Style', Text('Casual', style: TextStyle(fontWeight: FontWeight.w700))),
              const Divider(height: 1, color: AppColors.border),
              _Row(
                'Detection confidence',
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 44, height: 3, color: AppColors.textPrimary),
                  const SizedBox(width: 10),
                  Text('94%', style: AppTextStyles.title.copyWith(fontSize: 14)),
                ]),
              ),
            ]),
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
            onPressed: () => context.pop(),
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
            DefaultTextStyle(style: AppTextStyles.title.copyWith(fontSize: 14), child: value),
          ],
        ),
      );
}
