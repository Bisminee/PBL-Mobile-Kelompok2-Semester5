# Pembagian Tugas Minggu 11 — Sera-Z

Tim Sera-Z · Kelas TI-3D · Semester 5
Periode: **2 – 8 November 2026**
Disusun: 4 November 2026

> **CATATAN DARI BISMA**
>
> **JANGAN TAKUT SALAH PUSH, JANGAN TAKUT BIKIN KESALAHAN**
>
> **TAKUT KALAU KALIAN NGGAK ADA KONTRIBUSI DI GITHUB**

Fokus minggu ini: menuntaskan sisa minggu 5, menyelesaikan integrasi, menyiapkan QA,
dan menarik sebagian tugas minggu depan agar beban lebih merata.

Total **29,5 ho**, terdiri dari 15,5 ho mobile, 7,5 ho ML, dan 6,5 ho QA serta dokumentasi.

---

## 1. Sisa minggu 5 yang dilanjutkan

### 1.1 Sisa pekerjaan mobile

| Tugas | PIC | Target minggu 11 |
|---|---|---|
| E2.4 Riwayat rekomendasi (`recommendation_history`) | Pras | Selesai |
| E2.6 Unit test DAO | Pras | Selesai |
| E8.6 Halaman Admin master data | Izza | Selesai |
| E8.1 CRUD UI Lemari: tambah manual dan hapus | Izza | Selesai |
| Uji login, logout, dan hapus akun di perangkat | Bisma | Selesai |

### 1.2 Sisa pekerjaan ML

| Tugas | PIC | Target minggu 11 |
|---|---|---|
| E4.6 Ekspor TFLite model sendiri | Bisma | Selesai lewat Colab atau Linux |
| E6.5 Metrik Model 3 (AUC, precision@3) | Ahmad | Selesai |
| E5.3 Palet 14 warna | Bisma | Selesai |
| E5.4 Unit test warna | Izza | Selesai |
| Dokumentasi metode ML | Izza | Selesai |
| Label 9 kelas pada `assets/models/labels.txt` | Abim | Selesai |
| E7.6 Ukur latensi dan ukuran model | Abim | Selesai |

---

## 2. Pembagian pekerjaan minggu 11

### 2.1 Pekerjaan mobile

| Anggota | Tugas mobile | ho | Branch | PR ke |
|---|---|---:|---|---|
| Izza Dhafira Fanani | E8.6 Halaman Admin, E8.1 CRUD UI Lemari, thumbnail Lemari dan Home | 4,5 | `feat/admin-master-data`, `feat/wardrobe-crud-ui`, `feat/wardrobe-thumbnails` | `dev` |
| Faatihurrizki Prasojo | E2.4 Riwayat rekomendasi, E2.6 Unit test DAO, E8.3 Ranking dan explainability | 3,5 | `feat/recommendation-history`, `test/local-db`, `feat/ranking-explainability` | `dev` |
| Abim Mustawa | E8.7 Edit profil, sinkronkan gambar ke folder aplikasi, penanganan objek bukan outfit | 3,0 | `feat/profile-edit`, `feat/photo-sync`, `feat/non-clothing-object` | `dev` |
| Bisma Adhiaksa | Uji perangkat, E7.5 fallback aturan, rapikan UI login/signup, profil sesuai akun Google | 3,0 | `test/device-check`, `feat/rule-fallback`, `fix/auth-ui`, `feat/google-profile` | `dev` |
| Ahmad Falahi | E8.5 Tab Detail data nyata | 1,5 | `feat/detail-data` | `dev` |
| **Total** | | **15,5** | | |

Catatan:

- Halaman Admin sudah termasuk E8.6, tidak dihitung ulang.
- Penanganan objek bukan outfit: bila foto bukan pakaian, aplikasi memberi pesan
  "objek tidak dikenali sebagai pakaian" dan menawarkan ambil ulang, bukan
  menampilkan klasifikasi asal-asalan.
- Thumbnail memakai `garment_photo.dart` dengan placeholder bila foto tidak ada.

