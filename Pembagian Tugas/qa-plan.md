# Rencana Pengujian (QA Plan) — Sera-Z

Versi: 1.0
Tanggal: 6 November 2026
Disusun oleh: Bisma Adhiaksa

## 1. Ruang lingkup

Pengujian mencakup alur utama aplikasi Android: autentikasi, lemari, kamera dan
deteksi, rekomendasi, detail outfit, profil, serta halaman admin. Pengujian ML
(mis. akurasi model) dilakukan terpisah lewat laporan evaluasi di `ml/reports/`.

Di luar ruang lingkup: iOS, web, dan pengujian beban multi-pengguna.

## 2. Lingkungan pengujian

| Item | Keterangan |
|---|---|
| Perangkat | Minimal 3 perangkat Android berbeda versi |
| Sistem | Android 11, 13, dan 15 |
| Jaringan | Wi-Fi stabil, dan kondisi tanpa internet untuk uji offline |
| Data | Akun Google uji, minimal 5 item lemari, 1 foto non-pakaian |
| Alat | Perangkat fisik, `flutter test`, `flutter analyze` |
| Build | APK debug dari branch `dev` |

## 3. Kriteria lulus

1. Semua kasus prioritas tinggi lulus.
2. Tidak ada crash pada alur utama.
3. `flutter analyze` bersih dan seluruh test otomatis lulus.
4. Latensi inferensi di bawah 3 detik per foto.
5. Ukuran model di bawah 20 MB.

## 4. Kasus uji

### 4.1 Autentikasi

| ID | Skenario | Langkah | Hasil yang diharapkan | Jenis | Prioritas |
|---|---|---|---|---|---|
| TC-01 | Login Google berhasil | Buka aplikasi, tekan Masuk dengan Google, pilih akun | Masuk ke Home, nama dan email tampil | Positif | Tinggi |
| TC-02 | Login dibatalkan | Tekan Masuk dengan Google, tutup dialog akun | Tetap di layar Login, tidak ada error | Negatif | Sedang |
| TC-03 | Tanpa internet saat login | Matikan internet, tekan Masuk dengan Google | Muncul pesan tidak ada koneksi | Negatif | Tinggi |
| TC-04 | Sesi bertahan | Login, tutup paksa aplikasi, buka lagi | Langsung masuk ke Home | Positif | Tinggi |
| TC-05 | Logout | Buka Profil, tekan Logout | Kembali ke Login, rute privat tertutup | Positif | Tinggi |
| TC-06 | Hapus akun | Profil, Hapus Akun, konfirmasi | Akun dan data terhapus, kembali ke Login | Positif | Tinggi |
| TC-07 | Hapus akun dibatalkan | Tekan Hapus Akun, pilih Batal | Dialog tertutup, akun tetap ada | Negatif | Sedang |

### 4.2 Lemari

| ID | Skenario | Langkah | Hasil yang diharapkan | Jenis | Prioritas |
|---|---|---|---|---|---|
| TC-08 | Tambah item manual | Lemari, tombol tambah, isi data, simpan | Item muncul di daftar | Positif | Tinggi |
| TC-09 | Thumbnail tampil | Buka Lemari dan Home | Thumbnail foto tampil, placeholder bila kosong | Positif | Tinggi |
| TC-10 | Filter kategori | Pilih filter Atasan, Bawahan, Sepatu | Daftar menyesuaikan filter | Positif | Sedang |
| TC-11 | Hapus item | Geser atau tekan hapus pada item | Item hilang dari daftar | Positif | Tinggi |
| TC-12 | Data bertahan | Tambah item, tutup paksa, buka lagi | Item masih ada | Positif | Tinggi |
| TC-13 | Lemari kosong | Hapus semua item | Muncul empty state dan tombol tambah | Negatif | Sedang |

### 4.3 Kamera dan deteksi

