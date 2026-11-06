/// Palet 14 nama warna yang dipakai di UI dan laporan.
///
/// Nama keluarga warna dari `rgbToFamily` tetap dipakai untuk pencarian skor
/// pasangan di database. Kelas ini hanya menyediakan nama tampilan yang stabil.
library;

/// Daftar 14 nama warna, urut seperti di dokumen tugas.
const List<String> colorPalette14 = <String>[
  'hitam',
  'putih',
  'abu-abu',
  'krem',
  'cokelat',
  'merah',
  'pink',
  'oranye',
  'kuning',
  'hijau',
  'hijau army',
  'biru muda',
  'navy',
  'ungu',
];

/// Nama tampilan untuk satu keluarga warna.
///
/// Keluarga yang tidak dikenal tetap dikembalikan apa adanya agar tidak
/// menghilangkan informasi, tetapi UI sebaiknya memakai [colorPalette14].
String paletteNameForFamily(String family) {
  switch (family) {
    case 'black':
    case 'hitam':
      return 'hitam';
    case 'white':
    case 'putih':
      return 'putih';
    case 'gray':
    case 'grey':
    case 'abu-abu':
      return 'abu-abu';
    case 'cream':
    case 'beige':
    case 'krem':
      return 'krem';
    case 'brown':
    case 'cokelat':
      return 'cokelat';
    case 'red':
    case 'maroon':
    case 'merah':
      return 'merah';
    case 'pink':
      return 'pink';
    case 'orange':
    case 'oranye':
      return 'oranye';
    case 'yellow':
    case 'kuning':
      return 'kuning';
    case 'green':
    case 'hijau':
      return 'hijau';
    case 'sage':
    case 'army green':
    case 'hijau army':
      return 'hijau army';
    case 'blue':
    case 'denim':
    case 'light blue':
    case 'biru muda':
      return 'biru muda';
    case 'navy':
      return 'navy';
    case 'purple':
    case 'ungu':
      return 'ungu';
    default:
      return family;
  }
}

/// True bila [name] termasuk palet 14 warna.
bool isPaletteName(String name) => colorPalette14.contains(name);
