# Panduan Kerja Bisma — Minggu 6

Tim Sera-Z · Kelas TI-3D · Semester 5
Periode: **2 – 8 November 2026**
Total beban: **7,5 ho** (3,0 mobile, 2,0 ML, 2,5 QA)

> **CATATAN**
>
> Kerjakan berurutan, maksimal 2 tugas aktif, dan jangan menunggu sempurna.

---

## 1. Tugas mobile (3,0 ho)

### 1.1 Uji perangkat: login, logout, hapus akun — 1,0 ho

Branch: `test/device-check`

Langkah:

1. Pasang aplikasi di HP Android nyata.
2. Login dengan Google, pastikan nama dan email tampil di Profil.
3. Tutup paksa aplikasi, buka lagi, pastikan masih login.
4. Logout, pastikan kembali ke layar Login dan rute privat tidak bisa dibuka.
5. Login lagi, lalu uji hapus akun dengan dialog konfirmasi.
6. Catat hasil dan pesan error bila ada di `test/device-check-notes.md`.

Selesai bila: ketiga alur berhasil dan catatan bukti tersimpan.

### 1.2 E7.5 Fallback aturan — 1,0 ho

Branch: `feat/rule-fallback`

Langkah:

1. Di `providers.dart`, bila `engineProvider` null, jangan kembalikan daftar kosong.
2. Bentuk rekomendasi memakai aturan harmoni dan formalitas dari `recommender.dart`.
3. Tandai di UI bahwa skor berasal dari aturan, bukan model.
4. Uji dengan memaksa engine null.

Selesai bila: rekomendasi tetap muncul saat model gagal dimuat.

### 1.3 Rapikan UI autentikasi — 0,5 ho

Branch: `fix/auth-ui`

Langkah:

1. Di `login_screen.dart`, kolom email dan password dinonaktifkan atau disembunyikan.
2. Di `signup_screen.dart`, ganti tombol Daftar menjadi keterangan bahwa pendaftaran email belum tersedia.
3. Pastikan hanya tombol Google yang aktif.
4. Jalankan `flutter analyze` dan `flutter test`.

Selesai bila: tidak ada kolom yang terlihat bisa dipakai tetapi tidak berfungsi.

### 1.4 Profil sesuai akun Google — 0,5 ho

Branch: `feat/google-profile`

Langkah:

1. Di halaman Profil, ambil nama, email, dan foto dari `FirebaseAuth.currentUser`.
2. Tampilkan foto profil Google bila ada; jika tidak, pakai inisial.
3. Sinkronkan dengan dokumen `profiles/{uid}` di Firestore.
4. Uji dengan dua akun berbeda.

Selesai bila: data profil sama dengan akun Google yang sedang login.

---

## 2. Tugas ML (2,0 ho)

### 2.1 E4.6 Ekspor TFLite model sendiri — 1,0 ho

Branch: `ml/export-tflite`

Langkah:

1. Buka Colab, unggah `best.pt` 3,1 MB.
2. Ekspor TFLite int8 dengan data kalibrasi.
3. Verifikasi input `[1, 3, 224, 224]` dan output `[1, 9]`.
4. Unduh hasil, simpan sebagai `assets/models/model1_yolo11n_v1.tflite`.
5. Perbarui `ml/reports/model1-card.md`.

Selesai bila: berkas `.tflite` ada dan bisa dimuat dengan `tflite_flutter`.

### 2.2 E5.3 Palet 14 warna — 1,0 ho

Branch: `feat/color-palette`

Langkah:

1. Lengkapi pemetaan nama warna pada `color_extractor.dart` atau modul terkait.
2. Pastikan 14 nama konsisten dengan model card dan `model3_metadata.json`.
3. Uji pada beberapa gambar contoh.

Selesai bila: setiap warna keluaran punya nama dari palet 14 warna.

---

## 3. Tugas QA dan dokumentasi (2,5 ho)

### 3.1 E9.1 Rencana uji dan 20 test case — 2,0 ho

Branch: `test/qa-plan`

Langkah:

1. Tulis `Pembagian Tugas/qa-plan.md`: ruang lingkup, lingkungan, perangkat.
2. Susun minimal 20 test case fungsional, termasuk kasus negatif.
3. Kelompokkan per alur: login, lemari, kamera, rekomendasi, profil.
4. Tandai mana yang bisa diotomatisasi.

### 3.2 Rekap logbook minggu 6 — 0,5 ho

Branch: `docs/logbook-minggu-6`

Langkah:

1. Isi logbook minggu 6 dengan capaian dan kendala nyata.
2. Perbarui papan Notion.

---

## 4. Urutan pengerjaan

| Urutan | Tugas | Alasan |
|---:|---|---|
| 1 | Uji perangkat | Membuktikan E3 berjalan sebelum menambah fitur |
| 2 | E7.5 fallback | Aplikasi tetap berguna bila model gagal |
| 3 | Rapikan UI auth | Cepat dan mengurangi kebingungan pengguna |
| 4 | Profil sesuai akun Google | Menyamakan data dengan akun yang login |
| 5 | E4.6 ekspor | Membutuhkan Colab, jalankan lebih awal bila memungkinkan |
| 6 | E5.3 palet | Berurutan dengan test warna milik Izza |
| 7 | E9.1 QA plan | Bisa paralel sejak awal |
| 8 | Logbook | Akhir minggu |

## 5. Jadwal harian

| Hari | Pagi | Sore |
|---|---|---|
| Sen 2 | Rapikan UI auth | Kerangka E9.1 |
| Sel 3 | Profil sesuai akun Google | 20 test case |
| Rab 4 | E7.5 fallback | E5.3 palet |
| Kam 5 | E5.3 palet lanjutan | Perbaikan temuan |
| Jum 6 | E4.6 ekspor di Colab | Verifikasi hasil ekspor |
| Sab 7 | Uji perangkat | Perbaikan temuan |
| Min 8 | Logbook dan rekap | Review PR |

## 6. Dependensi

| Tugas | Butuh |
|---|---|
| E7.5 | `engineProvider`, `recommender.dart`, `color_harmony.dart` |
| Profil Google | `authProvider` dan `FirebaseAuth.currentUser` |
| E5.3 | `color_extractor.dart` |
| E4.6 | `best.pt` dan lingkungan Colab atau Linux |
| E9.1 | Tidak ada, bisa dimulai kapan saja |

## 7. Target akhir minggu

| Kategori | Target |
|---|---|
| Mobile | Login, logout, hapus akun terbukti di HP |
| Mobile | Rekomendasi tetap muncul tanpa model |
| Mobile | UI auth tidak menyesatkan |
| Mobile | Profil sesuai akun Google |
| ML | `.tflite` model sendiri ada dan tervalidasi |
| ML | Palet 14 warna konsisten |
| QA | 20 test case terdokumentasi |
