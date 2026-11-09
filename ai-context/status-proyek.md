# Status Proyek

Diperbarui: 9 November 2026 (minggu 11, branch `dev`)

## 1. Ringkasan

| Area | Kondisi |
|---|---|
| Aplikasi (UI) | Fondasi dan seluruh layar utama selesai. Galeri, crop, simpan outfit, dan pencarian lemari sudah ada |
| Penyimpanan (E2) | SQLite aktif, simpan outfit dan foto di folder aplikasi berjalan. Riwayat rekomendasi dan unit test DAO belum |
| Autentikasi (E3) | Selesai: login Google, profil Firestore, sesi, logout, hapus akun |
| Model 1 (E4) | Model v3: dataset HF + COCO negatif, 10 kelas termasuk `long_sleeve`, akurasi test 96,88 persen, macro F1 88,24 persen |
| Modul warna (E5) | Ekstraksi warna HSV dan palet 14 warna berjalan. K-Means di Dart (E5.2) dan unit test warna (E5.4) belum |
| Model 3 (E6) | Aturan harmoni dan skor pasangan berjalan. MLP masih data sintetis. Metrik di PR #22 menunggu perbaikan |
| Integrasi (E7) | Loader TFLite, inferensi, mesin rekomendasi, fallback aturan, dan tab Detail berjalan. Latensi (E7.6) belum |
| Fitur aplikasi (E8) | Lemari, Home, Profil, Detail, simpan outfit, pencarian, dan galeri berjalan. Halaman Admin dan CRUD lengkap belum |
| QA (E9) | 80 test otomatis lulus, `flutter analyze` bersih, rencana uji 34 kasus ada. Uji fungsional dan perangkat belum |
| Dokumentasi (E10) | Logbook minggu 1 sampai 7, laporan Milestone 1, model card v1 dan v3, dokumen tugas ML per anggota |

## 2. Status kode (selesai)

- Model 1 v3 dilatih di Colab: 10 kelas termasuk `long_sleeve` dan `other`,
  27 epoch, akurasi test 96,88 persen, macro F1 88,24 persen, kelas `other`
  F1 1,000.
- TFLite int8 1,76 MB, input `[1, 3, 224, 224]`, output `[1, 10]`, sudah
  diverifikasi dengan interpreter.
- Label model dipetakan ke kamus database: `tshirt` menjadi `t_shirt`,
  `long_pants` menjadi `pants`, `long_sleeve` menjadi `longsleeve`,
  `outerwear` menjadi `outwear`.
- Ambang penolakan 0,50 divalidasi pada test set v3: `other` ditolak
  100 persen, pakaian salah ditolak 0,63 persen, akurasi pakaian diterima
  97,08 persen.
- Pipeline ML: `13_prepare_hf.py`, `10_eval_field.py`,
  `11_download_negatives.py`, `12_run_model1_pipeline.py`,
  `14_threshold_sweep.py`, dan notebook Colab.
- Fitur aplikasi: foto Lemari dinamis, titik warna sesuai hasil deteksi, sub-tab
  Outfit Tersimpan dengan search dan filter, foto outfit dinamis di Home,
  maksimal 4 item terbaru, kartu jumlah kategori.
- Autentikasi: mode uji dibatasi ke build debug atau `DEV_SKIP_AUTH`, login
  Google dengan pesan error jelas, edit nama profil, preferensi notifikasi
  tersimpan lokal, logout mode uji diperbaiki.
- Ikon aplikasi memakai logo Sera-Z dan nama aplikasi `Sera-Z`.

## 3. Menunggu review

| Branch | Isi | Catatan |
|---|---|---|
| `feat/non-clothing-object` | Kelas `other`, label 10 kelas sesuai database, model v3, layar penolakan | Ambang 0,50 sudah divalidasi |
| `ml/model1-v2-pipeline` | Pipeline dataset HF, COCO negatif, notebook Colab | Script 09 diganti 13 agar tidak bentrok |
| `feat/profile-auth` | Login tanpa akun, edit profil, preferensi | Mode uji dibatasi ke debug |
| `docs/status-minggu-6` | Dokumen status ini | - |

## 4. Sudah digabung ke `dev`

| PR | Isi |
|---|---|
| #33 | Dokumen ML per anggota dan status minggu 7 |
| #29 | Ikon aplikasi Sera-Z |
| #28 | Perbaikan overflow teks dan baris info |
| #27 | Foto outfit dinamis dan ringkasan kategori Home |
| #25 | Simpan outfit, daftar outfit, pencarian dan filter Lemari |
| #24 | Tombol galeri di layar kamera dan Photo Picker |
| #21 | Halaman crop 1:1 untuk foto galeri |
| #20 | Impor galeri |
| #18 | Palet 14 warna dan unit test |
| #17 | Profil sesuai akun Google |
| #16 | Perapian UI autentikasi |
| #15 | Fallback rekomendasi aturan |
| #14 | Pembersihan kode mati |
| #13 | Integrasi SQLite dan TFLite |

## 5. Penghambat

1. **Uji foto lapangan belum dijalankan.** 150 foto lapangan belum terkumpul,
   sehingga akurasi 96,88 persen baru berlaku pada test katalog.
2. **Kelas `long_sleeve` dan `outerwear` masih lemah.** F1 `long_sleeve` 0,758
   dan `outerwear` 0,687 karena data jaket menyusut setelah sweatshirts dan
   sweaters dipindah ke `long_sleeve`.
3. **Model 3 masih memakai data sintetis.** AUC tinggi bukan bukti generalisasi.
4. **Uji perangkat belum menyeluruh.** Login, logout, dan hapus akun belum
   diuji sistematis di HP.
5. **Uji fungsional dan rencana QA formal belum dieksekusi.** Rencana 34 kasus
   sudah ada.

## 6. Langkah berikut (minggu 11)

1. Kumpulkan 150 foto lapangan, jalankan `10_eval_field.py`.
2. Review dan gabungkan branch non-clothing, ML, profile-auth, dan docs.
3. Uji perangkat untuk login, logout, simpan outfit, dan penolakan objek.
4. Lengkapi laporan evaluasi model v3 dan perbarui model card.
5. Jalankan uji fungsional 34 kasus dan uji regresi.
6. Lengkapi halaman Admin dan CRUD lemari.

## 7. Catatan branch

| Branch | Isi |
|---|---|
| `main` | Versi stabil |
| `dev` | Jalur integrasi, sudah memuat PR #13-#33 |
| `wip/backup` | Cadangan lokal semua perubahan, tidak di-push |
| `feat/gallery-camera` | Sudah digantikan PR #24, boleh dihapus |
| `fix/google-login` | Sudah digantikan `feat/profile-auth`, boleh dihapus |
| `chore/model1-v2-assets` | Duplikat, model sudah di `feat/non-clothing-object`; tutup PR #34 |
| `ml/model1-pipeline` | Branch lama, PR #3 ditutup; boleh dihapus |
| `pras` | Branch sampah; boleh dihapus |
