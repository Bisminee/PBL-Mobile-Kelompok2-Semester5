import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/app_routes.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../widgets/circle_icon_button.dart';
import '../widgets/clothing_thumb.dart';
import '../widgets/corner_frame.dart';

class AnalyzingScreen extends StatefulWidget {
  const AnalyzingScreen({super.key});

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Simulasi proses AI. Ganti dengan pemanggilan model/API sebenarnya.
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) context.pushReplacement(AppRoutes.detectionResult);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                        icon: Icons.close, onPressed: () => context.pop()),
                  ),
                  Text('SERA-Z VISION', style: AppTextStyles.mono(10, ls: 2)),
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
                  child: const ClothingThumb(
                    kind: ClothingKind.top,
                    background: Colors.transparent,
                    iconSize: 130,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Menganalisis pakaian…', style: AppTextStyles.h2),
                    const SizedBox(height: 6),
                    Text('AI sedang menganalisis warna dan\njenis pakaianmu',
                        style: AppTextStyles.bodySecondary),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: const [
                    _StepRow(label: 'Mendeteksi pakaian', value: 'KAOS', done: true),
                    Divider(height: 1, color: AppColors.border),
                    _StepRow(label: 'Menganalisis warna', value: 'HITAM', done: true),
                    Divider(height: 1, color: AppColors.border),
                    _StepRow(label: 'Menentukan style', value: '68%', done: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.label, required this.value, required this.done});
  final String label;
  final String value;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(children: [
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
                  child: CircleAvatar(radius: 4, backgroundColor: AppColors.accent)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: AppTextStyles.title.copyWith(fontSize: 15))),
        Text(value, style: AppTextStyles.mono(11)),
      ]),
    );
  }
}
