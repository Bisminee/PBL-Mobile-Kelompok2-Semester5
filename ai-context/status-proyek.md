# Status Proyek

Diperbarui: 9 November 2026 (branch `dev`, commit `f67732a`)

## 1. Ringkasan

| Area | Kondisi |
|---|---|
| Aplikasi (UI) | Fondasi dan seluruh layar utama selesai. Galeri, crop, simpan outfit, dan pencarian lemari sudah ada |
| Penyimpanan (E2) | SQLite aktif, simpan outfit dan foto di folder aplikasi berjalan. Riwayat rekomendasi dan unit test DAO belum |
| Autentikasi (E3) | Selesai: login Google, profil Firestore, sesi, logout, hapus akun |
| Model 1 (E4) | Dataset 33.667 gambar, baseline 89,37 persen, YOLOv11n-cls 94,34 persen test. Aset aplikasi masih model 15 kelas |
| Modul warna (E5) | Ekstraksi warna HSV dan palet 14 warna berjalan. K-Means di Dart (E5.2) dan unit test warna (E5.4) belum |
| Model 3 (E6) | Aturan harmoni dan skor pasangan berjalan. MLP masih data sintetis. Metrik tersedia di PR #22 yang menunggu perbaikan |
| Integrasi (E7) | Loader TFLite, inferensi, mesin rekomendasi, fallback aturan, dan tab Detail berjalan. Latensi (E7.6) belum |
| Fitur aplikasi (E8) | Lemari, Home, Profil, Detail, simpan outfit, pencarian, dan galeri berjalan. Halaman Admin dan CRUD lengkap belum |
| QA (E9) | 80 test otomatis lulus, `flutter analyze` bersih, rencana uji 34 kasus sudah ada. Uji fungsional dan perangkat belum |
| Dokumentasi (E10) | Logbook minggu 1 sampai 7, laporan Milestone 1, model card, dan dokumen tugas ML per anggota |

## 2. Yang sudah selesai

