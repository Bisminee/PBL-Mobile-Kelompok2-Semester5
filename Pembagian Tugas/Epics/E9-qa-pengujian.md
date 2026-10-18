# E9 — QA & Pengujian

**Status:** 🟡 Sebagian (baru 2 widget test dasar)

## 1. Apa yang harus dilakukan
- Menyusun **rencana pengujian** dan daftar **test case** (minimal 20),
  termasuk kasus negatif.
- Melakukan **pengujian fungsional** (black-box) pada seluruh fitur.
- Melakukan **pengujian performa** (waktu proses, memori, ukuran model).
- Melakukan **pengujian kompatibilitas** pada beberapa perangkat Android.
- Melakukan **pengujian usability** dengan responden dan kuesioner SUS,
  sekaligus meminta penilaian kecocokan rekomendasi.
- Mengumpulkan dan **mengelola bug** sampai tertutup, lalu menjalankan
  **regression** setelah perbaikan.
- Mengonsolidasikan **laporan evaluasi model** (Model 1, Modul 2, Model 3).

## 2. Bagaimana melakukannya
- Tulis skenario uji dari sudut pandang pengguna: langkah, hasil yang
  diharapkan, hasil nyata, status.
- Sertakan **kasus negatif**: foto buram, foto gelap, bukan pakaian, izin kamera
  ditolak, lemari kosong, dan koneksi terputus.
- Uji model pada **data uji terpisah** dan foto lapangan (bukan data latih).
- Ukur performa di **perangkat nyata**, jangan hanya di emulator.
- Catat setiap bug dengan langkah reproduksi, prioritas, dan status.
- Setelah bug diperbaiki, **ulangi** test case terkait (regression).
- Untuk usability: siapkan kuesioner SUS, kumpulkan 10–20 responden, dan
  rangkum skornya.

## 3. Target yang harus dicapai
- **Minimal 20 test case** dieksekusi dengan hasil terdokumentasi.
- Metrik model tercapai: akurasi ≥ 80% (Model 1), warna ≥ 80% (Modul 2),
  AUC ≥ 0,75 (Model 3).
- Performa memenuhi target (≤ 3 detik per foto, model ≤ 20 MB).
- Aplikasi berjalan pada **minimal 3 perangkat/versi Android** berbeda.
- Skor **SUS** dan penilaian kecocokan terdokumentasi (≥ 70% dinilai cocok).
- Semua bug berprioritas tinggi **tertutup** sebelum demo akhir.

## 4. Ketergantungan
- **E7** & **E8** (aplikasi & model siap diuji).
- Menjadi prasyarat untuk **E10.4** (laporan akhir).

## 5. Referensi
- Rencana uji di proposal (bagian QA).
- Metrik pengujian: `../referensi-metodologi.md`
