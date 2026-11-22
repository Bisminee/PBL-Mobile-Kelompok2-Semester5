import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../models/garment.dart';
import '../../models/garment_labels.dart';
import '../../services/color_family.dart';
import '../../services/providers.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/circle_icon_button.dart';
import '../../widgets/common/garment_photo.dart';
import '../../widgets/common/responsive.dart';

/// Detail satu pakaian di lemari. Pakaian dikirim lewat `extra` dari go_router.
class ClothingDetailScreen extends ConsumerStatefulWidget {
  const ClothingDetailScreen({
    super.key,
    this.garment,
    this.editOnOpen = false,
  });

  final Garment? garment;
  final bool editOnOpen;

  @override
  ConsumerState<ClothingDetailScreen> createState() =>
      _ClothingDetailScreenState();
}

class _ClothingDetailScreenState extends ConsumerState<ClothingDetailScreen> {
  bool _editScheduled = false;

  @override
  void initState() {
    super.initState();
    if (widget.editOnOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _editScheduled || widget.garment == null) return;
        _editScheduled = true;
        _edit(context, ref, widget.garment!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final source = widget.garment;
    if (source == null) {
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

    // Ambil versi terbaru dari provider agar layar langsung berubah setelah
    // atribut diedit, tanpa harus kembali ke daftar lemari.
    final g =
        ref
            .watch(wardrobeProvider)
            .where((item) => item.id == source.id)
            .firstOrNull ??
        source;

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
                      Expanded(child: _hero(context, ref, g, wide: true)),
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
                  _hero(context, ref, g, wide: false),
                  _details(context, ref, g, wide: false),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _hero(
    BuildContext context,
    WidgetRef ref,
    Garment g, {
    required bool wide,
  }) {
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
        Positioned(
          top: 12,
          right: 20,
          child: CircleIconButton(
            icon: Icons.edit_outlined,
            background: Colors.white,
            onPressed: () => _edit(context, ref, g),
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

  Future<void> _edit(BuildContext context, WidgetRef ref, Garment g) async {
    var type = g.garmentType ?? 't_shirt';
    if (!slotOfType.containsKey(type)) type = 't_shirt';
    var color =
        ColorFamily.byKeyOrAlias(g.colorFamily ?? 'black') ?? ColorFamily.black;
    var formality = g.formality ?? 'non_formal';
    if (!formalityValues.contains(formality)) formality = 'non_formal';
    var style = g.style ?? 'unspecified';
    if (!styleValues.contains(style)) style = 'unspecified';

    final types = slotOfType.keys.toList()
      ..sort((a, b) => typeLabel(a).compareTo(typeLabel(b)));

    final result = await showModalBottomSheet<Garment>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (ctx, setSheet) {
          InputDecoration decoration(String label) => InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            isDense: true,
          );

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                24,
                0,
                24,
                24 + MediaQuery.viewInsetsOf(ctx).bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Edit Pakaian', style: AppTextStyles.title),
                  const SizedBox(height: 4),
                  Text(
                    'Ubah atribut tanpa mengganti foto.',
                    style: AppTextStyles.bodySecondary,
                  ),
                  const SizedBox(height: 18),
                  DropdownButtonFormField<String>(
                    initialValue: type,
                    decoration: decoration('Jenis pakaian'),
                    items: [
                      for (final t in types)
                        DropdownMenuItem(value: t, child: Text(typeLabel(t))),
                    ],
                    onChanged: (value) {
                      if (value != null) setSheet(() => type = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: color.key,
                    decoration: decoration('Warna'),
                    items: [
                      for (final family in ColorFamily.values)
                        DropdownMenuItem(
                          value: family.key,
                          child: Text(family.label),
                        ),
                    ],
                    onChanged: (value) {
                      final next = ColorFamily.byKey(value ?? '');
                      if (next != null) setSheet(() => color = next);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: formality,
                    decoration: decoration('Formalitas'),
                    items: [
                      for (final f in formalityValues)
                        DropdownMenuItem(
                          value: f,
                          child: Text(formalityLabel(f)),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) setSheet(() => formality = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: style,
                    decoration: decoration('Style'),
                    items: [
                      for (final s in styleValues)
                        DropdownMenuItem(value: s, child: Text(styleLabel(s))),
                    ],
                    onChanged: (value) {
                      if (value != null) setSheet(() => style = value);
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Batal',
                          style: AppButtonStyle.outlined,
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButton(
                          label: 'Simpan',
                          onPressed: () {
                            final slot = slotOfType[type] ?? g.slot ?? 'top';
                            Navigator.of(ctx).pop(
                              g.copyWith(
                                garmentType: type,
                                slot: slot,
                                category: categoryOfSlot(slot),
                                colorFamily: color.key,
                                colorName: color.label,
                                colorValue: color.color,
                                formality: formality,
                                style: style,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    if (result == null) return;
    try {
      await ref.read(wardrobeProvider.notifier).update(result);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Atribut pakaian diperbarui.')),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan perubahan. Coba lagi.')),
      );
    }
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
                          border: Border.all(color: AppColors.border),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          g.colorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.title.copyWith(fontSize: 14),
                        ),
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
                  'Kemiripan model',
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
            onPressed: () => context.push(AppRoutes.recommendation, extra: g),
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
      children: [
        Text(label, style: AppTextStyles.bodySecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: DefaultTextStyle(
              style: AppTextStyles.title.copyWith(fontSize: 14),
              textAlign: TextAlign.end,
              child: value,
            ),
          ),
        ),
      ],
    ),
  );
}
