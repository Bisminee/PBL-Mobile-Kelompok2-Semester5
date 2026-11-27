# LAPORAN PROYEK PROJECT-BASED LEARNING (PBL), TAHAP MILESTONE 2

**Sera-Z: Aplikasi Rekomendasi Kombinasi Gaya Pakaian Berbasis Machine Learning**

Tim Sera-Z, Kelas TI-3D, Semester 5, Tahun Akademik 2026/2027

Bisma Adhiaksa, Abim Mustawa, Ahmad Falahi, Faatihurrizki Prasojo, Izza Dhafira Fanani

POLITEKNIK NEGERI MALANG

JURUSAN TEKNOLOGI INFORMASI

PROGRAM STUDI TEKNIK INFORMATIKA

November 2026

Diperbarui: 27 November 2026

> Catatan kerja: dokumen ini adalah draf Milestone 2. Bagian yang masih perlu
> dilengkapi ditandai dengan `[isi ...]`. Hapus catatan kerja sebelum ekspor PDF.

## Lembar Status Milestone 2

### S.1 Identitas, Dosen Pengampu, dan Dosen Rujukan

| Nama | NIM | Peran saat ini | Perubahan dari Milestone 1 |
|---|---|---|---|
| Bisma Adhiaksa | 244107020216 | Ketua Tim, QA, integrasi | Tidak ada |
| Abim Mustawa | 244107020078 | Pengembang mobile | Tidak ada |
| Ahmad Falahi | 244107020152 | ML Engineer | Tidak ada |
| Faatihurrizki Prasojo | 244107020142 | ML Engineer dan integrasi | Tidak ada |
| Izza Dhafira Fanani | 244107020106 | Sekretaris, dokumentator, penguji | Menambah pengujian otomatis |

| Mata kuliah | Dosen pengampu | Dosen rujukan kelas |
|---|---|---|
| Pemrograman Mobile | Agung Nugroho Pramudhita, S.T., M.T. | Dosen rujukan TI-3D |
| Pembelajaran Mesin | Vivi Nur Wijayaningrum, S.Kom., M.Kom. | Dosen rujukan TI-3D |
| Penjaminan Mutu Perangkat Lunak | Dika Rizky Yunianto, S.Kom., M.Kom. | Dosen rujukan TI-3D |

### S.2 Status Milestone 2

Status kami Sebagian. Alur utama aplikasi mobile sudah berjalan dari foto sampai rekomendasi: pengguna memilih foto, melakukan crop, model mengklasifikasikan jenis pakaian, warna diekstrak dan dapat dikoreksi, lalu lemari dan rekomendasi outfit menampilkan hasil. Model ML sudah dipanggil dari aplikasi dan ambang 70 persen dipakai untuk menolak hasil yang tidak meyakinkan. Aplikasi sudah dipasang pada perangkat Android dan 174 test otomatis lulus. Pemisahan data lokal, foto, preferensi, dan riwayat per akun sudah digabung lewat PR #62. Notebook remapping 16 warna ke 14 warna tabel ML sudah digabung lewat PR #63 sebagai acuan Izza. Logbook Minggu 9–12 sudah disusun, tetapi tangkapan layar akhir, video demo, tag `milestone-2`, dan bukti pengujian manual formal belum lengkap. Model 9 kelas belum dipasang sebagai aset aplikasi; aset yang dipakai masih 15 kelas. Rencana perbaikan ada di Bab 4.3 dan S.6.

### S.3 Tindak Lanjut Milestone 1

| Umpan balik atau temuan Milestone 1 | Dari | Tindak lanjut | Status |
|---|---|---|---|
| Ekspor TFLite model sendiri belum selesai | Pembelajaran Mesin | Model 9 kelas sudah dievaluasi, tetapi aset aplikasi masih 15 kelas | Belum selesai |
| Uji perangkat belum dilakukan | Penjaminan Mutu | APK debug dipasang dan diuji pada Samsung A32 | Sebagian |
| Rencana QA formal belum ada | Penjaminan Mutu | Test otomatis naik dari 39 menjadi 174; kasus uji manual disusun di Bab 4 | Sebagian |
| Model 3 masih memakai data sintetis | Pembelajaran Mesin | Tabel skor pasangan dipakai; MLP sintetis belum dipakai aplikasi | Belum selesai |
| Halaman Admin dan Detail belum selesai | Pemrograman Mobile | Detail pakaian dan detail outfit selesai; Admin masih PR #36 | Sebagian |
| Data pengguna belum terpisah per akun | Pemrograman Mobile | Data lokal, foto, preferensi, dan riwayat sudah dipisahkan per uid; uji A/B manual belum | Sebagian |
| Integrasi warna masih 14 palet | Pembelajaran Mesin | Acuan 16 keluarga warna dan koreksi warna pengguna sudah ditambahkan; pemetaan 16 ke 14 tersedia di notebook | Selesai |
| Klaim model 10 kelas belum valid | Pembelajaran Mesin | PR #32 ditahan; TFLite hanya benar 3 dari 270 foto | Ditolak sementara |

### Ringkasan Perubahan dari Milestone 1

