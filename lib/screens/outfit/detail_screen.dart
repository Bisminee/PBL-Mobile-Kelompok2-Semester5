import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_text_styles.dart';
import '../../models/garment.dart';
import '../../models/garment_labels.dart';
import '../../models/outfit.dart';
import '../../services/color_harmony.dart';
import '../../services/outfit_detail.dart';
import '../../services/providers.dart';
import '../../services/recommender.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/circle_icon_button.dart';
import '../../widgets/common/garment_photo.dart';
import '../../widgets/common/match_ring.dart';
import '../../widgets/common/responsive.dart';
import '../../widgets/outfit/outfit_item_row.dart';

/// Detail satu outfit. Bagian atas (foto, judul, skor) ikut tergulir, lalu tab
/// Warna, Styling, dan Lemari tetap menempel di atas (E8.5). Semua isi tab
/// diambil dari data outfit, lemari, dan engine, bukan teks contoh.
/// Outfit dikirim lewat `extra` dari go_router.
class DetailScreen extends ConsumerStatefulWidget {
  const DetailScreen({super.key, this.outfit});

  final Outfit? outfit;

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    // Tandai tombol sudah tersimpan bila outfit ini pernah disimpan.
    final o = widget.outfit;
    if (o != null) {
      _cekSudahDisimpan(o);
      _catatRiwayat(o);
    }
  }

  List<int> _itemIds(Outfit o) => [
    int.tryParse(o.top.id),
    int.tryParse(o.bottom.id),
  ].whereType<int>().toList();

  Future<void> _cekSudahDisimpan(Outfit o) async {
    final ids = _itemIds(o);
    if (ids.length < 2) return;
    try {
      final sudah = await ref.read(localDbProvider).outfitSaved(ids);
      if (mounted && sudah) setState(() => _saved = true);
    } catch (_) {
      // Database belum siap: biarkan tombol aktif.
    }
  }

  /// Membuka detail dihitung sebagai melihat rekomendasi; dicatat ke riwayat.
  Future<void> _catatRiwayat(Outfit o) async {
    final ids = _itemIds(o);
    if (ids.length < 2) return;
    try {
      await ref
          .read(localDbProvider)
          .logRecommendation(
            topId: ids[0],
            bottomId: ids[1],
            title: o.title,
            formality: o.formality ?? 'non_formal',
            score: o.score,
          );
    } catch (_) {
      // Riwayat bersifat pelengkap; kegagalan mencatat tidak boleh mengganggu detail.
    }
  }

  Future<void> _saveOutfit(Outfit o) async {
    if (_saved) return;
    final ids = _itemIds(o);
    if (ids.length < 2) return;
    try {
      await ref
          .read(localDbProvider)
          .saveOutfit(o.title, o.formality ?? 'non_formal', o.score, ids);
      ref.invalidate(savedOutfitsProvider);
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

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: ContentWidth(
                maxWidth: 720,
                child: NestedScrollView(
                  headerSliverBuilder: (context, _) => [
                    SliverToBoxAdapter(child: _Header(o)),
                    const SliverPersistentHeader(
                      pinned: true,
                      delegate: _TabBarHeader(),
                    ),
                  ],
                  body: TabBarView(
                    children: [_ColorTab(o), _StylingTab(o), _WardrobeTab(o)],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 28,
              left: 0,
              right: 0,
              child: Center(child: _saveButton(o)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _saveButton(Outfit o) => GestureDetector(
    onTap: () => _saveOutfit(o),
    child: Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 16)],
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
            style: AppTextStyles.button.copyWith(color: Colors.white),
          ),
        ],
      ),
    ),
  );
}

/// Bagian atas yang ikut tergulir: tombol kembali, foto, judul, skor, fakta.
class _Header extends StatelessWidget {
  const _Header(this.o);
  final Outfit o;

