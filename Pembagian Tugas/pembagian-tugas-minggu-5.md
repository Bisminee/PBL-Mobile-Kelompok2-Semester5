# Pembagian Tugas Minggu 5 — Sera-Z

Tim Sera-Z · Kelas TI-3D · Semester 5 · Tahun Akademik 2026/2027
Periode: **26 Oktober – 1 November 2026** · Disusun 27 Oktober 2026
Estimasi dalam jam-orang (ho).

## 1. Fokus minggu ini

1. **Menutup PR #3** agar pipeline Model 1 bisa dipakai.
2. **Mengunduh dataset dan menyelesaikan E4.1–E4.2** (jalur kritis).
3. **Menjalankan pekerjaan yang tidak bergantung dataset**: E5 modul warna,
   E2 penyimpanan, E3 autentikasi, E9 rencana uji.

Sasaran akhir minggu:

| Sasaran | Ukuran selesai |
|---|---|
| PR #3 | Digabung ke `main` |
| E4.1 | Tiga dataset ada di `ml/data/raw/`, laporan EDA singkat |
| E4.2 | Tabel mapping kelas + split 70/15/15 tersimpan |
| E5.1 | Crop dan thresholding latar berjalan pada 5 sampel |
| E2.1–E2.2 | DB terbuka, item lemari tersimpan setelah restart |
| E3.1 | Login Google berhasil di perangkat nyata |
| E9.1 | Rencana uji + minimal 20 test case terdokumentasi |
| E10.2 | Minimal 50 dari 150 foto lapangan terkumpul |

## 2. Pembagian per anggota

### 2.1 Faatihurrizki Prasojo — 5,0 ho (data ML + modul warna)

| ID | Tugas | ho | Prasyarat | Tenggat | Status |
|---|---|---:|---|---|---|
| E4.1 | Unduh 3 dataset + EDA + buang kelas ambigu | 1,0 | — | 29 Okt | Belum |
| E4.2 | Gabung kelas + mapping + split 70/15/15 | 1,0 | E4.1 | 31 Okt | Belum |
| E5.1 | Crop tengah + thresholding latar | 1,0 | — | 28 Okt | Bisa mulai |
| E5.2 | K-Means (k=3–5) Lab/HSV di Dart | 2,0 | E5.1 | 1 Nov (lanjut) | Bisa mulai |

Catatan: E5.1–E5.2 tidak bergantung dataset, kerjakan lebih dulu bila unduhan
macet.

### 2.2 Ahmad Falahi — 3,0 ho (pelatihan Model 1)

| ID | Tugas | ho | Prasyarat | Tenggat | Status |
|---|---|---:|---|---|---|
| — | Review PR #3 (rutin, tidak dihitung ho) | — | — | 28 Okt | Wajib |
| E4.3 | Baseline MobileNetV2 | 1,5 | E4.2 | 31 Okt | Menunggu |
| E4.4 | Latih YOLOv11n-cls + fine-tune (mulai) | 1,5 dari 2,5 | E4.2 | 1 Nov (lanjut) | Menunggu |

Rencana cadangan: bila E4.1 belum selesai 29 Okt, Ahmad membantu merapikan
dataset, bukan mengambil E4.2.

### 2.3 Abim Mustawa — 3,5 ho (penyimpanan)

| ID | Tugas | ho | Prasyarat | Tenggat | Status |
|---|---|---:|---|---|---|
| E2.1 | Setup `sqflite` + `path_provider`, helper DB & migrasi | 1,0 | — | 28 Okt | Bisa mulai |
| E2.2 | CRUD `wardrobe_items` | 1,5 | E2.1 | 30 Okt | Belum |
| E2.3 | Simpan foto ke folder dokumen (hanya path di DB) | 1,0 | E2.1 | 1 Nov | Belum |

### 2.4 Bisma Adhiaksa — 4,0 ho (autentikasi + QA)