| Area | Milestone 1 | Milestone 2 | Alasan perubahan |
|---|---|---|---|
| Rekomendasi outfit | Daftar pasangan atasan-bawahan global | Tiga outfit terbaik per atasan atau bawahan | Agar rekomendasi mudah dipakai per piece |
| Outfit tersimpan | Simpan dan daftar | Detail, edit nama/formalitas, hapus, menu tekan lama | Melengkapi pengelolaan outfit |
| Warna | 14 palet HSV | 16 keluarga warna, koreksi warna pengguna, warna asli tetap tampil | Mendekati kebutuhan harmoni dan validasi pengguna |
| Kamera | Ambil foto dan pratinjau | Crop tiga tombol, flash, hapus nama berkas, validasi area | Memperbaiki UX dan kualitas input |
| Ambang deteksi | Keyakinan tinggi hanya memberi peringatan | Di bawah 70 persen ditolak sebagai bukan pakaian | Mengurangi hasil yang menyesatkan |
| Lemari | Tambah, lihat, hapus | Edit atribut dan menu tekan lama | Melengkapi CRUD |
| Database | Versi 3, 14 warna | Versi 5, 16 warna dan data per `owner_uid` | Mendukung 16 warna dan akun terpisah |
| QA | 39 test | 174 test, analyze bersih, APK diuji | Meningkatkan bukti kualitas |
| Data pengguna | Satu ruang data lokal | Lemari, outfit, riwayat, preferensi, dan foto per uid | Mendukung lebih dari satu akun di perangkat yang sama |
| Model 1 | 9 kelas terlatih, aset 15 kelas | Belum berubah: aset masih 15 kelas | Ekspor dan validasi TFLite belum selesai |
| Model 3 | Data sintetis | Belum berubah | Data pasangan nyata belum tersedia |

### S.4 Capaian Produk

| Fitur | Status | Catatan |
|---|---|---|
| Login Google dan mode uji | Selesai | Firebase Auth dan Firestore |
| Data lokal per akun | Selesai implementasi | SQLite versi 5, folder foto per uid; uji A/B manual belum |
| Kamera, flash, dan pratinjau | Selesai | Termasuk tiga tombol simetris |
| Crop dan validasi area | Selesai | Kamera dan galeri |
| Klasifikasi jenis pakaian | Sebagian | Aset 15 kelas; model 9 kelas belum dipasang |
| Ekstraksi warna | Sebagian | HSV; K-Means Dart belum |
| Pemetaan 16 ke 14 warna | Selesai sebagai referensi | Notebook PR #63; integrasi aplikasi belum |
| Koreksi warna pengguna | Selesai | 16 warna acuan |
| Ambang bukan pakaian 70 persen | Selesai | Layar khusus jika di bawah ambang |
| Lemari dan edit atribut | Selesai | Tambah, lihat, edit, hapus, tekan lama |
| Rekomendasi per piece | Selesai | Maksimal tiga outfit per item |
| Simpan dan detail outfit | Selesai | Termasuk hapus dan edit nama/formalitas |
| Riwayat rekomendasi | Selesai | Tersimpan di SQLite |
| Admin Master Data | Belum | PR #36 masih konflik |
| Segmentasi pakaian | Belum | Masih wacana |
| Web | Belum | `tflite_flutter` dan `ffi` tidak mendukung web |

Daftar periksa target TI Semester 5:

- [x] Alur utama aplikasi mobile berjalan.
- [x] Model ML dapat dipanggil dari aplikasi.
- [x] Hasil awal model tertulis di Bab 4 dan Lampiran F.
- [x] Draf Bab 1–3 tersedia.
- [x] Bab 4 memuat minimal 10 kasus uji.
- [x] Logbook Minggu 9–12 tersusun.
- [ ] Lampiran akhir, tag `milestone-2`, dan video demo tersedia.

### S.5 Bukti

| Aspek | Pilihan tim | Tautan atau keterangan |
|---|---|---|
| Bentuk demo | Gabungan langsung dan video | Video maksimal 5 menit: [isi URL video] |
| Cara deploy | Berkas instalasi APK | `build/app/outputs/flutter-apk/app-arm64-v8a-debug.apk` |
| Repositori | Git dengan tag milestone-2 | https://github.com/Bisminee/PBL-Mobile-Kelompok2-Semester5 (`[isi tag]`) |
| Masukan pengguna | Calon pengguna internal | Bab 4.5 |
| Bukti pengujian | Uji manual dan uji otomatis | Bab 4 dan Lampiran B |

### S.6 Rencana Minggu 13–16

| Minggu | Target | Penanggung jawab |
|---|---|---|
| 13 | Audit 16 warna, harmoni CIELAB, dan QA; 170 test | Bisma, Izza |
| 14 | PR #62 data per akun dan PR #63 notebook remapping digabung; 174 test; PR #36/#51 masih konflik | Bisma, Izza, Pras |
| 15 | Ekspor dan pasang TFLite model 9 kelas; uji A/B akun; selesaikan Admin; uji 34 kasus | Ahmad, Bisma, Izza |
| 16 | Uji performa dan kompatibilitas; demo, video, tag, dan laporan akhir | Seluruh tim |

## Bab 1. Pendahuluan

### 1.1 Latar Belakang dan Rumusan Masalah

Memilih pakaian setiap hari membutuhkan waktu, terutama ketika pengguna hanya memiliki beberapa atasan, bawahan, dan warna yang terbatas. Keputusan sering dilakukan dengan mencoba beberapa kombinasi secara manual, tanpa panduan warna atau formalitas. Sera-Z menjawab masalah itu dengan memotret pakaian, mengenali jenisnya, mengekstrak warna dominan, lalu menyarankan outfit yang serasi dari lemari pengguna.

Rumusan masalah:

1. Bagaimana mengenali jenis pakaian dari foto secara on-device?
2. Bagaimana mengekstrak warna dominan dan memetakannya ke keluarga warna yang konsisten?
3. Bagaimana memberi skor dan alasan kecocokan antara atasan dan bawahan?
4. Bagaimana menyajikan rekomendasi yang mudah dipakai per item pakaian?
5. Bagaimana memastikan hasil berjalan pada perangkat Android tanpa mengirim foto ke server?

### 1.2 Tujuan

1. Membangun aplikasi mobile Flutter yang berjalan di Android.
2. Menjalankan klasifikasi jenis pakaian dengan TFLite secara on-device.
3. Mengekstrak warna dominan dan menyediakan 16 keluarga warna acuan.
4. Menyusun rekomendasi outfit dengan skor, harmoni, formalitas, dan alasan.
5. Menyediakan lemari digital, outfit tersimpan, riwayat, dan koreksi pengguna.
6. Menyediakan bukti pengujian otomatis dan manual sampai Minggu 12.

