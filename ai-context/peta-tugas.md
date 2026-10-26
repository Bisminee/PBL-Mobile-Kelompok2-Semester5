# Peta Tugas dan PIC

Sumber kebenaran: `Pembagian Tugas/feature-breakdown-id.md` (rincian jobdesk),
`Pembagian Tugas/pembagian-tugas.md` (cara mengambil tugas),
`Pembagian Tugas/Epics/` (satu berkas per epic).

## 1. Epic dan status

| Epic | Nama | Estimasi | Status |
|---|---|---:|---|
| E1 | Fondasi aplikasi | 7 | Selesai |
| E2 | Penyimpanan dan data | 7 | Belum |
| E3 | Autentikasi dan cloud | 5 | Belum |
| E4 | Model 1 klasifikasi jenis pakaian | 8 | Pipeline siap, belum dilatih |
| E5 | Modul 2 ekstraksi warna | 5 | Belum |
| E6 | Model 3 skor kecocokan | 8,5 | Sebagian (E6.4 selesai) |
| E7 | Integrasi on-device | 9,5 | Belum |
| E8 | Penyelesaian fitur | 11,5 | Sebagian |
| E9 | QA dan pengujian | 11 | Sebagian |
| E10 | Dokumentasi | 11,5 | Berjalan |

## 2. Daftar jobdesk ringkas

### E2 Penyimpanan (7 ho)
E2.1 setup `sqflite` + `path_provider` (1) · E2.2 CRUD `wardrobe_items` (1,5) ·
E2.3 simpan foto, hanya path di DB (1) · E2.4 tabel `outfits` +
`recommendation_history` (1,5) · E2.5 muat data saat start (1) ·
E2.6 unit test DAO (1).

### E3 Autentikasi (5 ho)
E3.1 login Google (2) · E3.2 record cloud `users` + `profiles` (1) ·
E3.3 sesi persisten (1) · E3.4 sign out + hapus akun (1).

### E4 Model 1 (8 ho)
E4.1 unduh dataset + EDA + buang kelas ambigu (1) · E4.2 gabung kelas +
mapping + split 70/15/15 (1) · E4.3 baseline MobileNetV2 (1,5) ·
E4.4 latih YOLOv11n-cls + fine-tune (2,5) · E4.5 evaluasi, target akurasi
minimal 80 persen (1) · E4.6 ekspor TFLite int8 (1).

### E5 Modul 2 (5 ho)
E5.1 crop tengah + thresholding latar (1) · E5.2 K-Means k=3-5 di ruang
Lab/HSV dengan Dart (2) · E5.3 pemetaan palet 14 nama warna (1) ·
E5.4 unit test warna (1).

### E6 Model 3 (8,5 ho)
E6.1 dataset pasangan + negative sampling (2) · E6.2 feature builder (1) ·
E6.3 latih MLP + pembanding (2) · E6.4 aturan harmoni warna, **selesai** (1,5) ·
E6.5 evaluasi AUC + precision@3 (1) · E6.6 ekspor MLP TFLite (1).

### E7 Integrasi (9,5 ho)
E7.1 loader TFLite + isolate (1,5) · E7.2 inferensi Model 1 (2) ·
E7.3 ganti atribut placeholder (1,5) · E7.4 skor Model 3 di rekomendasi (1,5) ·
E7.5 fallback aturan (1) · E7.6 ukur latensi dan ukuran model (1).

### E8 Fitur aplikasi (11,5 ho)
E8.1 CRUD UI Lemari (2) · E8.2 simpan outfit (1,5) · E8.3 ranking +
explainability (1,5) · E8.4 konten Home (1,5) · E8.5 tab Detail (1,5) ·
E8.6 halaman Admin (2) · E8.7 halaman Profil (1,5).

### E9 QA (11 ho)
E9.1 rencana uji + minimal 20 test case (2) · E9.2 eksekusi fungsional (2) ·
E9.3 uji performa (1) · E9.4 uji kompatibilitas minimal 3 perangkat (1) ·
E9.5 konsolidasi evaluasi ML (1) · E9.6 usability + SUS, 10-20 responden (2) ·
E9.7 pelacakan bug + regression (2).

### E10 Dokumentasi (11,5 ho)
E10.1 logbook mingguan (3) · E10.2 150 foto lapangan (2) · E10.3 tabulasi
kuesioner (1,5) · E10.4 laporan milestone dan akhir (3) · E10.5 dokumentasi
fitur (2).

## 3. Aturan pengambilan tugas

1. Ambil tugas yang **prasyaratnya sudah selesai**; cek kolom prasyarat di
   `feature-breakdown-id.md`.
2. Maksimal **2 tugas aktif** per orang.
3. Satu tugas = satu branch = satu PR.
4. Tugas boleh ditukar, tetapi laporkan di grup agar tidak dobel.
5. Status di papan Notion diperbarui setiap hari.

## 4. Jobdesk minggu 5 (27 Oktober - 1 November 2026)

Prinsip: mobile dulu, ML menyusul. Rincian per tugas dan kriteria selesai ada di
`Pembagian Tugas/jobdesk-per-anggota.md`.

| Anggota | Tugas minggu 5 | ho |
|---|---|---:|
| Abim Mustawa | E2.1 setup DB, E2.2 CRUD, E2.3 simpan foto | 3,5 dari 7,0 |
| Bisma Adhiaksa | E3.1 login Google, E3.2 record cloud, E3.3 sesi | 4,0 dari 6,5 |
| Faatihurrizki Prasojo | E5.1 crop, E4.1 dataset + EDA, E5.2 mulai | 4,0 dari 7,0 |
| Izza Dhafira Fanani | E8.6 halaman Admin, E10.2 foto lapangan | 4,0 dari 6,0 |
| Ahmad Falahi | Review PR #3, E9.1 rencana uji 20 test case | 2,5 dari 6,0 |

Daftar kerja harian: `Pembagian Tugas/pembagian-tugas-minggu-5.md`.
Jadwal 10 minggu dan prioritas: `Pembagian Tugas/timeline.md`.

## 5. Definisi selesai

1. Berjalan di perangkat Android nyata lewat alur utama.
2. Test terkait lulus (unit, widget, atau metrik model).
3. Digabung lewat PR yang direview ke `main`.
4. Tercatat di `docs/features/` atau laporan ML.
