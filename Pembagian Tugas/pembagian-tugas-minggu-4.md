# Pembagian Tugas Minggu 4 — Sera-Z

Tim Sera-Z · Kelas TI-3D · Semester 5 · Tahun Akademik 2026/2027
Periode: **19–25 Oktober 2026** · Disusun 20 Oktober 2026
Estimasi dalam jam-orang (ho).

## 1. Fokus minggu ini

1. **Menyusul jalur kritis ML**: dataset → EDA → gabung kelas/split → baseline → latih model utama.
2. **Membuka jalur paralel aplikasi**: penyimpanan (E2), autentikasi (E3), modul warna (E5).
3. **Menutup PR #3** (pipeline Model 1) agar jalur ML tidak tertahan review.

Sasaran terukur akhir minggu:

| Sasaran | Ukuran selesai |
|---|---|
| E4.1 selesai | Dataset bersih + laporan EDA singkat |
| E4.2 selesai | Tabel mapping kelas + split 70/15/15 tersimpan |
| E4.3 selesai | Akurasi baseline MobileNetV2 tercatat |
| E4.4 berjalan | Checkpoint YOLOv11n-cls tersimpan |
| E5.2 selesai | Warna dominan benar pada minimal 8 dari 10 gambar sampel |
| E2.1–E2.3 selesai | Item lemari bertahan setelah restart |
| E3.1 selesai | Login Google berhasil di perangkat nyata |

## 2. Pembagian per anggota

### 2.1 Faatihurrizki Prasojo — 5,0 ho (jalur kritis ML + modul warna)

| ID | Tugas | ho | Prasyarat | Target hari | Status |
|---|---|---:|---|---|---|
| E4.1 | Unduh 3 dataset + EDA + buang kelas ambigu | 1,0 | — | Sen–Sel | Belum (menunggu unduhan) |
| E4.2 | Gabung kelas + mapping + split 70/15/15 | 1,0 | E4.1 | Rab–Kam | Belum |
| E5.1 | Crop tengah + thresholding latar | 1,0 | — | Sel–Rab | Bisa mulai sekarang |
| E5.2 | K-Means (k=3–5) Lab/HSV di Dart | 2,0 | E5.1 | Kam–Jum | Belum |

Catatan: E5.1–E5.2 **tidak bergantung dataset**, jadi tetap bisa jalan sambil menunggu unduhan. Rantai E4.1 → E4.2 → E4.3/E4.4 adalah jalur kritis proyek.

### 2.2 Abim Mustawa — 3,5 ho (penyimpanan lokal)

| ID | Tugas | ho | Prasyarat | Target hari | Status |
|---|---|---:|---|---|---|
| E2.1 | Setup `sqflite` + `path_provider`, helper DB & migrasi | 1,0 | — | Sen–Sel | Bisa mulai sekarang |
| E2.2 | CRUD `wardrobe_items` | 1,5 | E2.1 | Sel–Rab | Belum |
| E2.3 | Simpan foto ke folder dokumen (hanya path di DB) | 1,0 | E2.1 | Kam | Belum |

Lanjutan bila sempat: E2.4 (tabel `outfits` + riwayat). E2.5–E2.6 minggu depan.

### 2.3 Bisma Adhiaksa — 4,0 ho (autentikasi + koordinasi)

| ID | Tugas | ho | Prasyarat | Target hari | Status |
|---|---|---:|---|---|---|
| E3.1 | `google_sign_in` + Firebase Auth | 2,0 | — | Sen–Sel | Bisa mulai sekarang |
| E3.2 | Record cloud `users` + `profiles` | 1,0 | E3.1 | Rab | Belum |
| E3.3 | Sesi persisten (`flutter_secure_storage`) | 1,0 | E3.1 | Kam | Belum |

Tugas rutin (tidak dihitung ho): menagih review PR #3, memperbarui papan Notion, menyiapkan bahan logbook Minggu 4.

### 2.4 Ahmad Falahi — 4,0 ho (pelatihan Model 1, bergantung data)

| ID | Tugas | ho | Prasyarat | Target hari | Status |
|---|---|---:|---|---|---|
| E4.3 | Baseline MobileNetV2 | 1,5 | E4.2 | Kam | Menunggu E4.2 |
| E4.4 | Latih YOLOv11n-cls + fine-tune | 2,5 | E4.2 | Jum–Sab | Menunggu E4.2 |