### 2.2 Pekerjaan Machine Learning

| Anggota | Tugas ML | ho | Branch | PR ke |
|---|---|---:|---|---|
| Bisma Adhiaksa | E4.6 ekspor TFLite, E5.3 palet 14 warna | 2,0 | `ml/export-tflite`, `feat/color-palette` | `dev` |
| Ahmad Falahi | E6.5 metrik Model 3, cari dataset aksesoris | 2,0 | `ml/model3-metrics`, `ml/accessory-dataset` | `dev` |
| Abim Mustawa | Label 9 kelas, E7.6 latensi | 1,5 | `chore/model-assets`, `feat/latency-check` | `dev` |
| Izza Dhafira Fanani | E5.4 unit test warna, dokumentasi metode ML | 2,0 | `test/color-palette`, `docs/ml-methods` | `dev` |
| Faatihurrizki Prasojo | Tidak ada tugas ML | 0 | - | - |
| **Total** | | **7,5** | | |

Catatan:

- Urutan kelas wajib: `dress, long_pants, long_sleeve, outerwear, shirt, shoes, shorts, skirt, tshirt`.
- Model 3 masih dilatih pada data sintetis. Tulis sebagai keterbatasan, bukan hasil validasi nyata.
- Ekspor dijalankan di Colab atau Linux dengan masukan `best.pt` 3,1 MB.
- Dataset aksesoris: hasil riset di `ml/reports/accessory-dataset.md` berisi sumber,
  lisensi, jumlah gambar, dan rekomendasi. Belum masuk pelatihan minggu ini.

### 2.3 Pekerjaan QA dan dokumentasi

| Anggota | Tugas | ho | Branch | PR ke |
|---|---|---:|---|---|
| Bisma Adhiaksa | E9.1 Rencana uji dan 20 test case, rekap logbook | 2,5 | `test/qa-plan`, `docs/logbook-minggu-6` | `dev` |
| Ahmad Falahi | E9.2 Uji fungsional black-box dan catat bug | 2,0 | `test/functional` | `dev` |
| Faatihurrizki Prasojo | E10.2 Kumpulkan 150 foto lapangan | 2,0 | `docs/field-photos` | `dev` |
| **Total** | | **6,5** | | |

---

## 3. Ringkasan beban

| Anggota | Mobile | ML | QA dan dokumen | Total |
|---|---:|---:|---:|---:|
| Bisma Adhiaksa | 3,0 | 2,0 | 2,5 | 7,5 |
| Faatihurrizki Prasojo | 3,5 | 0 | 2,0 | 5,5 |
| Ahmad Falahi | 1,5 | 2,0 | 2,0 | 5,5 |
| Abim Mustawa | 3,0 | 1,5 | 0 | 4,5 |
| Izza Dhafira Fanani | 4,5 | 2,0 | 0 | 6,5 |
| **Total** | **15,5** | **7,5** | **6,5** | **29,5** |

Rentang beban 4,5 sampai 7,5 ho.

---

## 4. Jadwal harian

| Hari | Bisma | Pras | Ahmad | Abim | Izza |
|---|---|---|---|---|---|
| Sen 2 | UI auth + kerangka E9.1 | E2.4 riwayat | E8.5 tab Detail | Label 9 kelas | E8.6 Admin |
| Sel 3 | Profil Google + 20 test case | E2.6 test DAO | E8.5 tab Detail | E7.6 latensi | E8.6 Admin |
| Rab 4 | E7.5 fallback + E5.3 palet | E8.3 ranking | E6.5 metrik | Sinkron gambar | Thumbnail |
| Kam 5 | E5.3 palet lanjutan | E8.3 explainability | E9.2 uji fungsional | Objek bukan outfit + edit profil | E5.4 test warna |
| Jum 6 | E4.6 ekspor di Colab | E10.2 foto lapangan | Dataset aksesoris | E8.7 edit profil | Dokumentasi ML + E8.1 CRUD |
| Sab 7 | Uji perangkat | Foto lapangan | Uji fungsional | Uji muat model | Uji CRUD |
| Min 8 | Rekap dan logbook | Rekap | Rekap | Rekap | Rekap |

