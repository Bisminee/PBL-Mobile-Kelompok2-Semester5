# Pembagian Tugas Minggu 14 - Sera-Z

Diperbarui: 25 November 2026
Minggu 14: 23 - 29 November 2026
Baseline: `dev` pada `de7eccc` setelah PR #62 digabung
Status baseline: `flutter analyze` bersih, 174 test lulus

Dokumen ini adalah satu-satunya pembagian tugas minggu 14 untuk mobile dan ML.
Setiap anggota memegang maksimal dua tugas aktif. Tugas yang tidak masuk dua
tugas aktif dicatat sebagai backlog dan tidak boleh dikerjakan bersamaan
sebelum salah satu tugas aktif selesai.

## 1. Ringkasan tugas aktif

| Anggota | Mobile aktif | ML aktif | Estimasi aktif | Backlog utama |
|---|---|---|---:|---|
| Bisma Adhiaksa | M1.1 Uji akun A/B dan metadata preferensi; M1.2 Pasang aset model 9 kelas | M6.3 Referensi remapping selesai; M6.6 integrasi menyusul | 3,5 ho | M6.6 Integrasi remapping ke aplikasi |
| Izza Dhafira Fanani | M2.1 Rebase dan perbaiki PR #36 Admin | M6.2 Pencocokan warna | 4,0 ho | M2.2 Jalur tambah pakaian dari Lemari |
| Faatihurrizki Prasojo | M3.1 Selamatkan koreksi style/warna dari PR #51 | M6.1 Deteksi atau klasifikasi pakaian | 4,0 ho | M3.2 K-Means warna di Dart |
| Ahmad Falahi | M4.1 Uji fungsional: smoke test lalu uji penuh | M6.4 Pencocokan jenis pakaian | 3,5 ho | M4.2 Uji kompatibilitas dan regresi |
| Abim Mustawa | M5.2 Perbaiki pesan error dan izin kamera | M6.5a Riset style dan dataset | 2,0 ho | M5.1 Ukur latensi dan ukuran model; M6.5b baseline style |
| **Total** | | | **17,0 ho** | |

Catatan kapasitas: 17,0 ho adalah estimasi pekerjaan inti. Tambahkan ruang
untuk review, merge, dan regression; jangan mengisi lebih dari sekitar 80 persen
kapasitas minggu ini.

### 1.1 Keputusan audit yang sudah diterapkan

| Temuan audit | Perbaikan di dokumen |
|---|---|
| Istilah "deteksi baju" ambigu | M6.1 wajib memilih klasifikasi, gate, atau deteksi lokasi sebelum coding |
| Aset model 9 kelas hanya backlog | M1.2 menjadi tugas aktif Bisma; ekspor TFLite menjadi handoff Pras |
| Notebook remapping dianggap integrasi | M6.3 ditandai sebagai referensi; integrasi dipisah ke M6.6 |
| Tugas style Abim terlalu besar | Dipecah menjadi M6.5a riset, M6.5b baseline, M6.5c integrasi |
| Kriteria ML tidak terukur | Ditambahkan tabel ambang penerimaan di bagian 3.9 |
| Uji Ahmad berisiko menguji build setengah jadi | M4.1 dipecah menjadi smoke test dan uji penuh setelah gate PR |
| Tidak ada gate integrasi end-to-end | Ditambahkan gate G4 dan M6.6 |
| Keputusan `navy` belum resmi | Dicatat sebagai keputusan sementara sampai tabel ML diperbarui |

### 1.2 Gate minggu ini

| Gate | Isi | Pemilik | Waktu |
|---|---|---|---|
| G1 | Tetapkan arti "deteksi baju": klasifikasi, gate, atau deteksi lokasi | Pras dan Bisma | Sebelum M6.1 dilanjutkan |
| G2 | Serahkan TFLite, label, dan hasil uji preprocessing ke Bisma | Pras | Sebelum M1.2 dan M6.4 |
| G3 | Rebase atau tutup PR #36 dan PR #51 | Izza dan Pras | Sebelum uji penuh Ahmad |
| G4 | Uji alur end-to-end di perangkat | Bisma dan Ahmad | Setelah M1.2 dan M6.4 |
| G5 | Setujui keputusan `navy -> blue` atau tambah navy ke tabel ML | Bisma dan Falah | Sebelum M6.6 |

## 2. Tugas per anggota

### 2.1 Bisma Adhiaksa

#### M1.1 Uji akun A/B dan metadata preferensi

| Item | Keterangan |
|---|---|
| Branch | `test/account-ab` |
| Estimasi | 1,5 ho |
| Prasyarat | PR #62 sudah digabung, APK debug bisa dipasang |
| Status | Siap mulai |

Langkah:

1. Pasang APK dari `dev` pada satu perangkat Android.
2. Login akun A. Tambahkan minimal 10 pakaian, simpan 2 outfit, dan buka
   rekomendasi agar riwayat serta preferensi terbentuk.
3. Catat jumlah pakaian, outfit, riwayat, dan lokasi foto di
   `Android/data/com.example.sera_z/files/wardrobe/<uid>/`.
4. Logout, login akun B. Pastikan lemari, outfit, riwayat, foto, dan preferensi
   kosong serta tidak ada data akun A yang tampil.
5. Tambahkan 1 pakaian dan 1 outfit pada akun B, lalu logout dan login A lagi.
   Pastikan data A kembali utuh.
6. Periksa `profiles/{uid}.preferences` di Firestore untuk akun A dan B.
   Pastikan isinya hanya metadata preferensi, bukan pakaian, foto, atau outfit.
7. Uji klaim data lama dari banner Lemari. Pastikan path foto berubah ke folder
   uid dan foto tetap bisa dibuka.
8. Hapus akun B, lalu pastikan baris SQLite, foto akun B, dan dokumen profilnya
   tidak tersisa. Akun A tidak boleh terpengaruh.
9. Setelah hasilnya stabil, perbarui `ai-context/status-proyek.md` dan
   `ai-context/peta-tugas.md`.

Selesai bila:

- Tidak ada data yang bocor antar akun A dan B.
- Foto akun A tetap tampil setelah logout dan login ulang.
- `profiles/{uid}.preferences` berisi metadata yang benar untuk kedua akun.
- Hasil uji dicatat dalam tabel lulus atau gagal, termasuk perangkat dan versi
  Android.
- Dokumen status proyek tidak lagi menyebut 170 test atau PR #52 sebagai status
  terbaru.

#### M1.2 Pasang aset model 9 kelas

| Item | Keterangan |
|---|---|
| Branch | `feat/model-assets-final` |
| Estimasi | 2,0 ho |
| Prasyarat | Model TFLite 9 kelas final dan `labels.txt` dari pipeline ML |
| Status | Aktif; menunggu handoff TFLite dari Pras |