| ID | Skenario | Langkah | Hasil yang diharapkan | Jenis | Prioritas |
|---|---|---|---|---|---|
| TC-14 | Izin kamera ditolak | Tolak izin saat pertama membuka kamera | Pesan jelas dan tombol buka pengaturan | Negatif | Tinggi |
| TC-15 | Ambil foto | Buka kamera, ambil foto | Pratinjau foto tampil | Positif | Tinggi |
| TC-16 | Ganti kamera | Tekan tombol ganti kamera | Pratinjau berpindah ke kamera lain | Positif | Sedang |
| TC-17 | Objek bukan pakaian | Foto wajah atau meja, lanjutkan analisis | Pesan "objek tidak dikenali sebagai pakaian" dan tombol ambil ulang | Negatif | Tinggi |
| TC-18 | Foto gelap | Foto dengan pencahayaan minim | Tetap dianalisis atau muncul saran ambil ulang | Negatif | Sedang |
| TC-19 | Model gagal dimuat | Jalankan dengan aset model tidak tersedia | Rekomendasi tetap muncul dari aturan harmoni | Negatif | Tinggi |

### 4.4 Rekomendasi dan detail

| ID | Skenario | Langkah | Hasil yang diharapkan | Jenis | Prioritas |
|---|---|---|---|---|---|
| TC-20 | Rekomendasi muncul | Setelah analisis, buka rekomendasi | Muncul daftar outfit dengan skor | Positif | Tinggi |
| TC-21 | Alasan tampil | Buka detail outfit | Alasan warna, formalitas, dan skor tampil | Positif | Tinggi |
| TC-22 | Simpan outfit | Tekan Simpan Outfit | Outfit masuk daftar tersimpan | Positif | Tinggi |
| TC-23 | Outfit tersimpan | Buka daftar outfit tersimpan | Outfit tampil setelah restart | Positif | Sedang |
| TC-24 | Riwayat rekomendasi | Buat rekomendasi baru, buka riwayat | Riwayat bertambah dan tersimpan | Positif | Sedang |
| TC-25 | Tab Detail | Buka tab Warna, Styling, Lemari | Data item tampil sesuai | Positif | Sedang |

### 4.5 Profil dan admin

| ID | Skenario | Langkah | Hasil yang diharapkan | Jenis | Prioritas |
|---|---|---|---|---|---|
| TC-26 | Profil sesuai Google | Login dengan dua akun berbeda | Nama, email, foto sesuai akun | Positif | Tinggi |
| TC-27 | Ubah preferensi | Ubah nama tampilan dan preferensi | Perubahan tersimpan | Positif | Sedang |
| TC-28 | Admin master data | Buka Admin, tambah, ubah, hapus kategori | Perubahan tersimpan dan tampil di Lemari | Positif | Tinggi |
| TC-29 | Admin tanpa hak | Buka rute admin sebagai pengguna biasa | Ditolak atau diarahkan | Negatif | Sedang |

### 4.6 Non-fungsional

| ID | Skenario | Langkah | Hasil yang diharapkan | Jenis | Prioritas |
|---|---|---|---|---|---|
| TC-30 | Latensi inferensi | Ukur waktu analisis 5 foto | Rata-rata di bawah 3 detik | Positif | Tinggi |
| TC-31 | Ukuran model | Periksa berkas `.tflite` dan APK | Model di bawah 20 MB | Positif | Sedang |
| TC-32 | Kompatibilitas | Jalankan alur utama di 3 perangkat | Tidak ada crash atau layout rusak | Positif | Tinggi |
| TC-33 | Orientasi layar | Putar perangkat di Home dan Detail | Layout menyesuaikan tanpa overflow | Positif | Sedang |
| TC-34 | Penyimpanan penuh | Isi penyimpanan hingga hampir penuh | Muncul pesan error yang jelas | Negatif | Rendah |

## 5. Jadwal eksekusi

| Tahap | Waktu | Penanggung |
|---|---|---|
| Uji fungsional black-box | 7 November 2026 | Ahmad |
| Uji perangkat dan regresi | 8 November 2026 | Bisma |
| Uji performa dan kompatibilitas | Minggu 8 | Bisma dan Abim |
| Usability dan SUS | Minggu 9 | Bisma |

## 6. Pelaporan bug

Setiap bug dicatat dengan format:

```
ID: BUG-xx
Kasus uji: TC-xx
Perangkat: <nama dan versi Android>
Langkah reproduksi:
1.
2.
Hasil aktual:
Hasil diharapkan:
Tingkat: kritis / tinggi / sedang / rendah
Bukti: tangkapan layar atau rekaman
```

Bug kritis dan tinggi harus diperbaiki sebelum demo. Bug sedang boleh ditunda
dengan catatan. Bug rendah masuk daftar perbaikan berikutnya.
