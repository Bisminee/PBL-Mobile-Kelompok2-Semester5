/// Batas panjang nama tampilan agar sapaan dan inisial tetap rapi.
const int maxDisplayNameLength = 60;

/// Membersihkan nama tampilan sebelum dikirim ke Firebase.
///
/// Mengembalikan null bila hasilnya kosong, supaya UI bisa menolak input
/// tanpa perlu mengetahui aturan Firebase.
String? normalizeDisplayName(String raw) {
  final rapi = raw.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (rapi.isEmpty) return null;
  if (rapi.length <= maxDisplayNameLength) return rapi;
  return rapi.substring(0, maxDisplayNameLength).trimRight();
}

/// Membaca preferensi boolean dari SQLite. Nilai yang tidak dikenal
/// dikembalikan ke [fallback].
bool parseBoolPreference(String? raw, {bool fallback = true}) {
  if (raw == null) return fallback;
  final nilai = raw.trim().toLowerCase();
  if (nilai == 'true' || nilai == '1') return true;
  if (nilai == 'false' || nilai == '0') return false;
  return fallback;
}

/// Bentuk penyimpanan preferensi boolean di tabel app_preference.
String encodeBoolPreference(bool value) => value ? 'true' : 'false';
