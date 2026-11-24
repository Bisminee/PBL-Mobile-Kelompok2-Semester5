import 'dart:convert';

import '../models/saved_outfit.dart';
import 'local_db.dart';
import 'user_repository.dart';

/// Metadata preferensi yang diturunkan dari outfit tersimpan.
///
/// Tahap ini hanya menyimpan metadata. Ranking rekomendasi belum memakai
/// preferensi tersebut.
class UserPreferences {
  const UserPreferences(this.data);

  final Map<String, dynamic> data;

  static const localKey = 'preferences_v1';

  static UserPreferences empty() => UserPreferences({
    'preferred_colors': <String>[],
    'preferred_formality': null,
    'preferred_styles': <String>[],
    'preferred_slots': <String>[],
    'source': 'saved_outfits',
    'schema_version': 1,
    'updated_at': DateTime.now().toUtc().toIso8601String(),
  });

  static UserPreferences derive(List<SavedOutfit> outfits) {
    final colors = <String, int>{};
    final styles = <String, int>{};
    final slots = <String, int>{};
    final formalities = <String, int>{};

    void count(Map<String, int> map, String? value) {
      if (value == null || value.isEmpty) return;
      map[value] = (map[value] ?? 0) + 1;
    }

    for (final outfit in outfits) {
      count(formalities, outfit.formality);
      for (final item in outfit.items) {
        count(colors, item.colorFamily);
        count(styles, item.style);
        count(slots, item.slot);
      }
    }

    List<String> top(Map<String, int> map, int n) {
      final entries = map.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      return entries.take(n).map((e) => e.key).toList();
    }

    String? mode(Map<String, int> map) {
      if (map.isEmpty) return null;
      final entries = map.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      return entries.first.key;
    }

    return UserPreferences({
      'preferred_colors': top(colors, 5),
      'preferred_formality': mode(formalities),
      'preferred_styles': top(styles, 5),
      'preferred_slots': top(slots, 2),
      'source': 'saved_outfits',
      'schema_version': 1,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  static UserPreferences? fromJson(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? UserPreferences(decoded) : null;
    } catch (_) {
      return null;
    }
  }

  String get encoded => jsonEncode(data);

  String? get updatedAt => data['updated_at'] as String?;

  bool isNewerThan(UserPreferences? other) {
    if (other == null) return true;
    final a = DateTime.tryParse(updatedAt ?? '');
    final b = DateTime.tryParse(other.updatedAt ?? '');
    if (a == null) return false;
    if (b == null) return true;
    return a.isAfter(b);
  }
}

class UserPreferenceService {
  UserPreferenceService(this._db, this._repo);

  final LocalDb _db;
  final UserRepository _repo;

  Future<UserPreferences> load(String uid) async {
    final local = UserPreferences.fromJson(
      await _db.preference(UserPreferences.localKey, ownerUid: uid),
    );
    Map<String, dynamic> cloud = const {};
    try {
      cloud = await _repo.loadPreferences(uid);
    } catch (_) {
      // Offline atau Firestore belum siap.
    }
    final remote = cloud.isEmpty ? null : UserPreferences(cloud);

    final chosen = remote != null && remote.isNewerThan(local)
        ? remote
        : (local ?? remote);
    if (chosen == null) {
      return refreshFromOutfits(uid);
    }
    await _saveLocal(uid, chosen);
    if (local == null || chosen.isNewerThan(remote)) {
      await _saveCloud(uid, chosen);
    }
    return chosen;
  }

  Future<UserPreferences> refreshFromOutfits(String uid) async {
    final outfits = await _db.savedOutfits(ownerUid: uid);
    final prefs = UserPreferences.derive(outfits);
    await _saveLocal(uid, prefs);
    await _saveCloud(uid, prefs);
    return prefs;
  }

  Future<void> _saveLocal(String uid, UserPreferences prefs) async {
    await _db.setPreference(
      UserPreferences.localKey,
      prefs.encoded,
      ownerUid: uid,
    );
  }

  Future<void> _saveCloud(String uid, UserPreferences prefs) async {
    try {
      await _repo.savePreferences(uid, prefs.data);
    } catch (_) {
      // Lokal tetap menjadi sumber utama saat offline.
    }
  }
}
