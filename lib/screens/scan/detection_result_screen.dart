import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../models/garment_labels.dart';
import '../../services/outfit_engine.dart';
import '../../services/providers.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/circle_icon_button.dart';
import '../../widgets/common/clothing_thumb.dart';
import '../../widgets/common/corner_frame.dart';
import '../../widgets/common/garment_photo.dart';
import '../../widgets/common/match_ring.dart';
import '../../widgets/common/pill_chip.dart';
import '../../widgets/common/responsive.dart';
import '../../widgets/scan/color_composition_bar.dart';
import '../../widgets/scan/info_grid.dart';

/// Hasil deteksi jenis, style, dan warna pakaian. User bisa mengoreksi jenis dan formalitas
/// sebelum menyimpan ke lemari.
class DetectionResultScreen extends ConsumerStatefulWidget {
  const DetectionResultScreen({super.key});

  @override
  ConsumerState<DetectionResultScreen> createState() =>
      _DetectionResultScreenState();
}

class _DetectionResultScreenState extends ConsumerState<DetectionResultScreen> {
  bool _saving = false;

  Future<void> _save({required bool toRecommendation}) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final saved = await ref.read(scanSessionProvider.notifier).save();
      if (!mounted) return;
      if (saved == null) {
        setState(() => _saving = false);
        return;
      }
      context.go(AppRoutes.home);
      if (toRecommendation) context.push(AppRoutes.recommendation);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan ke lemari. Coba lagi.')),
      );
    }
  }

  /// Daftar semua jenis pakaian untuk koreksi bila tebakan model salah dan tidak ada di tiga alternatif.
  Future<void> _pickOtherType() async {
    final type = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final t in slotOfType.keys.where((t) => t != notGarmentType))
              ListTile(
                title: Text(typeLabel(t)),
                subtitle: Text(slotLabel(slotOfType[t])),
                onTap: () => Navigator.of(ctx).pop(t),
              ),
          ],
        ),
      ),
    );
    if (type != null) {
      await ref.read(scanSessionProvider.notifier).chooseType(type);
    }
  }

  List<ColorSegment> _segments(Detection d) {
    final entries =
        d.colorShare.entries.where((e) => e.value * 100 >= 1).toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    return [
      for (final e in entries.take(3))
        ColorSegment(
          colorLabel(e.key),
          (e.value * 100).round().clamp(1, 100).toInt(),
          colorOfFamily(e.key),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(scanSessionProvider);
    final d = s.detection;

    if (d == null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Belum ada hasil deteksi.', style: AppTextStyles.title),
                  const SizedBox(height: 16),
                  AppButton(
                    label: 'Kembali',
                    onPressed: () => context.go(AppRoutes.home),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final pct = (d.confidence * 100).round();
    final segments = _segments(d);

    // Model 10 kelas punya kelas "other". Bila itu yang terpilih (atau model sangat
    // tidak yakin), tampilkan penolakan, bukan hasil pakaian.
    if (!d.isGarment) {
      return _NotGarmentView(
        imagePath: s.imagePath,
        confidence: pct,
        onRetry: () => context.go(AppRoutes.camera),
        onManual: () => _pickOtherType(),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ContentWidth(
            maxWidth: 560,
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
                    Text('Hasil Deteksi', style: AppTextStyles.title),
                    const CircleIconButton(icon: Icons.ios_share),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  height: 250,
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBg,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: CornerFrame(
                    color: const Color(0xFFB8B8BC),
                    cornerLength: 24,
                    child: GarmentPhoto(
                      imagePath: s.imagePath,
                      kind: clothingKindOf(d.type, d.slot),
                      radius: 12,
                      iconSize: 110,
                      background: Colors.transparent,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  '${slotLabel(d.slot).toUpperCase()} · ${formatDateShortId(DateTime.now())}',
                  style: AppTextStyles.mono(10),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            typeLabel(d.type),
                            style: AppTextStyles.display.copyWith(fontSize: 36),
                          ),
                          Text(
                            '${formalityLabel(d.formality)} · ${styleLabel(d.topStyle)}',
                            style: AppTextStyles.bodySecondary.copyWith(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Setelah dikoreksi manual, angka confidence model tidak lagi berlaku untuk jenis baru.
                    if (!d.manual)
                      MatchRing(
                        value: pct,
                        size: 66,
                        showPercent: true,
                        caption: 'CONF',
                        stroke: 4,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                if (!d.isConfident) ...[
                  _Notice(
                    d.manual
                        ? 'Jenis pakaian kamu atur sendiri. Formalitas dan style dihitung ulang dari pilihan itu.'
                        : 'Keyakinan model hanya $pct%. Di data uji, hasil di bawah 97% benar sekitar '
                              '6 dari 10 kali. Periksa jenis pakaian sebelum menyimpan.',
                  ),
                  const SizedBox(height: 16),
                ],
                InfoGrid(
                  cells: [
                    InfoCell('Jenis', typeLabel(d.type)),
                    InfoCell('Style', styleLabel(d.topStyle)),
                    InfoCell(
                      'Warna dominan',
                      colorLabel(d.color),
                      dotColor: colorFromHex(d.colorHex),
                    ),
                    InfoCell('Confidence', d.manual ? 'Manual' : '$pct%'),
                  ],
                ),
                const SizedBox(height: 22),
                Text(
                  'Bukan ${typeLabel(d.type).toLowerCase()}?',
                  style: AppTextStyles.title.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final a in d.alternatives)
                      PillChip(
                        label: typeLabel(a.label),
                        selected: a.label == d.type,
                        onTap: () => ref
                            .read(scanSessionProvider.notifier)
                            .chooseType(a.label),
                      ),
                    PillChip(
                      label: 'Lainnya…',
                      selected: false,
                      onTap: _pickOtherType,
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Text(
                  'Formalitas',
                  style: AppTextStyles.title.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final f in formalityValues)
                      PillChip(
                        label: formalityLabel(f),
                        selected: f == d.formality,
                        onTap: () => ref
                            .read(scanSessionProvider.notifier)
                            .chooseFormality(f),
                      ),
                  ],
                ),
                if (segments.isNotEmpty) ...[
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Komposisi warna',
                        style: AppTextStyles.title.copyWith(fontSize: 14),
                      ),
                      Text(
                        '${segments.length} TONE',
                        style: AppTextStyles.mono(10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ColorCompositionBar(segments: segments),
                ],
                const SizedBox(height: 28),
                AppButton(
                  label: 'Simpan dan Lihat Rekomendasi',
                  trailingIcon: Icons.arrow_forward,
                  onPressed: () => _save(toRecommendation: true),
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Simpan ke Lemari',
                  style: AppButtonStyle.outlined,
                  onPressed: () => _save(toRecommendation: false),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Kotak peringatan netral di atas grid informasi.
class _Notice extends StatelessWidget {
  const _Notice(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.secondaryBg,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: AppTextStyles.label.copyWith(fontSize: 12)),
        ),
      ],
    ),
  );
}

/// Layar penolakan: foto dianggap bukan pakaian.
///
/// User tetap boleh melanjutkan dengan memilih jenis pakaian sendiri,
/// karena model juga bisa salah menolak foto yang sebenarnya pakaian.
class _NotGarmentView extends StatelessWidget {
  const _NotGarmentView({
    required this.imagePath,
    required this.confidence,
    required this.onRetry,
    required this.onManual,
  });

  final String? imagePath;
  final int confidence;
  final VoidCallback onRetry;
  final VoidCallback onManual;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ContentWidth(
            maxWidth: 520,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                CircleIconButton(icon: Icons.chevron_left, onPressed: onRetry),
                const SizedBox(height: 18),
                Container(
                  height: 300,
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBg,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: CornerFrame(
                    color: const Color(0xFFB8B8BC),
                    cornerLength: 24,
                    child: GarmentPhoto(
                      imagePath: imagePath,
                      kind: ClothingKind.top,
                      radius: 12,
                      iconSize: 110,
                      background: Colors.transparent,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Sepertinya ini bukan pakaian',
                  style: AppTextStyles.display.copyWith(fontSize: 30),
                ),
                const SizedBox(height: 8),
                Text(
                  'Model tidak menemukan pakaian di foto ini '
                  '(keyakinan $confidence%). Coba foto satu potong pakaian '
                  'dengan latar lebih sederhana dan pencahayaan cukup.',
                  style: AppTextStyles.bodySecondary.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 24),
                AppButton(label: 'Ambil foto ulang', onPressed: onRetry),
                const SizedBox(height: 10),
                AppButton(
                  label: 'Tetap pilih jenis manual',
                  style: AppButtonStyle.outlined,
                  onPressed: onManual,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