  @override
  Widget build(BuildContext context) {
    final pct = o.scorePercent;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
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
                _Fact(
                  'Color Harmony',
                  colorRelation(o.top.colorFamily, o.bottom.colorFamily),
                ),
                const VerticalDivider(width: 1, color: AppColors.border),
                _Fact(
                  'Style',
                  styleSummary(o.top.style, o.bottom.style, styleLabel),
                ),
                const VerticalDivider(width: 1, color: AppColors.border),
                _Fact('Formalitas', formalityLabel(o.formality)),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 8),
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

/// Menjaga TabBar tetap terlihat saat bagian atas tergulir.
class _TabBarHeader extends SliverPersistentHeaderDelegate {
  const _TabBarHeader();

  static const double _height = 48;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    return ColoredBox(
      color: AppColors.background,
      child: TabBar(
        labelColor: AppColors.textPrimary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.accent,
        dividerColor: AppColors.border,
        labelStyle: AppTextStyles.labelBold.copyWith(fontSize: 14),
        unselectedLabelStyle: AppTextStyles.label.copyWith(fontSize: 14),
        tabs: const [
          Tab(text: 'Warna'),
          Tab(text: 'Styling'),
          Tab(text: 'Lemari'),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarHeader oldDelegate) => false;
}

/// Isi satu tab. Padding bawah memberi ruang untuk tombol Simpan yang melayang.
class _TabList extends StatelessWidget {
  const _TabList({required this.storageKey, required this.children});
  final String storageKey;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ListView(
    key: PageStorageKey(storageKey),
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
    children: children,
  );
}

// ===========================================================================
// Tab Warna
// ===========================================================================

class _ColorTab extends StatelessWidget {
  const _ColorTab(this.o);
  final Outfit o;

  @override
  Widget build(BuildContext context) {
    final harmony = ColorHarmony.evaluate(
      o.top.colorValue,
      o.bottom.colorValue,
    );
    final relation = colorRelation(o.top.colorFamily, o.bottom.colorFamily);
    return _TabList(
      storageKey: 'detail-warna',
      children: [
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
                    Text(harmony.label, style: AppTextStyles.title),
                    Text(
                      '$relation · harmoni ${(harmony.score * 100).round()}%',
                      style: AppTextStyles.label,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          harmony.detail,
          style: AppTextStyles.bodySecondary.copyWith(fontSize: 13),
        ),
        const SizedBox(height: 22),
        Text('Warna per item', style: AppTextStyles.h3),
        const SizedBox(height: 6),
        _ColorRow('Atasan', o.top),
        _ColorRow('Bawahan', o.bottom),
        const SizedBox(height: 22),
        Text('Cara membaca', style: AppTextStyles.h3),
        const SizedBox(height: 6),
        Text(
          'Harmoni dihitung dari jarak hue dan kecerahan kedua warna (CIELCh). '
          'Warna diambil dari piksel foto saat pemindaian; item tanpa foto '
          'memakai warna baku keluarganya.',
          style: AppTextStyles.bodySecondary.copyWith(fontSize: 13),
        ),
      ],
    );
  }
}

class _ColorRow extends StatelessWidget {
  const _ColorRow(this.role, this.g);
  final String role;
  final Garment g;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColors.border)),
    ),
    child: Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: g.colorValue,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                g.colorName,
                style: AppTextStyles.title.copyWith(fontSize: 15),
              ),
              Text('$role · ${g.title}', style: AppTextStyles.label),
            ],
          ),
        ),
        Text(hexOf(g.colorValue), style: AppTextStyles.mono(11)),
      ],
    ),
  );
}

// ===========================================================================
// Tab Styling
// ===========================================================================

class _StylingTab extends ConsumerWidget {
  const _StylingTab(this.o);
  final Outfit o;

