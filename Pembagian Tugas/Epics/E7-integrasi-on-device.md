# E7 — Integrasi On-device

**Status:** ⬜ Belum

## 1. Apa yang harus dilakukan
- Menyiapkan **mesin inferensi di perangkat** yang dapat memuat model.
- Menjalankan **Model 1** pada gambar yang diambil pengguna.
- Mengganti **atribut placeholder** (jenis & warna) dengan hasil nyata dari
  Model 1 dan Modul 2.
- Menjalankan **skor Model 3** untuk mengurutkan rekomendasi.
- Menyediakan **mekanisme cadangan** bila model gagal dimuat, agar aplikasi
  tetap memberi rekomendasi.
- Mengukur **waktu proses dan ukuran model** pada perangkat nyata.
- Memastikan proses berat **tidak menghambat tampilan** aplikasi.

## 2. Bagaimana melakukannya
- Tetapkan **kontrak data** yang jelas antara model dan aplikasi (apa yang
  masuk, apa yang keluar, urutan label) agar tidak terjadi salah tafsir.
- Muat model sekali saja saat dibutuhkan, bukan berulang setiap layar dibuka.
- Jalankan proses analisis di **latar belakang**, tampilkan indikator progres di
  layar Analisis, lalu tampilkan hasil.
- Sambungkan hasil ke layar: Hasil Deteksi (jenis + warna) → Rekomendasi
  (daftar outfit + skor + alasan) → Detail.
- Uji **fallback**: matikan model, pastikan aplikasi tetap berjalan dengan
  aturan harmoni.
- Uji di perangkat nyata pada berbagai kondisi (foto terang, gelap, buram).

## 3. Target yang harus dicapai
- Waktu analisis **≤ 3 detik** per foto (target antara: ≤ 5 detik).
- Total ukuran model **≤ 20 MB**.
- Alur utama stabil: foto → analisis → hasil → rekomendasi → detail.
- Tidak ada tampilan yang tersendat saat analisis berjalan.
- Aplikasi tetap memberi rekomendasi meski model gagal dimuat.

## 4. Ketergantungan
- **E4** (Model 1 selesai), **E5** (warna), **E6** (Model 3 selesai).
- Menjadi prasyarat untuk **E8.3** (ranking & explainability).

## 5. Referensi
- Kontrak data & alur: `../implementation-plan.md`
- Interaksi antar model: bagian "How the Models Interact".
