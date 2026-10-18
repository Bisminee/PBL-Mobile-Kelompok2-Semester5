import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../widgets/circle_icon_button.dart';
import '../widgets/clothing_thumb.dart';
import '../widgets/match_ring.dart';
import '../widgets/outfit_item_row.dart';

<<<<<<< Updated upstream
class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key, this.outfit});

  /// The outfit selected from the recommendation list (may be null on deep link).
  final Outfit? outfit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendations = ref.watch(recommendationsProvider);
    final selected = outfit ??
        (recommendations.isNotEmpty ? recommendations.first : null);

    if (selected == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Tidak ada detail untuk ditampilkan.')),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PlaceholderBox(
                height: 260,
                radius: 16,
                color: selected.top.colorValue.withValues(alpha: 0.55),
                child: const Text('gambar',
                    style: TextStyle(color: Colors.black54)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selected.title,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selected.subtitle,
                    style:
                        TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      PillTag(label: selected.top.category),
                      const SizedBox(width: 8),
                      PillTag(label: selected.bottom.category),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ColorDot(
                          color: selected.top.colorValue,
                          label: selected.top.colorName),
                      const SizedBox(width: 16),
                      ColorDot(
                          color: selected.bottom.colorValue,
                          label: selected.bottom.colorName),
                    ],
                  ),
                ],
              ),
            ),
            const TabBar(
              tabs: [
                Tab(text: 'Warna'),
                Tab(text: 'Styling'),
                Tab(text: 'Lemari'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _infoCard('Skor kecocokan: ${selected.scorePercent}%',
                      selected.reasons.join('\n• ')),
                  _infoCard('Rekomendasi Styling', selected.subtitle),
                  _infoCard('Simpan ke Lemari',
                      'Tambahkan paduan ini ke Lemari Saya.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String body) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(body, style: const TextStyle(height: 1.5)),
          ],
        ),
=======
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleIconButton(
                          icon: Icons.chevron_left, onPressed: () => context.pop()),
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
                    child: Row(children: [
                      const Expanded(child: SizedBox.expand(child: ClothingThumb(kind: ClothingKind.top, iconSize: 60))),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(children: const [
                          Expanded(child: SizedBox.expand(child: ClothingThumb(kind: ClothingKind.bottom, dark: false))),
                          SizedBox(height: 8),
                          Expanded(child: SizedBox.expand(child: ClothingThumb(kind: ClothingKind.shoes))),
                        ]),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  Text('REKOMENDASI TERBAIK', style: AppTextStyles.mono(10)),
                  const SizedBox(height: 4),
                  Text('Monochrome Casual', style: AppTextStyles.display),
                  const SizedBox(height: 12),
                  Row(children: [
                    const MatchRing(value: 94, size: 40),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('94% Match', style: AppTextStyles.title),
                        Text('Berdasarkan warna, kategori, dan style',
                            style: AppTextStyles.label),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.border, height: 1),
                  IntrinsicHeight(
                    child: Row(children: const [
                      _Fact('Color Harmony', 'Monochromatic'),
                      VerticalDivider(width: 1, color: AppColors.border),
                      _Fact('Style', 'Casual'),
                      VerticalDivider(width: 1, color: AppColors.border),
                      _Fact('Occasion', 'Daily / Campus'),
                    ]),
                  ),
                  const Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 22),
                  Row(children: [
                    Text('Items', style: AppTextStyles.h3),
                    const SizedBox(width: 6),
                    Text('3', style: AppTextStyles.mono(11)),
                  ]),
                  const SizedBox(height: 10),
                  const OutfitItemRow(
                      name: 'Kaos Hitam',
                      meta: 'Atasan · Hitam',
                      badge: 'FOTO KAMU',
                      badgeFilled: true,
                      kind: ClothingKind.top,
                      dark: true),
                  const OutfitItemRow(
                      name: 'Chino Putih',
                      meta: 'Bawahan · Putih',
                      badge: 'LEMARI',
                      kind: ClothingKind.bottom,
                      dark: false),
                  const OutfitItemRow(
                      name: 'Sneakers Hitam',
                      meta: 'Sepatu · Hitam',
                      badge: 'LEMARI',
                      kind: ClothingKind.shoes,
                      dark: true),
                  const SizedBox(height: 22),
                  Text('Color Harmony', style: AppTextStyles.h3),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(children: [
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: Stack(children: const [
                          _Swatch(0, AppColors.darkSecondary),
                          _Swatch(28, Colors.white),
                          _Swatch(56, Colors.black),
                        ]),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Monochromatic', style: AppTextStyles.title),
                            Text('Hitam · Putih · Hitam', style: AppTextStyles.label),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 22),
                  Text('Why it works', style: AppTextStyles.h3),
                  const SizedBox(height: 12),
                  const _Reason('01', 'Kontras yang seimbang',
                      'Atasan hitam dan bawahan putih membagi tampilan dengan bersih.'),
                  const _Reason('02', 'Warna yang berulang',
                      'Sneakers hitam mengulang warna kaos, jadi outfit terasa utuh.'),
                  const _Reason('03', 'Style yang selaras',
                      'Semua item casual — nyaman untuk kampus dan aktivitas harian.'),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 16)],
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.bookmark_border, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text('Simpan Outfit',
                        style: AppTextStyles.button.copyWith(color: Colors.white)),
                  ]),
                ),
              ),
            ),
          ),
        ],
>>>>>>> Stashed changes
      ),
    );
  }
}
<<<<<<< Updated upstream
=======

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
                  Text(desc, style: AppTextStyles.bodySecondary.copyWith(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      );
}
>>>>>>> Stashed changes
