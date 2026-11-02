# Panduan Kerja Bisma — Minggu 6

Tim Sera-Z · Kelas TI-3D · Semester 5
Periode: **2 – 8 November 2026**
Total beban: **12,0 ho** (4,5 mobile, 5,0 ML, 2,5 QA)

> **CATATAN**
>
> Beban minggu ini besar. Kerjakan berurutan, maksimal 2 tugas aktif,
> dan jangan menunggu sempurna.

---

## 1. Tugas mobile (4,5 ho)

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

### 1.2 E2.4 Riwayat rekomendasi — 1,0 ho

Branch: `feat/recommendation-history`

Langkah:

1. Tambah tabel `recommendation_history` di `local_db.dart` bila belum ada.
2. Catat riwayat setiap kali daftar rekomendasi dibuat: waktu, jumlah outfit, skor tertinggi.
3. Tambah query untuk membaca 20 riwayat terakhir.
4. Tampilkan di layar riwayat atau bagian bawah Profil.

Selesai bila: riwayat bertambah setiap rekomendasi dan tetap ada setelah restart.

### 1.3 E2.6 Unit test DAO — 1,0 ho

Branch: `test/local-db`

Langkah:

1. Tambah `sqflite_common_ffi` di `dev_dependencies`.
2. Buat `test/local_db_test.dart`, jalankan database di memori.
3. Uji minimal 6 kasus: insert item, baca daftar, hapus item, simpan outfit, baca outfit, hapus outfit.
4. Pastikan `flutter test` lulus.

Selesai bila: minimal 6 test DAO lulus.

### 1.4 E7.5 Fallback aturan — 1,0 ho

Branch: `feat/rule-fallback`

Langkah:

1. Di `providers.dart`, bila `engineProvider` null, jangan kembalikan daftar kosong.
2. Bentuk rekomendasi memakai aturan harmoni dan formalitas dari `recommender.dart`.
3. Tandai di UI bahwa skor berasal dari aturan, bukan model.
4. Uji dengan memaksa engine null.

Selesai bila: rekomendasi tetap muncul saat model gagal dimuat.

### 1.5 Rapikan UI autentikasi — 0,5 ho

Branch: `fix/auth-ui`

Langkah:

1. Di `login_screen.dart`, kolom email dan password dinonaktifkan atau disembunyikan.
2. Di `signup_screen.dart`, ganti tombol Daftar menjadi keterangan bahwa pendaftaran email belum tersedia.
3. Pastikan hanya tombol Google yang aktif.
4. Jalankan `flutter analyze` dan `flutter test`.

Selesai bila: tidak ada kolom yang terlihat bisa dipakai tetapi tidak berfungsi.

---

## 2. Tugas ML (5,0 ho)

### 2.1 E4.6 Ekspor TFLite model sendiri — 1,0 ho

Branch: `ml/export-tflite`

Langkah:

1. Buka Colab, unggah `best.pt` 3,1 MB.
2. Jalankan ekspor TFLite int8 dengan dataset kalibrasi.
3. Unduh hasil, simpan sebagai `assets/models/model1_yolo11n_v1.tflite`.
4. Perbarui `ml/reports/model1-card.md` dengan ukuran dan nama berkas.

Selesai bila: berkas `.tflite` ada dan bisa dimuat dengan `tflite_flutter`.

### 2.2 E6.5 Metrik Model 3 — 1,0 ho

Branch: `ml/model3-metrics`

Langkah:

1. Jalankan `ml/scripts/08_train_model3_mlp.py`.
2. Tambahkan penyimpanan `ml/reports/model3_metrics.json` berisi AUC, akurasi, Random Forest, dan Logistic Regression.
3. Tulis catatan bahwa data latih sintetis.

Selesai bila: berkas JSON ada dan angkanya bisa dikutip laporan.

### 2.3 E5.3 Palet 14 warna — 1,0 ho

Branch: `feat/color-palette`

Langkah:

1. Lengkapi pemetaan nama warna pada `color_extractor.dart` atau modul terkait.
2. Pastikan 14 nama konsisten dengan daftar di model card dan `model3_metadata.json`.
3. Uji pada beberapa gambar contoh.

Selesai bila: setiap warna keluaran punya nama dari palet 14 warna.

### 2.4 E5.4 Unit test warna — 1,0 ho

Branch: `test/color-palette`

Langkah:

1. Tambah test untuk pemetaan palet.
2. Uji warna yang jelas: hitam, putih, navy, merah, krem.
3. Pastikan test lulus bersama test lain.

### 2.5 Dokumentasi metode ML — 1,0 ho

Branch: `docs/ml-methods`

Langkah:

1. Tulis `docs/ml-methods.md`: dataset, dua langkah pre-processing, split, arsitektur, parameter latih, metrik.
2. Tulis keterbatasan: Model 3 berbasis data sintetis, akurasi carousell lebih rendah.
3. Tautkan laporan evaluasi dan model card.

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
| 2 | E2.4 riwayat | Melengkapi pekerjaan Ahmad |
| 3 | E2.6 test DAO | Menjaga lapisan data |
| 4 | E7.5 fallback | Aplikasi tetap berguna bila model gagal |
| 5 | Rapikan UI auth | Cepat dan mengurangi kebingungan pengguna |
| 6 | E4.6 ekspor | Membutuhkan Colab, jalankan lebih awal bila memungkinkan |
| 7 | E6.5 metrik | Cepat, hanya menjalankan skrip |
| 8 | E5.3 dan E5.4 palet | Berurutan |
| 9 | Dokumentasi ML | Setelah angka tersedia |
| 10 | E9.1 QA plan | Bisa paralel sejak awal |
| 11 | Logbook | Akhir minggu |

## 5. Jadwal harian

| Hari | Pagi | Sore |
|---|---|---|
| Sen 2 | E2.4 riwayat | Kerangka E9.1 |
| Sel 3 | E2.6 test DAO | 20 test case |
| Rab 4 | E7.5 fallback | E5.3 palet |
| Kam 5 | Rapikan UI auth | E5.4 test warna |
| Jum 6 | E4.6 ekspor di Colab | E6.5 metrik |
| Sab 7 | Dokumentasi ML | Uji perangkat |
| Min 8 | Logbook dan rekap | Review PR |

## 6. Dependensi

| Tugas | Butuh |
|---|---|
| E2.4 | `local_db.dart` dan tabel outfit yang sudah ada |
| E2.6 | `sqflite_common_ffi` |
| E7.5 | `engineProvider`, `recommender.dart`, `color_harmony.dart` |
| E5.3 | `color_extractor.dart` |
| E6.5 | `ml/scripts/08_train_model3_mlp.py` dan TensorFlow |
| E4.6 | `best.pt` di `ml/runs/model1_yolo11n/weights/` |

## 7. Target akhir minggu

| Kategori | Target |
|---|---|
| Mobile | Login, logout, hapus akun terbukti di HP |
| Mobile | Riwayat rekomendasi tersimpan |
| Mobile | 6 test DAO lulus |
| Mobile | Rekomendasi tetap muncul tanpa model |
| Mobile | UI auth tidak menyesatkan |
| ML | `.tflite` model sendiri ada |
| ML | AUC dan precision@3 tercatat |
| ML | Palet 14 warna + test lulus |
| ML | Dokumentasi metode selesai |
| QA | 20 test case terdokumentasi |