### 1.3 Cakupan Fitur dan Batasan

Cakupan:

1. Login Google dan mode uji tanpa Firebase.
2. Kamera, galeri, crop, pratinjau, dan flash.
3. Klasifikasi jenis pakaian dan ekstraksi warna.
4. Koreksi jenis, formalitas, dan warna oleh pengguna.
5. Lemari pakaian, edit atribut, dan tekan lama.
6. Rekomendasi tiga outfit per atasan atau bawahan.
7. Simpan outfit, detail, edit nama/formalitas, hapus, dan riwayat.
8. Ambang 70 persen untuk menolak hasil yang bukan pakaian.

Batasan:

1. Aset model aplikasi masih 15 kelas, bukan model latihan 9 kelas.
2. Model 10 kelas belum valid dan tidak dipasang.
3. K-Means belum diimplementasikan di Dart.
4. Segmentasi pakaian belum tersedia.
5. Model 3 masih memakai data sintetis dan tabel skor.
6. Rekomendasi baru mencakup atasan dan bawahan.
7. Web belum didukung karena dependensi TFLite dan FFI.
8. Admin Master Data belum selesai.

### 1.4 Pemangku Kepentingan dan Manfaat

| Pemangku kepentingan | Manfaat |
|---|---|
| Pengguna umum | Mendapat rekomendasi outfit dari pakaian sendiri |
| Mahasiswa | Memakai aplikasi untuk memilih pakaian harian |
| Tim pengembang | Memperoleh pengalaman ML on-device, Flutter, dan QA |
| Dosen | Memantau ketercapaian target Milestone 2 |
| Peneliti atau pengembang berikutnya | Mendapat dokumentasi dataset, model, dan batasan |

### 1.5 Kriteria Keberhasilan

1. Alur utama foto sampai rekomendasi berjalan di Android.
2. Model TFLite dapat dimuat dan menghasilkan prediksi.
3. Hasil di bawah 70 persen ditolak dengan pesan yang jelas.
4. Pengguna dapat mengoreksi warna dan atribut pakaian.
5. Setiap item atasan atau bawahan mendapat maksimal tiga outfit.
6. Minimal 10 kasus uji alur utama tersedia.
7. `flutter analyze` bersih dan seluruh test otomatis lulus.
8. APK dapat dipasang pada perangkat Android nyata.

## Bab 2. Analisis Kebutuhan dan Perancangan

### 2.1 Kebutuhan Pengguna dan Daftar Fitur

| Pengguna | Kebutuhan | Fitur |
|---|---|---|
| Pengguna | Masuk dengan akun | Login Google, mode uji |
| Pengguna | Menambahkan pakaian | Kamera, galeri, crop |
| Pengguna | Memeriksa hasil | Hasil deteksi, warna, komposisi |
| Pengguna | Mengoreksi hasil | Pilih jenis, formalitas, warna |
| Pengguna | Mengelola lemari | Lihat, edit, hapus, tekan lama |
| Pengguna | Mendapat ide outfit | Tiga rekomendasi per piece |
| Pengguna | Menyimpan pilihan | Simpan outfit, detail, riwayat |
| Pengguna | Mengelola outfit | Edit nama/formalitas, hapus |

Kebutuhan non-fungsional:

1. Foto diproses on-device.
2. UI responsif pada layar kecil dan lebar.
3. Data pengguna tersimpan di SQLite.
4. Aplikasi tetap dapat dibuka ketika Firebase belum dikonfigurasi.
5. Kesalahan model ditampilkan dengan bahasa yang jelas.

### 2.2 Susunan Komponen Sistem

| Komponen | Teknologi | Fungsi |
|---|---|---|
| Antarmuka | Flutter, Material 3 | Layar dan navigasi |
| State | Riverpod | Sesi scan, lemari, rekomendasi |
| Navigasi | go_router | Rute aplikasi |
| Autentikasi | Firebase Auth, Firestore | Login dan profil |
| Database lokal | SQLite via sqflite | Lemari, outfit, riwayat, referensi |
| Model on-device | tflite_flutter | Klasifikasi jenis pakaian |
| Pengolahan gambar | package image, camera, image_picker | Crop, resize, decode |
| Rekomendasi | Aturan harmoni CIELCh, tabel skor | Skor dan alasan outfit |

### 2.3 Rancangan Basis Data

Database lokal `fashion_app.db` memakai SQLite. Tabel utama:

| Tabel | Isi | Kunci atau batasan |
|---|---|---|
| `wardrobe_item` | Pakaian pengguna | id, owner_uid, garment_type, slot, color_family, color_hex |
| `outfit` | Outfit tersimpan | id, owner_uid, name, target_formality, match_score |
| `outfit_item` | Relasi outfit ke pakaian | outfit_id, wardrobe_item_id |
| `recommendation_history` | Riwayat rekomendasi | owner_uid, top_item_id, bottom_item_id, unique pair |
| `app_preference` | Preferensi lokal | owner_uid, key, value |
| `ref_color` | Warna acuan | color_family, hex |
| `ref_garment_type` | Jenis pakaian | garment_type, slot, detectable |
| `catalog_item` | Katalog untuk saran slot | garment_type, color_family, slot |
| `ml_formality` | Prediksi formalitas | jenis, warna, gender, age |
| `ml_style` | Prediksi style | jenis, warna, gender, age |
| `ml_pair_score` | Skor pasangan | type_a, color_a, type_b, color_b |