- E1 fondasi aplikasi: tema, rute, `StatefulShellRoute` Home dan Lemari, kamera.
- UI Figma dan layout responsif (PR #4).
- Aturan harmoni warna CIELCh dan unit test (PR #2).
- E3 autentikasi Firebase (PR #8 sampai #12).
- E4 Model 1 (PR #6 dan #7): dataset 33.667 gambar, split 70/15/15,
  baseline MobileNetV2 89,37 persen, YOLOv11n-cls 94,34 persen test,
  macro F1 89,48 persen, laporan evaluasi, dan model card.
- Integrasi SQLite dan TFLite (PR #13): aset `fashion_app.db`, CRUD lemari,
  pemuat TFLite, klasifikasi jenis, ekstraksi warna, mesin rekomendasi.
- Pembersihan kode mati (PR #14).
- Fallback rekomendasi aturan (PR #15), perbaikan UI autentikasi (PR #16),
  profil sesuai akun Google (PR #17), dan palet 14 warna (PR #18).
- Tab Detail Warna, Styling, dan Lemari (PR #19).
- Impor foto dari galeri (PR #20) dan halaman crop 1:1 (PR #21).
- Tombol galeri di layar kamera dan Android Photo Picker (PR #24).
- Simpan outfit, daftar outfit tersimpan, dan pencarian lemari (PR #25).
- Foto asli pada kartu outfit dan ringkasan kategori Home (PR #27).
- Perbaikan overflow teks (PR #28) dan ikon aplikasi Sera-Z (PR #29).
- Dokumen: logbook minggu 1 sampai 7, laporan Milestone 1, timeline,
  pembagian tugas minggu 11, QA plan 34 kasus, dan
  `Pembagian Tugas/tugas-ml-per-anggota.md`.

## 3. Status ML

| Komponen | Kondisi | Bukti |
|---|---|---|
| Model 1 | Terlatih 9 kelas, akurasi test 94,34 persen. Ekspor float32 5,91 MB, float16 2,99 MB, int8 dynamic range 1,53 MB. Belum dipasang di aset aplikasi | `ml/reports/model1-card.md`, `ml/runs/` |
| Modul 2 | Heuristik HSV dan palet 14 warna berjalan. K-Means di Dart belum | `lib/services/color_extractor.dart`, `color_palette.dart` |
| Model 3 | MLP sintetis, AUC 0,976 dan P@3 0,455. Random Forest 0,978 dan 0,515. Aturan harmoni 0,912 dan 0,424 | `ml/reports/model3_metrics.json` di PR #22 |

Rincian tugas ML per anggota dan cara kerja ketiga komponen ada di
`Pembagian Tugas/tugas-ml-per-anggota.md`.

## 4. Test

- 80 test lulus.
- Cakupan: harmoni warna, garment, label, color extractor, palet, recommender,
  kamera dan pratinjau, crop, intake foto, outfit detail, home summary, widget.
- `flutter analyze` bersih.

## 5. Penghambat

1. **Aset model aplikasi belum sesuai model latihan.** `assets/models/yolo11n_cls.tflite`
   masih model 15 kelas 5,97 MB. Pada 270 foto test, aset itu benar 65,6 persen,
   sedangkan model latihan kita 86,7 persen pada sampel yang sama.
2. **E4.6 belum selesai.** Ekspor final belum dipasang, layout input model
   latihan NHWC sedangkan aplikasi NCHW, dan label model belum dipetakan ke
   kosakata database.
3. **Modul 2 K-Means di Dart belum dibuat.** Warna masih memakai ambang HSV.
4. **Model 3 masih memakai data sintetis.** AUC tinggi bukan bukti generalisasi.
5. **Uji perangkat belum.** Galeri, crop, login, logout, dan hapus akun belum
   diuji di HP.
6. **Enam PR masih menunggu perbaikan.** Rincian di bagian 7.

## 6. Langkah berikut

Fokus minggu 7 proyek (9 sampai 15 November 2026):

1. Putuskan target model final, 9 atau 10 kelas, lalu selesaikan E4.6 (Bisma).
2. Uji galeri, crop, login, logout, dan hapus akun di perangkat (Bisma).
3. Perbaiki PR #26, #30, #31, dan #32 (Abim).
4. Perbaiki PR #22 dan #23 (Ahmad).
5. Kerjakan E5.2 K-Means, E5.4 unit test warna, dan dokumentasi metode ML (Izza).
6. Kerjakan E2.4, E2.6, E8.3, dan E10.2 (Pras).

## 7. PR terbuka

| PR | Isi | PIC | Status |
|---|---|---|---|
| #22 | Evaluasi Model 3 (E6.5) | Ahmad | Perlu perbaikan |
| #23 | Riset dataset aksesoris | Ahmad | Perlu perbaikan |
| #26 | Profil dan autentikasi | Abim | Perlu perbaikan |
| #30 | Dokumen status | Abim | Perlu perbaikan |
| #31 | Pipeline Hugging Face dan kelas `other` | Abim | Perlu perbaikan |
| #32 | Penolakan objek bukan pakaian | Abim | Perlu perbaikan |

## 8. Catatan branch

| Branch | Isi |
|---|---|
| `main` | Versi stabil, belum menerima penggabungan `dev` |
| `dev` | Satu-satunya jalur integrasi, berisi seluruh pekerjaan sampai PR #29 |
| `feat/profile-auth` | PR #26, terbuka |
| `docs/status-minggu-6` | PR #30, terbuka |
| `ml/model1-v2-pipeline` | PR #31, terbuka |
| `feat/non-clothing-object` | PR #32, terbuka |
| `ml/model3-metrics` | PR #22, terbuka |
| `ml/accessory-dataset` | PR #23, terbuka |
| `ml/model1-pipeline` | Branch lama, PR #3 ditutup, boleh dihapus |
| `pras` | Branch lama, boleh dihapus |
