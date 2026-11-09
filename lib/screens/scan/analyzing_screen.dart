import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../models/garment_labels.dart';
import '../../services/providers.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/circle_icon_button.dart';
import '../../widgets/common/corner_frame.dart';
import '../../widgets/common/garment_photo.dart';
import '../../widgets/common/responsive.dart';

/// Layar tunggu selagi model mendeteksi jenis dan warna pakaian dari foto.
class AnalyzingScreen extends ConsumerStatefulWidget {
  const AnalyzingScreen({super.key});

  @override
  ConsumerState<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends ConsumerState<AnalyzingScreen> {
  @override
  void initState() {
    super.initState();
    // Provider tidak boleh diubah selama build pertama, jadi analisis dimulai setelah frame pertama.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(scanSessionProvider.notifier).run();
    });
  }

  void _close() {
    ref.read(scanSessionProvider.notifier).reset();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    // Pindah ke layar hasil begitu deteksi selesai.
    ref.listen<ScanSession>(scanSessionProvider, (prev, next) {
      if (next.detection != null && prev?.detection == null) {
        context.pushReplacement(AppRoutes.detectionResult);
      }
    });

    final s = ref.watch(scanSessionProvider);
    final d = s.detection;
    final failed = s.errorMessage != null;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: ContentWidth(
              maxWidth: 520,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CircleIconButton(
                          icon: Icons.close,
                          onPressed: _close,
                        ),
                      ),
                      Text(
                        'SERA-Z VISION',
                        style: AppTextStyles.mono(10, ls: 2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Container(
                    height: 340,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryBg,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    padding: const EdgeInsets.all(26),
                    child: CornerFrame(
                      color: const Color(0xFFB8B8BC),
                      cornerLength: 28,
                      child: GarmentPhoto(
                        imagePath: s.imagePath,
                        kind: clothingKindOf(d?.type, d?.slot),
                        radius: 12,
                        iconSize: 130,
                        background: Colors.transparent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          failed ? 'Analisis gagal' : 'Menganalisis pakaian…',
                          style: AppTextStyles.h2,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          failed
                              ? s.errorMessage!
                              : 'AI sedang menganalisis warna dan\njenis pakaianmu',
                          style: AppTextStyles.bodySecondary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (failed)
                    AppButton(label: 'Kembali', onPressed: _close)
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          _StepRow(
                            label: 'Mendeteksi pakaian',
                            value: d == null
                                ? '…'
                                : typeLabel(d.type).toUpperCase(),
                            done: d != null,
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _StepRow(
                            label: 'Menganalisis warna',
                            value: d == null
                                ? '…'
                                : colorLabel(d.color).toUpperCase(),
                            done: d != null,
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _StepRow(
                            label: 'Menentukan style',
                            value: d == null
                                ? '…'
                                : styleLabel(d.topStyle).toUpperCase(),
                            done: d != null,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.label,
    required this.value,
    required this.done,
  });
  final String label;
  final String value;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: done ? AppColors.accent : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accent, width: 1.5),
            ),
            child: done
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : const Center(
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: AppColors.accent,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.title.copyWith(fontSize: 15),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.mono(11),
            ),
          ),
        ],
      ),
    );
  }
}