Langkah:

1. Ganti `assets/models/yolo11n_cls.tflite` dan `assets/models/labels.txt`
   dengan model 9 kelas yang sudah divalidasi.
2. Samakan urutan label dengan output model. Jangan memakai label 15 kelas yang
   sekarang masih ada di aplikasi.
3. Perbarui komentar model di `lib/services/garment_classifier.dart` agar tidak
   lagi menyebut output 15 kelas.
4. Jalankan preprocessing aplikasi pada 270 foto uji dan catat akurasi model
   TFLite, bukan hanya akurasi model latihan.
5. Pastikan pemetaan jenis ke slot di `garment_labels.dart` tetap cocok dengan
   9 kelas: `dress`, `long_pants`, `long_sleeve`, `outerwear`, `shirt`,
   `shoes`, `shorts`, `skirt`, `tshirt`.
6. Uji ambang penolakan 70 persen. Hasil di bawah ambang harus masuk layar
   "Pakaian tidak terdeteksi".
7. Ukur ukuran aset dan pastikan tidak melebihi batas 20 MB.

Selesai bila:

- Pras menyerahkan `best.pt`, file TFLite, dan `labels.txt` dengan jumlah label
  yang sama.
- Aplikasi memuat model 9 kelas tanpa error jumlah label.
- Hasil inferensi TFLite dengan preprocessing aplikasi minimal 80 persen pada
  set uji aplikasi; macro F1 minimal 75 persen.
- Tidak ada label 15 kelas yang tersisa di aset atau komentar kode.
- APK berhasil dibangun dan model dapat dipakai di perangkat.
- Model final tidak digabung jika akurasi TFLite masih di bawah ambang.

### 2.2 Izza Dhafira Fanani

#### M2.1 Rebase dan perbaiki PR #36 Admin master data

| Item | Keterangan |
|---|---|
| Branch | `feat/admin-master-data-v6` atau rebase branch `feat/admin-master-data` |
| Estimasi | 2,5 ho |
| Prasyarat | PR #62 selesai, database `dev` sudah versi 5 |
| Status | Siap mulai, PR #36 sekarang konflik |

Masalah yang harus diperbaiki:

- PR #36 masih menaikkan database ke versi 4, sedangkan `dev` sudah versi 5.
- `app_preference` sekarang memakai `(owner_uid, key)`. Kode seed di PR #36
  memasukkan `key` tanpa `owner_uid`, sehingga akan gagal pada skema baru.
- PR #36 mematikan `PRAGMA foreign_keys` saat membuka database. Jangan
  mempertahankan perubahan itu; migrasi harus tetap aman dengan foreign key.
- Route admin belum punya pembatasan akses. Pengguna biasa tidak boleh bisa
  membuka halaman admin hanya dengan mengetahui path.
- Halaman admin harus tetap bisa dipakai pada database baru dan database lama
  yang dimigrasikan, tanpa menghapus data pengguna.

Langkah:

1. Rebase ke `dev` `de7eccc`.
2. Naikkan versi database ke 6 hanya jika benar-benar menambah tabel master data.
3. Buat migrasi yang tidak menimpa `owner_uid` dan tidak menyalin ulang data
   master yang sudah ada.
4. Pisahkan data master global dari preferensi akun. Jangan memakai
   `app_preference` tanpa pemilik.
5. Tambahkan pengujian migrasi dari versi 5 ke versi 6.
6. Pastikan CRUD `ref_garment_type` dan `ref_color` berjalan untuk 16 keluarga
   warna.
7. Tambahkan guard akses admin. Jika belum ada sistem role, tetapkan mekanisme
   yang disepakati, misalnya allowlist uid atau flag admin di Firestore.
8. Jalankan `flutter analyze` dan `flutter test` sebelum memperbarui PR.

Selesai bila:

- PR #36 bisa digabung tanpa konflik.
- Database baru dan database lama sama-sama bisa dibuka.
- Tidak ada data pengguna yang hilang akibat migrasi.
- Pengguna biasa tidak bisa membuka halaman admin.
- CRUD master data berjalan dan tercatat di test.

#### M2.2 Rapikan jalur tambah pakaian dari Lemari

| Item | Keterangan |
|---|---|
| Branch | `fix/wardrobe-add-entry` |
| Estimasi | 1,0 ho |
| Prasyarat | M2.1 selesai atau tidak mengubah skema database |
| Status | Backlog |

Latar belakang:

QA plan TC-08 menyebut "tambah item manual" dari Lemari, tetapi UI Lemari
saat ini tidak punya tombol tambah. Pakaian hanya bisa masuk lewat kamera atau
galeri. Harus ada keputusan produk yang jelas agar QA tidak menguji fitur yang
tidak ada.

Langkah:

1. Putuskan apakah produk membutuhkan input manual atau cukup jalur kamera dan
   galeri.
2. Jika input manual dipakai, tambahkan tombol Tambah Pakaian di Lemari dan
   form atribut dasar.
3. Jika tidak, revisi TC-08 di `Pembagian Tugas/qa-plan.md` agar sesuai alur
   yang benar dan catat alasannya.
4. Periksa empty state, loading, dan error pada tab Lemari.
5. Uji layar 320 px agar tidak ada overflow.

Selesai bila:

- Ada satu jalur tambah pakaian yang jelas dari Lemari.
- QA plan dan UI memakai definisi yang sama.
- Tidak ada overflow pada layar kecil.

### 2.3 Faatihurrizki Prasojo

#### M3.1 Selamatkan koreksi style dan warna dari PR #51

| Item | Keterangan |
|---|---|
| Branch | `fix/deteksi-style-warna` dari `dev` |
| Estimasi | 2,0 ho |
| Prasyarat | PR #62 selesai |
| Status | Siap mulai, PR #51 konflik dan sebagian sudah duplikat |

PR #51 berisi beberapa perubahan yang sekarang sudah ada di `dev`, yaitu ubah
nama outfit, hapus outfit, detail outfit tersimpan, dan menu tekan lama. Jangan
menggabungkan seluruh PR lama.

Langkah:

1. Bandingkan PR #51 dengan `dev` dan tandai bagian yang masih belum ada.
2. Pertahankan koreksi style dan warna dominan di layar Hasil Deteksi.
3. Simpan pilihan style manual secara terpisah agar tidak tertimpa saat jenis
   atau warna diubah.
4. Hitung ulang formalitas dan style dari engine setelah warna diubah.
5. Hapus atau aktifkan tombol share `Icons.ios_share` di
   `lib/screens/scan/detection_result_screen.dart` yang saat ini tidak punya
   aksi.
