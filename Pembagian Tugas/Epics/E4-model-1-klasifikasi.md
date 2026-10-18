# E4 — Model 1: Klasifikasi Jenis Pakaian

**Status:** ⬜ Belum

## 1. Apa yang harus dilakukan
- Menyiapkan **dataset** gambar pakaian dan memeriksa kualitasnya.
- **Menyederhanakan kelas**: membuang kelas ambigu dan menggabungkan kelas
  sejenis menjadi sekitar 8–10 kelas yang jelas.
- Memetakan setiap kelas ke **kategori fungsional** (atasan, bawahan, luaran,
  terusan, alas kaki).
- Membagi data menjadi **latih, validasi, dan uji**.
- Melatih **model pembanding sederhana** sebagai patokan.
- Melatih **model utama** untuk mengenali jenis pakaian.
- **Mengevaluasi** performa model dengan ukuran yang jelas.
- **Menyiapkan model** agar dapat dijalankan di perangkat (ukuran ringan).

## 2. Bagaimana melakukannya
- Mulai dari eksplorasi data: lihat sebaran kelas, contoh gambar, dan label yang
  meragukan.
- Tentukan aturan penggabungan kelas dan tuliskan alasannya (agar dapat
  dipertanggungjawabkan).
- Terapkan **augmentasi** (variasi ringan) dan penanganan kelas yang jumlahnya
  sedikit agar model tidak berat sebelah.
- Latih model utama dengan pendekatan **transfer learning** dari model yang
  sudah terlatih, lalu sesuaikan pada dataset pakaian.
- Bandingkan hasil model utama dengan model pembanding.
- Evaluasi **bukan hanya akurasi**: gunakan F1 dan tabel kesalahan antar kelas.
- Uji ketahanan pada **foto lapangan** (pencahayaan dan latar berbeda).

## 3. Target yang harus dicapai
- Akurasi model **≥ 80%** pada data uji (target antara: ≥ 75%).
- **F1 ≥ 0,75** dan hasil per kelas dilaporkan lengkap.
- Model cukup **ringan** untuk dijalankan di perangkat Android kelas menengah.
- Model dapat mengenali minimal 8 kategori pakaian yang relevan.
- Ada perbandingan tertulis antara model utama dan model pembanding.
- Laporan evaluasi memuat tabel kesalahan (confusion matrix).

## 4. Ketergantungan
- Tidak ada untuk mulai (dataset bisa diunduh lebih dulu).
- Menjadi prasyarat untuk **E6** (kategori dipakai untuk menyusun fitur) dan
  **E7** (integrasi model ke aplikasi).

## 5. Referensi
- Dataset: `../dataset-clothing-full.md`
- Pemetaan paper: `../referensi-metodologi.md`
