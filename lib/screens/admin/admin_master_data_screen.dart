// E8.6: Halaman Admin Master Data.
// Dua tab: "Tipe Pakaian" (ref_garment_type) dan "Warna" (ref_color).
// Setiap tab mendukung tambah, ubah, dan hapus (CRUD) lewat LocalDb.
import 'package:flutter/material.dart';

import '../../services/local_db.dart';

/// Pilihan slot untuk tipe pakaian.
/// PENTING: samakan dengan nilai slot di tabel catalog_item. Cek lewat:
///   SELECT DISTINCT slot FROM catalog_item;
/// Nilai yang sudah ada di database tetap muncul di dropdown walau tidak ada di daftar ini.
const List<String> kSlotOptions = ['top', 'bottom', 'outer', 'shoes', 'dress'];

/// Format hex yang diterima: #RRGGBB.
final RegExp _hexPattern = RegExp(r'^#[0-9A-Fa-f]{6}$');

/// Mengubah '#RRGGBB' menjadi Color. Mengembalikan null bila kosong atau tidak valid.
Color? _parseHex(String? hex) {
  if (hex == null || !_hexPattern.hasMatch(hex)) return null;
  return Color(int.parse('FF${hex.substring(1)}', radix: 16));
}

class AdminMasterDataScreen extends StatelessWidget {
  const AdminMasterDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Master Data'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tipe Pakaian'),
              Tab(text: 'Warna'),
            ],
          ),
        ),
        body: const TabBarView(children: [_GarmentTypeTab(), _ColorTab()]),
      ),
    );
  }
}

// ============================================================================
// Dialog konfirmasi hapus (dipakai kedua tab)
// ============================================================================

Future<bool> _confirmDelete(BuildContext context, String label) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Hapus data?'),
      content: Text(
        '"$label" akan dihapus dari master data. '
        'Item lemari yang sudah ada tidak terpengaruh.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Hapus'),
        ),
      ],
    ),
  );
  return ok ?? false;
}

// ============================================================================
// TAB 1: Tipe Pakaian
// ============================================================================

class _GarmentTypeTab extends StatefulWidget {
  const _GarmentTypeTab();

  @override
  State<_GarmentTypeTab> createState() => _GarmentTypeTabState();
}