6. Tambahkan widget test untuk pilihan style dan warna.
7. Tutup PR #51 jika seluruh isinya sudah tercakup, atau ajukan PR baru yang
   hanya berisi bagian yang belum ada.

Selesai bila:

- Pengguna bisa mengubah style dan warna dominan sebelum menyimpan pakaian.
- Formalitas dan style tidak kembali ke nilai model setelah perubahan manual.
- Tidak ada tombol tanpa aksi di layar hasil deteksi.
- `flutter analyze` bersih dan seluruh test lulus.
- PR #51 tidak lagi menjadi PR terbuka yang menggantung.

#### M3.2 K-Means warna di Dart

| Item | Keterangan |
|---|---|
| Branch | `feat/kmeans-dart` |
| Estimasi | 2,0 ho |
| Prasyarat | `color_extractor.dart` dan 16 keluarga warna stabil |
| Status | Backlog; menunggu M3.1 |

Langkah:

1. Implementasikan K-Means k=3 sampai 5 pada piksel hasil crop tengah.
2. Gunakan ruang warna Lab atau HSV yang konsisten dengan modul warna.
3. Kembalikan warna dominan beserta proporsi cluster, bukan hanya satu nilai.
4. Petakan hasil cluster ke 16 keluarga warna yang sudah ada.
5. Pertahankan HSV sebagai fallback bila piksel tidak cukup.
6. Tambahkan unit test dengan gambar sintetis yang warna dominannya diketahui.
7. Ukur waktu proses agar tidak menambah latensi berlebihan.

Selesai bila:

- Warna dominan stabil pada gambar uji.
- Ada test untuk minimal tiga kombinasi warna.
- Fallback HSV tetap berjalan.
- Tidak ada regresi pada rekomendasi dan penyimpanan warna.

### 2.4 Ahmad Falahi

#### M4.1 Uji fungsional: smoke test lalu uji penuh

| Item | Keterangan |
|---|---|
| Branch | `test/functional` |
| Estimasi | 2,0 ho |
| Prasyarat | Build `dev` stabil dan APK bisa dipasang |
| Status | Siap mulai untuk smoke test; uji penuh menunggu gate |

Langkah:

1. Lakukan smoke test alur utama pada build `dev` saat ini: login, kamera,
   simpan pakaian, lemari, rekomendasi, dan profil.
2. Jalankan uji penuh 34 kasus setelah PR #36 dan PR #51 selesai atau ditutup.
3. Prioritaskan alur login, logout, hapus akun, kamera, crop, lemari, outfit,
   rekomendasi, profil, dan admin setelah M2.1 selesai.
4. Uji kasus negatif: izin kamera ditolak, foto gelap, bukan pakaian, offline,
   lemari kosong, dan data lama sebelum klaim.
5. Catat setiap bug dengan format yang sudah ada: ID, test case, perangkat,
   langkah reproduksi, hasil aktual, hasil diharapkan, prioritas, dan bukti.
6. Simpan hasil di `Pembagian Tugas/hasil-uji-fungsional.md`.
7. Bedakan bug aplikasi dari keterbatasan model ML.

Selesai bila:

- Smoke test alur utama lulus pada build `dev` saat ini.
- Uji penuh 34 kasus dijalankan setelah gate G3.
- Semua bug prioritas tinggi punya langkah reproduksi.
- Hasil lulus dan gagal tidak hanya berupa centang tanpa bukti.
- Bug yang sudah diperbaiki diuji ulang.

#### M4.2 Uji kompatibilitas dan regresi

| Item | Keterangan |
|---|---|
| Branch | `test/compatibility` |
| Estimasi | 1,5 ho |
| Prasyarat | M4.1 sudah menghasilkan daftar bug |
| Status | Backlog; menunggu M4.1 |

Langkah:

1. Uji alur utama pada minimal tiga perangkat atau versi Android berbeda,
   misalnya Android 11, 13, dan 15.
2. Uji orientasi layar, layar 320 px, kamera depan dan belakang, flash, serta
   tombol back.
3. Uji login, migrasi data lama, klaim data, dan hapus akun di perangkat yang
   berbeda dari perangkat pengembang.
4. Ulangi test case yang sebelumnya gagal setelah bug diperbaiki.
5. Catat matriks perangkat, versi Android, hasil, dan bug yang masih terbuka.

Selesai bila:

- Matriks kompatibilitas minimal tiga perangkat terisi.
- Tidak ada crash pada alur utama.
- Bug layout dan bug kritis sudah masuk daftar perbaikan.
- Regression test untuk bug yang sudah diperbaiki tercatat.

### 2.5 Abim Mustawa

#### M5.1 Ukur latensi dan ukuran model

| Item | Keterangan |
|---|---|
| Branch | `test/performance` |
| Estimasi | 1,0 ho |
| Prasyarat | Model yang dipakai adalah model final atau model 9 kelas |
| Status | Backlog; menunggu M1.2 atau model final |

Langkah:

1. Ukur waktu muat model saat aplikasi dibuka.
2. Ukur waktu analisis untuk lima foto pada perangkat nyata.
3. Catat waktu preprocessing, inferensi, dan penyimpanan foto secara terpisah
   bila memungkinkan.
4. Catat ukuran file `.tflite` dan ukuran APK.
5. Uji pada perangkat kelas bawah bila tersedia.
6. Tulis hasil dan bottleneck di `Pembagian Tugas/hasil-performa.md`.

Selesai bila:

- Rata-rata analisis di bawah 3 detik per foto.
- Ukuran model di bawah 20 MB.
- Ada catatan perangkat, versi Android, dan kondisi pengujian.
- Jika target tidak tercapai, ada rekomendasi perbaikan yang konkret.

#### M5.2 Perbaiki pesan error dan izin kamera

| Item | Keterangan |
|---|---|
| Branch | `fix/camera-errors` |
| Estimasi | 1,0 ho |
| Prasyarat | Tidak ada |
| Status | Siap mulai |

Masalah yang ditemukan:

- Pesan `No camera was found on this device.`, `Camera permission was denied.
  Please allow it in settings.`, dan `Camera access is restricted on this
  device.` masih berbahasa Inggris di `lib/screens/scan/camera_screen.dart`.
- Izin kamera yang ditolak belum tentu memberi tombol langsung ke pengaturan
  aplikasi.
- Perilaku lifecycle setelah Ambil Ulang perlu diuji pada perangkat, bukan
  hanya lewat widget test.

Langkah:

