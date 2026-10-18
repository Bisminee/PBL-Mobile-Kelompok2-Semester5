# E1 — Fondasi Aplikasi

**Status:** ✅ Selesai

## 1. Apa yang harus dilakukan
- Menyiapkan proyek Flutter (struktur folder, tema, konfigurasi).
- Membuat **navigasi antar layar** untuk seluruh alur aplikasi.
- Membangun **semua layar utama**: Login, Buat Akun, Home, Kamera, Lemari,
  Rekomendasi, Detail.
- Menyediakan **manajemen state** agar data mengalir antar layar.
- Menyediakan **fitur kamera**: pratinjau, ganti kamera depan/belakang, ambil foto.
- Menulis **uji dasar** (widget test) untuk memastikan aplikasi berjalan.

## 2. Bagaimana melakukannya
- Inisialisasi proyek dan tentukan konvensi struktur (config, models, screens,
  services, widgets).
- Tentukan **tema** (warna, tipografi, komponen) supaya konsisten.
- Rancang **peta navigasi** lebih dulu, lalu implementasi rute per layar.
- Buat **shell** dengan bottom navigation dan tombol tengah untuk kamera.
- Terapkan **manajemen state** untuk menyimpan data pengguna, isi lemari, dan
  hasil rekomendasi agar tidak hilang saat berpindah layar.
- Integrasikan **izin kamera** di Android/iOS.
- Jalankan pemeriksaan kualitas (analisis statis) dan uji widget.

## 3. Target yang harus dicapai
- Aplikasi **terpasang dan berjalan** di perangkat Android.
- **7 layar** dapat dibuka dan saling terhubung sesuai alur.
- Alur utama berjalan: Login → Home → Kamera → Rekomendasi → Detail.
- Tombol tengah (kamera) berfungsi dan menampilkan pratinjau nyata.
- Tidak ada error analisis statis; uji dasar lulus.
- Menjadi **fondasi** bagi epic lain (E2–E10) tanpa perlu merombak struktur.

## 4. Ketergantungan
- Tidak ada (epic pertama).

## 5. Referensi
- Desain layar: `../wireframe-ux.md`
- Wireframe Figma: `docs/wireframes/`
