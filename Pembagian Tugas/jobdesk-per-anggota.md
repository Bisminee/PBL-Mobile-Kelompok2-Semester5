# Jobdesk per Anggota – Minggu 11

Diperbarui: 9 November 2026
Periode: **2 – 8 November 2026**
Status terakhir: **9 November 2026**

Seluruh pekerjaan dikerjakan dari branch `dev` dan PR diarahkan ke `dev`.
Branch `dev-ml` sudah dihapus dan seluruh isinya digabung ke `dev`.

## 1. Ringkasan beban

| Anggota | Mobile | ML | QA dan dokumen | Total |
|---|---:|---:|---:|---:|
| Bisma Adhiaksa | 3,0 | 2,0 | 2,5 | **7,5** |
| Izza Dhafira Fanani | 4,5 | 2,0 | 0 | **6,5** |
| Faatihurrizki Prasojo | 3,5 | 0 | 2,0 | **5,5** |
| Ahmad Falahi | 1,5 | 2,0 | 2,0 | **5,5** |
| Abim Mustawa | 3,0 | 1,5 | 0 | **4,5** |

## 2. Bisma Adhiaksa — 7,5 ho

Rincian langkah ada di `panduan-kerja-bisma-minggu-6.md`.

### 2.1 Mobile (3,0 ho)

| ID | Tugas | ho | Branch | Selesai bila |
|---|---|---:|---|---|
| - | Uji login, logout, hapus akun di perangkat | 1,0 | `test/device-check` | Ketiga alur berhasil di HP |
| E7.5 | Fallback aturan saat model gagal | 1,0 | `feat/rule-fallback` | Rekomendasi tetap muncul |
| - | Rapikan UI login dan signup | 0,5 | `fix/auth-ui` | Tidak ada kolom yang menyesatkan |
| - | Profil sesuai akun Google | 0,5 | `feat/google-profile` | Nama, email, foto sesuai akun |

### 2.2 ML (2,0 ho)

| ID | Tugas | ho | Branch | Selesai bila |
|---|---|---:|---|---|
| E4.6 | Ekspor TFLite model sendiri | 1,0 | `ml/export-tflite` | `.tflite` ada dan tervalidasi |
| E5.3 | Palet 14 warna | 1,0 | `feat/color-palette` | 14 nama konsisten |

### 2.3 QA (2,5 ho)

| ID | Tugas | ho | Branch | Selesai bila |
|---|---|---:|---|---|
| E9.1 | Rencana uji dan 20 test case | 2,0 | `test/qa-plan` | 20 test case terdokumentasi |
| E10.1 | Rekap logbook minggu 6 | 0,5 | `docs/logbook-minggu-6` | Logbook terisi |

## 3. Izza Dhafira Fanani — 6,5 ho

| ID | Kategori | Tugas | ho | Branch | Selesai bila |
|---|---|---|---:|---|---|
| E8.6 | Mobile | Halaman Admin master data | 2,0 | `feat/admin-master-data` | Master data bisa dikelola |
| E8.1 | Mobile | CRUD UI Lemari | 1,5 | `feat/wardrobe-crud-ui` | Tambah manual dan hapus berjalan |
| - | Mobile | Thumbnail di Lemari dan Home | 1,0 | `feat/wardrobe-thumbnails` | Thumbnail tampil, ada placeholder |
| E5.4 | ML | Unit test warna | 1,0 | `test/color-palette` | Test palet lulus |
| - | ML | Dokumentasi metode ML | 1,0 | `docs/ml-methods` | Dokumen metode dan keterbatasan |

## 4. Faatihurrizki Prasojo — 5,5 ho

| ID | Kategori | Tugas | ho | Branch | Selesai bila |
|---|---|---|---:|---|---|
| E2.4 | Mobile | Riwayat rekomendasi | 1,0 | `feat/recommendation-history` | Tersimpan dan tampil setelah restart |
| E2.6 | Mobile | Unit test DAO | 1,0 | `test/local-db` | Minimal 6 test lulus |
| E8.3 | Mobile | Ranking dan explainability | 1,5 | `feat/ranking-explainability` | Skor dan alasan tampil |
| E10.2 | Dokumen | Kumpulkan 150 foto lapangan | 2,0 | `docs/field-photos` | 150 foto terkumpul |