| ID | Tugas | ho | Prasyarat | Tenggat | Status |
|---|---|---:|---|---|---|
| E3.1 | `google_sign_in` + Firebase Auth | 2,0 | — | 30 Okt | Bisa mulai |
| E9.1 | Rencana uji + minimal 20 test case fungsional | 2,0 | — | 1 Nov | Bisa mulai |

Tugas rutin: memastikan PR #3 direview dan digabung, memperbarui papan Notion,
menyiapkan rekap mingguan.

Prasyarat E3.1: proyek Firebase dan `google-services.json` harus dibuat lebih
dulu. Berkas kunci tidak boleh di-commit.

### 2.5 Izza Dhafira Fanani — 4,0 ho (dokumentasi + fitur)

| ID | Tugas | ho | Prasyarat | Tenggat | Status |
|---|---|---:|---|---|---|
| E10.2 | Kumpulkan minimal 50 foto lapangan | 2,0 | — | 1 Nov | Bisa mulai |
| E8.6 | Halaman Admin: master data kategori warna & jenis | 2,0 | E2.1 | 1 Nov (lanjut) | Menunggu |

Tugas rutin: E10.1 logbook minggu 5 (0,5 ho, Minggu).

## 3. Jadwal harian

| Hari | Faatihurrizki | Ahmad | Abim | Bisma | Izza |
|---|---|---|---|---|---|
| Sel 27 | E4.1 unduh | review PR #3 | E2.1 | E3.1 setup Firebase | E10.2 foto |
| Rab 28 | E4.1 EDA + E5.1 | review selesai | E2.1 → E2.2 | E3.1 | E10.2 foto |
| Kam 29 | E4.2 (dataset lengkap) | siapkan skrip latih | E2.2 | E3.1 uji login | E10.2 + E8.6 |
| Jum 30 | E4.2 + E5.2 | E4.3 baseline | E2.3 | E9.1 test case | E8.6 |
| Sab 31 | E4.2 selesai + uji | E4.3 selesai | E2.3 | E9.1 | E8.6 |
| Min 1 | E5.2 | E4.4 mulai | rekap | logbook + rekap | logbook |

## 4. Penghambat dan aksi

| Penghambat | Aksi | Penanggung | Batas |
|---|---|---|---|
| Dataset belum diunduh | Unduh 3 zip Kaggle, taruh di `ml/data/raw/` | Faatihurrizki | 29 Okt |
| PR #3 belum direview | Review dan gabung | Ahmad, Bisma | 28 Okt |
| Firebase belum ada | Buat proyek + `google-services.json` lokal | Bisma | 28 Okt |
| `main` bertambah commit baru | Sinkronkan `dev` dengan `main` | Bisma | 28 Okt |

## 5. Ringkasan beban

| Anggota | ho | Tugas aktif | Peran |
|---|---:|---:|---|
| Faatihurrizki Prasojo | 5,0 | 2 | Data ML + modul warna |
| Bisma Adhiaksa | 4,0 | 2 | Autentikasi + QA |
| Izza Dhafira Fanani | 4,0 (+0,5 rutin) | 2 | Dokumentasi + UI admin |
| Abim Mustawa | 3,5 | 2 | Penyimpanan |
| Ahmad Falahi | 3,0 | 2 | Pelatihan Model 1 |
| **Total** | **19,5 (+0,5)** | | |

## 6. Yang tidak dikerjakan minggu ini

E4.5–E4.6, E6.1–E6.6, E7.1–E7.6, E8.1–E8.5, E8.7, E9.2 ke atas. Semua menunggu
artefak model atau prasyarat fitur.

## 7. Aturan

- Satu tugas = satu branch = satu PR; PR mengarah ke `main`.
- Branch `dev` dipakai untuk uji integrasi, bukan menyimpan hasil akhir.
- Maksimal 2 tugas aktif per orang.
- Status di papan Notion diperbarui setiap hari.
- Rekap mingguan diisi Minggu, 1 November 2026.
