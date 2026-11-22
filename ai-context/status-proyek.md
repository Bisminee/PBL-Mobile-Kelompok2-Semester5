# Status Proyek

Diperbarui: 23 November 2026 (setelah PR #59 di `dev`)

## 1. Ringkasan

| Area | Kondisi |
|---|---|
| Aplikasi (UI) | Alur kamera, pratinjau, crop, hasil deteksi, lemari, rekomendasi, dan detail outfit berjalan |
| Penyimpanan (E2) | SQLite aktif. Database versi 4 menambah lima warna baru. Riwayat rekomendasi dan unit test DAO sudah ada |
| Autentikasi (E3) | Selesai: login Google, profil Firestore, sesi, logout, hapus akun |
| Model 1 (E4) | Model 9 kelas selesai dilatih, tetapi aset aplikasi masih model 15 kelas |
| Modul warna (E5) | 16 keluarga warna sebagai acuan. Ekstraksi piksel masih HSV; K-Means Dart belum |
| Segmentasi | Belum diimplementasikan. Wacana ada di `ai-context/wacana-segmentasi-warna.md` (diabaikan Git) |
| Model 3 (E6) | Aturan harmoni dan skor pasangan berjalan. MLP masih data sintetis |
| Integrasi (E7) | Loader TFLite, inferensi, rekomendasi per piece, dan fallback aturan berjalan. Latensi belum diukur |
| Fitur aplikasi (E8) | Lemari, Home, Profil, detail pakaian, edit atribut, detail outfit tersimpan, dan menu tekan lama berjalan |
| QA (E9) | 135 test lulus; `flutter analyze` bersih. APK debug sudah diuji di HP Android |
| Dokumentasi (E10) | Logbook, laporan milestone, model card, dan dokumen tugas ML tersedia |

## 2. Perubahan mobile terbaru (PR #59)

| Fitur | Kondisi |
|---|---|
| Pratinjau kamera | Tiga tombol simetris: Ambil Ulang/Pilih Ulang, Sesuaikan, Gunakan Foto |
| Crop | Tersedia untuk foto kamera dan galeri |
| Nama berkas | Tidak ditampilkan lagi |
| Chip kualitas foto | Disembunyikan; catatan TODO ada di kode |
| Label confidence | Berubah menjadi `MIRIP` |
| Warna | Warna dari gambar tetap tampil; pengguna bisa memilih 16 warna acuan |
| Edit pakaian | Tombol pensil mengubah jenis, warna, formalitas, dan style |
| Rekomendasi | Maksimal tiga outfit per atasan/bawahan; halaman dapat difokuskan ke satu item |
| Outfit tersimpan | Bisa dibuka detailnya; persentase dan tombol hapus sejajar |
| Simpan outfit | Outfit hilang dari rekomendasi, masuk riwayat dan outfit tersimpan |
| Hapus outfit | Tersedia dari tombol dan menu tekan lama |
| Tekan lama | Pakaian dan outfit tersimpan menampilkan menu Lihat, Edit, Hapus |
| Flash kamera | Berfungsi dengan urutan Off, Auto, On |

Database lokal naik ke versi 4. Migrasi menambahkan `cream`, `maroon`, `olive`,
`teal`, dan `navy` ke `ref_color` agar edit atribut memakai 16 keluarga warna.

## 3. Status ML

| Komponen | Kondisi | Bukti |
|---|---|---|
| Model 1 v1 | 9 kelas, akurasi test 94,34 persen, macro F1 89,48 persen | `ml/reports/model1-card.md`, `ml/reports/model1_test_summary.json` |
| Model 1 v3 | 10 kelas termasuk `other`, TFLite gagal saat diuji dengan preprocessing aplikasi: 3 dari 270 foto benar | PR #32 |
| Aset aplikasi | Masih `yolo11n_cls.tflite` 15 kelas, 5,97 MB | `assets/models/` |
| Modul 2 | HSV area tengah dan 16 keluarga warna acuan. K-Means hanya ada di Python | `color_extractor.dart`, `color_family.dart` |
| Model 3 | MLP sintetis AUC 0,976 dan P@3 0,455; aturan harmoni dipakai aplikasi | PR #22, `ml/reports/model3_metrics.json` |

Keputusan ML yang belum final:

1. Dataset tunggal untuk T1.
2. `other` menjadi kelas ke-10 atau gate terpisah.
3. Cakupan T3: ekstraksi warna, penilaian pasangan warna, atau keduanya.
4. Apakah segmentasi dipakai on-device atau hanya offline.

## 4. Test

| Kondisi | Hasil |
|---|---|
| `flutter analyze` | Bersih |
| `flutter test` | 135 test lulus |
| APK debug | Berhasil build dan terpasang di SM A325F |
| Uji UI perangkat | Pratinjau, tekan lama, detail outfit, dan edit atribut sudah dicoba |
| Inferensi TFLite | Belum ada test integrasi otomatis |

Test baru yang relevan:

1. `test/camera_preview_test.dart` termasuk layar 320 px.
2. `test/camera_overlay_test.dart` untuk flash.
3. `test/clothing_detail_test.dart` untuk form edit.
4. `test/saved_outfit_test.dart` untuk konversi detail.
5. `test/saved_outfit_card_test.dart` untuk tap dan tekan lama.

## 5. PR

| PR | Isi | Status |
|---|---|---|
| #59 | Revisi alur mobile dan rekomendasi per piece | Digabung ke `dev` |
| #32 | Penolakan objek dan model 10 kelas | Belum valid, jangan digabung |
| #30 | Dokumen status lama | Perlu ditutup atau diperbarui |
| #22, #23, #26, #31 | Perbaikan ML, dataset, auth | Sudah diperbaiki dan menunggu review |

## 6. Penghambat

1. Aset aplikasi masih model 15 kelas; model latihan 9 kelas belum dipasang.
2. Model v3 10 kelas tidak valid pada TFLite dengan preprocessing aplikasi.
3. K-Means di Dart belum diimplementasikan.
4. Segmentasi pakaian belum ada; warna masih memakai crop tengah dan HSV.
5. Model 3 masih memakai data sintetis.
6. Tabel ML masih 14 warna; warna baru hanya tersedia di `ref_color` untuk
   penyimpanan, belum tentu punya skor pasangan.
7. Web belum bisa dikompilasi karena `tflite_flutter` dan `ffi`.
8. Uji inferensi TFLite dan latensi perangkat belum otomatis.

## 7. Langkah berikut

1. Putuskan dataset T1 dan bentuk kelas `other`.
2. Perbaiki atau ekspor ulang TFLite model v3, lalu uji dengan preprocessing
   aplikasi.
3. Selesaikan E4.6 dan pasang model final di `assets/models`.
4. Implementasikan K-Means di Dart dan sambungkan ke mask bila segmentasi siap.
5. Lengkapi tabel ML untuk 16 warna atau gunakan `legacy_family`.
6. Ukur latensi dan ukuran APK.
7. Tutup atau perbarui PR #30; putuskan #31 dan #32.

## 8. Catatan branch

| Branch | Isi |
|---|---|
| `main` | Versi stabil, belum menerima penggabungan `dev` |
| `dev` | Jalur integrasi setelah PR #59 |
| `feat/mobile-flow-revision` | Branch revisi mobile, sudah digabung |
| `ml/color-mapping-notebook` | Arsip notebook pemetaan warna 16 keluarga |
| `revert/color-mapping-notebook` | Revert notebook dari `dev` |
