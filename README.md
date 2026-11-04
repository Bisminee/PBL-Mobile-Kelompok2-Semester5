# Sera-Z

Aplikasi mobile Flutter yang mengenali **jenis dan warna pakaian** dari foto,
lalu merekomendasikan kombinasi outfit yang serasi. Seluruh model berjalan
on-device dengan TensorFlow Lite, tanpa mengirim foto pengguna ke server.

Proyek ini dikerjakan sebagai tugas Project-Based Learning (PBL), Program Studi
Teknik Informatika, Jurusan Teknologi Informasi, Politeknik Negeri Malang,
Kelas TI-3D Semester 5, Tahun Akademik 2026/2027.

---

## 1. Latar belakang

Banyak orang kesulitan memadukan atasan dan bawahan, terutama saat warna dan
jenis pakaian terbatas. Sera-Z membantu dengan tiga langkah:

1. Mengenali **jenis pakaian** dari foto (Model 1).
2. Mengekstrak **warna dominan** pakaian (Modul 2).
3. Memberi **skor kecocokan** atasan dan bawahan, lalu menyusun rekomendasi outfit (Model 3).

## 2. Fitur utama

- Login dengan akun Google dan profil yang tersimpan di cloud.
- Lemari pakaian digital: tambah, lihat, filter, dan hapus item.
- Pemindaian foto pakaian dengan kamera, lengkap dengan pratinjau.
- Klasifikasi jenis pakaian di perangkat.
- Ekstraksi warna dominan dan palet warna.
- Rekomendasi outfit dengan skor dan alasan kecocokan.
- Simpan outfit dan lihat detail item.
- Data lemari tersimpan lokal di SQLite.
- Tampilan responsif untuk layar kecil dan lebar.

## 3. Teknologi

| Bagian | Teknologi |
|---|---|
| Aplikasi | Flutter, Dart |
| State management | Riverpod |
| Navigasi | go_router |
| Autentikasi dan cloud | Firebase Authentication, Cloud Firestore, Google Sign-In |
| Basis data lokal | SQLite melalui `sqflite` |
| Model on-device | `tflite_flutter` |
| Pengolahan citra | `camera`, `image` |
| Model 1 | YOLOv11n-cls, transfer learning ImageNet |
| Model 3 | MLP Keras dan aturan harmoni warna CIELCh |
| Pipeline ML | Python, Ultralytics, PyTorch, scikit-learn, TensorFlow |

## 4. Arsitektur aplikasi

```
lib/
  main.dart            Titik masuk aplikasi, inisialisasi Firebase dan model
  config/              Rute, tema, warna, ukuran, gaya teks, aset
  models/              Garment, Outfit, label pakaian
  screens/             Layar per alur: auth, home, scan, wardrobe, outfit, profile
  services/            Auth, database lokal, klasifikasi, ekstraksi warna, rekomendasi
  widgets/             Widget reusable per layar dan common
```

Alur utama:

```
Splash -> Onboarding -> Login Google -> Home
Home -> Kamera -> Pratinjau -> Analisis -> Hasil Deteksi -> Rekomendasi -> Detail
Home -> Lemari -> Detail Pakaian
Home -> Profil
```

## 5. Machine learning

| Komponen | Model | Hasil |
|---|---|---|
| Model 1 | YOLOv11n-cls, 9 kelas | Akurasi test 94,34 persen, macro F1 89,48 persen |
| Baseline | MobileNetV2 | Akurasi validasi 89,37 persen, macro F1 79,27 persen |
| Modul 2 | K-Means dan palet 14 warna | Berjalan di aplikasi |
| Model 3 | MLP dan aturan harmoni | Data latih masih sintetis, metrik AUC menyusul |

Dataset Model 1 memakai tiga sumber berlisensi bebas: Clothing Dataset Full
(CC0), Fashion Product Images Small (MIT), dan Clothes Dataset Carousell (MIT).
Total 33.667 gambar setelah deduplikasi, dibagi 70/15/15.

Rincian lengkap ada di `ml/README.md` dan `ml/reports/model1-card.md`.

## 6. Status proyek

Diperbarui: 3 November 2026.

| Area | Status |
|---|---|
| Fondasi aplikasi dan UI | Selesai |
| Autentikasi Firebase | Selesai |
| Model 1 dan evaluasi | Selesai, ekspor model sendiri masih tertunda |
| Penyimpanan SQLite | Selesai sebagian |
| Integrasi TFLite | Selesai sebagian |
| Fitur aplikasi | Selesai sebagian |
| QA dan dokumentasi | Berjalan |

Status terperinci ada di `ai-context/status-proyek.md` dan
`Pembagian Tugas/pembagian-tugas.md`.

## 7. Menjalankan proyek

Prasyarat: Flutter stable, Android Studio, dan perangkat atau emulator Android.

```bash
flutter pub get
flutter test
flutter run
```

Autentikasi memerlukan konfigurasi Firebase:

1. Buat proyek Firebase dan daftarkan aplikasi Android dengan package
   `com.example.sera_z`.
2. Unduh `google-services.json` dan letakkan di `android/app/`.
3. Daftarkan SHA-1 debug di Firebase Console.
4. Aktifkan Google Sign-In dan Cloud Firestore.

Berkas `google-services.json` tidak di-commit. Tanpa berkas itu, aplikasi masih
bisa dibuka, tetapi login Google tidak berfungsi.

Pipeline ML dijalankan dari folder `ml/` sesuai `ml/README.md`. Dataset dan
hasil latihan tidak disimpan di repositori.

## 8. Struktur repositori

| Folder | Isi |
|---|---|
| `lib/` | Kode aplikasi Flutter |
| `test/` | Unit test dan widget test |
| `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/` | Konfigurasi platform |
| `ml/` | Skrip pelatihan, label map, laporan, dan model card |
| `assets/` | Basis data awal dan aset model TFLite |
| `Pembagian Tugas/` | EPIC, jobdesk, timeline, logbook, panduan kerja |
| `ai-context/` | Konteks proyek untuk agen AI |

## 9. Dokumentasi

| Dokumen | Isi |
|---|---|
| `Pembagian Tugas/panduan-git-dan-branch.md` | Tutorial Git dan alur branch untuk anggota baru |
| `Pembagian Tugas/pembagian-tugas.md` | Daftar jobdesk dan ketergantungan |
| `Pembagian Tugas/pembagian-tugas-minggu-11.md` | Pembagian tugas minggu berjalan |
| `Pembagian Tugas/timeline.md` | Jadwal 10 minggu dan milestone |
| `Pembagian Tugas/Logbook/logbook.md` | Logbook mingguan |
| `ml/README.md` | Cara menjalankan pipeline ML |
| `ai-context/README.md` | Konteks proyek untuk agen AI |

## 10. Tim

| Nama | Peran |
|---|---|
| Bisma Adhiaksa | Project Manager dan QA |
| Abim Mustawa | Mobile Developer |
| Ahmad Falahi | ML Engineer |
| Faatihurrizki Prasojo | ML Engineer |
| Izza Dhafira Fanani | Sekretaris dan Dokumentator |

## 11. Lisensi data

Dataset yang dipakai berlisensi CC0 dan MIT, sehingga aman untuk keperluan
akademik. Kode proyek dibuat untuk kebutuhan tugas perkuliahan.
