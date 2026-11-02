import 'dart:async' show unawaited;
import 'dart:io' show Directory, File;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/garment.dart';
import '../models/outfit.dart';
import 'local_db.dart';
import 'outfit_engine.dart';
import 'recommender.dart';

/// Signed-in user (null = logged out). Local placeholder for the cloud profile.
class AppUser {
  const AppUser({required this.name, required this.email});

  final String name;
  final String email;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class AuthNotifier extends Notifier<AppUser?> {
  @override
  AppUser? build() {
    try {
      final subscription =
          FirebaseAuth.instance.authStateChanges().listen((user) {
        state = _fromFirebase(user);
      });
      ref.onDispose(subscription.cancel);
      return _fromFirebase(FirebaseAuth.instance.currentUser);
    } catch (error) {
      // Firebase belum dikonfigurasi; aplikasi tetap bisa dibuka.
      return null;
    }
  }

  /// Dipanggil setelah Firebase berhasil mengautentikasi pengguna.
  void setUser(AppUser? user) => state = user;

  void signOut() => state = null;

  static AppUser? _fromFirebase(User? user) {
    if (user == null) return null;
    final email = user.email ?? '';
    return AppUser(
      name: user.displayName ??
          (email.contains('@') ? email.split('@').first : 'Pengguna'),
      email: email,
    );
  }
}

final authProvider = NotifierProvider<AuthNotifier, AppUser?>(AuthNotifier.new);

// ===========================================================================
// ML dan database
// ===========================================================================

final localDbProvider = Provider<LocalDb>((ref) => LocalDb.instance);

/// Null bila model/database tidak bisa dimuat (web, desktop, atau aset belum terdaftar).
/// Di-override di main.dart dengan engine yang sudah dimuat.
final engineProvider = Provider<OutfitEngine?>((ref) => null);

/// Gender untuk tabel prediksi: 'male' | 'female' | 'unisex'. Belum ada UI untuk mengubahnya;
/// tambahkan pilihan di profile_screen lalu panggil ref.read(genderProvider.notifier).set(...).
class GenderNotifier extends Notifier<String> {
  @override
  String build() => 'unisex';

  void set(String value) => state = value;
}

final genderProvider = NotifierProvider<GenderNotifier, String>(
  GenderNotifier.new,
);

// ===========================================================================
// Sesi scan: foto -> hasil deteksi (dibaca analyzing_screen dan detection_result_screen)
// ===========================================================================

class ScanSession {
  const ScanSession({
    this.imagePath,
    this.detection,
    this.loading = false,
    this.errorMessage,
  });

  final String? imagePath;
  final Detection? detection;
  final bool loading;
  final String? errorMessage;
}

class ScanSessionNotifier extends Notifier<ScanSession> {
  @override
  ScanSession build() => const ScanSession();

  /// Dipanggil camera_preview_screen saat user memilih "Gunakan Foto".
  void start(String imagePath) => state = ScanSession(imagePath: imagePath);

  /// Dipanggil analyzing_screen. Hasil atau pesan galat dibaca lewat state.
  Future<void> run() async {
    final path = state.imagePath;
    if (path == null) {
      state = const ScanSession(errorMessage: 'Foto tidak ditemukan.');
      return;
    }
    final engine = ref.read(engineProvider);
    if (engine == null) {
      state = ScanSession(
        imagePath: path,
        errorMessage:
            'Model deteksi hanya tersedia di Android dan iOS, '
            'dan harus terpasang bersama aplikasi.',
      );
      return;
    }
    state = ScanSession(imagePath: path, loading: true);
    try {
      final bytes = await File(path).readAsBytes();
      final d = await engine.analyze(bytes, gender: ref.read(genderProvider));
      // User bisa menutup layar dan memulai scan lain selagi analisis berjalan; hasil lama dibuang.
      if (state.imagePath != path) return;
      state = ScanSession(imagePath: path, detection: d);
    } catch (_) {
      if (state.imagePath != path) return;
      state = ScanSession(
        imagePath: path,
        errorMessage: 'Foto tidak bisa dianalisis. Coba foto lain.',
      );
    }
  }

  /// User mengoreksi jenis pakaian (mis. memilih salah satu alternatif).
  Future<void> chooseType(String type) async {
    final d = state.detection;
    final engine = ref.read(engineProvider);
    if (d == null || engine == null || d.type == type) return;
    final nd = await engine.withType(d, type, gender: ref.read(genderProvider));
    state = ScanSession(imagePath: state.imagePath, detection: nd);
  }

  void chooseFormality(String formality) {
    final d = state.detection;
    if (d == null) return;
    state = ScanSession(
      imagePath: state.imagePath,
      detection: d.copyWith(formality: formality),
    );
  }

  /// Simpan hasil ke lemari (SQLite) lalu reset sesi. Melempar galat bila penyimpanan gagal.
  Future<Garment?> save() async {
    final path = state.imagePath;
    final d = state.detection;
    if (path == null || d == null) return null;
    final g = await ref
        .read(wardrobeProvider.notifier)
        .addDetected(imagePath: path, d: d);
    state = const ScanSession();
    return g;
  }