Versi database 5 menambahkan `owner_uid` ke `wardrobe_item`, `outfit`, dan `recommendation_history`, serta memisahkan preferensi per akun. Versi 4 sebelumnya menambahkan `cream`, `maroon`, `olive`, `teal`, dan `navy` ke `ref_color`. Migrasi dijalankan lewat `onUpgrade` tanpa menghapus data pengguna. Foto disimpan di folder aplikasi per uid, bukan di galeri umum.

Normalisasi:

1. `wardrobe_item` menyimpan satu item per baris dan satu pemilik.
2. `outfit_item` memisahkan relasi banyak-ke-banyak.
3. `recommendation_history` memakai pasangan unik agar tidak menggandakan riwayat.
4. `app_preference` memakai pasangan `(owner_uid, key)`.
5. `ref_color` dan `ref_garment_type` menjadi tabel referensi.

### 2.4 Rancangan Model ML

| Komponen | Rancangan | Status |
|---|---|---|
| Model 1 | YOLOv11n-cls, input 224 x 224, 9 kelas target | Terlatih; aset aplikasi 15 kelas |
| Modul warna | HSV area tengah, 16 keluarga acuan | Berjalan; K-Means Dart belum; pemetaan 16 ke 14 tersedia di notebook |
| Model 3 | Tabel skor pasangan dan aturan harmoni | Berjalan; MLP sintetis belum dipakai |
| Penolakan non-pakaian | Ambang confidence 70 persen | Berjalan |
| Segmentasi | Belum | Wacana |

Model 1 memakai 9 kelas: `dress`, `long_pants`, `long_sleeve`, `outerwear`, `shirt`, `shoes`, `shorts`, `skirt`, `tshirt`. Evaluasi test: akurasi 94,34 persen dan macro F1 89,48 persen. Rincian ada di Lampiran F.

### 2.5 Rancangan Antarmuka

| Layar | Fungsi |
|---|---|
| Splash dan onboarding | Pembuka aplikasi |
| Login dan sign up | Autentikasi |
| Home | Ringkasan lemari dan rekomendasi |
| Kamera | Ambil foto, flash, galeri |
| Pratinjau | Lihat foto, crop, gunakan foto |
| Analyzing | Proses model |
| Hasil deteksi | Jenis, warna, komposisi, koreksi |
| Rekomendasi | Tiga outfit per piece |
| Detail outfit | Warna, styling, lemari |
| Lemari | Daftar, pencarian, filter, tekan lama |
| Detail pakaian | Atribut dan edit |
| Profil | Akun dan pengaturan |

### 2.6 Rancangan Laporan atau Dasbor

Sera-Z tidak memiliki dasbor admin pada Milestone 2. Halaman Admin Master Data masih berada di PR #36 dan belum menjadi bagian alur utama.

## Bab 3. Implementasi

### 3.1 Teknologi yang Dipakai

| Teknologi | Versi atau konfigurasi | Fungsi |
|---|---|---|
| Flutter | Stable | Aplikasi mobile |
| Dart | ^3.12.2 | Bahasa aplikasi |
| Riverpod | 2.6.1 | State management |
| go_router | 17.5.0 | Navigasi |
| sqflite | ^2.4.1 | SQLite |
| tflite_flutter | ^0.12.1 | Inferensi on-device |
| image | ^4.5.4 | Decode, resize, crop |
| camera | ^0.12.1 | Kamera |
| image_picker | ^1.2.4 | Galeri |
| Firebase Auth/Firestore | Versi proyek | Autentikasi dan profil |
| Python, PyTorch, Ultralytics | 3.11, 2.14.1, 8.4.190 | Pipeline dan pelatihan ML |

### 3.2 Cara Membuat Tiap Fitur

#### 3.2.1 Autentikasi

Login Google memakai Firebase Auth. Profil pengguna disimpan di Firestore. Mode uji disediakan untuk pengembangan ketika Firebase belum dikonfigurasi. Logout dan hapus akun tersedia di Profil.

#### 3.2.2 Kamera, Pratinjau, dan Crop

Kamera memakai `camera`. Flash memiliki mode off, auto, dan on. Setelah foto diambil, pengguna masuk ke pratinjau dengan tiga tombol simetris:

```text
[ Ambil Ulang ] [ Sesuaikan ] [ Gunakan Foto ]
```

Crop memakai `crop_your_image`. Foto kamera dan galeri sama-sama dapat disesuaikan. Nama berkas tidak ditampilkan.

#### 3.2.3 Analisis dan Hasil Deteksi

`OutfitEngine.analyze` menjalankan preprocessing gambar dan ekstraksi warna. `GarmentClassifier` menghasilkan top-3 prediksi. `LocalDb` mengambil formalitas dan style. `Detection` menyimpan jenis, slot, warna, confidence, alternatif, style, dan komposisi warna.

Ambang 70 persen:

```dart
const double recognizedThreshold = 0.70;

bool get isRecognized => manual || confidence >= recognizedThreshold;
```

Jika `isRecognized` false, layar hasil menampilkan “Pakaian tidak terdeteksi” dan tombol ambil foto lagi.

#### 3.2.4 Warna

Warna dari gambar tetap ditampilkan setelah pengguna memilih warna lain. Pengguna dapat memilih 16 keluarga warna. Komposisi warna asli tidak dihapus. `ref_color` pada database pengguna memuat 16 warna setelah migrasi.

#### 3.2.5 Lemari dan Edit Atribut

Lemari memuat item dari `wardrobe_item`. Pengguna dapat mencari, memfilter, menekan lama, melihat detail, mengedit, dan menghapus. Edit mencakup jenis, warna, formalitas, dan style. Tombol pensil di detail pakaian membuka form yang sama.

#### 3.2.6 Rekomendasi Per Piece

`recommendationGroupsProvider` membentuk maksimal tiga outfit untuk setiap atasan atau bawahan. Outfit yang sudah tersimpan disaring dari daftar. Halaman rekomendasi dapat difokuskan pada satu pakaian dari detail pakaian.

