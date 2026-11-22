# Alur Warna Sera-Z

Diperbarui: 23 November 2026

Dokumen ini menjelaskan alur warna dari dataset sampai aplikasi, termasuk
kondisi yang sudah berjalan dan target 16 keluarga warna.

## 1. Tujuan

Warna dipakai untuk tiga hal:

1. Menampilkan warna dominan pakaian di UI.
2. Menjadi fitur untuk menilai kecocokan outfit.
3. Menjadi alasan yang bisa dibaca pengguna, misalnya "navy cocok dengan krem".

Warna tidak dipakai untuk mengenali jenis pakaian. Klasifikasi jenis tetap
tugas Model 1.

## 2. Tiga kosakata warna

| Kosakata | Jumlah | Dipakai untuk | Status |
|---|---:|---|---|
| `baseColour` dataset | 47 | Label katalog dan evaluasi | Ada di dataset |
| 16 keluarga harmoni | 16 | UI, harmoni, dan warna item baru | Target |
| 14 warna lama | 14 | Tabel ML dan database lama | Legacy |

16 keluarga target:

```
black, white, gray, cream, brown, red, maroon, pink,
orange, yellow, green, olive, teal, blue, navy, purple
```

14 warna lama:

```
beige, black, blue, brown, gray, green, multicolor,
orange, other, pink, purple, red, white, yellow
```

## 3. Sumber acuan warna

| Berkas | Isi |
|---|---|
| `lib/services/color_family.dart` | 16 keluarga, HEX, tone, netral, pencocokan Lab, harmoni |
| `lib/services/color_palette.dart` | Palet tampilan, saat ini masih 14 |
| `lib/services/color_extractor.dart` | Ekstraksi warna dari piksel |
| `lib/services/color_harmony.dart` | Aturan harmoni CIELCh |
| `lib/services/local_db.dart` | Lookup warna ke tabel ML |
| `assets/db/fashion_app.db` | Tabel `ref_color` dan tabel ML |

`color_family.dart` adalah sumber kebenaran untuk 16 warna. File lain harus
mengikuti daftar itu, bukan menyimpan daftar baru.

## 4. Alur dataset

```
Dataset Fashion Product Images
  -> styles.csv
  -> kolom articleType, baseColour, gender, image
  -> mapping articleType ke kelas pakaian
  -> mapping baseColour ke 16 keluarga
  -> split train/val/test
  -> training Model 1
```

Kolom yang dipakai:

| Kolom | Fungsi |
|---|---|
| `image` | Input gambar |
| `articleType` | Label jenis produk |
| `baseColour` | Label warna katalog |
| `id` | Kunci produk dan group split |
| `gender` | Filter opsional |
| `masterCategory` | Validasi kategori |
| `subCategory` | Metadata |
| `season`, `year` | Tidak dipakai |

### Mapping `baseColour`

| baseColour | color_family |
|---|---|
| Black | black |
| White | white |
| Grey, Silver, Steel | gray |
| Beige, Cream, Off White | cream |
| Brown, Tan, Coffee Brown | brown |
| Red, Rust | red |
| Maroon, Burgundy | maroon |
| Pink, Peach, Rose, Mauve | pink |
| Orange | orange |
| Yellow, Mustard | yellow |
| Green, Lime Green, Sea Green | green |
| Olive | olive |
| Teal, Turquoise Blue | teal |
| Blue | blue |
| Navy Blue | navy |
| Purple, Lavender, Magenta | purple |
| Multi | warna dominan saat runtime, bukan satu keluarga |
| NA | tidak dipakai untuk evaluasi warna |

Mapping lengkap harus mencakup 47 nilai. Setiap nilai wajib punya tujuan.
Nilai yang tidak dikenal tidak boleh dibiarkan tanpa catatan.

## 5. Alur ekstraksi warna di aplikasi

### Kondisi sekarang

```
Foto
  -> decode
  -> resize lebar 96
  -> ambil area tengah 50 persen
  -> RGB ke HSV
  -> klasifikasi keluarga dengan ambang
  -> pilih keluarga terbanyak
  -> hitung rata-rata RGB
  -> ColorResult(family, hex, share)
```

