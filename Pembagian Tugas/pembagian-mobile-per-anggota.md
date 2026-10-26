# Pembagian Tugas Mobile — Sera-Z (Per Anggota)

Tim Sera-Z · Kelas TI-3D · Semester 5 · Tahun Akademik 2026/2027
Rencana per 19 Okt 2026 (Minggu 4). Semua estimasi dalam jam-orang (ho).

## 1. Pembagian kerja "mobile" (sisi aplikasi)

Kolam tugas aplikasi (E2, E3, E5, E7, E8): **37,0 ho** → target rata **± 7,4 ho/orang**.

### 1.1 Abim Mustawa — **7,0 ho** (Mobile Developer)

| ID | Tugas | ho | Prasyarat |
|---|---|---:|---|
| E2.1 | Setup `sqflite` + `path_provider`, helper DB & migrasi | 1,0 | — |
| E2.2 | CRUD `wardrobe_items` | 1,5 | E2.1 |
| E2.3 | Simpan foto ke folder dokumen; simpan hanya path | 1,0 | E2.1 |
| E2.4 | Tabel `outfits` + `recommendation_history` & DAO | 1,5 | E2.1 |
| E2.5 | Muat lemari/riwayat saat start (provider async) | 1,0 | E2.2, E2.4 |
| E2.6 | Unit test DAO | 1,0 | E2.2, E2.4 |

Paket ini adalah rantai penyimpanan utuh: sekali E2.1 selesai, E2.2–E2.6 bisa jalan
berurutan. Buka juga jalur ke E8.1, E8.4, E8.6 (butuh E2.2/E2.5/E2.1).

### 1.2 Faatihurrizki Prasojo — **7,5 ho** (ML Engineer, modul warna + sebagian UI)

| ID | Tugas | ho | Prasyarat |
|---|---|---:|---|
| E5.1 | Crop tengah + thresholding latar | 1,0 | — |
| E5.2 | K-Means (k=3–5) Lab/HSV di Dart | 2,0 | E5.1 |
| E5.3 | Pemetaan palet 14 nama warna | 1,0 | E5.2 |
| E5.4 | Unit test warna | 1,0 | E5.3 |
| E8.4 | Konten Home (banner, kategori, item terbaru) | 1,5 | E2.5 |
| E7.6 | Ukur latensi & ukuran model di perangkat | 1,0 | E7.2, E7.4 |

Rantai modul warna lengkap (E5.1→E5.4) + konten Home + pengukuran performa.

### 1.3 Ahmad Falahi — **7,5 ho** (ML Engineer, integrasi on-device)

| ID | Tugas | ho | Prasyarat |
|---|---|---:|---|
| E7.1 | Tambah `tflite_flutter`; loader + isolate runner | 1,5 | E4.6, E6.6 |
| E7.2 | Inferensi Model 1 pada gambar ter-crop | 2,0 | E7.1 |
| E7.3 | Ganti atribut placeholder (jenis + warna) | 1,5 | E7.2, E5.2 |
| E7.4 | Sambungkan skor Model 3 ke rekomendasi | 1,5 | E7.1, E6.4 |
| E7.5 | Fallback ke skor aturan bila model gagal | 1,0 | E7.4 |

Seluruh integrasi on-device dalam satu tangan — sinkron dengan model yang ia latih.

### 1.4 Bisma Adhiaksa — **8,0 ho** (PM & QA, autentikasi + profil)

| ID | Tugas | ho | Prasyarat |
|---|---|---:|---|
| E3.1 | `google_sign_in` + Firebase Auth | 2,0 | — |
| E3.2 | Record cloud `users` + `profiles` | 1,0 | E3.1 |
| E3.3 | Sesi persisten + `flutter_secure_storage` | 1,0 | E3.1 |
| E3.4 | Sign out + jalur hapus akun | 1,0 | E3.1 |
| E8.2 | Simpan outfit → "Outfit Tersimpan" | 1,5 | E2.4 |
| E8.7 | Halaman Profil (nama, avatar, sign out, preferensi) | 1,5 | E3.4 |

Rantai autentikasi lengkap + simpan outfit + halaman profil (butuh E3.4).