#### 3.2.7 Outfit Tersimpan

Kartu outfit tersimpan dapat diketuk untuk membuka detail. Menu tekan lama berisi Lihat detail, Edit, dan Hapus. Edit mengubah nama dan formalitas. Hapus hanya menghapus outfit, bukan pakaian.

#### 3.2.8 Riwayat

Detail outfit mencatat riwayat rekomendasi ke `recommendation_history`. Pasangan yang sama tidak digandakan. Riwayat ditampilkan terbaru lebih dulu.

### 3.3 Basis Data

Database naik ke versi 5. Versi 4 menambahkan warna baru ke `ref_color`; versi 5 menambahkan `owner_uid` dan memisahkan preferensi per akun. Contoh:

```sql
INSERT OR IGNORE INTO ref_color (color_family, hex)
VALUES ('cream', '#F2E3C6');
```

Data pengguna tidak dihapus. Tabel referensi ML tetap 14 warna; warna pengguna 16 keluarga dipetakan ke 14 warna saat mencari skor. Foto pengguna disimpan di folder aplikasi per uid.

### 3.4 Model dan Cara Memasangnya ke Aplikasi

1. Model disimpan di `assets/models/yolo11n_cls.tflite`.
2. Label disimpan di `assets/models/labels.txt`.
3. `GarmentClassifier` memuat model dengan `Interpreter.fromAsset`.
4. Input disusun NCHW `[1, 3, 224, 224]`, nilai 0..1.
5. Output diambil top-3.
6. Model latihan 9 kelas belum diekspor dan dipasang sebagai aset final.
7. Model 10 kelas di PR #32 belum valid.
8. Model 3 memakai tabel `ml_pair_score`, bukan inferensi MLP.
9. Notebook remapping 16 ke 14 warna tersedia di `ml/notebooks/remapping_warna_sera_z.ipynb`; integrasi ke aplikasi belum.

### 3.5 Penyambungan dan Deploy

APK debug arm64 dibangun dan dipasang pada perangkat Samsung A32, Android 13. Web belum didukung karena `tflite_flutter` dan `ffi` tidak dapat dikompilasi ke web. Tag `milestone-2` belum dibuat. APK terbaru memakai 174 test otomatis dan sudah memuat perbaikan pemisahan data per akun dari PR #62.

## Bab 4. Pengujian dan Evaluasi

### 4.1 Rencana Pengujian

Jenis pengujian:

1. Unit test logika warna, label, rekomendasi, dan database.
2. Widget test kamera, edit atribut, kartu outfit, dan detail.
3. Uji perangkat untuk kamera, tekan lama, detail outfit, dan edit.
4. Uji ambang 70 persen melalui unit test dan rencana uji foto.
5. Uji manual alur utama minimal 10 kasus.
6. Uji akun A/B untuk memastikan data, foto, dan preferensi tidak tercampur.

Alat dan perangkat:

1. Flutter test dan `flutter analyze`.
2. Perangkat Samsung SM-A325F, Android 13.
3. APK debug arm64.
4. SQLite salinan aset untuk pengujian DAO.

### 4.2 Kasus Uji dan Hasil

| ID | Skenario | Hasil yang diharapkan | Hasil aktual | Status |
|---|---|---|---|---|
| TC-01 | Login mode uji | Masuk ke Home | Widget test lulus | Lulus otomatis |
| TC-02 | Home dan lemari | Data lemari tampil | 17 item tampil di perangkat | Lulus |
| TC-03 | Ambil foto kamera | Pratinjau terbuka | Pratinjau tampil | Lulus |
| TC-04 | Tiga tombol pratinjau | Tidak overflow; tombol terbaca | Test 320 px lulus; perlu uji ulang perangkat | Sebagian |
| TC-05 | Crop foto | Area tersimpan | Crop kamera dan galeri tersedia | Perlu uji manual |
| TC-06 | Hasil di bawah 70 persen | Layar tidak terdeteksi | Unit test ambang lulus | Lulus otomatis |
| TC-07 | Pilih warna manual | Warna berubah, warna gambar tetap | Kode dan UI tersedia | Perlu uji manual |
| TC-08 | Simpan ke lemari | Item masuk lemari | Item tersimpan di SQLite | Lulus |
| TC-09 | Edit atribut | Perubahan tersimpan | Unit test DAO dan widget test lulus | Lulus otomatis |
| TC-10 | Rekomendasi per piece | Maksimal tiga outfit per item | Unit test lulus | Lulus otomatis |
| TC-11 | Simpan outfit | Masuk tersimpan dan hilang dari rekomendasi | Unit test dan widget test lulus | Lulus otomatis |
| TC-12 | Detail outfit tersimpan | Detail terbuka | Berhasil di perangkat | Lulus |
| TC-13 | Tekan lama pakaian/outfit | Menu Lihat, Edit, Hapus | Berhasil di perangkat untuk outfit; pakaian diuji widget | Lulus |
| TC-14 | Flash kamera | Mode berubah | Widget test lulus | Lulus otomatis |
| TC-15 | Akun A/B | Data, foto, dan preferensi tidak tercampur | Implementasi dan migrasi perangkat sudah; uji A/B formal belum | Perlu uji manual |

Keterlacakan kebutuhan ke kasus uji:

| Kebutuhan | Kasus uji |
|---|---|
| Login | TC-01 |
| Kamera dan crop | TC-03, TC-04, TC-05 |
| Klasifikasi dan ambang | TC-06 |
| Warna | TC-07 |
| Lemari | TC-02, TC-08, TC-09 |
| Rekomendasi | TC-10, TC-11 |
| Outfit tersimpan | TC-12, TC-13 |
| Flash | TC-14 |
| Data per akun | TC-15 |

### 4.3 Bug yang Ditemukan

