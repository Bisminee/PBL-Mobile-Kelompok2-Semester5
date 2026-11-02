# Pembagian Tugas Minggu 6 — Sera-Z

Tim Sera-Z · Kelas TI-3D · Semester 5
Periode: **2 – 8 November 2026**
Disusun: 2 November 2026

> **CATATAN DARI BISMA**
>
> **JANGAN TAKUT SALAH PUSH, JANGAN TAKUT BIKIN KESALAHAN**
>
> **TAKUT KALAU KALIAN NGGAK ADA KONTRIBUSI DI GITHUB**

Fokus minggu ini: **menuntaskan sisa minggu 5**, menyelesaikan integrasi, dan menyiapkan QA.

Pekerjaan yang belum selesai pada minggu 5 dikembalikan ke orang yang sama, lalu ditambah
pekerjaan baru secukupnya agar beban tetap seimbang.

Total: **17,0 ho**, rentang 3,0 sampai 4,0 ho per orang.

---

## 1. Sisa minggu 5 yang dilanjutkan

| Tugas | PIC | Status minggu 5 | Target minggu 6 |
|---|---|---|---|
| E2.4 Riwayat rekomendasi (`recommendation_history`) | Ahmad | Sebagian, tabel outfit sudah ada | Selesai |
| E2.6 Unit test DAO | Ahmad | Belum | Selesai |
| E4.6 Ekspor TFLite model sendiri | Ahmad | Belum, gagal di Windows | Selesai lewat Colab atau Linux |
| E6.5 Metrik Model 3 (AUC, precision@3) | Faatihurrizki | Belum | Selesai |
| E8.6 Halaman Admin master data | Izza | Belum | Selesai |
| E8.1 CRUD UI Lemari: tambah manual dan hapus | Izza | Sebagian, baru baca dan filter | Selesai |
| Label 9 kelas pada `assets/models/labels.txt` | Abim | Sebagian, masih 15 label lama | Selesai |
| Dokumentasi metode ML | Faatihurrizki | Belum | Selesai |
| Uji login di perangkat | Bisma | Belum | Selesai, termasuk logout dan hapus akun |

---

## 2. Pembagian per anggota

### 2.1 Bisma Adhiaksa — 3,5 ho

| Tugas | ho | Branch | PR ke |
|---|---:|---|---|
| E9.1 Rencana uji + minimal 20 test case fungsional | 2,0 | `test/qa-plan` | `dev` |
| Uji login, logout, dan hapus akun di perangkat | 1,0 | `test/device-check` | `dev` |
| Rekap mingguan dan logbook minggu 6 | 0,5 | `docs/logbook-minggu-6` | `dev` |

Keluaran: dokumen QA plan, catatan hasil uji perangkat, logbook minggu 6.

### 2.2 Ahmad Falahi — 3,0 ho

| Tugas | ho | Branch | PR ke |
|---|---:|---|---|
| E2.4 Tabel `recommendation_history` + pencatatan riwayat | 1,0 | `feat/recommendation-history` | `dev` |
| E2.6 Unit test DAO | 1,0 | `test/local-db` | `dev` |
| E4.6 Ekspor TFLite model sendiri | 1,0 | `ml/export-tflite` | `dev` |

Keluaran: riwayat tersimpan, test DAO lulus, berkas `.tflite` model sendiri.

Catatan: ekspor dijalankan di Colab atau Linux. Berkas masukan hanya `best.pt` 3,1 MB.
Kalau berhasil, simpan sebagai `assets/models/model1_yolo11n_v1.tflite` dan perbarui model card.

### 2.3 Faatihurrizki Prasojo — 4,0 ho

| Tugas | ho | Branch | PR ke |
|---|---:|---|---|
| E6.5 Metrik Model 3: AUC dan precision@3 ke JSON | 1,0 | `ml/model3-metrics` | `dev` |
| E5.3 Pemetaan palet 14 warna | 1,0 | `feat/color-palette` | `dev` |
| E5.4 Unit test warna | 1,0 | `test/color-palette` | `dev` |
| Dokumentasi metode ML | 1,0 | `docs/ml-methods` | `dev` |