1. Ganti seluruh pesan error kamera ke Bahasa Indonesia.
2. Tambahkan tombol Buka Pengaturan saat izin kamera ditolak.
3. Bedakan pesan tidak ada kamera, izin ditolak, dan flash tidak tersedia.
4. Uji kamera depan dan belakang, flash Off/Auto/On, serta Ambil Ulang.
5. Tambahkan test untuk teks dan tombol yang bisa diuji tanpa perangkat.

Selesai bila:

- Tidak ada pesan error kamera berbahasa Inggris.
- Pengguna bisa membuka pengaturan dari layar kamera saat izin ditolak.
- Ambil Ulang membuka kamera baru dan tidak memakai controller lama.
- Tidak ada crash saat aplikasi masuk background lalu dibuka lagi.

## 3. Tugas ML per anggota

Pembagian dari Bisma: Pras untuk deteksi atau klasifikasi pakaian, Fira untuk
pencocokan warna, Bisma untuk remapping warna dan harmoni, Falah untuk
pencocokan jenis pakaian, dan Abim untuk style setelah pencocokan. Tugas ML
dihitung sebagai tugas aktif, sehingga satu anggota hanya memegang satu tugas
mobile dan satu tugas ML pada saat yang sama.

| ID | PIC | Tugas ML | Estimasi | Status | Branch | Bukti |
|---|---|---:|---|---|---|---|
| M6.1 | Pras | Deteksi atau klasifikasi pakaian | 2,0 ho | Diblokir sampai definisi tugas disepakati; output lama belum valid | `ml/deteksi-baju` | `D:\Download\test_dataset_Yolov11n.ipynb` |
| M6.2 | Izza (Fira) | Pencocokan warna | 1,5 ho | Prototipe selesai, validasi data nyata belum | `ml/pencocokan-warna` | `D:\Download\pencocokan_warna_sera_z.ipynb` |
| M6.3 | Bisma | Referensi remapping warna dan harmoni | 2,0 ho | Notebook referensi selesai; integrasi aplikasi belum | `feat/color-remapping` | `ml/notebooks/remapping_warna_sera_z.ipynb` |
| M6.4 | Ahmad (Falah) | Pencocokan jenis pakaian | 1,5 ho | Menunggu M1.2; evaluasi di aplikasi belum | `ml/pencocokan-jenis` | `garment_classifier.dart`, `garment_labels.dart` |
| M6.5a | Abim | Riset style dan dataset | 1,0 ho | Aktif riset; sumber label belum | `ml/style-research` | `ml_style` di `fashion_app.db` |
| M6.5b | Abim | Baseline dan evaluasi style | 2,0 ho | Backlog; menunggu M6.5a | `ml/style-baseline` | belum ada |
| M6.5c | Abim | Integrasi style ke aplikasi | 1,0 ho | Backlog; menunggu M6.5b dan M1.2 | `ml/style-integration` | belum ada |
| M6.6 | Bisma | Integrasi remapping ke aplikasi | 1,5 ho | Backlog; menunggu M6.3 dan M6.2 | `ml/color-integration` | notebook remapping |

### 3.1 M6.1 Deteksi atau klasifikasi pakaian - Pras

Status: **diblokir sampai definisi tugas disepakati**.

Gate G1: Pras dan Bisma harus memilih salah satu definisi berikut sebelum
melanjutkan:

1. Klasifikasi jenis pakaian 9 kelas.
2. Gate biner pakaian atau bukan pakaian.
3. Deteksi lokasi atau segmentasi pakaian.

Jika memilih klasifikasi atau gate, metriknya akurasi dan F1. Jika memilih
deteksi lokasi atau segmentasi, metriknya mAP atau IoU. Jangan memakai istilah
"deteksi" untuk notebook klasifikasi.

Yang sudah dikerjakan di notebook `test_dataset_Yolov11n.ipynb`:

- Memakai dataset Fashion Product Images dari Kaggle.
- Membersihkan data menjadi 44.419 gambar valid.
- Melabeli ulang menjadi 10 kelas: `dress`, `long_pants`, `long_sleeve`,
  `outerwear`, `other`, `shirt`, `shoes`, `shorts`, `skirt`, dan `tshirt`.
- Menyeimbangkan kelas dengan batas 3.000 gambar per kelas menjadi 15.666
  gambar.
- Membagi data menjadi 10.966 train, 2.350 validation, dan 2.350 test.
- Sel output menampilkan pelatihan `YOLO11n-cls` selama 30 epoch dengan
  `imgsz=224`.
- Output test set menampilkan akurasi 98,13 persen dan macro F1 94,76 persen,
  dengan kelas terendah `outerwear` F1 82,61 persen.
- Output menampilkan `best.pt` sudah diunduh dari Colab.

Catatan penting: output notebook saat ini tidak sinkron dengan source. Source
sel relabel memakai `relabelArticleType` dan 8 kelas, sedangkan output
menampilkan `label10` dan 10 kelas. Angka 98,13 persen dan `best.pt` belum boleh
dipakai sebagai hasil final sampai seluruh notebook dijalankan ulang dari awal.

Yang belum dikerjakan:

- Notebook memakai `YOLO11n-cls`, yaitu klasifikasi gambar, bukan deteksi
  bounding box atau segmentasi. Jika "deteksi baju" berarti menemukan lokasi
  pakaian di foto, pekerjaan itu belum dicoba.
- Belum ada ekspor TFLite dan validasi dengan `preprocessForModel` aplikasi.
- Belum diuji pada foto kamera nyata; hasil 98,13 persen berasal dari foto
  produk dengan latar relatif bersih.
- Model memakai 10 kelas termasuk `other`, sedangkan aset aplikasi masih model
  15 kelas. Jangan mencampur label kedua model.
- PR #32 tetap tidak boleh digabung sebelum TFLite divalidasi dengan
  preprocessing aplikasi.

Selesai bila:

- Definisi "deteksi baju" disepakati dan dicatat di dokumen ini sebelum
  pekerjaan dilanjutkan.
- Jika klasifikasi: model diekspor ke TFLite dan diuji pada 270 foto dengan
  preprocessing aplikasi; akurasi minimal 80 persen dan macro F1 minimal 75
  persen.
- Jika gate biner: precision minimal 80 persen dan recall minimal 80 persen
  pada foto pakaian dan non-pakaian.
- Jika deteksi lokasi: dataset bounding box atau mask tersedia; mAP@0.5 minimal
  0,60 atau IoU minimal 0,70.
- Hasil per kelas dan batasan data dicatat di laporan ML.
- `best.pt`, TFLite, dan label diserahkan ke Bisma untuk M1.2.

### 3.2 M6.2 Pencocokan warna - Izza (Fira)

Status: **prototipe selesai, validasi belum**.

Yang sudah dikerjakan di notebook `pencocokan_warna_sera_z.ipynb`:

- Menyediakan palet 14 warna UI Sera-Z.
- Mengambil area tengah 50 persen gambar.
- Mengelompokkan piksel dengan K-Means, lalu memilih cluster terbanyak.
- Mengubah RGB ke HSV dan memetakan ke nama palet.
- Menghitung skor harmoni warna dengan aturan netral, monokromatik, analog,
  komplementer, dan kontras kurang harmonis.
- Menguji empat skenario sintetis: navy dan krem, putih dan hijau army, biru
  muda dan kuning, serta merah dan hijau.

Bug yang sudah ditemukan saat review:

- `hsv_ke_palet` memetakan RGB navy `(26, 35, 126)` ke biru muda, bukan navy,
  karena ambang `v < 0.48` sedangkan nilai V navy sekitar 0.49.
- Teal `(0, 137, 123)` juga dipetakan ke biru muda, bukan ke keluarga warna
  yang sesuai.
- Olive `(107, 142, 35)` dipetakan ke hijau, bukan hijau army.
- K-Means tetap dijalankan pada gambar satu warna dan menghasilkan
  `ConvergenceWarning`; jumlah cluster harus dibatasi oleh jumlah warna unik.
- Hanya cluster terbesar yang dikembalikan, padahal aplikasi membutuhkan
  komposisi beberapa warna untuk bar warna.

Yang belum dikerjakan:

- Semua pengujian masih memakai gambar sintetis; belum ada foto pakaian nyata.
- Belum ada ground truth, akurasi, confusion matrix, atau perbandingan dengan
  aturan harmoni yang sudah ada di aplikasi.
- Belum diputuskan apakah hasil notebook akan menggantikan
  `color_harmony.dart` atau hanya menjadi alat evaluasi.
- Belum ada integrasi ke kode Dart.
- Notebook belum dimasukkan ke repositori; simpan versi bersih di
  `ml/notebooks/` tanpa token atau data pribadi.

Selesai bila:

- Ada minimal 50 foto nyata dengan label warna dan pasangan warna.
- Top-1 accuracy warna minimal 80 persen dan top-2 minimal 90 persen.
- Ada metrik evaluasi dan perbandingan dengan aturan harmoni aplikasi.
- Pemetaan 16 ke 14 memakai referensi notebook Bisma di
  `ml/notebooks/remapping_warna_sera_z.ipynb`.
- Keputusan integrasi ditulis: dipakai di aplikasi, dijadikan acuan, atau
  ditolak dengan alasan.
- Batas antara pencocokan warna (Fira) dan remapping/harmoni (Bisma) jelas.

### 3.3 M6.3 Referensi remapping warna dan harmoni - Bisma

Status: **referensi notebook selesai; integrasi aplikasi belum**.

Hasil referensi:

- Branch `feat/color-remapping`, commit `185e7fc`.
- Notebook `ml/notebooks/remapping_warna_sera_z.ipynb` sudah dieksekusi.
- Tabel 16 keluarga internal, 14 palet UI, dan 14 warna tabel ML sudah dibuat.
- Semua 16 keluarga berhasil dipetakan.
- Database `ml_pair_score` berisi 51.352 baris dan tidak ada hasil mapping yang
  hilang.
- Keputusan sementara: `navy` dipetakan ke `blue` karena `ml_pair_score` belum
  memiliki navy.

Yang sudah ada di aplikasi:

- `ColorFamily` berisi 16 keluarga warna di `color_family.dart`.
- `colorPalette14` berisi 14 nama tampilan di `color_palette.dart`.
- `color_harmony.dart` sudah punya aturan harmoni dan unit test.

Yang belum dikerjakan:

- Integrasi pemetaan ke `color_extractor.dart`, query `ml_pair_score`, dan
  `OutfitEngine` belum ada; ini dipisah ke M6.6.
- Keputusan `navy -> blue` perlu disetujui. Jika produk ingin membedakan navy
  dan biru, tabel ML harus diperbarui.
- Belum ada test remapping di kode aplikasi; test saat ini hanya di notebook.
- Belum dibandingkan hasil remapping Python, Dart, dan database.

Selesai bila:

- Notebook referensi dapat dijalankan ulang tanpa error.
- Tabel pemetaan 16 ke 14 disepakati.
- Semua warna baru punya perilaku yang jelas saat skor pasangan tidak tersedia.
- Hasil notebook diserahkan ke Izza sebelum integrasi aplikasi.

### 3.4 M6.4 Pencocokan jenis pakaian - Ahmad (Falah)

Status: **sebagian; menunggu M1.2**.

Yang sudah ada:

- Model 9 kelas sudah dilatih dan dievaluasi: akurasi test 94,34 persen dan
  macro F1 89,48 persen.
- Aplikasi punya pemetaan jenis ke slot di `garment_labels.dart`.
- Engine sudah memakai jenis untuk formalitas, style, dan rekomendasi.

Yang belum dikerjakan:

- Aset aplikasi masih model 15 kelas, sehingga hasil model 9 kelas belum
  benar-benar dipakai di perangkat.
- Belum ada evaluasi "pencocokan jenis" dengan preprocessing aplikasi pada 270
  foto uji.
- Belum ada analisis per kelas, terutama `outerwear`, `dress`, dan `long_sleeve`
  yang sering tertukar dengan atasan lain.
- Belum dipastikan alternatif jenis dan ambang 70 persen bekerja sama dengan
  model final.
- Belum ada laporan yang memisahkan akurasi model latihan dari akurasi
  pencocokan di aplikasi.

Selesai bila:

- M1.2 sudah memasang model dan label yang sama.
- Ada laporan akurasi per kelas dengan preprocessing aplikasi.
- Akurasi minimal 80 persen dan macro F1 minimal 75 persen pada 270 foto uji.
- Pemetaan 9 kelas ke slot dan kategori konsisten.
- Ambang penolakan dan daftar alternatif jenis diuji pada foto nyata.
- Hasilnya dipakai sebagai dasar M1.2 dan bukan hanya angka di notebook.

### 3.5 M6.5a Riset style dan dataset - Abim

Status: **aktif**.

Ruang lingkup:

- Tentukan taksonomi style yang dipakai produk.
- Cari sumber label style yang tersedia di dataset.
- Ukur jumlah dan sebaran label sebelum memilih model.
- Bandingkan opsi lookup `ml_style` dengan classifier citra.
- Jangan melatih model final pada tahap ini.

Yang sudah ada:

- Tabel `ml_style` berisi 4.788 baris lookup style.
- `OutfitEngine` bisa membaca prediksi style dari tabel berdasarkan jenis,
  warna, gender, dan kelompok usia.
