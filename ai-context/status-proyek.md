# Status Proyek

Diperbarui: 10 November 2026 (branch `dev`, commit `b00b3e5`)

## 1. Ringkasan

| Area | Kondisi |
|---|---|
| Aplikasi (UI) | Fondasi dan layar utama selesai. Galeri, crop, simpan outfit, pencarian lemari, dan ikon aplikasi sudah ada |
| Penyimpanan (E2) | SQLite aktif, simpan outfit dan foto di folder aplikasi berjalan. Riwayat rekomendasi dan unit test DAO belum |
| Autentikasi (E3) | Selesai: login Google, profil Firestore, sesi, logout, hapus akun. PR #26 menambah perbaikan mode uji dan preferensi |
| Model 1 (E4) | Model 9 kelas: akurasi test 94,34 persen, macro F1 89,48 persen. Aset aplikasi masih model 15 kelas |
| Modul warna (E5) | Ekstraksi warna HSV dan palet 14 warna berjalan. K-Means di Dart (E5.2) dan unit test warna (E5.4) belum |
| Model 3 (E6) | Aturan harmoni dan skor pasangan berjalan. MLP masih data sintetis dan belum dipakai aplikasi |
| Integrasi (E7) | Loader TFLite, inferensi, rekomendasi, fallback aturan, dan tab Detail berjalan. Latensi (E7.6) belum |
| Fitur aplikasi (E8) | Lemari, Home, Profil, Detail, simpan outfit, pencarian, dan galeri berjalan. Halaman Admin dan CRUD lengkap belum |
| QA (E9) | 80 test otomatis lulus di `dev`; `flutter analyze` bersih. Uji perangkat dan uji fungsional belum |
| Dokumentasi (E10) | Logbook minggu 1 sampai 7, laporan Milestone 1, model card, dan dokumen tugas ML per anggota |

## 2. Arahan dosen 10 November 2026

Dosen menyarankan dua hal:

1. **Cek tipe baju cukup memakai satu dataset.** Model klasifikasi jenis tidak perlu mencampur tiga sumber data.
2. **Kombinasi warna dijadikan pekerjaan ML terpisah.** Warna tidak digabung ke model klasifikasi jenis.

Implikasi yang dicatat:

| Aspek | Arah yang disarankan |
|---|---|
| T1 Klasifikasi jenis | Satu dataset, satu label jenis, evaluasi accuracy dan macro F1 |
| T2 Ekstraksi warna | Modul terpisah, tidak memakai label jenis |
| T3 Kombinasi warna | Dataset, model, dan evaluasi sendiri |
| T4 Penolakan non-cloth | Dipisah dari T1 atau tetap kelas ke-10, belum diputuskan |

Keputusan yang belum diambil:

1. Dataset tunggal untuk T1: Fashion Product Images Small, Carousell, atau Clothing Dataset Full.
2. `other` menjadi kelas ke-10 atau gate biner terpisah.
3. Arti "kombinasi warna": ekstraksi warna dominan, penilaian pasangan warna, atau keduanya.

## 3. Status ML

| Komponen | Kondisi | Bukti |
|---|---|---|
| Model 1 v1 | 9 kelas, akurasi test 94,34 persen, macro F1 89,48 persen. Ekspor float32, float16, dan dynamic range quant ada di `ml/runs` | `ml/reports/model1-card.md`, `ml/reports/model1_test_summary.json` |
| Model 1 v3 | 10 kelas termasuk `other`, klaim akurasi 96,88 persen, TFLite 1,68 MB. **TFLite gagal saat diuji dengan preprocessing aplikasi: 3 dari 270 foto benar** | PR #32, `ml/reports/model1-v3-card.md` |
| Aset aplikasi | Masih `yolo11n_cls.tflite` 15 kelas, 5,97 MB. Pada 270 foto, akurasi 65,6 persen | `assets/models/` |
| Modul 2 | HSV area tengah dan palet 14 warna. K-Means hanya ada di Python | `color_extractor.dart`, `color_palette.dart` |
| Model 3 | MLP sintetis AUC 0,976 dan P@3 0,455; RF 0,978 dan 0,505; aturan 0,912 dan 0,404. Aplikasi memakai tabel `ml_pair_score` dan aturan | PR #22, `ml/reports/model3_metrics.json` |