Keluaran: `ml/reports/model3_metrics.json`, palet 14 warna + test, `docs/ml-methods.md`.

Catatan: tulis jelas bahwa Model 3 masih dilatih pada data sintetis dan itu batasan, bukan hasil validasi nyata.

### 2.4 Abim Mustawa — 3,0 ho

| Tugas | ho | Branch | PR ke |
|---|---:|---|---|
| Label 9 kelas + aset model + smoke test | 0,5 | `chore/model-assets` | `dev` |
| E7.6 Ukur latensi dan ukuran model | 1,0 | `feat/latency-check` | `dev` |
| E8.7 Lengkapi edit profil dan preferensi | 1,5 | `feat/profile-edit` | `dev` |

Keluaran: `labels.txt` berisi 9 kelas, hasil ukur latensi, profil bisa diedit.

Urutan kelas wajib: `dress, long_pants, long_sleeve, outerwear, shirt, shoes, shorts, skirt, tshirt`.

### 2.5 Izza Dhafira Fanani — 3,5 ho

| Tugas | ho | Branch | PR ke |
|---|---:|---|---|
| E8.6 Halaman Admin master data kategori dan warna | 2,0 | `feat/admin-master-data` | `dev` |
| E8.1 CRUD UI Lemari: tambah manual dan hapus | 1,5 | `feat/wardrobe-crud-ui` | `dev` |

Keluaran: layar admin dengan CRUD, tombol tambah dan hapus di layar Lemari.

Catatan: master data memakai tabel SQLite yang sudah ada di `fashion_app.db`. Koordinasi dengan Ahmad bila perlu migrasi.

---

## 3. Ringkasan beban

| Anggota | Sisa minggu 5 | Tugas baru | Total |
|---|---:|---:|---:|
| Bisma Adhiaksa | 1,0 | 2,5 | 3,5 |
| Ahmad Falahi | 3,0 | 0 | 3,0 |
| Faatihurrizki Prasojo | 1,0 | 3,0 | 4,0 |
| Abim Mustawa | 0,5 | 2,5 | 3,0 |
| Izza Dhafira Fanani | 3,5 | 0 | 3,5 |
| **Total** | **9,0** | **8,0** | **17,0** |

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

| Target | Ukuran selesai | PIC |
|---|---|---|
| Riwayat rekomendasi | Tersimpan dan tampil kembali setelah restart | Ahmad |
| Unit test DAO | Minimal 6 test lulus | Ahmad |
| Ekspor model sendiri | Berkas `.tflite` ada dan bisa dimuat | Ahmad |
| Metrik Model 3 | AUC dan precision@3 tercatat di JSON | Faatihurrizki |
| Palet warna | 14 nama warna konsisten, test lulus | Faatihurrizki |
| Halaman Admin | Master data bisa ditambah, diubah, dihapus | Izza |
| CRUD Lemari | Tambah manual dan hapus berjalan | Izza |
| Label model | 9 kelas sesuai urutan training | Abim |
| Latensi | Tercatat, target di bawah 3 detik per foto | Abim |
| Edit profil | Nama dan preferensi bisa diubah | Abim |
| QA plan | 20 test case terdokumentasi | Bisma |
| Uji perangkat | Login, logout, hapus akun berhasil | Bisma |

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
3. `dev-ml` sudah dihapus dan digabung ke `dev`. Tidak ada lagi jalur ML terpisah.
4. Jangan commit dataset, `ml/data`, `ml/runs`, `ml/.venv`, `*.pt`, atau `google-services.json`.
5. `flutter analyze` dan `flutter test` wajib lulus sebelum PR.
6. Status di papan Notion diperbarui setiap hari; rekap diisi Minggu, 8 November.
