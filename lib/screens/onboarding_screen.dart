import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/app_routes.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../widgets/app_button.dart';
import '../widgets/onboarding_illustrations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  static const _titles = [
    'Kenali Pakaianmu',
    'Temukan Kombinasi',
    'Berpakaian Lebih Mudah',
  ];
  static const _descs = [
    'Foto pakaian yang kamu miliki dan biarkan Sera-Z mengenali jenis serta warnanya.',
    'Dapatkan rekomendasi outfit berdasarkan warna, style, dan pakaian yang kamu miliki.',
    'Temukan outfit yang cocok tanpa menghabiskan waktu memilih pakaian',
  ];

  bool get _isLast => _index == _titles.length - 1;

  void _next() {
    if (_isLast) {
      context.go(AppRoutes.login);
    } else {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _skip() => context.go(AppRoutes.login);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0${_index + 1} / 03', style: AppTextStyles.mono(11)),
                  GestureDetector(
                    onTap: _skip,
                    child: Text('Lewati',
                        style: AppTextStyles.bodySecondary.copyWith(fontSize: 14)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                children: List.generate(3, (i) => _OnboardingSlide(
                      index: i,
                      title: _titles[i],
                      desc: _descs[i],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 8, 24, 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Dots(index: _index, count: 3),
                  AppButton(
                    label: _isLast ? 'Masuk' : 'Lanjut',
                    trailingIcon: Icons.arrow_forward,
                    expand: false,
                    onPressed: _next,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({required this.index, required this.title, required this.desc});

  final int index;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    final illustrations = [
      const ScanIllustration(),
      const MatchIllustration(),
      const OutfitCardIllustration(),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 380,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.secondaryBg,
              borderRadius: BorderRadius.circular(28),
            ),
            child: illustrations[index],
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.h1),
                const SizedBox(height: 12),
                Text(desc, style: AppTextStyles.bodySecondary.copyWith(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.index, required this.count});
  final int index;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(right: 6),
          width: active ? 24 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? AppColors.textPrimary : AppColors.border,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