Berkas: `lib/services/color_extractor.dart`.

Kelemahan:

1. Latar ikut dihitung.
2. Baju putih di latar putih sulit dibedakan.
3. Warna bermotif bisa salah.
4. Hasil keluarga lama belum tentu 16 warna.
5. Tanpa mask, area tengah bukan jaminan area pakaian.

### Target

```
Foto
  -> segmentasi atau mask pakaian
  -> ambil piksel pakaian
  -> konversi ke Lab
  -> K-Means atau K-Means++ (ditunda)
  -> pilih klaster dominan
  -> konversi pusat klaster ke Lab
  -> cari keluarga terdekat dari 16 acuan
  -> hasil color_family, hex, share, tone
```

K-Means++ belum dikerjakan. Untuk tahap sekarang, HSV dan pemetaan ke 16
keluarga tetap dipakai.

### Pencocokan ke 16 keluarga

Gunakan jarak Lab:

```
jarak = sqrt((L - L_acuan)^2 + (a - a_acuan)^2 + (b - b_acuan)^2)
```

Atau CIEDE2000 untuk hasil yang lebih halus.

Aturan:

1. Jangan memakai RGB mentah.
2. Abaikan klaster dengan area terlalu kecil.
3. Gabungkan klaster yang jaraknya sangat dekat.
4. Jika jarak ke semua acuan terlalu besar, gunakan fallback `gray` atau
   tolak hasil.
5. `multicolor` tidak disimpan. Jika warna campuran, ambil warna dominan.

## 6. Penyimpanan warna

### Target tabel `ref_color`

```sql
CREATE TABLE ref_color (
  color_family TEXT PRIMARY KEY,
  hex TEXT NOT NULL,
  legacy_family TEXT NOT NULL,
  tone TEXT,
  is_neutral INTEGER NOT NULL DEFAULT 0,
  aliases TEXT
);
```

Isi 16 keluarga:

| color_family | legacy_family | tone | netral |
|---|---|---|---|
| black | black | dark | ya |
| white | white | light | ya |
| gray | gray | medium | ya |
| cream | beige | light | ya |
| brown | brown | dark | ya |
| red | red | medium | tidak |
| maroon | red | dark | tidak |
| pink | pink | light | tidak |
| orange | orange | medium | tidak |
| yellow | yellow | light | tidak |
| green | green | medium | tidak |
| olive | green | medium | tidak |
| teal | blue | medium | tidak |
| blue | blue | medium | tidak |
| navy | blue | dark | ya |
| purple | purple | dark | tidak |

### Kenapa ada `legacy_family`

Tabel ML masih memakai 14 warna:

```
ml_formality, ml_style, ml_pair_score
```

Warna baru tidak punya baris di tabel itu. `legacy_family` memetakan warna
baru ke warna lama agar lookup tetap menemukan skor.

| Warna baru | Legacy |
|---|---|
| cream | beige |
| maroon | red |
| olive | green |
| teal | blue |
| navy | blue |

Tanpa `legacy_family`, formalitas, style, dan skor pasangan untuk warna baru
akan kosong atau memakai default.

## 7. Migrasi data

### Data lemari

| Warna lama | Tindakan |
|---|---|
| beige | menjadi cream |
| multicolor | hitung warna dominan dari foto; jika gagal, gray |
| other | cari warna terdekat dari color_hex; jika gagal, gray |
| warna lain | tetap |

### Data katalog

`catalog_item` tidak punya `image_path`. Untuk `multicolor` dan `other`:

1. Petakan ke `gray`, atau
2. Hapus baris dari katalog jika tidak bisa dipertanggungjawabkan.

### Urutan migrasi

1. Naikkan versi database.
2. Buat tabel `ref_color` baru.
3. Isi 16 warna.
4. Ubah `wardrobe_item.color_family` dan `catalog_item.color_family`.
5. Hapus tabel lama setelah data aman.
6. Jalankan foreign key check.
7. Ubah query ML agar memakai `legacy_family`.