| ID | Bug | Tingkat | Status | Rencana |
|---|---|---|---|---|
| BUG-01 | Aset aplikasi masih 15 kelas | Tinggi | Terbuka | Ekspor dan pasang model 9 kelas |
| BUG-02 | TFLite 10 kelas tidak valid, 3 dari 270 benar | Tinggi | Terbuka | Tahan PR #32; validasi preprocessing |
| BUG-03 | K-Means belum ada di Dart | Sedang | Terbuka | Implementasi setelah Milestone 2 |
| BUG-04 | Web tidak dapat dikompilasi | Sedang | Diketahui | Conditional import atau stub web |
| BUG-05 | APK debug besar dan penyimpanan perangkat penuh | Rendah | Selesai | Pakai split ABI arm64 |
| BUG-06 | Tombol pratinjau overflow dan tidak terlihat | Sedang | Selesai | Padding, FittedBox, border putih |
| BUG-07 | Tekan lama dan detail outfit tidak berjalan di APK lama | Tinggi | Selesai | Install ulang non-streaming |
| BUG-08 | Warna deteksi hilang setelah koreksi | Sedang | Selesai | Komposisi asli dipertahankan |
| BUG-09 | PR Admin masih konflik | Sedang | Terbuka | Rebase PR #36 |
| BUG-10 | Pemetaan 16 ke 14 warna belum masuk aplikasi | Sedang | Terbuka | Integrasikan notebook PR #63 lewat M6.6 |

### 4.4 Hasil Awal Model

| Model | Metrik | Nilai |
|---|---|---|
| Model 1 9 kelas | Akurasi test | 94,34 persen |
| Model 1 9 kelas | Macro F1 | 89,48 persen |
| Model 1 9 kelas | Macro precision | 89,3 persen |
| Model 1 9 kelas | Macro recall | 89,9 persen |
| Aset aplikasi 15 kelas | Akurasi 270 foto | 65,6 persen |
| Model 10 kelas | Uji TFLite aplikasi | 3 dari 270 benar |
| Model 3 | AUC MLP sintetis | 0,976 |
| Model 3 | P@3 MLP sintetis | 0,455 |

### 4.5 Masukan Pengguna

Pengujian internal menemukan:

1. Pratinjau kamera overflow dan tombol Ambil Ulang tidak terlihat.
2. Tekan lama pakaian dan outfit tidak berfungsi pada APK lama.
3. Detail outfit tersimpan tidak muncul.
4. Warna hasil deteksi hilang setelah pengguna memilih warna.
5. Hasil dengan kemiripan rendah masih dianggap pakaian.

Tindak lanjut:

1. Padding tombol diperkecil dan label memakai `FittedBox`.
2. APK dipasang ulang dengan mode non-streaming.
3. Detail outfit tersimpan ditambahkan.
4. Komposisi warna asli dipertahankan.
5. Ambang 70 persen dan layar penolakan ditambahkan.

### 4.6 Ketercapaian Kriteria Keberhasilan

Ditulis pada laporan akhir.

## Bab 5. Pengelolaan Proyek dan Penutup

### 5.1 Rencana dan Realisasi

| Tugas | Penanggung jawab | Rencana | Realisasi sampai Minggu 14 |
|---|---|---|---|
| Fondasi aplikasi dan autentikasi | Bisma, Abim | Minggu 1–3 | Selesai |
| Model 1 dan evaluasi | Ahmad, Bisma | Minggu 3–6 | Model 9 kelas selesai; aset belum |
| Integrasi TFLite dan SQLite | Faatihurrizki | Minggu 6–7 | Selesai |
| Kamera, crop, dan pratinjau | Abim, Bisma | Minggu 7–9 | Selesai |
| 16 warna dan koreksi warna | Bisma, Izza | Minggu 9–10 | Selesai |
| Lemari, edit atribut, tekan lama | Bisma, Abim | Minggu 10–11 | Selesai |
| Rekomendasi per piece | Bisma, Faatihurrizki | Minggu 10–11 | Selesai |
| Outfit tersimpan dan detail | Bisma | Minggu 11 | Selesai |
| Data lokal per akun dan foto per uid | Bisma | Minggu 13–14 | Selesai implementasi; uji A/B belum |
| QA dan dokumentasi | Bisma, Izza | Minggu 11–14 | 174 test; dokumen sebagian |
| Admin Master Data | Izza | Minggu 10–14 | Belum, PR #36 konflik |
| Model 3 data nyata | Ahmad, Faatihurrizki | Minggu 9–12 | Belum |

### 5.2 Kontribusi Anggota

| Nama | Tugas selesai | Bukti | Estimasi kontribusi | Bagian demo |
|---|---|---|---|---|
| Bisma Adhiaksa | Integrasi, rekomendasi, QA, dokumen, perbaikan UX, data per akun | Commit, PR #59, #61, #62, #63 | 30 persen | Alur utama dan rekomendasi |
| Abim Mustawa | UI mobile, kamera, layout, profil | Commit dan PR terkait | 17 persen | Kamera dan profil |
| Ahmad Falahi | Pipeline ML, evaluasi Model 1 | Commit ML dan laporan | 17 persen | Model 1 |
| Faatihurrizki Prasojo | Integrasi SQLite/TFLite, mesin outfit | PR #13 | 24 persen | Inferensi dan lemari |
| Izza Dhafira Fanani | Logbook, laporan, unit test warna | PR #52, #53, #55 | 12 persen | Pengujian |

Estimasi ini perlu dicocokkan dengan hasil Penilaian 360.

### 5.3 Perubahan, Risiko, dan Permintaan Tambahan

Perubahan dari Milestone 1:

