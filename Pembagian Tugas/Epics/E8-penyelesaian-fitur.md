# E8 — Penyelesaian Fitur

**Status:** 🟡 Sebagian (UI sudah ada, logika & data nyata belum)

## 1. Apa yang harus dilakukan
- Melengkapi **Lemari Saya**: tambah, lihat, hapus, dan filter item.
- Menyediakan **Simpan Outfit** dan daftar outfit tersimpan.
- Menyediakan **Riwayat** hasil deteksi/rekomendasi.
- Menampilkan **ranking rekomendasi** beserta alasan kecocokan
  (explainability).
- Mengisi **Home** dengan data nyata: item terbaru, rekomendasi terbaru,
  jumlah item lemari.
- Melengkapi **Detail Outfit**: daftar item, harmoni warna, "kenapa cocok".
- Membuat **halaman Admin** untuk mengelola master data (nama warna, jenis
  pakaian, daftar gaya).
- Membuat **halaman Profil & Pengaturan** (nama, avatar, preferensi, keluar).
- Menyediakan **tampilan kondisi khusus**: kosong, sedang memuat, dan error.

## 2. Bagaimana melakukannya
- Ikuti desain layar yang sudah ada (UIUX) agar tampilan konsisten.
- Hubungkan setiap layar ke sumber data (penyimpanan lokal & state aplikasi),
  bukan data contoh.
- Tangani **kondisi kosong** dengan ajakan bertindak (mis. "Foto Pakaian").
- Berikan **umpan balik** setiap aksi (mis. notifikasi "Tersimpan ke Lemari").
- Untuk aksi berbahaya (hapus item/outfit/akun) gunakan **dialog konfirmasi**.
- Uji setiap layar dengan data nyata hasil dari kamera, bukan placeholder.

## 3. Target yang harus dicapai
- Semua layar **berfungsi dengan data nyata** — tidak ada lagi placeholder.
- Pengguna dapat mengelola lemari dan outfit tanpa keluar aplikasi.
- Rekomendasi menampilkan **skor dan alasan** yang dapat dipahami.
- Kondisi kosong/loading/error **tidak membuat aplikasi membeku atau bingung**.
- Alur utama tetap stabil setelah semua fitur ditambahkan.

## 4. Ketergantungan
- **E2** (Lemari & Simpan Outfit), **E3** (Profil), **E7** (ranking & hasil ML).
- Menjadi prasyarat untuk **E9** (pengujian) dan **E10.5** (dokumentasi fitur).

## 5. Referensi
- Wireframe & UX: `../wireframe-ux.md`
- Interaksi layar: `docs/wireframe-interactions.md`