## 8. Alur harmoni warna

Harmoni memakai warna aktual, bukan nama katalog.

```
Warna atasan (Lab/LCh) + warna bawahan (Lab/LCh)
  -> cek netral
  -> hitung selisih hue
  -> tentukan aturan
  -> skor 0..1
  -> label dan alasan
```

Aturan saat ini:

| Aturan | Kondisi | Skor |
|---|---|---:|
| Netral-netral | Keduanya netral | 0.80 sampai 1.00 |
| Netral-berwarna | Salah satu netral | 0.85 |
| Monokromatik | Selisih hue <= 10 derajat | 0.85 sampai 1.00 |
| Analog | Selisih hue <= 30 derajat | 0.75 sampai 0.90 |
| Komplementer | Selisih hue sekitar 180 derajat | 0.70 sampai 0.85 |
| Kontras | Tidak masuk aturan | 0.35 |

16 keluarga dipakai untuk:

1. Menentukan pasangan warna acuan.
2. Menampilkan alasan.
3. Menjadi fitur T3.
4. Menjaga konsistensi UI dan database.

## 9. Hubungan dengan ML

| Bagian ML | Memakai warna? | Cara |
|---|---|---|
| Model 1 klasifikasi jenis | Tidak | Hanya gambar |
| Ekstraksi warna | Ya | Piksel, HSV/K-Means |
| Model 3 skor pasangan | Ya | Skor pasangan dan harmoni |
| Formalitas dan style | Ya | Lookup `legacy_family` |
| Rekomendasi outfit | Ya | Skor pasangan, harmoni, alasan |

## 10. Kondisi sekarang dan target

| Bagian | Sekarang | Target |
|---|---|---|
| Keluarga warna UI | 16 pilihan di hasil deteksi | 16 di seluruh UI |
| Warna hasil gambar | Tetap tampil setelah koreksi pengguna | Dipertahankan |
| Ekstraksi | HSV area tengah | Mask dan K-Means/HSV |
| Database `ref_color` | 14 di aset, migrasi menambah 5 warna | 16 + legacy |
| Tabel ML | 14 | Tetap 14, lookup legacy |
| Harmoni | CIELCh 4 aturan | CIELCh + 16 keluarga |
| K-Means++ | Belum | Ditunda |
| Segmentasi | Belum | Ditambahkan jika perlu |

## 11. Berkas yang terlibat

| Berkas | Peran |
|---|---|
| `lib/services/color_family.dart` | 16 keluarga dan pencocokan Lab |
| `lib/services/color_palette.dart` | Nama tampilan warna |
| `lib/services/color_extractor.dart` | Ekstraksi piksel |
| `lib/services/color_harmony.dart` | Aturan harmoni |
| `lib/models/garment_labels.dart` | Label dan nilai warna UI |
| `lib/services/local_db.dart` | Query warna dan ML |
| `assets/db/fashion_app.db` | `ref_color` dan tabel ML |
| `lib/screens/scan/detection_result_screen.dart` | Koreksi warna hasil deteksi |
| `lib/screens/admin/admin_master_data_screen.dart` | Kelola warna master |
| `test/color_family_test.dart` | Test 16 keluarga |
| `test/color_palette_test.dart` | Test palet |
| `test/color_extractor_test.dart` | Test ekstraksi |
| `test/color_harmony_test.dart` | Test harmoni |

## 12. Kriteria selesai

1. Hanya ada satu daftar 16 warna, yaitu `ColorFamily`.
2. Palette dan label UI memakai 16 warna.
3. Ekstraksi menghasilkan salah satu dari 16 keluarga.
4. `ref_color` berisi 16 warna dan `legacy_family`.
5. `wardrobe_item` dan `catalog_item` sudah dimigrasikan.
6. Lookup ML memakai `legacy_family`.
7. Harmoni menghasilkan skor dan alasan.
8. Semua test warna, database, dan rekomendasi lulus.
9. `multicolor` dan `other` sebagai warna tidak lagi disimpan.
10. Objek bukan pakaian ditolak sebelum warna disimpan.