| Perubahan | Alasan | Konsultasi |
|---|---|---|
| Rekomendasi menjadi tiga outfit per piece | Lebih mudah dipakai per item | Internal tim |
| Detail, edit, dan hapus outfit tersimpan | Melengkapi pengelolaan | Internal tim |
| Warna menjadi 16 keluarga dan dapat dikoreksi | Validasi pengguna dan harmoni | Arahan 16 warna |
| Ambang 70 persen | Mengurangi hasil bukan pakaian | Internal tim |
| Kamera tiga tombol dan flash | Perbaikan UX | Umpan balik pengujian |
| Database versi 5 | Mendukung 16 warna dan data per akun | Internal tim |
| Data lokal per akun | Privasi dan pemakaian beberapa akun | PR #62 |
| Admin ditunda | Konflik dan prioritas alur utama | Akan dikonsultasikan |

Risiko:

| Risiko | Tingkat | Tindakan |
|---|---|---|
| Model 9 kelas belum menjadi aset aplikasi | Tinggi | Ekspor dan validasi Minggu 15 |
| Tabel ML masih 14 warna | Tinggi | Pemetaan 16 ke 14 lewat notebook PR #63; integrasi aplikasi belum |
| Uji A/B akun belum formal | Tinggi | Jalankan skenario akun A/B di perangkat |
| Model 3 sintetis | Tinggi | Cari data pasangan nyata atau nyatakan batasan |
| QA dan logbook belum lengkap | Sedang | Lengkapi Minggu 13–15 |
| Latensi dan ukuran APK | Sedang | Ukur dan optimalkan |
| Admin belum selesai | Sedang | Rebase PR #36 |

Permintaan tambahan dari dosen: [isi bila ada; jika tidak, tulis "Tidak ada permintaan tambahan"].

### 5.4 Kesimpulan

Ditulis pada laporan akhir.

### 5.5 Pelajaran dan Saran

Ditulis pada laporan akhir.

## Lampiran A. Tangkapan Layar

[Isi tangkapan layar: Home, Kamera, Pratinjau, Hasil Deteksi, Pakaian Tidak Terdeteksi, Lemari, Detail Pakaian, Rekomendasi, Detail Outfit, Outfit Tersimpan.]

## Lampiran B. Logbook Minggu 1–12

Logbook Minggu 1–8 tersedia di `Pembagian Tugas/Logbook/logbook.md`. Logbook Minggu 9–12 tersedia di `Pembagian Tugas/Logbook/logbook-minggu-9-12.md` dan diringkas di bawah.

| Minggu | Pekerjaan selesai | Dikerjakan oleh | Kendala | Rencana berikutnya |
|---|---|---|---|---|
| 9 (10–16 Nov) | Audit 16 warna, harmoni CIELAB/CIELCh, review PR #51/#52/#53/#36, QC PR #54/#56, 122 test | Bisma, Izza | Palet tampilan dan tabel ML masih 14 warna | Revisi mobile |
| 10 (17–23 Nov) | Tiga tombol pratinjau, flash, crop kamera/galeri, 16 warna dan koreksi, edit atribut, tekan lama, rekomendasi per piece, detail outfit, ambang 70 persen, 170 test, APK perangkat | Bisma, Abim, Izza | APK lama tidak ter-update; penyimpanan HP penuh | Finalisasi model |
| 11 (24–30 Nov) | Ekspor TFLite 9 kelas, uji manual 14 kasus, tangkapan layar, video, tag `milestone-2`, lengkapi Lampiran B/F/E, rebase PR #36 | Ahmad, Bisma, Izza | Label dan preprocessing harus sama; tautan harus publik | Demo |
| 12 (1–7 Des) | Demo Day, perbaikan umpan balik, Bab 4.6/5.4/5.5, ekspor PDF dan unggah | Seluruh tim | Prioritas bug dan waktu | Selesai |

Catatan: status per 27 November 2026. Minggu 11 dan 12 masih berisi rencana; hasil aktual perlu diperbarui setelah pelaksanaan.

## Lampiran C. Dokumen Rujukan

| No | Dokumen | Versi | Pemilik | Bagian yang merujuk |
|---|---|---|---|---|
| 1 | Proposal PBL Sera-Z | 1.0 | Tim | Bab 1–2 |
| 2 | SRS dan daftar kebutuhan | 1.0 | Tim | Bab 2.1 |
| 3 | Wireframe dan desain UI | 1.0 | Tim | Bab 2.5 |
| 4 | Rancangan basis data dan migrasi | 4.0 | Tim | Bab 2.3, 3.3 |
| 5 | Rencana dan kasus uji | 1.0 | Tim | Bab 4 |
| 6 | Dokumentasi ML | 1.0 | Tim | Lampiran F |

## Lampiran D. Dokumen Tambahan dari Dosen

Tidak ada dokumen tambahan yang diumumkan secara tertulis. Jika ada, tambahkan D.1, D.2, dan seterusnya sesuai mata kuliah.

## Lampiran E. Daftar Tautan Eksternal

| No | Keterangan | Bagian | Tautan | Jenis akses |
|---|---|---|---|---|
| 1 | Repositori Git | S.5 | https://github.com/Bisminee/PBL-Mobile-Kelompok2-Semester5 | Publik |
| 2 | PR revisi mobile | Bab 3, 4 | https://github.com/Bisminee/PBL-Mobile-Kelompok2-Semester5/pull/59 | Publik |
| 3 | PR ambang deteksi | Bab 4 | https://github.com/Bisminee/PBL-Mobile-Kelompok2-Semester5/pull/61 | Publik |
| 4 | PR data per akun | Bab 2, 3 | https://github.com/Bisminee/PBL-Mobile-Kelompok2-Semester5/pull/62 | Publik |
| 5 | PR notebook remapping warna | Bab 2, 3 | https://github.com/Bisminee/PBL-Mobile-Kelompok2-Semester5/pull/63 | Publik |
| 6 | Tag milestone-2 | S.5 | [isi URL tag] | Publik |
| 7 | Video demo | S.5 | [isi URL video] | Siapa saja yang memiliki link |

