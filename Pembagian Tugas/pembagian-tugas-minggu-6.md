# Pembagian Tugas Minggu 6 — Sera-Z

Tim Sera-Z · Kelas TI-3D · Semester 5
Periode: **2 – 8 November 2026**
Disusun: 2 November 2026

> **CATATAN DARI BISMA**
>
> **JANGAN TAKUT SALAH PUSH, JANGAN TAKUT BIKIN KESALAHAN**
>
> **TAKUT KALAU KALIAN NGGAK ADA KONTRIBUSI DI GITHUB**

Fokus minggu ini: menuntaskan sisa minggu 5, menyelesaikan integrasi, dan menyiapkan QA.
Pekerjaan yang belum selesai dikembalikan ke orang yang sama.

Total **17,0 ho**, terdiri dari 7,0 ho mobile, 6,5 ho ML, dan 3,5 ho QA serta dokumentasi.

---

## 1. Sisa minggu 5 yang dilanjutkan

### 1.1 Sisa pekerjaan mobile

| Tugas | PIC | Status minggu 5 | Target minggu 6 |
|---|---|---|---|
| E2.4 Riwayat rekomendasi (`recommendation_history`) | Ahmad | Sebagian, tabel outfit sudah ada | Selesai |
| E2.6 Unit test DAO | Ahmad | Belum | Selesai |
| E8.6 Halaman Admin master data | Izza | Belum | Selesai |
| E8.1 CRUD UI Lemari: tambah manual dan hapus | Izza | Sebagian, baru baca dan filter | Selesai |

### 1.2 Sisa pekerjaan ML

| Tugas | PIC | Status minggu 5 | Target minggu 6 |
|---|---|---|---|
| E4.6 Ekspor TFLite model sendiri | Ahmad | Belum, gagal di Windows | Selesai lewat Colab atau Linux |
| E6.5 Metrik Model 3 (AUC, precision@3) | Faatihurrizki | Belum | Selesai |
| Label 9 kelas pada `assets/models/labels.txt` | Abim | Sebagian, masih 15 label lama | Selesai |
| Dokumentasi metode ML | Faatihurrizki | Belum | Selesai |

### 1.3 Sisa pekerjaan QA

| Tugas | PIC | Status minggu 5 | Target minggu 6 |
|---|---|---|---|
| Uji login, logout, dan hapus akun di perangkat | Bisma | Belum | Selesai |

---

## 2. Pembagian pekerjaan minggu 6

### 2.1 Pekerjaan mobile

| Anggota | Tugas mobile | ho | Branch | PR ke |
|---|---|---:|---|---|
| Ahmad Falahi | E2.4 Riwayat rekomendasi, E2.6 Unit test DAO | 2,0 | `feat/recommendation-history`, `test/local-db` | `dev` |
| Izza Dhafira Fanani | E8.6 Halaman Admin, E8.1 CRUD UI Lemari | 3,5 | `feat/admin-master-data`, `feat/wardrobe-crud-ui` | `dev` |
| Abim Mustawa | E8.7 Lengkapi edit profil dan preferensi | 1,5 | `feat/profile-edit` | `dev` |
| Bisma Adhiaksa | Tidak ada tugas mobile | 0 | - | - |
| Faatihurrizki Prasojo | Tidak ada tugas mobile | 0 | - | - |
| **Total** | | **7,0** | | |

### 2.2 Pekerjaan Machine Learning

| Anggota | Tugas ML | ho | Branch | PR ke |
|---|---|---:|---|---|
| Faatihurrizki Prasojo | E6.5 Metrik Model 3, E5.3 Palet 14 warna, E5.4 Unit test warna, dokumentasi metode ML | 4,0 | `ml/model3-metrics`, `feat/color-palette`, `test/color-palette`, `docs/ml-methods` | `dev` |
| Abim Mustawa | Label 9 kelas, E7.6 Ukur latensi dan ukuran model | 1,5 | `chore/model-assets`, `feat/latency-check` | `dev` |
| Ahmad Falahi | E4.6 Ekspor TFLite model sendiri | 1,0 | `ml/export-tflite` | `dev` |
| Bisma Adhiaksa | Tidak ada tugas ML | 0 | - | - |
| Izza Dhafira Fanani | Tidak ada tugas ML | 0 | - | - |
| **Total** | | **6,5** | | |

Catatan:

- Urutan kelas wajib: `dress, long_pants, long_sleeve, outerwear, shirt, shoes, shorts, skirt, tshirt`.
- Model 3 masih dilatih pada data sintetis. Tulis sebagai keterbatasan, bukan hasil validasi nyata.
- Ekspor dijalankan di Colab atau Linux dengan masukan `best.pt` 3,1 MB.
- Kalau ekspor berhasil, simpan sebagai `assets/models/model1_yolo11n_v1.tflite` dan perbarui model card.

