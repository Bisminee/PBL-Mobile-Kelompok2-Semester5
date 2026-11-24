import 'dart:async' show unawaited;
import 'dart:io' show File;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/garment.dart';
import '../models/outfit.dart';
import '../models/saved_outfit.dart';
import '../models/scan_source.dart';
import 'local_db.dart';
import 'outfit_detail.dart';
import 'outfit_engine.dart';
import 'photo_source.dart';
import 'photo_storage.dart';
import 'recommender.dart';
import 'user_preferences.dart';
import 'user_repository.dart';

/// Signed-in user (null = logged out). Local placeholder for the cloud profile.
class AppUser {
  const AppUser({
    required this.name,
    required this.email,
    this.photoUrl,
    this.uid,
  });

  final String name;
  final String email;

  /// URL foto profil dari akun Google. Null bila pengguna tidak punya foto.
  final String? photoUrl;

  /// UID Firebase. Null pada mode uji lama atau pengguna yang belum login.
  final String? uid;

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
      final subscription = FirebaseAuth.instance.authStateChanges().listen((
        user,
      ) {
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
      uid: user.uid,
      name:
          user.displayName ??
          (email.contains('@') ? email.split('@').first : 'Pengguna'),
      email: email,
      photoUrl: user.photoURL,
    );
  }
}

final authProvider = NotifierProvider<AuthNotifier, AppUser?>(AuthNotifier.new);

/// UID aktif. Semua data pengguna di SQLite difilter memakai nilai ini.
final activeUidProvider = Provider<String?>((ref) {
  return ref.watch(authProvider)?.uid;
});

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(),
);

final userPreferenceServiceProvider = Provider<UserPreferenceService>((ref) {
  return UserPreferenceService(
    ref.watch(localDbProvider),
    ref.watch(userRepositoryProvider),
  );
});

/// Metadata preferensi per akun. Sumber awal: outfit tersimpan.
final userPreferencesProvider = FutureProvider<UserPreferences>((ref) async {
  final uid = ref.watch(activeUidProvider);
  if (uid == null) return UserPreferences.empty();
  return ref.watch(userPreferenceServiceProvider).load(uid);
});

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

/// Pemilih foto galeri. Diganti versi palsu pada widget test.
final photoPickerProvider = Provider<PhotoPicker>(
  (ref) => GalleryPhotoPicker(),
);

class ScanSession {
  const ScanSession({
    this.imagePath,
    this.source = ScanSource.camera,
    this.detection,
    this.loading = false,
    this.errorMessage,
  });

  final String? imagePath;
  final ScanSource source;
  final Detection? detection;
  final bool loading;
  final String? errorMessage;
}

class ScanSessionNotifier extends Notifier<ScanSession> {
  @override
  ScanSession build() => const ScanSession();

  /// Dipanggil camera_preview_screen saat user memilih "Gunakan Foto".
  void start(String imagePath, {ScanSource source = ScanSource.camera}) =>
      state = ScanSession(imagePath: imagePath, source: source);

