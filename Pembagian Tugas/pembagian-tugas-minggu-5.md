# Daftar Kerja Minggu 5 — Sera-Z

Tim Sera-Z · Kelas TI-3D · Semester 5
Periode: **27 Oktober – 1 November 2026** (sisa minggu 5)
Disusun: 27 Oktober 2026

Prinsip minggu ini: **mobile dulu, ML menyusul**.
Perubahan 27 Oktober: penyimpanan (E2) pindah dari Abim ke Faatihurrizki Prasojo
(Pras); modul warna (E5) dan foto lapangan (E10.2) pindah ke Abim.

---

## 1. Prioritas

| Prioritas | Tugas | Pemilik | Alasan |
|---|---|---|---|
| P0 | E2.1, E2.2 | Pras | Membuka E8.6, E8.1, E8.2, E8.4 |
| P0 | E3.1 | Bisma | Membuka E3.2–E3.4 dan E8.7 |
| P0 | E5.1 | Abim | Tanpa prasyarat, tidak butuh dataset |
| P0 | E9.1 | Ahmad | Harus siap sebelum E9.2; bisa jalan tanpa kode |
| P0 | Review dan gabung PR #3 | Ahmad, Bisma | Kode pipeline ML berhenti di PR |
| P1 | E4.1–E4.2 | Ahmad | Jalur kritis jangka panjang, lead time unduh |
| P2 | E2.3, E3.2, E3.3, E5.2, E8.6 | Pras, Bisma, Abim, Izza | Lanjutan setelah P0 |
| Ditunda | E4.3–E4.6, E6.*, E7.* | — | Menunggu data dan artefak model |

---

## 2. Daftar kerja per hari

### Selasa, 27 Oktober

| Orang | Tugas | Keluaran |
|---|---|---|
| Pras | E2.1 setup `sqflite`, `path_provider`, helper DB | DB terbuka, skema v1 |
| Bisma | Buat proyek Firebase + `google-services.json` lokal | Berkas kunci ada, tidak di-commit |
| Abim | E5.1 crop tengah + thresholding latar | Crop berjalan pada 5 sampel |
| Izza | Mulai E10.2 foto lapangan | 20 foto pertama |
| Ahmad | Review PR #3 + mulai unduh 3 dataset | Komentar review, unduhan berjalan |

### Rabu, 28 Oktober

| Orang | Tugas | Keluaran |
|---|---|---|
| Pras | E2.2 CRUD `wardrobe_items` | Insert, ambil, hapus berjalan |
| Bisma | E3.1 `google_sign_in` + Firebase Auth | Login berhasil di perangkat |
| Abim | Selesaikan E5.1, mulai E5.2 K-Means | Crop final, kerangka K-Means |
| Izza | E8.6 rancangan master data | Rancangan tabel dan layar |
| Ahmad | Review PR #3 selesai, mulai E9.1 | PR siap digabung, kerangka test case |

### Kamis, 29 Oktober

| Orang | Tugas | Keluaran |
|---|---|---|
| Pras | E2.3 simpan foto (hanya path di DB) | Foto tampil setelah restart |
| Bisma | E3.2 record cloud `users` + `profiles` | Profil terbentuk saat login |
| Abim | E5.2 K-Means (k=3–5) Lab/HSV | Warna dominan benar pada 5 sampel |
| Izza | E8.6 implementasi (setelah E2.1) | Layar admin membaca master data |
| Ahmad | E9.1 minimal 20 test case | Dokumen rencana uji |

### Jumat, 30 Oktober

| Orang | Tugas | Keluaran |
|---|---|---|
| Pras | E2.4 tabel `outfits` + `recommendation_history` | DAO outfit dan riwayat |
| Bisma | E3.3 sesi persisten | Masih login setelah restart |
| Abim | E5.2 lanjutan | Warna dominan stabil pada 8 dari 10 sampel |
| Izza | E8.1 mulai CRUD UI Lemari | Form tambah dan daftar item |
| Ahmad | E4.1 EDA + mulai E10.5 dokumentasi | Laporan EDA singkat |

### Sabtu, 31 Oktober

| Orang | Tugas | Keluaran |
|---|---|---|
| Pras | E2.5 muat data saat start | Data muncul setelah cold start |
| Bisma | E3.4 sign out + jalur hapus akun | Logout bersih |
| Abim | E5.3 palet 14 warna | Nama warna sesuai sampel |
| Izza | E8.1 filter dan empty state | CRUD penuh berjalan |
| Ahmad | E9.1 selesai + E4.2 split | 20 test case final, split tersimpan |

### Minggu, 1 November

| Orang | Tugas | Keluaran |
|---|---|---|
| Pras | E2.6 unit test DAO | Test lulus |
| Bisma | E8.7 halaman Profil | Profil dapat diedit |
| Abim | E5.4 unit test warna | Test lulus |
| Izza | E10.1 logbook minggu 5 + rekap | Logbook diperbarui |
| Ahmad | Rekap QA + perbarui papan Notion | Status terisi |

---

## 3. Target akhir minggu

| Tugas | Kriteria diterima | Pemilik |
|---|---|---|
| E2.1–E2.3 | Item lemari bertahan setelah aplikasi ditutup; foto tampil dari folder dokumen | Pras |
| E3.1–E3.3 | Login Google berhasil, profil terbentuk, sesi bertahan setelah restart | Bisma |
| E5.1–E5.2 | Crop berjalan; warna dominan benar pada minimal 8 dari 10 gambar uji | Abim |
| E8.6 | Master data kategori dan jenis dapat dikelola dari aplikasi | Izza |
| E9.1 | Dokumen rencana uji berisi minimal 20 test case, termasuk kasus negatif | Ahmad |
| E4.1–E4.2 | Dataset bersih, laporan EDA singkat, split 70/15/15 tersimpan | Ahmad |
| PR #3 | Digabung ke `main` | Ahmad, Bisma |

Semua PR wajib lulus `flutter analyze` dan `flutter test` sebelum digabung.

---

## 4. Penghambat dan aksi

| Penghambat | Aksi | Penanggung | Batas |
|---|---|---|---|
| PR #3 belum direview | Review lalu gabung | Ahmad, Bisma | 28 Okt |
| Firebase belum ada | Buat proyek dan berkas konfigurasi lokal | Bisma | 28 Okt |
| Dataset belum diunduh | Unduh 3 zip dan taruh di `ml/data/raw/` | Ahmad | 29 Okt |
| Branch `feat/sqflite-setup` usang | Buat ulang dari `main` sebelum E2.1 | Pras | 27 Okt |
| `dev` perlu sinkron dengan `main` | Merge `main` ke `dev` | Bisma | 28 Okt |

---

## 5. Aturan

1. Maksimal 2 tugas aktif per orang.
2. Satu tugas = satu branch = satu PR; PR mengarah ke `main`.
3. `dev` hanya untuk uji integrasi, bukan tempat menyimpan hasil akhir.
4. Tugas yang prasyaratnya belum selesai tidak diambil.
5. Status di papan Notion diperbarui setiap hari; rekap diisi Minggu, 1 November.
