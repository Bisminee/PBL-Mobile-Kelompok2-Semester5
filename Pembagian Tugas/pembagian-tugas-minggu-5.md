# Daftar Kerja Minggu 5 — Sera-Z

Tim Sera-Z · Kelas TI-3D · Semester 5
Periode: **27 Oktober – 1 November 2026** (sisa minggu 5)
Disusun: 27 Oktober 2026

Prinsip minggu ini: **mobile dulu, ML menyusul**. Dataset tetap diunduh sebagai
tugas latar karena waktu unduh dan EDA tidak bisa ditekan.

---

## 1. Prioritas

| Prioritas | Tugas | Alasan |
|---|---|---|
| P0 | E2.1, E2.2 (Abim) | Membuka E8.6, E8.1, E8.2, E8.4 |
| P0 | E3.1 (Bisma) | Membuka E3.2–E3.4 dan E8.7 |
| P0 | E5.1 (Faatihurrizki) | Membuka E5.2–E5.4, tidak butuh dataset |
| P0 | E9.1 (Ahmad) | Harus siap sebelum E9.2; bisa jalan tanpa kode |
| P0 | Review dan gabung PR #3 | Kode pipeline ML berhenti di PR |
| P1 | E4.1–E4.2 (Faatihurrizki) | Jalur kritis jangka panjang, lead time unduh |
| P2 | E2.3, E3.2, E3.3, E5.2, E8.6 | Lanjutan setelah P0 selesai |
| Ditunda | E4.3–E4.6, E6.*, E7.* | Menunggu data dan artefak model |

---

## 2. Daftar kerja per hari

### Selasa, 27 Oktober

| Orang | Tugas | Keluaran |
|---|---|---|
| Ahmad | Review PR #3 (skrip ML, label map, panduan) | Komentar review atau approve |
| Bisma | Buat proyek Firebase + `google-services.json` lokal | Berkas kunci ada, tidak di-commit |
| Abim | E2.1 setup `sqflite`, `path_provider`, helper DB | DB terbuka, skema v1 |
| Faatihurrizki | Mulai unduh 3 dataset + E5.1 crop | Zip masuk `ml/data/raw/`, crop berjalan |
| Izza | Mulai E10.2 foto lapangan | 20 foto pertama |

### Rabu, 28 Oktober

| Orang | Tugas | Keluaran |
|---|---|---|
| Ahmad | Lanjut review PR #3, siapkan E9.1 | PR siap digabung, kerangka test case |
| Bisma | E3.1 `google_sign_in` + Firebase Auth | Login berhasil di perangkat |
| Abim | E2.2 CRUD `wardrobe_items` | Insert, ambil, hapus berjalan |
| Faatihurrizki | E4.1 EDA + selesaikan E5.1 | Laporan EDA singkat, crop final |
| Izza | E8.6 desain master data (skema kategori) | Rancangan tabel dan layar |

### Kamis, 29 Oktober

| Orang | Tugas | Keluaran |
|---|---|---|
| Bisma | E3.2 record cloud `users` + `profiles` | Profil terbentuk saat login |
| Abim | E2.3 simpan foto (hanya path di DB) | Foto tampil setelah restart |
| Faatihurrizki | E4.2 split 70/15/15 + mulai E5.2 | Mapping dan split tersimpan |
| Ahmad | E9.1 minimal 20 test case | Dokumen rencana uji |
| Izza | E8.6 implementasi (setelah E2.1) | Layar admin membaca master data |

### Jumat, 30 Oktober

| Orang | Tugas | Keluaran |
|---|---|---|
| Abim | E2.4 tabel `outfits` + `recommendation_history` | DAO outfit dan riwayat |
| Bisma | E3.3 sesi persisten | Masih login setelah restart |
| Faatihurrizki | E5.2 K-Means (k=3–5) Lab/HSV | Warna dominan benar pada 5 sampel |
| Ahmad | E10.2 lanjut foto + E10.5 kerangka dokumentasi | 60 foto, kerangka docs |
| Izza | E8.1 mulai CRUD UI Lemari | Form tambah dan daftar item |

### Sabtu, 31 Oktober

| Orang | Tugas | Keluaran |
|---|---|---|
| Abim | E2.5 muat data saat start | Data muncul setelah cold start |
| Bisma | E3.4 sign out + jalur hapus akun | Logout bersih |
| Faatihurrizki | E5.3 palet 14 warna | Nama warna sesuai sampel |
| Ahmad | E9.1 selesai + tinjau hasil review PR #3 | 20 test case final |
| Izza | E8.1 filter dan empty state | CRUD penuh berjalan |

### Minggu, 1 November

| Orang | Tugas | Keluaran |
|---|---|---|
| Abim | E2.6 unit test DAO | Test lulus |
| Faatihurrizki | E5.4 unit test warna | Test lulus |
| Bisma | E8.7 halaman Profil | Profil dapat diedit |
| Ahmad | Rekap QA + perbarui papan Notion | Status terisi |
| Izza | E10.1 logbook minggu 5 + rekap | Logbook diperbarui |

---

## 3. Target akhir minggu

| Tugas | Kriteria diterima |
|---|---|
| E2.1–E2.3 | Item lemari bertahan setelah aplikasi ditutup; foto tampil dari folder dokumen |
| E3.1–E3.3 | Login Google berhasil, profil terbentuk, sesi bertahan setelah restart |
| E5.1–E5.2 | Crop berjalan; warna dominan benar pada minimal 8 dari 10 gambar uji |
| E8.6 | Master data kategori dan jenis dapat dikelola dari aplikasi |
| E9.1 | Dokumen rencana uji berisi minimal 20 test case, termasuk kasus negatif |
| E4.1–E4.2 | Dataset bersih, laporan EDA singkat, split 70/15/15 tersimpan |
| PR #3 | Digabung ke `main` |

Semua PR wajib lulus `flutter analyze` dan `flutter test` sebelum digabung.

---

## 4. Penghambat dan aksi

| Penghambat | Aksi | Penanggung | Batas |
|---|---|---|---|
| PR #3 belum direview | Review lalu gabung | Ahmad, Bisma | 28 Okt |
| Firebase belum ada | Buat proyek dan berkas konfigurasi lokal | Bisma | 28 Okt |
| Dataset belum diunduh | Unduh 3 zip dan taruh di `ml/data/raw/` | Faatihurrizki | 29 Okt |
| `dev` perlu sinkron dengan `main` | Merge `main` ke `dev` | Bisma | 28 Okt |
| Branch `feat/sqflite-setup` usang | Buat ulang dari `main` sebelum E2.1 | Abim | 27 Okt |

---

## 5. Aturan

1. Maksimal 2 tugas aktif per orang.
2. Satu tugas = satu branch = satu PR; PR mengarah ke `main`.
3. `dev` hanya untuk uji integrasi, bukan tempat menyimpan hasil akhir.
4. Tugas yang prasyaratnya belum selesai tidak diambil.
5. Status di papan Notion diperbarui setiap hari; rekap diisi Minggu, 1 November.
