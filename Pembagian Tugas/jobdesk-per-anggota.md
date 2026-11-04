# Jobdesk per Anggota — Minggu 6

Diperbarui: 2 November 2026
Periode: **2 – 8 November 2026**

Dokumen ini menggantikan pembagian minggu 5. Seluruh pekerjaan dikerjakan dari
branch `dev` dan PR diarahkan ke `dev`. Branch `dev-ml` sudah dihapus dan
isinya sudah digabung ke `dev`.

## 1. Ringkasan beban

| Anggota | Mobile | ML | QA dan dokumen | Total |
|---|---:|---:|---:|---:|
| Bisma Adhiaksa | 5,0 | 5,5 | 2,5 | **13,0** |
| Abim Mustawa | 2,5 | 1,5 | 0 | **4,0** |
| Izza Dhafira Fanani | 4,5 | 0 | 0 | **4,5** |
| Ahmad Falahi | 0 | 1,0 | 0 | **1,0** |
| Faatihurrizki Prasojo | 0 | 0 | 0 | **0** |

## 2. Ahmad Falahi — 1,0 ho

| ID | Tugas | ho | Branch | Selesai bila |
|---|---|---:|---|---|
| - | Cari dataset aksesoris: tas, topi, ikat pinggang, perhiasan | 1,0 | `ml/accessory-dataset` | Rekomendasi sumber, lisensi, dan jumlah gambar tertulis di `ml/reports/accessory-dataset.md` |

## 3. Faatihurrizki Prasojo

Tidak ada tugas minggu ini.

## 4. Bisma Adhiaksa — 12,0 ho

Rincian langkah ada di `panduan-kerja-bisma-minggu-6.md`.

### 4.1 Mobile (4,5 ho)

| ID | Tugas | ho | Branch | Selesai bila |
|---|---|---:|---|---|
| - | Uji login, logout, hapus akun di perangkat | 1,0 | `test/device-check` | Ketiga alur berhasil di HP |
| E2.4 | Riwayat rekomendasi | 1,0 | `feat/recommendation-history` | Riwayat tersimpan dan tampil setelah restart |
| E2.6 | Unit test DAO | 1,0 | `test/local-db` | Minimal 6 test lulus |
| E7.5 | Fallback aturan | 1,0 | `feat/rule-fallback` | Rekomendasi muncul saat model gagal |
| - | Rapikan UI login dan signup | 0,5 | `fix/auth-ui` | Tidak ada kolom yang menyesatkan |
| - | Profil sesuai akun Google | 0,5 | `feat/google-profile` | Nama, email, dan foto sesuai akun Google |

### 4.2 ML (5,5 ho)

| ID | Tugas | ho | Branch | Selesai bila |
|---|---|---:|---|---|
| E4.6 | Ekspor TFLite model sendiri | 1,0 | `ml/export-tflite` | `.tflite` ada dan bisa dimuat |
| E6.5 | Metrik Model 3 | 1,0 | `ml/model3-metrics` | AUC dan precision@3 di JSON |
| E5.3 | Palet 14 warna | 1,0 | `feat/color-palette` | 14 nama konsisten |
| E5.4 | Unit test warna | 1,0 | `test/color-palette` | Test palet lulus |
| - | Dokumentasi metode ML | 1,0 | `docs/ml-methods` | Dokumen metode dan keterbatasan |
| - | Penanganan outfit tidak terdeteksi | 0,5 | `feat/no-outfit-fallback` | Pesan dan saran tampil, bukan layar kosong |

### 4.3 QA dan dokumentasi (2,5 ho)

| ID | Tugas | ho | Branch | Selesai bila |
|---|---|---:|---|---|
| E9.1 | Rencana uji dan 20 test case | 2,0 | `test/qa-plan` | 20 test case terdokumentasi |
| E10.1 | Rekap logbook minggu 6 | 0,5 | `docs/logbook-minggu-6` | Logbook terisi |

## 5. Abim Mustawa — 4,0 ho

| ID | Tugas | ho | Branch | Selesai bila |
|---|---|---:|---|---|
| - | Label 9 kelas dan aset model | 0,5 | `chore/model-assets` | `labels.txt` sesuai 9 kelas |
| E7.6 | Ukur latensi dan ukuran model | 1,0 | `feat/latency-check` | Latensi di bawah 3 detik per foto |
| E8.7 | Lengkapi edit profil dan preferensi | 1,5 | `feat/profile-edit` | Nama dan preferensi bisa diubah |
| - | Sinkronkan gambar ke folder khusus aplikasi | 1,0 | `feat/photo-sync` | Semua foto ada di folder aplikasi dan path valid |

## 6. Izza Dhafira Fanani — 4,5 ho

| ID | Tugas | ho | Branch | Selesai bila |
|---|---|---:|---|---|
| E8.6 | Halaman Admin master data | 2,0 | `feat/admin-master-data` | Master data bisa ditambah, diubah, dihapus |
| E8.1 | CRUD UI Lemari | 1,5 | `feat/wardrobe-crud-ui` | Tambah manual dan hapus berjalan |
| - | Thumbnail di Lemari dan Home | 1,0 | `feat/wardrobe-thumbnails` | Thumbnail tampil, ada placeholder bila kosong |

## 7. Dependensi

| Tugas | Menunggu |
|---|---|
| E2.4 | Tabel outfit dan `local_db.dart` yang sudah ada |
| E2.6 | `sqflite_common_ffi` |
| E7.5 | `engineProvider`, `recommender.dart`, `color_harmony.dart` |
| E4.6 | `best.pt` dan lingkungan Colab atau Linux |
| E6.5 | Skrip `08_train_model3_mlp.py` dan TensorFlow |
| E5.3, E5.4 | `color_extractor.dart` |
| E8.6, E8.1 | Skema master data dan CRUD di `fashion_app.db` |
| Thumbnail Lemari dan Home | Sinkron gambar dari Abim |
| Profil sesuai akun Google | `authProvider` dan data `FirebaseAuth.currentUser` |
| Outfit tidak terdeteksi | E7.5 dan `engineProvider` |
| E9.1 | Tidak ada, bisa dimulai kapan saja |

## 8. Aturan

1. Maksimal 2 tugas aktif per orang.
2. Satu tugas = satu branch = satu PR; branch dari `dev`, PR ke `dev`.
3. Jangan commit dataset, `ml/data`, `ml/runs`, `ml/.venv`, `*.pt`, atau
   `google-services.json`.
4. `flutter analyze` dan `flutter test` wajib lulus sebelum PR.
5. Perbarui papan Notion dan logbook setiap hari.