Rencana cadangan: bila E4.1 belum selesai sampai Kamis, Ahmad membantu Faatihurrizki merapikan dataset (bukan mengambil E4.2) agar jalur kritis tidak menganggur. E4.5/E4.6 digeser ke awal minggu 5 bila E4.4 baru selesai Sabtu.

### 2.5 Izza Dhafira Fanani — 4,0 ho (UI + dokumentasi)

| ID | Tugas | ho | Prasyarat | Target hari | Status |
|---|---|---:|---|---|---|
| E8.1 | CRUD UI Lemari (tambah/hapus, filter, empty state) | 2,0 | E2.2 | Rab–Kam | Menunggu E2.2 |
| E8.6 | Halaman Admin: master data kategori warna & jenis | 2,0 | E2.1 | Jum–Sab | Menunggu E2.1 |

Tugas rutin: E10.1 logbook minggu 4 (0,5 ho, Minggu), menyiapkan tangkapan layar untuk laporan.

## 3. Jadwal harian ringkas

| Hari | Faatihurrizki | Abim | Ahmad | Bisma | Izza |
|---|---|---|---|---|---|
| Sen 19 | E4.1 unduh dataset | E2.1 | siapkan skrip latih | E3.1 | rancangan E8.1 |
| Sel 20 | E4.1 EDA + E5.1 | E2.1 → E2.2 | bantu E4.1 bila perlu | E3.1 | E8.1 |
| Rab 21 | E4.2 + E5.2 | E2.2 → E2.3 | tunggu E4.2 | E3.2 | E8.1 |
| Kam 22 | E5.2 | E2.3 | E4.3 | E3.3 | E8.1 → E8.6 |
| Jum 23 | E5.2 + uji sampel | E2.4 (lanjutan) | E4.4 | review PR #3 | E8.6 |
| Sab 24 | buffer + perbaikan | E2.6 (bila E2.4 jadi) | E4.4 | siapkan logbook | E8.6 |
| Min 25 | logbook + demo internal | — | — | rekap minggu | logbook |

## 4. Jalur kritis dan penghambat

1. **Dataset belum terunduh (E4.1)** — penghambat utama. Tiga zip Kaggle (Clothing Full, Fashion Product Images Small, Carousell) harus masuk ke `ml/data/raw/` sebelum EDA. Selama ini tertunda, E4.2–E4.6 dan seluruh E7 ikut bergeser.
2. **PR #3 menunggu reviewer** — minta satu anggota (Bisma atau Ahmad) mereview paling lambat Rabu.
3. **E7 belum bisa dimulai** — butuh E4.6 dan E6.6. Jangan diambil minggu ini.
4. **E8.1 dan E8.6 menunggu E2.2/E2.1** — Izza mulai setelah Abim menyelesaikan prasyaratnya, bukan sebelumnya.

## 5. Ringkasan beban minggu ini

| Anggota | ho | Tugas aktif | Peran utama |
|---|---:|---:|---|
| Faatihurrizki Prasojo | 5,0 | 2 | Data ML + modul warna |
| Ahmad Falahi | 4,0 | 2 | Pelatihan Model 1 |
| Bisma Adhiaksa | 4,0 | 2 | Autentikasi + koordinasi |
| Izza Dhafira Fanani | 4,0 (+0,5 rutin) | 2 | UI fitur + dokumentasi |
| Abim Mustawa | 3,5 | 2 | Penyimpanan lokal |
| **Total** | **20,5 (+0,5)** | | |

Selisih maksimal 1,5 ho. Aturan **maksimal 2 tugas aktif per orang** terpenuhi: tugas berikutnya baru diambil setelah tugas sebelumnya masuk PR.

## 6. Aturan kerja minggu ini

- Satu tugas = satu branch bernama fitur = satu PR. Jangan push langsung ke `main`.
- Status tugas diperbarui di papan Notion setiap hari (kolom Status: Belum / Berjalan / Selesai / Terhambat).
- Definisi selesai: berjalan di perangkat nyata, test terkait lulus, PR direview dan digabung ke `main`, tercatat di `docs/features/` atau laporan ML.
- Tugas boleh ditukar antar anggota, tetapi laporkan di grup agar tidak ada pekerjaan ganda.

## 7. Yang sengaja tidak dikerjakan minggu ini

E6.2–E6.6 (fitur + MLP Model 3), E7.1–E7.6 (integrasi on-device), E8.2–E8.5 dan E8.7, E9.2 ke atas, serta E10.2 ke atas. Semua dijadwalkan mulai minggu 5 agar minggu ini fokus menutup jalur kritis.