- UI menampilkan style hasil engine; pilihan style manual baru ada di PR #51
  dan belum digabung.

Selesai bila:

- Dokumen keputusan style dibuat: label, sumber data, jumlah sampel, dan split.
- Ada rekomendasi apakah style tetap lookup atau perlu classifier citra.
- Tidak ada training model final sebelum taksonomi disetujui.
- Hasil riset diserahkan ke Bisma dan Falah sebagai bahan M6.5b.

### 3.5a M6.5b Baseline dan evaluasi style - Abim

Status: **backlog; menunggu M6.5a**.

Ruang lingkup:

- Latih baseline sederhana setelah taksonomi disetujui.
- Bandingkan dengan lookup `ml_style`.
- Laporkan macro F1, confusion matrix, dan keterbatasan data.

Selesai bila:

- Macro F1 test minimal 70 persen, atau keputusan eksplisit untuk tetap memakai
  lookup bila data tidak cukup.
- Dataset train, validation, dan test tidak bocor.
- Metrik dan batasan dicatat.

### 3.5b M6.5c Integrasi style ke aplikasi - Abim

Status: **backlog; menunggu M6.5b dan M1.2**.

Ruang lingkup:

- Ekspor TFLite bila model dipakai.
- Sambungkan style setelah jenis dan warna ditentukan.
- Uji pada perangkat dan pastikan fallback lookup tetap berjalan.

Selesai bila:

- Style tampil di alur hasil deteksi.
- Model gagal dimuat tetap memakai lookup.
- Ada test regresi untuk hasil style.

### 3.5c M6.6 Integrasi remapping ke aplikasi - Bisma

Status: **backlog; menunggu M6.3 dan M6.2**.

Ruang lingkup:

- Pakai tabel referensi dari notebook `remapping_warna_sera_z.ipynb`.
- Sambungkan pemetaan 16 ke 14 ke `color_extractor.dart`, query
  `ml_pair_score`, dan `OutfitEngine`.
- Pertahankan `ColorFamily` 16 untuk UI dan gunakan 14 nama hanya untuk tabel
  ML.
- Tambahkan test aplikasi untuk `cream`, `maroon`, `olive`, `teal`, dan `navy`.

Selesai bila:

- Warna 16 keluarga tidak gagal mencari skor pasangan.
- Query rekomendasi memakai pemetaan yang sama dengan notebook.
- `flutter analyze` bersih dan seluruh test lulus.
- Ranking rekomendasi sebelum dan sesudah remapping dibandingkan.

### 3.6 Batas pekerjaan antar anggota ML

| Anggota | Batas kerja | Tidak mengerjakan |
|---|---|---|
| Pras | Deteksi atau klasifikasi pakaian, ekspor model visual | Remapping warna dan aturan harmoni |
| Fira | Ekstraksi dan pencocokan warna, evaluasi data nyata | Perubahan tabel warna global dan ranking rekomendasi |
| Bisma | Pemetaan warna global, harmoni, integrasi aset final | Melatih ulang classifier jenis tanpa koordinasi |
| Falah | Evaluasi pencocokan jenis dan pemetaan slot | Mengubah model 10 kelas milik PR #32 |
| Abim | Klasifikasi style setelah jenis dan warna | Deteksi pakaian dan pencocokan warna dasar |

### 3.7 Revisi wajib notebook Izza (Fira)

Prioritas revisi: perbaiki logika warna lebih dulu, lalu uji pada data nyata.
Jangan menambah fitur aplikasi sebelum dua hal itu selesai.

1. Ganti pemetaan HSV manual dengan pemetaan ke palette reference memakai
   jarak warna yang konsisten dengan aplikasi, misalnya CIELAB. Jika tetap
   memakai HSV, tambahkan kasus batas dan tabel keputusan yang eksplisit.
2. Perbaiki bug yang sudah terbukti:
   - Navy `(26, 35, 126)` harus menjadi navy, bukan biru muda.
   - Teal `(0, 137, 123)` harus punya keputusan eksplisit: biru muda, hijau,
     atau keluarga teal baru. Jangan dibiarkan jatuh ke biru muda tanpa alasan.
   - Olive `(107, 142, 35)` harus menjadi hijau army atau keputusan eksplisit
     lain yang sama dengan aplikasi.
   - Maroon `(123, 31, 43)` harus konsisten dengan pemetaan 14/16 warna.
3. Tambahkan unit test untuk seluruh 14 nama palette dan 16 keluarga warna.
   Setiap keluarga harus punya contoh RGB dan hasil yang diharapkan.
4. Perbaiki K-Means:
   - Batasi `n_clusters` dengan jumlah warna unik.
   - Tangani gambar satu warna tanpa warning.
   - Kembalikan minimal tiga cluster beserta proporsinya, bukan hanya cluster
     terbesar.
   - Tetapkan seed dan `n_init` agar hasil dapat diulang.
5. Uji pada data nyata:
   - Minimal 50 foto pakaian dari perangkat atau dataset, bukan gambar
     sintetis.
   - Siapkan ground truth warna dominan.
   - Laporkan top-1 dan top-2 accuracy serta confusion matrix per warna.
   - Pisahkan hasil untuk foto produk dan foto perangkat.
6. Selaraskan dengan aplikasi:
   - Bandingkan hasil notebook dengan `color_harmony.dart` dan
     `color_extractor.dart`.
   - Bandingkan Lab dengan HSV pada gambar yang sama.
   - Jangan membuat aturan harmoni baru yang berbeda tanpa persetujuan Bisma.
   - Tulis keputusan: notebook dipakai sebagai acuan, diganti ke Dart, atau
     ditolak.
7. Rapikan notebook:
   - Pindahkan ke `ml/notebooks/pencocokan_warna.ipynb`.
   - Hapus path lokal, output yang tidak perlu, dan data pribadi.
   - Tambahkan sel instalasi, versi library, dan cara menjalankan.
   - Jalankan ulang dari awal sehingga source dan output konsisten.
8. Jangan mengintegrasikan hasil ke `color_extractor.dart` sebelum Bisma
   menyelesaikan remapping 16 ke 14 dan tabel ML siap.

Selesai bila:

- Tidak ada warning K-Means pada gambar satu warna.
- Seluruh test palette lulus.
- Ada metrik pada data nyata.
- Keputusan integrasi dan batas kerja dengan Bisma tertulis.
- Notebook bersih dapat dijalankan ulang oleh anggota lain.

### 3.8 Revisi wajib notebook Pras

Prioritas revisi: samakan definisi tugas dan buat output yang dapat dipercaya
sebelum mengekspor model.