## Lampiran F. Dokumentasi Model Pembelajaran Mesin

### F.1 Dataset

| Aspek | Isi |
|---|---|
| Sumber dan lisensi | Clothing Dataset Full (CC0), Fashion Product Images Small (MIT), Clothes Dataset Carousell (MIT) |
| Cara pelabelan | Label sumber dipetakan ke 9 kelas target |
| Jumlah total | 34.077 gambar terfilter, 33.667 setelah deduplikasi MD5 |
| Pembagian data | 23.566 latih, 5.050 validasi, 5.051 uji; stratified per kelas, seed 42 |

| Kelas | Latih | Validasi | Uji |
|---|---:|---:|---:|
| dress | 836 | 180 | 179 |
| long_pants | 2.116 | 454 | 453 |
| long_sleeve | 395 | 84 | 85 |
| outerwear | 3.365 | 721 | 721 |
| shirt | 2.642 | 567 | 566 |
| shoes | 6.231 | 1.334 | 1.336 |
| shorts | 857 | 184 | 183 |
| skirt | 518 | 111 | 111 |
| tshirt | 6.606 | 1.415 | 1.417 |

Analisis dataset: sebaran kelas tidak seimbang. `shoes` dan `tshirt` mendominasi, sedangkan `long_sleeve` dan `skirt` berjumlah kecil. Fashion Product Images menyumbang 66,9 persen data latih. Ketidakseimbangan ini menjelaskan F1 rendah pada `long_sleeve` dan `dress`; class weight atau penyeimbangan belum diterapkan penuh.

### F.2 Praproses Data

| No | Langkah | Alasan | Parameter | Diterapkan pada |
|---|---|---|---|---|
| 1 | Validasi gambar dengan Pillow | Membuang gambar rusak | - | Semua |
| 2 | Deduplikasi MD5 | Menghapus duplikat | Hash MD5 | Semua |
| 3 | Mapping label | Menyeragamkan 9 kelas | `ml/label_maps/` | Semua |
| 4 | Resize | Menyamakan input | 224 x 224 | Semua |
| 5 | Augmentasi | Mengurangi overfitting | Flip horizontal, rotasi kecil, kecerahan | Latih |

### F.3 Eksperimen Pembanding

| ID | Model dan konfigurasi | Metrik latih | Metrik validasi | Terpilih |
|---|---|---|---|---|
| E1 | MobileNetV2 transfer learning | [isi] | Akurasi 89,37 persen; macro F1 79,27 persen | Tidak |
| E2 | YOLOv11n-cls, 6 epoch, 224 px, batch 32 | [isi] | Akurasi validasi 94,06 persen | Ya |

Analisis: YOLOv11n-cls dipilih karena akurasi validasi lebih tinggi dan ukuran model lebih sesuai untuk aplikasi mobile. Perbandingan metrik latih lengkap perlu diambil dari log pelatihan sebelum laporan akhir.

### F.4 Evaluasi Rinci pada Data Uji

| Kelas | Presisi | Recall | F1 | Jumlah data |
|---|---:|---:|---:|---:|
| dress | 0,734 | 0,877 | 0,799 | 179 |
| long_pants | 0,954 | 0,954 | 0,954 | 453 |
| long_sleeve | 0,750 | 0,776 | 0,763 | 85 |
| outerwear | 0,899 | 0,906 | 0,903 | 721 |
| shirt | 0,921 | 0,929 | 0,925 | 566 |
| shoes | 0,999 | 0,999 | 0,999 | 1.336 |
| shorts | 0,924 | 0,929 | 0,926 | 183 |
| skirt | 0,887 | 0,775 | 0,827 | 111 |
| tshirt | 0,970 | 0,946 | 0,958 | 1.417 |
| Rata-rata makro | 0,893 | 0,899 | 0,895 | 5.051 |

Kekeliruan terbanyak: `tshirt` ke `dress` (29), `outerwear` ke `tshirt` (24), `shirt` ke `outerwear` (23), `tshirt` ke `shirt` (19), dan `outerwear` ke `shirt` (19).

Analisis: kelas dengan data sedikit memiliki F1 lebih rendah. `long_sleeve` dan `dress` perlu perhatian pada penyeimbangan dan augmentasi. Hasil ini belum diuji pada foto lapangan.

### F.5 Kesimpulan Analisis

Sumber masalah utama adalah ketidakseimbangan data dan domain foto katalog yang berbeda dari foto pengguna. Model sudah melewati target akurasi, tetapi kelas minoritas dan foto lapangan masih lemah. Perbaikan diarahkan pada penyeimbangan kelas, validasi TFLite dengan preprocessing aplikasi, dan uji foto lapangan.

## Lampiran G. Dokumentasi Kueri Basis Data

Tidak wajib untuk TI Semester 5. Kueri SQLite yang penting:

1. `SELECT * FROM wardrobe_item ORDER BY id ASC`.
2. `SELECT * FROM outfit ORDER BY id DESC`.
3. `SELECT oi.outfit_id, w.* FROM outfit_item oi JOIN wardrobe_item w ON w.id = oi.wardrobe_item_id`.
4. `SELECT * FROM recommendation_history ORDER BY id DESC LIMIT ?`.
5. `SELECT style, prob FROM ml_style WHERE garment_type=? AND color_family=? ... ORDER BY prob DESC`.

## Lampiran H. Deklarasi Penggunaan AI

| Bagian | Alat | Tujuan | Pemeriksaan |
|---|---|---|---|
| Kode dan dokumentasi teknis | AI coding assistant | Contoh implementasi dan perapian dokumen | Ditinjau, `flutter analyze`, dan 174 test |
| Laporan | AI assistant | Merapikan kalimat dan tabel | Diperiksa dan disesuaikan tim |
