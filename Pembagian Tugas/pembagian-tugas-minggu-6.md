# Pembagian Tugas Minggu 6 — Sera-Z

Tim Sera-Z · Kelas TI-3D · Semester 5
Periode: **2 – 8 November 2026**
Disusun: 2 November 2026

> **CATATAN DARI BISMA**
>
> **JANGAN TAKUT SALAH PUSH, JANGAN TAKUT BIKIN KESALAHAN**
>
> **TAKUT KALAU KALIAN NGGAK ADA KONTRIBUSI DI GITHUB**

Fokus minggu ini: menuntaskan sisa minggu 5 dan menyiapkan QA.

Total **18,5 ho**, terdiri dari 9,5 ho mobile, 6,5 ho ML, dan 2,5 ho QA serta dokumentasi.

---

## 1. Sisa minggu 5 yang dilanjutkan

### 1.1 Sisa pekerjaan mobile

| Tugas | PIC | Target minggu 6 |
|---|---|---|
| E2.4 Riwayat rekomendasi (`recommendation_history`) | Bisma | Selesai |
| E2.6 Unit test DAO | Bisma | Selesai |
| E8.6 Halaman Admin master data | Izza | Selesai |
| E8.1 CRUD UI Lemari: tambah manual dan hapus | Izza | Selesai |
| Uji login, logout, dan hapus akun di perangkat | Bisma | Selesai |

### 1.2 Sisa pekerjaan ML

| Tugas | PIC | Target minggu 6 |
|---|---|---|
| E4.6 Ekspor TFLite model sendiri | Bisma | Selesai lewat Colab atau Linux |
| E6.5 Metrik Model 3 (AUC, precision@3) | Bisma | Selesai |
| E5.3 Palet 14 warna | Bisma | Selesai |
| E5.4 Unit test warna | Bisma | Selesai |
| Dokumentasi metode ML | Bisma | Selesai |
| Label 9 kelas pada `assets/models/labels.txt` | Abim | Selesai |
| E7.6 Ukur latensi dan ukuran model | Abim | Selesai |

### 1.3 Sisa pekerjaan QA

Tidak ada. Uji perangkat masuk ke pekerjaan mobile.

---

## 2. Pembagian pekerjaan minggu 6

### 2.1 Pekerjaan mobile

| Anggota | Tugas mobile | ho | Branch | PR ke |
|---|---|---:|---|---|
| Bisma Adhiaksa | Uji perangkat, E2.4 riwayat, E2.6 test DAO, E7.5 fallback aturan, rapikan UI login/signup | 4,5 | `test/device-check`, `feat/recommendation-history`, `test/local-db`, `feat/rule-fallback`, `fix/auth-ui` | `dev` |
| Izza Dhafira Fanani | E8.6 Halaman Admin, E8.1 CRUD UI Lemari | 3,5 | `feat/admin-master-data`, `feat/wardrobe-crud-ui` | `dev` |
| Abim Mustawa | E8.7 Lengkapi edit profil dan preferensi | 1,5 | `feat/profile-edit` | `dev` |
| Ahmad Falahi | Tidak ada tugas | 0 | - | - |
| Faatihurrizki Prasojo | Tidak ada tugas | 0 | - | - |
| **Total** | | **9,5** | | |

Rincian tugas mobile Bisma:

| Tugas | ho | Isi |
|---|---:|---|
| Uji perangkat | 1,0 | Login, logout, hapus akun di HP nyata |
| E2.4 Riwayat rekomendasi | 1,0 | Tabel `recommendation_history`, catat saat rekomendasi dibuat, tampilkan di layar riwayat |
| E2.6 Unit test DAO | 1,0 | Minimal 6 test untuk `local_db.dart` memakai `sqflite_common_ffi` |
| E7.5 Fallback aturan | 1,0 | Bila engine model gagal dimuat, rekomendasi tetap muncul memakai aturan harmoni dan skor formalitas |
| Rapikan UI login/signup | 0,5 | Sembunyikan atau nonaktifkan kolom email dan password sampai autentikasi email tersedia |

### 2.2 Pekerjaan Machine Learning

| Anggota | Tugas ML | ho | Branch | PR ke |
|---|---|---:|---|---|
| Bisma Adhiaksa | E4.6 ekspor TFLite, E6.5 metrik Model 3, E5.3 palet warna, E5.4 test warna, dokumentasi metode | 5,0 | `ml/export-tflite`, `ml/model3-metrics`, `feat/color-palette`, `test/color-palette`, `docs/ml-methods` | `dev` |
| Abim Mustawa | Label 9 kelas, E7.6 latensi | 1,5 | `chore/model-assets`, `feat/latency-check` | `dev` |
| Ahmad Falahi | Tidak ada tugas | 0 | - | - |
| Faatihurrizki Prasojo | Tidak ada tugas | 0 | - | - |
| Izza Dhafira Fanani | Tidak ada tugas | 0 | - | - |
| **Total** | | **6,5** | | |

Catatan:

- Urutan kelas wajib: `dress, long_pants, long_sleeve, outerwear, shirt, shoes, shorts, skirt, tshirt`.
- Model 3 masih dilatih pada data sintetis. Tulis sebagai keterbatasan, bukan hasil validasi nyata.
- Ekspor TFLite dijalankan di Colab atau Linux dengan masukan `best.pt` 3,1 MB.
- Kalau ekspor berhasil, simpan sebagai `assets/models/model1_yolo11n_v1.tflite` dan perbarui model card.

### 2.3 Pekerjaan QA dan dokumentasi

| Anggota | Tugas | ho | Branch | PR ke |
|---|---|---:|---|---|
| Bisma Adhiaksa | E9.1 Rencana uji dan 20 test case, rekap logbook | 2,5 | `test/qa-plan`, `docs/logbook-minggu-6` | `dev` |
| **Total** | | **2,5** | | |

---

## 3. Ringkasan beban

| Anggota | Mobile | ML | QA dan dokumen | Total |
|---|---:|---:|---:|---:|
| Bisma Adhiaksa | 4,5 | 5,0 | 2,5 | 12,0 |
| Ahmad Falahi | 0 | 0 | 0 | 0 |
| Faatihurrizki Prasojo | 0 | 0 | 0 | 0 |
| Abim Mustawa | 1,5 | 1,5 | 0 | 3,0 |
| Izza Dhafira Fanani | 3,5 | 0 | 0 | 3,5 |
| **Total** | **9,5** | **6,5** | **2,5** | **18,5** |

---

## 4. Jadwal harian

| Hari | Bisma | Abim | Izza |
|---|---|---|---|
| Sen 2 | E2.4 riwayat + kerangka E9.1 | Label 9 kelas | E8.6 Admin |
| Sel 3 | E2.6 test DAO + 20 test case | E7.6 latensi | E8.6 Admin |
| Rab 4 | E7.5 fallback + E5.3 palet | E8.7 edit profil | E8.1 tambah item |
| Kam 5 | Rapikan UI auth + E5.4 test warna | E8.7 edit profil | E8.1 hapus item |
| Jum 6 | E4.6 ekspor di Colab + E6.5 metrik | Review PR | Review PR |
| Sab 7 | Dokumentasi ML + uji perangkat | Uji muat model | Uji CRUD |
| Min 8 | Rekap dan logbook | Rekap | Rekap |

---

## 5. Target akhir minggu

| Kategori | Target | Ukuran selesai | PIC |
|---|---|---|---|
| Mobile | Uji perangkat | Login, logout, hapus akun berhasil | Bisma |
| Mobile | Riwayat rekomendasi | Tersimpan dan tampil setelah restart | Bisma |
| Mobile | Unit test DAO | Minimal 6 test lulus | Bisma |
| Mobile | Fallback aturan | Rekomendasi tetap muncul saat model gagal | Bisma |
| Mobile | UI autentikasi | Tidak ada kolom yang menyesatkan pengguna | Bisma |
| Mobile | Halaman Admin | Master data bisa ditambah, diubah, dihapus | Izza |
| Mobile | CRUD Lemari | Tambah manual dan hapus berjalan | Izza |
| Mobile | Edit profil | Nama dan preferensi bisa diubah | Abim |
| ML | Ekspor model sendiri | Berkas `.tflite` ada dan bisa dimuat | Bisma |
| ML | Metrik Model 3 | AUC dan precision@3 tercatat di JSON | Bisma |
| ML | Palet warna | 14 nama warna konsisten, test lulus | Bisma |
| ML | Label model | 9 kelas sesuai urutan training | Abim |
| ML | Latensi | Tercatat, target di bawah 3 detik per foto | Abim |
| QA | QA plan | 20 test case terdokumentasi | Bisma |

---

## 6. Penghambat dan aksi

| Penghambat | Aksi | PIC | Batas |
|---|---|---|---|
| `labels.txt` tidak cocok dengan model | Samakan sebelum mengukur latensi | Abim | 3 Nov |
| Ekspor TFLite gagal di Windows | Jalankan di Colab atau Linux | Bisma | 4 Nov |
| Model 3 memakai data sintetis | Tulis keterbatasan di dokumen | Bisma | 5 Nov |
| Master data belum punya tabel | Cek `fashion_app.db`, tambah migrasi bila perlu | Izza | 3 Nov |
| Uji perangkat butuh HP dan SHA-1 | Pastikan SHA-1 sudah terdaftar | Bisma | 4 Nov |
| Beban Bisma 12,0 ho | Kerjakan berurutan, maksimal 2 tugas aktif | Bisma | 8 Nov |

---

## 7. Aturan kerja

1. Maksimal 2 tugas aktif per orang.
2. Satu tugas = satu branch = satu PR; branch dari `dev`, PR ke `dev`.
3. `dev-ml` sudah dihapus dan digabung ke `dev`.
4. Jangan commit dataset, `ml/data`, `ml/runs`, `ml/.venv`, `*.pt`, atau `google-services.json`.
5. `flutter analyze` dan `flutter test` wajib lulus sebelum PR.
6. Status di papan Notion diperbarui setiap hari; rekap diisi Minggu, 8 November.