1. Hentikan penggunaan output lama. Notebook saat ini tidak konsisten:
   source memakai `relabelArticleType` dan 8 kelas, sedangkan output
   menampilkan `label10` dan 10 kelas. Hapus semua output, lalu jalankan ulang
   dari sel pertama sampai terakhir. `best.pt` lama tidak boleh dipakai sebelum
   notebook bersih selesai dijalankan.
2. Tegaskan definisi "deteksi baju":
   - Jika yang dimaksud klasifikasi jenis, gunakan kelas yang sama dengan
     aplikasi dan dokumentasikan.
   - Jika yang dimaksud deteksi lokasi atau segmentasi, siapkan dataset
     bounding box/mask dan ukur mAP atau IoU. Notebook `YOLO11n-cls` tidak
     memenuhi definisi itu.
   - Jangan mencampur 10 kelas `other` dengan 9 kelas aplikasi tanpa keputusan
     resmi.
3. Samakan kelas dengan aplikasi:
   - Target minimal 9 kelas: `dress`, `long_pants`, `long_sleeve`, `outerwear`,
     `shirt`, `shoes`, `shorts`, `skirt`, `tshirt`.
   - Jika `other` tetap dipakai, jadikan gate biner terpisah atau kelas ke-10
     yang disepakati.
   - Hapus sel label biner lama yang tidak lagi dipakai agar tidak
     membingungkan.
4. Ekspor TFLite:
   - Tambahkan sel ekspor dari `best.pt` ke TFLite.
   - Uji dengan `preprocessForModel` aplikasi, bukan hanya `best.predict`.
   - Pastikan jumlah output sama dengan jumlah label dan layout input sesuai
     kode aplikasi.
   - Uji pada 270 foto test aplikasi dan laporkan akurasi TFLite.
5. Validasi data:
   - Catat versi dan lisensi dataset.
   - Pastikan split tidak memiliki ID produk yang sama di train dan test.
   - Periksa duplikat gambar dengan hash persepsi bila memungkinkan.
   - Laporkan precision, recall, F1 per kelas dan confusion matrix.
   - Catat kelas dengan support kecil, misalnya skirt 20 dan outerwear 47,
     agar angka test tidak dianggap stabil.
6. Uji di luar dataset produk:
   - Ambil minimal 30 foto kamera nyata dengan latar dan pencahayaan berbeda.
   - Bandingkan hasil dengan foto produk.
   - Tulis keterbatasan domain produk versus foto pengguna.
7. Rapikan kode:
   - Gabungkan dataframe yang duplikat dan hapus sel eksplorasi yang tidak
     dipakai.
   - Perbaiki peringatan `groupby.apply` dan gunakan API pandas yang sekarang.
   - Gunakan `pathlib`, seed, dan konfigurasi yang dapat diulang.
   - Jangan menyimpan token Kaggle di notebook.
8. Simpan ke repo:
   - Pindahkan versi bersih ke `ml/notebooks/deteksi_pakaian_yolov11n.ipynb`.
   - Tambahkan README yang menjelaskan dataset, cara menjalankan, dan hasil.
   - Jangan commit dataset, `best.pt`, atau output gambar berukuran besar.

Selesai bila:

- Notebook berjalan dari awal tanpa error dan output sesuai source.
- Kelas dan label sesuai keputusan tim.
- TFLite tersedia dan lolos uji preprocessing aplikasi.
- Ada metrik per kelas pada data test dan foto nyata.
- PR #32 tidak disentuh sampai validasi selesai.

### 3.9 Ambang penerimaan

Angka berikut dipakai agar status tugas tidak subjektif. Jika data belum cukup,
PM harus memutuskan perubahan ambang secara tertulis, bukan menurunkan ambang
diam-diam.

| Area | Metrik | Ambang minimum |
|---|---|---|
| M6.1 klasifikasi | Akurasi dan macro F1 pada preprocessing aplikasi | Akurasi 80 persen; macro F1 75 persen |
| M6.1 gate pakaian | Precision dan recall | 80 persen |
| M6.1 deteksi lokasi | mAP@0.5 atau IoU | mAP 0,60 atau IoU 0,70 |
| M6.2 warna | Top-1 dan top-2 accuracy pada minimal 50 foto nyata | Top-1 80 persen; top-2 90 persen |
| M6.3 remapping | Cakupan 16 keluarga ke 14 palet dan 14 warna ML | 100 persen |
| M6.4 jenis | Akurasi dan macro F1 dengan preprocessing aplikasi | Akurasi 80 persen; macro F1 75 persen |
| M6.5b style | Macro F1 pada test | 70 persen, atau keputusan memakai lookup |
| M1.2 aset | Akurasi TFLite dan macro F1 | Akurasi 80 persen; macro F1 75 persen |
| Semua ML | Latensi per foto | Maksimal 3 detik |
| Semua model | Ukuran model | Maksimal 20 MB |
| Gate G4 | Alur utama di perangkat | Tidak ada bug kritis; smoke test lulus |

## 4. Daftar perbaikan yang perlu dikerjakan