  static const _reasonTitles = ['Harmoni warna', 'Formalitas', 'Skor pasangan'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestions = ref.watch(suggestionsProvider(o));
    return _TabList(
      storageKey: 'detail-styling',
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _InfoRow('Style atasan', styleLabel(o.top.style)),
              const Divider(height: 1, color: AppColors.border),
              _InfoRow('Style bawahan', styleLabel(o.bottom.style)),
              const Divider(height: 1, color: AppColors.border),
              _InfoRow('Formalitas atasan', formalityLabel(o.top.formality)),
              const Divider(height: 1, color: AppColors.border),
              _InfoRow(
                'Formalitas bawahan',
                formalityLabel(o.bottom.formality),
              ),
              const Divider(height: 1, color: AppColors.border),
              _InfoRow('Formalitas outfit', formalityLabel(o.formality)),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text('Kenapa cocok', style: AppTextStyles.h3),
        const SizedBox(height: 12),
        if (o.reasons.isEmpty)
          Text(
            'Belum ada alasan untuk outfit ini.',
            style: AppTextStyles.bodySecondary,
          ),
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
    );
  }
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

// ===========================================================================
// Tab Lemari
// ===========================================================================

class _WardrobeTab extends ConsumerWidget {
  const _WardrobeTab(this.o);
  final Outfit o;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wardrobe = ref.watch(wardrobeProvider);
    final altTop = wardrobeAlternatives(
      wardrobe: wardrobe,
      outfit: o,
      slot: 'top',
    );
    final altBottom = wardrobeAlternatives(
      wardrobe: wardrobe,
      outfit: o,
      slot: 'bottom',
    );
    return _TabList(
      storageKey: 'detail-lemari',
      children: [
        Row(
          children: [
            Text('Items', style: AppTextStyles.h3),
            const SizedBox(width: 6),
            Text('2', style: AppTextStyles.mono(11)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Ketuk item untuk melihat detailnya di lemari.',
          style: AppTextStyles.label.copyWith(fontSize: 11),
        ),
        const SizedBox(height: 6),
        for (final g in [o.top, o.bottom])
          _GarmentTile(g, meta: _itemMeta(g), badge: 'LEMARI'),
        const SizedBox(height: 22),
        Text('Alternatif dari lemarimu', style: AppTextStyles.h3),
        const SizedBox(height: 4),
        Text(
          'Diurut dari harmoni warna dengan pasangannya di outfit ini.',
          style: AppTextStyles.label.copyWith(fontSize: 11),
        ),
        const SizedBox(height: 6),
        if (altTop.isEmpty && altBottom.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Belum ada atasan atau bawahan lain di lemari. Pindai pakaian '
              'lain untuk melihat alternatif.',
              style: AppTextStyles.bodySecondary,
            ),
          ),
        for (final a in altTop)
          _GarmentTile(
            a.garment,
            meta: 'Ganti atasan · ${a.harmony.label}',
            badge: '${(a.harmony.score * 100).round()}%',
          ),
        for (final a in altBottom)
          _GarmentTile(
            a.garment,
            meta: 'Ganti bawahan · ${a.harmony.label}',
            badge: '${(a.harmony.score * 100).round()}%',
          ),
      ],
    );
  }

  String _itemMeta(Garment g) {
    final parts = [g.category, g.colorName];
    final conf = confidenceText(g.confidence);
    if (conf != null) parts.add('yakin $conf');
    final added = g.addedAt;
    if (added != null) parts.add(formatDateId(added));
    return parts.join(' · ');
  }
}

/// Baris item lemari yang bisa diketuk untuk membuka detail pakaian.
class _GarmentTile extends StatelessWidget {
  const _GarmentTile(this.g, {required this.meta, required this.badge});
  final Garment g;
  final String meta;
  final String badge;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => context.push(AppRoutes.clothingDetail, extra: g),
    child: OutfitItemRow(
      name: g.title,
      meta: meta,
      badge: badge,
      kind: clothingKindOf(g.garmentType, g.slot),
      dark: g.isDark,
      imagePath: g.imagePath,
    ),
  );
}

// ===========================================================================
// Widget kecil
// ===========================================================================

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

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        Expanded(child: Text(label, style: AppTextStyles.label)),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.title.copyWith(fontSize: 14),
          ),
        ),
      ],
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