### 1.5 Izza Dhafira Fanani — **7,0 ho** (Dokumentator, UI fitur)

| ID | Tugas | ho | Prasyarat |
|---|---|---:|---|
| E8.1 | CRUD UI Lemari (tambah/hapus, filter, empty state) | 2,0 | E2.2 |
| E8.3 | Ranking rekomendasi + teks explainability | 1,5 | E7.4 |
| E8.5 | Tab Detail (Warna/Styling/Lemari) data nyata | 1,5 | E8.3 |
| E8.6 | Halaman Admin: master data kategori warna/jenis | 2,0 | E2.1 |

### Ringkasan beban mobile

| Anggota | ho | Rantai utama |
|---|---:|---|
| Abim Mustawa | 7,0 | Penyimpanan (E2.1–E2.6) |
| Ahmad Falahi | 7,5 | Integrasi on-device (E7.1–E7.5) |
| Faatihurrizki Prasojo | 7,5 | Modul warna + E8.4 + E7.6 |
| Bisma Adhiaksa | 8,0 | Autentikasi + E8.2 + E8.7 |
| Izza Dhafira Fanani | 7,0 | UI lemari/rekomendasi/admin |
| **Total** | **37,0** | |

Selisih maksimal 1,0 ho — rata.

## 2. Pembagian kerja Machine Learning

Kolam tugas ML (E4 + E6, kecuali E6.4 yang sudah selesai): **15,0 ho**.

| Anggota | Tugas | ho |
|---|---|---:|
| Faatihurrizki Prasojo | E4.1 Unduh dataset + EDA · E4.2 Gabung kelas + split · E6.1 Pasangan + negative sampling | 4,0 |
| Ahmad Falahi | E4.3 Baseline MobileNetV2 · E4.4 Latih YOLOv11n-cls · E6.2 Feature builder · E6.3 Latih MLP + pembanding | 7,0 |
| Bisma Adhiaksa | E4.5 Evaluasi Model 1 · E6.5 Evaluasi MLP/AUC | 2,0 |
| Abim Mustawa | E4.6 Ekspor TFLite int8 · E6.6 Ekspor MLP TFLite int8 | 2,0 |
| Izza Dhafira Fanani | (tidak ada tugas ML murni) | 0,0 |

Catatan: E6.4 (Aturan harmoni warna) sudah selesai (PR #2 digabung ke main).

## 3. Ringkasan beban total (mobile + ML)

| Anggota | Mobile | ML | **Total** |
|---|---:|---:|---:|
| Abim Mustawa | 8,5 | 2,0 | **10,5** |
| Ahmad Falahi | 7,5 | 7,0 | **10,5** |
| Faatihurrizki Prasojo | 7,5 | 4,0 | **10,5** |
| Bisma Adhiaksa | 8,0 | 2,0 | **10,0** |
| Izza Dhafira Fanani | 10,5 | 0 | **10,5** |

Rentang 10,0–10,5 ho — sangat rata (selisih maksimal 0,5 ho).

## 4. Urutan mulai (minggu ini)

1. **Faatihurrizki** — E4.1 (unduh 3 dataset + EDA) → E4.2; **paralel** E5.1.
2. **Abim** — E2.1 (setup sqflite) → E2.2/E2.4.
3. **Bisma** — E3.1 (Google Sign-In) → E3.2/E3.3/E3.4.
4. **Ahmad** — siapkan skrip latih; mulai E4.3 begitu E4.2 selesai; E6.1 (Faatihurrizki) siap → E6.2/E6.3.
5. **Izza** — E8.1 (butuh E2.2), E8.6 (butuh E2.1).

## 5. Catatan

- Aturan repo tetap berlaku: **maksimal 2 tugas aktif per orang**, tugas boleh ditukar
  antar anggota.
- E9 (QA, 11 ho) & E10 (Dokumentasi, 11,5 ho) belum termasuk di sini — keduanya
  peran inti (Bisma & Izza). Kalau mau ikut dibagi rata juga, bilang saja.
- E6.4 (Aturan harmoni warna) sudah selesai dan digabung ke `main` (PR #2).
- PR #3 (pipeline Model 1) masih menunggu review — agar E4.1 bisa jalan, reviewer
  diperlukan.