## 4. Test

| Kondisi | Hasil |
|---|---|
| `dev` | 80 test lulus |
| PR #26 | 85 test lulus |
| PR #32 | 81 test lulus, tetapi tidak ada test inferensi TFLite |
| `flutter analyze` | Bersih di `dev` dan branch yang diperiksa |

## 5. PR terbuka

| PR | Isi | PIC | Status per 10 November |
|---|---|---|---|
| #22 | Evaluasi Model 3 (E6.5) | Ahmad | Perbaikan selesai: `--out`, RNG per model, versi library, interpretasi |
| #23 | Riset dataset aksesoris | Ahmad | Perbaikan selesai: script hitung, angka 11.244, kelas Open Images, mitigasi |
| #26 | Profil dan autentikasi | Abim | Perbaikan selesai: mode uji hanya debug, release wajib Firebase, test preferensi |
| #30 | Dokumen status | Abim | Perlu diperbarui setelah #22, #26, dan #32; masih menulis 80 test dan model v3 seolah siap |
| #31 | Pipeline Hugging Face dan `other` | Abim | Perbaikan selesai: nomor script 13, COCO opt-in, pin `datasets`, threshold sweep |
| #32 | Penolakan objek dan model 10 kelas | Abim | **Blocker**: label sudah sesuai database, tetapi TFLite belum akurat dengan preprocessing aplikasi |

PR #34 (`Chore/model1 v2 assets`) sudah ditutup.

## 6. Penghambat

1. **Model v3 belum lolos uji aplikasi.** Klaim 96,88 persen tidak terbukti pada TFLite yang dipasang. Perlu ekspor ulang atau validasi dengan preprocessing yang sama.
2. **Aset aplikasi masih 15 kelas.** Model latihan 9 kelas belum dipasang.
3. **E4.6 belum selesai.** Layout input model latihan NHWC, aplikasi NCHW; label dan aset belum disatukan.
4. **K-Means di Dart belum ada.** Warna masih memakai ambang HSV.
5. **Model 3 masih sintetis.** AUC tinggi sebagian karena kebocoran label harmoni.
6. **Uji perangkat belum.** Galeri, crop, login, logout, dan hapus akun belum diuji di HP.
7. **Arahan dosen belum diterjemahkan menjadi pembagian tugas baru.**

## 7. Langkah berikut

1. Putuskan dataset tunggal untuk T1 dan apakah `other` menjadi kelas ke-10 atau gate terpisah.
2. Perbaiki atau ekspor ulang TFLite model v3, lalu uji dengan preprocessing aplikasi.
3. Selesaikan E4.6 dan pasang model final di `assets/models`.
4. Implementasikan K-Means di Dart untuk T2.
5. Tetapkan dataset dan evaluasi terpisah untuk T3 kombinasi warna.
6. Perbarui PR #30 setelah status PR lain selesai.
7. Uji perangkat dan jalankan QA fungsional.

## 8. Catatan branch

| Branch | Isi |
|---|---|
| `main` | Versi stabil, belum menerima penggabungan `dev` |
| `dev` | Jalur integrasi, `b00b3e5`, berisi pekerjaan sampai PR #33 |
| `feat/profile-auth` | PR #26 |
| `docs/status-minggu-6` | PR #30 |
| `ml/model1-v2-pipeline` | PR #31 |
| `feat/non-clothing-object` | PR #32 |
| `ml/model3-metrics` | PR #22 |
| `ml/accessory-dataset` | PR #23 |
| `ml/model1-pipeline` | Branch lama, PR #3 ditutup, boleh dihapus |
| `pras` | Branch lama, boleh dihapus |