  void reset() => state = const ScanSession();
}

final scanSessionProvider = NotifierProvider<ScanSessionNotifier, ScanSession>(
  ScanSessionNotifier.new,
);

// ===========================================================================
// Lemari
// ===========================================================================

/// The user's wardrobe ("Lemari Saya"). Dimuat dari SQLite saat start; item baru disimpan ke SQLite.
class WardrobeNotifier extends Notifier<List<Garment>> {
  @override
  List<Garment> build() {
    unawaited(_load()); // tidak menahan build; state terisi setelah DB terbaca
    return <Garment>[];
  }

  Future<void> _load() async {
    try {
      final rows = await ref.read(localDbProvider).wardrobe();
      state = rows.map(Garment.fromRow).toList();
    } catch (_) {
      // DB belum siap atau aset belum terdaftar: biarkan lemari kosong agar app tidak crash saat start.
    }
  }

  /// Jalur lama (data placeholder, hanya di memori). Dipertahankan agar kode lama tidak patah.
  void add(Garment garment) => state = [...state, garment];

  /// Salin foto ke penyimpanan aplikasi, simpan ke SQLite, lalu tambahkan ke state.
  Future<Garment> addDetected({
    required String imagePath,
    required Detection d,
  }) async {
    // Foto kamera biasanya ada di folder cache yang bisa dibersihkan sistem; salin ke folder dokumen.
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory(p.join(dir.path, _photoFolder));
    await folder.create(recursive: true);
    final saved = await File(imagePath).copy(
      p.join(
        folder.path,
        '${DateTime.now().millisecondsSinceEpoch}${p.extension(imagePath)}',
      ),
    );

    final style = d.topStyle;
    final id = await ref
        .read(localDbProvider)
        .insertWardrobeItem(
          imagePath: saved.path,
          type: d.type,
          slot: d.slot,
          color: d.color,
          colorHex: d.colorHex,
          confidence: d.confidence,
          formality: d.formality,
          style: style,
        );
    final g = Garment.fromRow({
      'id': id,
      'image_path': saved.path,
      'garment_type': d.type,
      'slot': d.slot,
      'color_family': d.color,
      'color_hex': d.colorHex,
      'detection_conf': d.confidence,
      'formality': d.formality,
      'style': style,
      'created_at': DateTime.now()
          .toUtc()
          .toIso8601String()
          .substring(0, 19)
          .replaceFirst('T', ' '),
    });
    state = [...state, g];
    return g;
  }

  static const _photoFolder = 'wardrobe';

  void remove(String id) {
    final target = state.where((g) => g.id == id).firstOrNull;
    final n = int.tryParse(id);
    if (n != null) unawaited(ref.read(localDbProvider).deleteWardrobeItem(n));
    final path = target?.imagePath;
    // Hapus berkas foto hanya bila ada di folder milik app, bukan foto asli di galeri user.
    if (path != null && p.basename(p.dirname(path)) == _photoFolder) {
      unawaited(File(path).delete().then((_) {}, onError: (_) {}));
    }
    state = state.where((g) => g.id != id).toList();
  }

  /// Mengosongkan lemari, dipakai saat pengguna keluar atau menghapus akun.
  void clear() => state = const <Garment>[];

  Garment? get latest => state.isEmpty ? null : state.last;
}

final wardrobeProvider = NotifierProvider<WardrobeNotifier, List<Garment>>(
  WardrobeNotifier.new,
);

// ===========================================================================
// Rekomendasi
// ===========================================================================

/// Outfit atasan + bawahan dari pakaian yang sudah diinput user, diurut skor pasangan model.
/// Kosong bila engine belum termuat atau lemari belum punya satu atasan dan satu bawahan.
final recommendationsProvider = Provider<List<Outfit>>((ref) {
  final wardrobe = ref.watch(wardrobeProvider);
  final engine = ref.watch(engineProvider);
  if (engine == null || wardrobe.isEmpty) return const <Outfit>[];
  return buildOutfits(
    wardrobe: wardrobe,
    pairScore: engine.pairScore,
    toPercentile: engine.topBottomPercentile,
  );
});

/// Saran item untuk slot yang belum ada pada sebuah outfit (sepatu, luaran, tas).
/// Tiap saran: garment_type, color_family, score. Berupa deskripsi teks; dataset tidak punya foto item.
final suggestionsProvider =
    FutureProvider.family<Map<String, List<Map<String, dynamic>>>, Outfit>((
      ref,
      outfit,
    ) async {
      final engine = ref.watch(engineProvider);
      if (engine == null) return const {};
      final gender = ref.watch(genderProvider);
      // Outfit placeholder punya id non-numerik dan tidak ada di database.
      final items = [outfit.top, outfit.bottom]
          .where((g) => int.tryParse(g.id) != null && g.slot != null)
          .map((g) => g.toEngineRow())
          .toList();
      if (items.length < 2) return const {};
      return engine.recommend(
        items,
        targetFormality: outfit.formality ?? engine.outfitFormality(items),
        gender: gender,
      );
    });