  /// Dipanggil analyzing_screen. Hasil atau pesan galat dibaca lewat state.
  Future<void> run() async {
    final path = state.imagePath;
    final source = state.source;
    if (path == null) {
      state = const ScanSession(errorMessage: 'Foto tidak ditemukan.');
      return;
    }
    final engine = ref.read(engineProvider);
    if (engine == null) {
      state = ScanSession(
        imagePath: path,
        source: source,
        errorMessage:
            'Model deteksi hanya tersedia di Android dan iOS, '
            'dan harus terpasang bersama aplikasi.',
      );
      return;
    }
    state = ScanSession(imagePath: path, source: source, loading: true);
    try {
      final bytes = await File(path).readAsBytes();
      final d = await engine.analyze(bytes, gender: ref.read(genderProvider));
      // User bisa menutup layar dan memulai scan lain selagi analisis berjalan; hasil lama dibuang.
      if (state.imagePath != path) return;
      state = ScanSession(imagePath: path, source: source, detection: d);
    } catch (_) {
      if (state.imagePath != path) return;
      state = ScanSession(
        imagePath: path,
        source: source,
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
    state = ScanSession(
      imagePath: state.imagePath,
      source: state.source,
      detection: nd,
    );
  }

  /// User memilih warna sendiri bila hasil ekstraksi piksel dianggap salah.
  /// Komposisi warna asli tetap disimpan agar warna hasil deteksi tidak hilang
  /// dari layar setelah user memilih warna lain.
  void chooseColor(String family, String hex) {
    final d = state.detection;
    if (d == null || (d.color == family && d.colorHex == hex)) return;
    state = ScanSession(
      imagePath: state.imagePath,
      source: state.source,
      detection: d.copyWith(color: family, colorHex: hex),
    );
  }

  void chooseFormality(String formality) {
    final d = state.detection;
    if (d == null) return;
    state = ScanSession(
      imagePath: state.imagePath,
      source: state.source,
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
    final uid = ref.watch(activeUidProvider);
    if (uid == null) return <Garment>[];
    unawaited(
      _load(uid),
    ); // tidak menahan build; state terisi setelah DB terbaca
    return <Garment>[];
  }

  Future<void> _load(String uid) async {
    try {
      final rows = await ref.read(localDbProvider).wardrobe(ownerUid: uid);
      if (ref.read(activeUidProvider) != uid) return;
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
    final uid = ref.read(activeUidProvider);
    if (uid == null) throw StateError('Belum ada akun aktif.');
    final savedPath = await PhotoStorage.save(uid, imagePath);

    final style = d.topStyle;
    final id = await ref
        .read(localDbProvider)
        .insertWardrobeItem(
          ownerUid: uid,
          imagePath: savedPath,
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
      'image_path': savedPath,
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

  /// Menyimpan perubahan atribut dari layar detail pakaian. Foto tidak diubah.
  Future<void> update(Garment garment) async {
    final id = int.tryParse(garment.id);
    final uid = ref.read(activeUidProvider);
    if (id == null ||
        uid == null ||
        garment.garmentType == null ||
        garment.slot == null) {
      return;
    }
    await ref
        .read(localDbProvider)
        .updateWardrobeItem(
          id: id,
          ownerUid: uid,
          type: garment.garmentType!,
          slot: garment.slot!,
          color: garment.colorFamily ?? 'other',
          colorHex: hexOf(garment.colorValue),
          formality: garment.formality ?? 'non_formal',
          style: garment.style,
        );
    state = [
      for (final item in state)
        if (item.id == garment.id) garment else item,
    ];
  }

  void remove(String id) {
    final uid = ref.read(activeUidProvider);
    if (uid == null) return;
    final target = state.where((g) => g.id == id).firstOrNull;
    final n = int.tryParse(id);
    if (n != null) {
      unawaited(ref.read(localDbProvider).deleteWardrobeItem(n, ownerUid: uid));
    }
    final path = target?.imagePath;
    if (path != null) unawaited(PhotoStorage.deleteFileIfOwned(path));
    state = state.where((g) => g.id != id).toList();
  }

  /// Mengosongkan lemari, dipakai saat pengguna keluar atau menghapus akun.
  void clear() => state = const <Garment>[];

  Garment? get latest => state.isEmpty ? null : state.last;
}

final wardrobeProvider = NotifierProvider<WardrobeNotifier, List<Garment>>(
  WardrobeNotifier.new,
);

/// Outfit yang disimpan pengguna dari layar detail. Dibaca dari SQLite.
/// Panggil `ref.invalidate(savedOutfitsProvider)` setelah menyimpan outfit baru.
final savedOutfitsProvider = FutureProvider<List<SavedOutfit>>((ref) async {
  final uid = ref.watch(activeUidProvider);
  if (uid == null) return const <SavedOutfit>[];
  try {
    return await ref.read(localDbProvider).savedOutfits(ownerUid: uid);
  } catch (_) {
    return const <SavedOutfit>[];
  }
});

/// Riwayat rekomendasi yang pernah dibuka pengguna, terbaru lebih dulu.
/// autoDispose: dibaca ulang dari SQLite setiap layar riwayat dibuka.
final recommendationHistoryProvider =
    FutureProvider.autoDispose<List<SavedOutfit>>((ref) async {
      final uid = ref.watch(activeUidProvider);
      if (uid == null) return const <SavedOutfit>[];
      try {
        return await ref
            .read(localDbProvider)
            .recommendationHistory(ownerUid: uid);
      } catch (_) {
        return const <SavedOutfit>[];
      }
    });

// ===========================================================================
// Rekomendasi
// ===========================================================================

/// Outfit atasan + bawahan dari pakaian yang sudah diinput user, diurut skor pasangan model.
/// Kosong bila engine belum termuat atau lemari belum punya satu atasan dan satu bawahan.
final recommendationsProvider = Provider<List<Outfit>>((ref) {
  final wardrobe = ref.watch(wardrobeProvider);
  if (wardrobe.isEmpty) return const <Outfit>[];
  final engine = ref.watch(engineProvider);
  // E7.5: bila model belum termuat, tetap beri rekomendasi dari aturan harmoni.
  if (engine == null) return buildRuleOutfits(wardrobe: wardrobe);
  return buildOutfits(
    wardrobe: wardrobe,
    pairScore: engine.pairScore,
    toPercentile: engine.topBottomPercentile,
  );
});

/// Rekomendasi per piece: setiap atasan atau bawahan mendapat maksimal tiga
/// outfit terbaik. Dipakai halaman rekomendasi dan tombol dari detail pakaian.
final recommendationGroupsProvider = Provider<List<RecommendationGroup>>((ref) {
  final wardrobe = ref.watch(wardrobeProvider);
  if (wardrobe.isEmpty) return const <RecommendationGroup>[];
  final engine = ref.watch(engineProvider);
  if (engine == null) {
    return buildRuleRecommendationGroups(wardrobe: wardrobe);
  }
  return buildRecommendationGroups(
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