| ID | Prioritas | Perbaikan | Bukti atau lokasi | PIC | Tugas |
|---|---|---|---|---|---|
| F-01 | Tinggi | Rebase PR #36 dan sesuaikan dengan database versi 5 | `feat/admin-master-data`, `local_db.dart` | Izza | M2.1 |
| F-02 | Tinggi | Jangan memakai `app_preference` tanpa `owner_uid` untuk seed admin | PR #36, `local_db.dart` | Izza | M2.1 |
| F-03 | Tinggi | Jangan mematikan foreign key saat migrasi database | PR #36, `openOptions` | Izza | M2.1 |
| F-04 | Tinggi | Tambahkan pembatasan akses halaman Admin | `app_router.dart`, PR #36 | Izza | M2.1 |
| F-05 | Tinggi | Rebase PR #51 dan buang bagian yang sudah ada di `dev` | PR #51 | Pras | M3.1 |
| F-06 | Tinggi | Pasang aset model 9 kelas dan samakan label | `assets/models/`, `garment_classifier.dart` | Bisma | M1.2 |
| F-07 | Tinggi | Uji akun A/B dan verifikasi metadata Firestore | PR #62, perangkat Android | Bisma | M1.1 |
| F-08 | Tinggi | Jalankan uji fungsional dan kompatibilitas pasca-merge | `qa-plan.md` | Ahmad | M4.1, M4.2 |
| F-09 | Sedang | Tombol share di Hasil Deteksi belum punya aksi | `detection_result_screen.dart` | Pras | M3.1 |
| F-10 | Sedang | Pesan error dan izin kamera masih Bahasa Inggris | `camera_screen.dart` | Abim | M5.2 |
| F-11 | Sedang | QA TC-08 meminta tambah manual, UI hanya lewat scan | `qa-plan.md`, `wardrobe_screen.dart` | Izza | M2.2 |
| F-12 | Sedang | K-Means di Dart belum ada; warna masih HSV | `color_extractor.dart` | Pras | M3.2 |
| F-13 | Sedang | Latensi dan ukuran model belum diukur | aset model dan perangkat | Abim | M5.1 |
| F-14 | Rendah | `ai-context/status-proyek.md` dan `peta-tugas.md` masih memakai status 170 test dan PR #52 | `ai-context/` | Bisma | M1.1 |
| F-15 | Rendah | Layar signup masih placeholder dan belum punya alur akun email | `signup_screen.dart` | Bisma | Backlog produk |
| F-16 | Tinggi | Output notebook Pras tidak sinkron dengan source: source 8 kelas, output 10 kelas; belum ada TFLite | notebook Pras | Pras | M6.1 |
| F-17 | Tinggi | Pencocokan warna Fira masih memakai gambar sintetis dan belum punya metrik | notebook Fira | Izza | M6.2 |
| F-22 | Tinggi | `hsv_ke_palet` salah memetakan navy, teal, dan olive | notebook Fira | Izza | M6.2 |
| F-23 | Sedang | K-Means Fira warning pada gambar satu warna dan hanya mengembalikan satu cluster | notebook Fira | Izza | M6.2 |
| F-18 | Tinggi | Pemetaan 16 keluarga warna, 14 palet UI, dan tabel ML baru tersedia sebagai referensi notebook; integrasi aplikasi belum | `ml/notebooks/remapping_warna_sera_z.ipynb` | Bisma | M6.3, M6.6 |
| F-19 | Tinggi | Pencocokan jenis pakaian belum dievaluasi dengan model dan preprocessing aplikasi | `garment_classifier.dart`, `garment_labels.dart` | Ahmad | M6.4 |
| F-20 | Tinggi | Klasifikasi style berbasis citra setelah pencocokan belum ada | `ml_style`, `outfit_engine.dart` | Abim | M6.5a, M6.5b, M6.5c |
| F-21 | Sedang | Notebook ML masih di `D:\Download`, belum disalin bersih ke `ml/notebooks/` | notebook Pras dan Fira | Pras dan Izza | M6.1, M6.2 |
| F-25 | Tinggi | Notebook remapping Bisma belum terhubung ke aplikasi | `ml/notebooks/remapping_warna_sera_z.ipynb` | Bisma | M6.6 |
| F-26 | Tinggi | `navy` dipetakan ke `blue` karena tabel ML belum punya navy | notebook remapping, `ml_pair_score` | Bisma | M6.6 |
| F-27 | Tinggi | Tidak ada gate integrasi end-to-end setelah model baru | alur scan sampai rekomendasi | Bisma dan Ahmad | G4 |

## 5. Status PR yang perlu diperhatikan

| PR | Isi | Tindakan | PIC |
|---|---|---|---|
| #36 | Admin master data | Rebase ke database versi 5 atau 6, jangan digabung sebelum F-01 sampai F-04 selesai | Izza |
| #51 | Koreksi style/warna dan pengelolaan outfit | Ambil bagian yang belum ada, lalu tutup atau ganti dengan PR baru | Pras |
| #32 | Model 10 kelas dan penolakan objek | Tetap diblokir; TFLite belum valid | Abim dan Bisma |
| #31 | Pipeline dataset HF dan kelas `other` | Pekerjaan ML; putuskan apakah masih dipakai setelah M6.1 dan M6.4 | Abim |
| #30 | Dokumen status lama | Tutup atau perbarui agar tidak menyesatkan | Bisma |

## 6. Urutan kerja

1. Bisma menjalankan M1.1 dan menyiapkan M1.2. M6.3 sudah menjadi referensi;
   integrasinya ditunda ke M6.6.
2. Izza menjalankan M2.1 dan M6.2; M6.2 memakai notebook remapping Bisma sebagai
   acuan.
3. Pras menyelesaikan G1 lebih dulu, lalu M6.1 dan M3.1. Bandingkan isi PR #51
   dengan `dev` sebelum mengerjakan ulang.
4. Ahmad menjalankan smoke test M4.1 sekarang; uji penuh menunggu G3. M6.4
   menunggu M1.2.
5. Abim menjalankan M5.2 dan M6.5a. M6.5b dan M6.5c menunggu hasil riset.
   M5.1 menunggu model final.
6. Bisma mengerjakan M1.2 setelah G2 dari Pras.
7. Izza mengerjakan M2.2 setelah keputusan bentuk input manual.
8. Pras mengerjakan M3.2 setelah M3.1 selesai.
9. Ahmad mengerjakan M4.2 setelah M4.1 selesai.
10. Bisma mengerjakan M6.6 setelah M6.2 dan M6.3 selesai.
11. Notebook Pras dan Fira disalin ke `ml/notebooks/` setelah dibersihkan dari
    token, output data pribadi, dan path lokal sebelum diajukan lewat PR.

## 7. Aturan dan definisi selesai

1. Maksimal dua tugas aktif per anggota, terdiri dari satu mobile dan satu ML
   pada saat yang sama.
2. Satu tugas = satu branch = satu PR; branch dibuat dari `dev`, PR ke `dev`.
3. Tugas ML yang belum selesai tidak boleh dianggap selesai hanya karena
   notebook sudah berjalan.
4. Status selesai harus memenuhi ambang penerimaan di bagian 3.9. Jika ambang
   diubah, catat alasan dan persetujuan PM.
5. Gate G1 sampai G5 harus dilewati sesuai urutan. Jangan memulai tugas hilir
   sebelum gate selesai.
6. Notebook referensi bukan integrasi aplikasi. M6.3 tidak boleh ditutup sebagai
   integrasi sebelum M6.6 selesai.
7. Jangan menggabungkan PR yang masih konflik atau masih memiliki bug kritis.
8. `flutter analyze` bersih dan seluruh test lulus sebelum PR.
9. Perubahan yang menyentuh database wajib punya test migrasi dari versi
   sebelumnya.
10. Perubahan UI wajib diuji pada perangkat Android nyata dan layar 320 px.
11. Setiap bug dicatat dengan langkah reproduksi dan bukti.
12. Perbarui logbook dan `ai-context/status-proyek.md` setelah tugas selesai.
13. Jangan commit dataset, foto lapangan mentah, `ml/data/`, `ml/runs/`,
    `ml/.venv/`, `*.pt`, `google-services.json`, token Kaggle, atau notebook
    yang masih berisi data pribadi.
14. Sisakan sekitar 20 sampai 30 persen kapasitas untuk review, merge, dan
    regression.