### 2.3 Pekerjaan QA dan dokumentasi

| Anggota | Tugas | ho | Branch | PR ke |
|---|---|---:|---|---|
| Bisma Adhiaksa | E9.1 Rencana uji dan 20 test case, uji perangkat, rekap logbook | 3,5 | `test/qa-plan`, `test/device-check`, `docs/logbook-minggu-6` | `dev` |
| **Total** | | **3,5** | | |

---

## 3. Ringkasan beban

| Anggota | Mobile | ML | QA dan dokumen | Total |
|---|---:|---:|---:|---:|
| Bisma Adhiaksa | 0 | 0 | 3,5 | 3,5 |
| Ahmad Falahi | 2,0 | 1,0 | 0 | 3,0 |
| Faatihurrizki Prasojo | 0 | 4,0 | 0 | 4,0 |
| Abim Mustawa | 1,5 | 1,5 | 0 | 3,0 |
| Izza Dhafira Fanani | 3,5 | 0 | 0 | 3,5 |
| **Total** | **7,0** | **6,5** | **3,5** | **17,0** |

---

## 4. Jadwal harian

| Hari | Bisma | Ahmad | Faatihurrizki | Abim | Izza |
|---|---|---|---|---|---|
| Sen 2 | Susun kerangka E9.1 | E2.4 riwayat | E6.5 metrik | Label 9 kelas | E8.6 Admin |
| Sel 3 | Tulis 20 test case | E2.6 test DAO | E5.3 palet | E7.6 latensi | E8.6 Admin |
| Rab 4 | Uji login di perangkat | E4.6 ekspor di Colab | E5.4 test warna | E8.7 edit profil | E8.1 tambah item |
| Kam 5 | Uji logout dan hapus akun | Verifikasi hasil ekspor | Dokumentasi ML | E8.7 edit profil | E8.1 hapus item |
| Jum 6 | Review PR dan catat temuan | Review PR | Review PR | Review PR | Review PR |
| Sab 7 | Uji regresi alur utama | Perbaiki temuan | Perbaiki temuan | Uji muat model | Uji CRUD |
| Min 8 | Rekap dan logbook | Rekap | Rekap | Rekap | Rekap |

---

## 5. Target akhir minggu

| Kategori | Target | Ukuran selesai | PIC |
|---|---|---|---|
| Mobile | Riwayat rekomendasi | Tersimpan dan tampil kembali setelah restart | Ahmad |
| Mobile | Unit test DAO | Minimal 6 test lulus | Ahmad |
| Mobile | Halaman Admin | Master data bisa ditambah, diubah, dihapus | Izza |
| Mobile | CRUD Lemari | Tambah manual dan hapus berjalan | Izza |
| Mobile | Edit profil | Nama dan preferensi bisa diubah | Abim |
| ML | Ekspor model sendiri | Berkas `.tflite` ada dan bisa dimuat | Ahmad |
| ML | Metrik Model 3 | AUC dan precision@3 tercatat di JSON | Faatihurrizki |
| ML | Palet warna | 14 nama warna konsisten, test lulus | Faatihurrizki |
| ML | Label model | 9 kelas sesuai urutan training | Abim |
| ML | Latensi | Tercatat, target di bawah 3 detik per foto | Abim |
| QA | QA plan | 20 test case terdokumentasi | Bisma |
| QA | Uji perangkat | Login, logout, hapus akun berhasil | Bisma |

---

## 6. Penghambat dan aksi

| Penghambat | Aksi | PIC | Batas |
|---|---|---|---|
| `labels.txt` tidak cocok dengan model | Samakan sebelum mengukur latensi | Abim | 3 Nov |
| Ekspor TFLite gagal di Windows | Jalankan di Colab atau Linux | Ahmad | 4 Nov |
| Model 3 memakai data sintetis | Tulis keterbatasan di dokumen | Faatihurrizki | 5 Nov |
| Master data belum punya tabel | Cek `fashion_app.db`, tambah migrasi bila perlu | Izza, Ahmad | 3 Nov |
| Uji perangkat butuh HP dan SHA-1 | Pastikan SHA-1 sudah terdaftar | Bisma | 4 Nov |

---

## 7. Aturan kerja

1. Maksimal 2 tugas aktif per orang.
2. Satu tugas = satu branch = satu PR; branch dari `dev`, PR ke `dev`.
3. `dev-ml` sudah dihapus dan digabung ke `dev`. Tidak ada jalur ML terpisah.
4. Jangan commit dataset, `ml/data`, `ml/runs`, `ml/.venv`, `*.pt`, atau `google-services.json`.
5. `flutter analyze` dan `flutter test` wajib lulus sebelum PR.
6. Status di papan Notion diperbarui setiap hari; rekap diisi Minggu, 8 November.