---

## 5. Target akhir minggu

| Kategori | Target | Ukuran selesai | PIC |
|---|---|---|---|
| Mobile | Uji perangkat | Login, logout, hapus akun berhasil | Bisma |
| Mobile | Fallback aturan | Rekomendasi muncul saat model gagal | Bisma |
| Mobile | UI autentikasi | Tidak ada kolom yang menyesatkan | Bisma |
| Mobile | Profil Google | Nama, email, dan foto sesuai akun | Bisma |
| Mobile | Riwayat rekomendasi | Tersimpan dan tampil setelah restart | Pras |
| Mobile | Unit test DAO | Minimal 6 test lulus | Pras |
| Mobile | Ranking dan explainability | Skor dan alasan tampil di rekomendasi | Pras |
| Mobile | Tab Detail | Data nyata tampil di tab Warna, Styling, Lemari | Ahmad |
| Mobile | Edit profil | Nama dan preferensi bisa diubah | Abim |
| Mobile | Sinkron gambar | Semua foto di folder aplikasi, path valid | Abim |
| Mobile | Objek bukan outfit | Pesan jelas dan tombol ambil ulang | Abim |
| Mobile | Halaman Admin | Master data bisa ditambah, diubah, dihapus | Izza |
| Mobile | CRUD Lemari | Tambah manual dan hapus berjalan | Izza |
| Mobile | Thumbnail | Lemari dan Home menampilkan thumbnail | Izza |
| ML | Ekspor model sendiri | `.tflite` ada dan bisa dimuat | Bisma |
| ML | Palet warna | 14 nama konsisten | Bisma |
| ML | Test warna | Unit test palet lulus | Izza |
| ML | Dokumentasi metode | Dokumen metode dan keterbatasan | Izza |
| ML | Metrik Model 3 | AUC dan precision@3 di JSON | Ahmad |
| ML | Dataset aksesoris | Rekomendasi sumber dan lisensi | Ahmad |
| ML | Label model | 9 kelas sesuai urutan training | Abim |
| ML | Latensi | Di bawah 3 detik per foto | Abim |
| QA | QA plan | 20 test case terdokumentasi | Bisma |
| QA | Uji fungsional | Hasil dan daftar bug tercatat | Ahmad |
| Dokumen | Foto lapangan | 150 foto terkumpul | Pras |

---

## 6. Penghambat dan aksi

| Penghambat | Aksi | PIC | Batas |
|---|---|---|---|
| `labels.txt` tidak cocok dengan model | Samakan sebelum mengukur latensi | Abim | 4 Nov |
| Ekspor TFLite gagal di Windows | Jalankan di Colab atau Linux | Bisma | 5 Nov |
| Model 3 memakai data sintetis | Tulis keterbatasan di dokumen | Bisma | 6 Nov |
| Master data belum punya tabel | Cek `fashion_app.db`, tambah migrasi bila perlu | Izza | 4 Nov |
| Thumbnail butuh foto tersinkron | Kerjakan sinkron gambar lebih dulu | Abim lalu Izza | 4 Nov |
| Uji fungsional butuh build stabil | Uji setelah PR utama digabung | Ahmad | 7 Nov |
| Uji perangkat butuh HP dan SHA-1 | Pastikan SHA-1 sudah terdaftar | Bisma | 5 Nov |

---

## 7. Aturan kerja

1. Maksimal 2 tugas aktif per orang.
2. Satu tugas = satu branch = satu PR; branch dari `dev`, PR ke `dev`.
3. `dev-ml` sudah dihapus dan digabung ke `dev`.
4. Jangan commit dataset, `ml/data`, `ml/runs`, `ml/.venv`, `*.pt`, atau `google-services.json`.
5. `flutter analyze` dan `flutter test` wajib lulus sebelum PR.
6. Status di papan Notion diperbarui setiap hari; rekap diisi Minggu, 8 November.