class _GarmentTypeTabState extends State<_GarmentTypeTab> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetch();
  }

  /// Pastikan master data sudah terisi awal, lalu ambil daftar tipe.
  Future<List<Map<String, dynamic>>> _fetch() async {
    await LocalDb.instance.ensureMasterSeeded();
    return LocalDb.instance.getMasterGarmentTypes();
  }

  /// Muat ulang daftar setelah ada perubahan data.
  void _reload() {
    setState(() => _future = _fetch());
  }

  /// Buka form. [row] null = tambah baru, terisi = ubah.
  Future<void> _openForm({Map<String, dynamic>? row}) async {
    final result = await showDialog<({String name, String slot})>(
      context: context,
      builder: (_) => _TypeFormDialog(row: row),
    );
    if (result == null) return; // dibatalkan
    if (row == null) {
      await LocalDb.instance.insertMasterGarmentType(result.name, result.slot);
    } else {
      await LocalDb.instance.updateMasterGarmentType(
        row['id'] as int,
        result.name,
        result.slot,
      );
    }
    if (mounted) _reload();
  }

  Future<void> _delete(Map<String, dynamic> row) async {
    final ok = await _confirmDelete(context, row['name'] as String);
    if (!ok) return;
    await LocalDb.instance.deleteMasterGarmentType(row['id'] as int);
    if (mounted) _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_type',
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah tipe'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Gagal memuat data: ${snap.error}'));
          }
          final rows = snap.data ?? const <Map<String, dynamic>>[];
          if (rows.isEmpty) {
            return const Center(child: Text('Belum ada tipe pakaian.'));
          }
          return ListView.separated(
            // Padding bawah supaya item terakhir tidak tertutup tombol FAB.
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: rows.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final r = rows[i];
              return ListTile(
                title: Text(r['name'] as String),
                subtitle: Text('Slot: ${r['slot']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Ubah',
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _openForm(row: r),
                    ),
                    IconButton(
                      tooltip: 'Hapus',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _delete(r),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Dialog form tipe pakaian. Dibuat sebagai widget sendiri agar controller
/// dibuang dengan aman saat dialog ditutup.
class _TypeFormDialog extends StatefulWidget {
  const _TypeFormDialog({this.row});
  final Map<String, dynamic>? row;

  @override
  State<_TypeFormDialog> createState() => _TypeFormDialogState();
}

class _TypeFormDialogState extends State<_TypeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameC;
  late String _slot;
  String? _nameError; // error hasil cek duplikat (async)
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController(text: widget.row?['name'] as String? ?? '');
    _slot = widget.row?['slot'] as String? ?? kSlotOptions.first;
  }

  @override
  void dispose() {
    _nameC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _nameError = null;
    });
    final name = _nameC.text.trim();
    final dup = await LocalDb.instance.masterGarmentTypeExists(
      name,
      exceptId: widget.row?['id'] as int?,
    );
    if (!mounted) return;
    if (dup) {
      setState(() {
        _saving = false;
        _nameError = 'Nama sudah dipakai';
      });
      return;
    }
    Navigator.pop(context, (name: name, slot: _slot));
  }

  @override
  Widget build(BuildContext context) {
    // Gabungkan slot standar dengan slot milik baris ini (bila beda).
    final slotItems = {...kSlotOptions, _slot}.toList();
    return AlertDialog(
      title: Text(
        widget.row == null ? 'Tambah tipe pakaian' : 'Ubah tipe pakaian',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameC,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Nama tipe',
                hintText: 'contoh: shirt',
                errorText: _nameError,
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Nama tidak boleh kosong'
                  : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _slot,
              decoration: const InputDecoration(labelText: 'Slot'),
              items: [
                for (final s in slotItems)
                  DropdownMenuItem(value: s, child: Text(s)),
              ],
              onChanged: (v) => setState(() => _slot = v ?? _slot),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

// ============================================================================
// TAB 2: Warna
// ============================================================================

class _ColorTab extends StatefulWidget {
  const _ColorTab();

  @override
  State<_ColorTab> createState() => _ColorTabState();
}

class _ColorTabState extends State<_ColorTab> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetch();
  }

  /// Pastikan master data sudah terisi awal, lalu ambil daftar warna.
  Future<List<Map<String, dynamic>>> _fetch() async {
    await LocalDb.instance.ensureMasterSeeded();
    return LocalDb.instance.getMasterColors();
  }

  void _reload() {
    setState(() => _future = _fetch());
  }

  Future<void> _openForm({Map<String, dynamic>? row}) async {
    final result = await showDialog<({String name, String? hex})>(
      context: context,
      builder: (_) => _ColorFormDialog(row: row),
    );
    if (result == null) return;
    if (row == null) {
      await LocalDb.instance.insertMasterColor(result.name, result.hex);
    } else {
      await LocalDb.instance.updateMasterColor(
        row['id'] as int,
        result.name,
        result.hex,
      );
    }
    if (mounted) _reload();
  }

  Future<void> _delete(Map<String, dynamic> row) async {
    final ok = await _confirmDelete(context, row['color_family'] as String);
    if (!ok) return;
    await LocalDb.instance.deleteMasterColor(row['id'] as int);
    if (mounted) _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_color',
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah warna'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Gagal memuat data: ${snap.error}'));
          }
          final rows = snap.data ?? const <Map<String, dynamic>>[];
          if (rows.isEmpty) {
            return const Center(child: Text('Belum ada warna.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: rows.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final r = rows[i];
              final hex = r['hex_code'] as String?;
              return ListTile(
                // Lingkaran pratinjau warna; abu-abu bila hex kosong/tidak valid.
                leading: CircleAvatar(
                  backgroundColor:
                      _parseHex(hex) ??
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: _parseHex(hex) == null
                      ? const Icon(Icons.palette_outlined, size: 18)
                      : null,
                ),
                title: Text(r['color_family'] as String),
                subtitle: Text(hex ?? 'Tanpa kode hex'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Ubah',
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _openForm(row: r),
                    ),
                    IconButton(
                      tooltip: 'Hapus',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _delete(r),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ColorFormDialog extends StatefulWidget {
  const _ColorFormDialog({this.row});
  final Map<String, dynamic>? row;

  @override
  State<_ColorFormDialog> createState() => _ColorFormDialogState();
}

class _ColorFormDialogState extends State<_ColorFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameC;
  late final TextEditingController _hexC;
  String? _nameError;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController(
      text: widget.row?['color_family'] as String? ?? '',
    );
    _hexC = TextEditingController(
      text: widget.row?['hex_code'] as String? ?? '',
    );
  }

  @override
  void dispose() {
    _nameC.dispose();
    _hexC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _nameError = null;
    });
    final name = _nameC.text.trim();
    final dup = await LocalDb.instance.masterColorExists(
      name,
      exceptId: widget.row?['id'] as int?,
    );
    if (!mounted) return;
    if (dup) {
      setState(() {
        _saving = false;
        _nameError = 'Nama warna sudah dipakai';
      });
      return;
    }
    final hex = _hexC.text.trim();
    // Hex disimpan huruf besar agar seragam; kosong disimpan sebagai null.
    Navigator.pop(context, (
      name: name,
      hex: hex.isEmpty ? null : hex.toUpperCase(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.row == null ? 'Tambah warna' : 'Ubah warna'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameC,
              decoration: InputDecoration(
                labelText: 'Nama warna',
                hintText: 'contoh: navy',
                errorText: _nameError,
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Nama tidak boleh kosong'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _hexC,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Kode hex (opsional)',
                hintText: '#1A237E',
              ),
              validator: (v) {
                final t = v?.trim() ?? '';
                if (t.isEmpty) return null; // opsional
                return _hexPattern.hasMatch(t)
                    ? null
                    : 'Format harus #RRGGBB';
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}