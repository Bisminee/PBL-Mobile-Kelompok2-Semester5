import 'package:flutter/material.dart' show Color;

/// Kosakata pakaian: pemetaan dari kode model/database (bahasa Inggris, snake_case)
/// ke teks yang tampil di UI (bahasa Indonesia). Semua fungsi murni agar mudah diuji.

/// Slot outfit dari jenis pakaian. Harus sama dengan tabel ref_garment_type di fashion_app.db.
const Map<String, String> slotOfType = {
  't_shirt': 'top',
  'longsleeve': 'top',
  'shirt': 'top',
  'polo': 'top',
  'undershirt': 'top',
  'blouse': 'top',
  'top': 'top',
  'body': 'top',
  'hoodie': 'top',
  'sweater': 'top',
  'pants': 'bottom',
  'shorts': 'bottom',
  'skirt': 'bottom',
  'dress': 'onepiece',
  'outwear': 'outer',
  'blazer': 'outer',
  'shoes': 'shoes',
  'hat': 'headwear',
  'bag': 'bag',
  'accessory': 'accessory',
};

const Map<String, String> _typeLabel = {
  't_shirt': 'Kaos',
  'longsleeve': 'Kaos lengan panjang',
  'shirt': 'Kemeja',
  'polo': 'Polo',
  'undershirt': 'Kaos dalam',
  'blouse': 'Blus',
  'top': 'Atasan',
  'body': 'Bodysuit',
  'hoodie': 'Hoodie',
  'sweater': 'Sweater',
  'pants': 'Celana panjang',
  'shorts': 'Celana pendek',
  'skirt': 'Rok',
  'dress': 'Dress',
  'outwear': 'Luaran',
  'blazer': 'Blazer',
  'shoes': 'Sepatu',
  'hat': 'Topi',
  'bag': 'Tas',
  'accessory': 'Aksesori',
};

/// Kategori yang dipakai filter lemari. Sepatu memakai kata "Sepatu" agar sama dengan filter di UI.
const Map<String, String> _categoryOfSlot = {
  'top': 'Atasan',
  'bottom': 'Bawahan',
  'onepiece': 'Terusan',
  'outer': 'Luaran',
  'shoes': 'Sepatu',
  'headwear': 'Aksesori',
  'bag': 'Aksesori',
  'accessory': 'Aksesori',
};

const Map<String, String> _slotLabel = {
  'top': 'Atasan',
  'bottom': 'Bawahan',
  'onepiece': 'Terusan',
  'outer': 'Luaran',
  'shoes': 'Sepatu',
  'headwear': 'Topi',
  'bag': 'Tas',
  'accessory': 'Aksesori',
};

const Map<String, String> _styleLabel = {
  'casual': 'Casual',
  'minimalist': 'Minimalis',
  'vintage': 'Vintage',
  'streetwear': 'Streetwear',
  'preppy': 'Preppy',
  'elegant': 'Elegan',
  'commuter': 'Commuter',
  'sporty': 'Sporty',
  'feminine': 'Feminin',
  'unspecified': 'Umum',
};

const Map<String, String> _colorLabel = {
  'black': 'Hitam',
  'white': 'Putih',
  'gray': 'Abu-abu',
  'beige': 'Krem',
  'brown': 'Cokelat',
  'blue': 'Biru',
  'green': 'Hijau',
  'red': 'Merah',
  'pink': 'Merah muda',
  'purple': 'Ungu',
  'yellow': 'Kuning',
  'orange': 'Oranye',
  'multicolor': 'Multiwarna',
  'other': 'Lainnya',
};

/// Sama dengan tabel ref_color di fashion_app.db. Dipakai bila hex dari piksel tidak ada.
const Map<String, int> _colorValue = {
  'black': 0xFF1A1A1A,
  'white': 0xFFF5F5F5,
  'gray': 0xFF808080,
  'beige': 0xFFD8C3A5,
  'brown': 0xFF6B4423,
  'blue': 0xFF2F5D9E,
  'green': 0xFF3E7C4F,
  'red': 0xFFB3261E,
  'pink': 0xFFE8A0BF,
  'purple': 0xFF7B4B94,
  'yellow': 0xFFE6C229,
  'orange': 0xFFE67E22,
  'multicolor': 0xFF9E9E9E,
  'other': 0xFF9E9E9E,
};

/// Urutan formalitas dari paling santai ke paling resmi.
const List<String> formalityValues = ['non_formal', 'semi_formal', 'formal'];

const Map<String, int> _formalityLevel = {
  'non_formal': 1,
  'semi_formal': 2,
  'formal': 3,
};

String typeLabel(String? type) => _typeLabel[type] ?? type ?? '-';

String categoryOfSlot(String? slot) => _categoryOfSlot[slot] ?? 'Aksesori';

String slotLabel(String? slot) => _slotLabel[slot] ?? slot ?? '-';

String styleLabel(String? style) =>
    style == null ? '-' : (_styleLabel[style] ?? style);

String colorLabel(String? family) =>
    family == null ? '-' : (_colorLabel[family] ?? family);

Color colorOfFamily(String? family) =>
    Color(_colorValue[family] ?? _colorValue['other']!);

/// Mengubah "#RRGGBB" menjadi Color. Format yang salah jatuh ke abu-abu agar UI tidak crash.
Color colorFromHex(String? hex) {
  if (hex == null) return colorOfFamily('other');
  final clean = hex.replaceFirst('#', '');
  final value = int.tryParse(clean, radix: 16);
  if (clean.length != 6 || value == null) return colorOfFamily('other');
  return Color(0xFF000000 | value);
}

String formalityLabel(String? f) => switch (f) {
  'formal' => 'Formal',
  'semi_formal' => 'Semi formal',
  'non_formal' => 'Non formal',
  _ => '-',
};

/// Formalitas yang lebih rendah di antara dua item. Outfit hanya seformal bagian paling santainya.
String lowerFormality(String? a, String? b) {
  final la = _formalityLevel[a] ?? 1;
  final lb = _formalityLevel[b] ?? 1;
  return formalityValues[(la <= lb ? la : lb) - 1];
}

const List<String> _monthLong = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

const List<String> _monthShort = [
  'JAN',
  'FEB',
  'MAR',
  'APR',
  'MEI',
  'JUN',
  'JUL',
  'AGU',
  'SEP',
  'OKT',
  'NOV',
  'DES',
];

/// "31 Oktober 2026". Tanpa paket intl supaya tidak menambah dependensi.
String formatDateId(DateTime d) =>
    '${d.day} ${_monthLong[d.month - 1]} ${d.year}';

/// "31 OKT 2026", untuk label kecil bergaya mono.
String formatDateShortId(DateTime d) =>
    '${d.day} ${_monthShort[d.month - 1]} ${d.year}';

const List<String> _dayLong = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

/// "Minggu, 1 Nov". Dipakai sebagai label tanggal di beranda.
String formatDayDateId(DateTime d) {
  final m = _monthShort[d.month - 1];
  return '${_dayLong[d.weekday - 1]}, ${d.day} ${m[0]}${m.substring(1).toLowerCase()}';
}

/// Sapaan menurut jam (0..23).
String greetingId(int hour) {
  if (hour < 11) return 'Selamat pagi,';
  if (hour < 15) return 'Selamat siang,';
  if (hour < 18) return 'Selamat sore,';
  return 'Selamat malam,';
}
