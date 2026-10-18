# E2 — Penyimpanan & Data

**Status:** ⬜ Belum

## 1. Apa yang harus dilakukan
- Menyiapkan **basis data lokal** di perangkat.
- Membuat **struktur tabel** untuk: item pakaian (Lemari), outfit tersimpan, dan
  riwayat rekomendasi.
- Membuat operasi **tambah, lihat, hapus** untuk item lemari.
- Menyimpan **foto pakaian** di penyimpanan aplikasi dan hanya mencatat
  lokasinya di basis data.
- **Memuat data otomatis** saat aplikasi dibuka.
- Menulis **unit test** untuk lapisan data.

## 2. Bagaimana melakukannya
- Tentukan skema tabel lebih dulu (kolom, tipe, indeks, relasi).
- Buat **helper basis data** yang menangani pembuatan dan pembaruan versi skema.
- Pisahkan **lapisan akses data** (repository) dari tampilan agar mudah diuji.
- Simpan foto sebagai berkas di folder aplikasi; basis data hanya menyimpan
  **jalur berkas**, bukan isi gambarnya.
- Hubungkan data ke tampilan lewat state provider agar perubahan langsung
  terlihat (tanpa memuat ulang manual).
- Uji skenario: simpan, tutup aplikasi, buka lagi, data masih ada.

## 3. Target yang harus dicapai
- Data lemari **tetap ada setelah aplikasi ditutup** dan dibuka kembali.
- Aplikasi tetap berfungsi **tanpa internet** untuk melihat lemari.
- Tidak ada penyimpanan gambar di dalam basis data (basis data tetap ringan).
- Operasi baca/tulis cepat dan tidak membebani waktu buka aplikasi.
- Unit test lapisan data lulus.

## 4. Ketergantungan
- **E1** (struktur aplikasi & state).
- Menjadi prasyarat untuk **E8** (fitur Lemari, Simpan Outfit).

## 5. Referensi
- Rancangan data: `../arsitektur-data.md`
- Struktur folder: `../struktur-folder.md`