## 5. Ahmad Falahi — 5,5 ho

| ID | Kategori | Tugas | ho | Branch | Selesai bila |
|---|---|---|---:|---|---|
| E8.5 | Mobile | Tab Detail data nyata | 1,5 | `feat/detail-data` | Data tampil di tab Warna, Styling, Lemari |
| E6.5 | ML | Metrik Model 3 | 1,0 | `ml/model3-metrics` | AUC dan precision@3 di JSON |
| - | ML | Cari dataset aksesoris | 1,0 | `ml/accessory-dataset` | Rekomendasi sumber dan lisensi tertulis |
| E9.2 | QA | Uji fungsional black-box | 2,0 | `test/functional` | Hasil dan daftar bug tercatat |

## 6. Abim Mustawa — 4,5 ho

| ID | Kategori | Tugas | ho | Branch | Selesai bila |
|---|---|---|---:|---|---|
| E8.7 | Mobile | Edit profil dan preferensi | 1,5 | `feat/profile-edit` | Nama dan preferensi bisa diubah |
| - | Mobile | Sinkronkan gambar ke folder aplikasi | 1,0 | `feat/photo-sync` | Semua foto di folder aplikasi, path valid |
| - | Mobile | Penanganan objek bukan outfit | 0,5 | `feat/non-clothing-object` | Pesan jelas dan tombol ambil ulang |
| - | ML | Label 9 kelas | 0,5 | `chore/model-assets` | `labels.txt` sesuai 9 kelas |
| E7.6 | ML | Ukur latensi dan ukuran model | 1,0 | `feat/latency-check` | Di bawah 3 detik per foto |

## 7. Dependensi

| Tugas | Menunggu |
|---|---|
| E2.4 | Tabel outfit dan `local_db.dart` |
| E2.6 | `sqflite_common_ffi` |
| E8.3 | `outfit_engine` dan alasan harmoni |
| E8.5 | Data lemari dan `OutfitEngine` |
| E7.5 | `engineProvider`, `recommender.dart`, `color_harmony.dart` |
| Profil Google | `authProvider` dan `FirebaseAuth.currentUser` |
| Thumbnail | Sinkron gambar dari Abim |
| E8.6, E8.1 | Skema master data dan CRUD di `fashion_app.db` |
| E4.6 | `best.pt` dan lingkungan Colab atau Linux |
| E6.5 | Skrip `08_train_model3_mlp.py` dan TensorFlow |
| E5.3, E5.4 | `color_extractor.dart` |
| E9.2 | Build stabil dari PR utama |
| E9.1 | Tidak ada, bisa dimulai kapan saja |

## 8. Aturan

1. Maksimal 2 tugas aktif per orang.
2. Satu tugas = satu branch = satu PR; branch dari `dev`, PR ke `dev`.
3. Jangan commit dataset, `ml/data`, `ml/runs`, `ml/.venv`, `*.pt`, atau
   `google-services.json`.
4. `flutter analyze` dan `flutter test` wajib lulus sebelum PR.
5. Perbarui papan Notion dan logbook setiap hari.

## 9. Status pelaksanaan per 9 November 2026

| Anggota | Selesai | Menunggu perbaikan | Belum mulai |
|---|---|---|---|
| Bisma | E7.5, UI auth, profil Google, E5.3, E9.1, logbook, galeri, crop, kamera | - | Uji perangkat, E4.6 |
| Ahmad | E8.5 | E6.5 (#22), dataset aksesoris (#23) | E9.2 |
| Abim | Pipeline foto dan sebagian profil | E8.7 (#26), label 10 kelas (#32), objek bukan pakaian (#32), pipeline HF (#31) | E7.6 |
| Pras | - | - | E2.4, E2.6, E8.3, E10.2 |
| Izza | - | - | E8.6, E5.4, dokumentasi ML; E8.1 dan thumbnail baru sebagian |

Rincian status dan bukti ada di `Pembagian Tugas/pembagian-tugas-minggu-11.md`
bagian "Status per 9 November 2026". Rincian tugas ML ada di
`Pembagian Tugas/tugas-ml-per-anggota.md`.

