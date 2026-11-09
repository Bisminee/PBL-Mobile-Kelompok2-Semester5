# Status Proyek

Diperbarui: 9 November 2026 (minggu 11, branch `dev`)

## 1. Ringkasan

| Area | Kondisi |
|---|---|
| Aplikasi (UI) | Seluruh layar utama ada dan responsif; galeri dan crop sudah digabung |
| Penyimpanan (E2) | SQLite aktif; riwayat rekomendasi dan unit test DAO tersisa |
| Autentikasi (E3) | Login Google, profil Firestore, sesi, logout, hapus akun |
| Model 1 (E4) | Model v3: dataset HF + COCO negatif, 10 kelas termasuk `long_sleeve`, akurasi test 96,88 persen, macro F1 88,24 persen |
| Modul warna (E5) | Ekstraksi warna dan palet 14 warna ada; test palet tersisa |
| Model 3 (E6) | Aturan harmoni selesai; MLP data sintetis; metrik AUC belum |
| Integrasi (E7) | Loader TFLite, inferensi, mesin rekomendasi jalan; uji latensi tersisa |
| Fitur aplikasi (E8) | Lemari, Home, Profil, Detail, simpan outfit, pencarian, dan filter jalan |
| QA (E9) | 80 test otomatis lulus; rencana uji formal belum |
| Dokumentasi (E10) | Logbook minggu 1-10, laporan Milestone 1, model card v1 dan v2 |

## 2. Status kode (selesai)

- Model 1 v3 dilatih di Colab: 10 kelas termasuk `long_sleeve` dan `other`,
  27 epoch, akurasi test 96,88 persen, macro F1 88,24 persen, kelas `other`
  F1 1,000.
- TFLite int8 1,76 MB, input `[1, 3, 224, 224]`, output `[1, 10]`, sudah
  diverifikasi dengan interpreter.
- Label model dipetakan ke kamus database: `tshirt` menjadi `t_shirt`,
  `long_pants` menjadi `pants`, `long_sleeve` menjadi `longsleeve`,
  `outerwear` menjadi `outwear`.
- Pipeline ML: `13_prepare_hf.py`, `10_eval_field.py`,
  `11_download_negatives.py`, `12_run_model1_pipeline.py`, dan notebook Colab.
- Fitur aplikasi: foto Lemari dinamis, titik warna sesuai hasil deteksi, sub-tab
  Outfit Tersimpan dengan search dan filter, foto outfit dinamis di Home,
  maksimal 4 item terbaru, kartu jumlah kategori.
- Autentikasi: mode uji dibatasi ke build debug atau `DEV_SKIP_AUTH`, login
  Google dengan pesan error yang jelas, edit nama profil, preferensi notifikasi
  tersimpan lokal, logout mode uji diperbaiki.
- Ikon aplikasi memakai logo Sera-Z dan nama aplikasi `Sera-Z`.

## 3. Menunggu review

| Branch | Isi | Catatan |
|---|---|---|
| `ml/model1-v2-pipeline` | Pipeline dataset HF, COCO negatif, notebook Colab | Nomor script 09 diganti 13 agar tidak bentrok dengan `09_eval_model3.py` |
| `feat/non-clothing-object` | Kelas `other`, label 10 kelas sesuai database, model v3, layar penolakan | Ambang 0,50 sudah divalidasi: `other` ditolak 100 persen, pakaian salah ditolak 0,63 persen |
| `feat/profile-auth` | Login tanpa akun, edit profil, preferensi | Mode uji dibatasi ke debug |
| `chore/model1-v2-assets` | Model v2, laporan evaluasi, model card | Digabung setelah non-clothing |
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
2. **Ambang 0,50 sudah divalidasi pada model v3.** Hasil: `other` ditolak
   100 persen, pakaian salah ditolak 0,63 persen, akurasi pakaian diterima
   97,08 persen. Bukti di `ml/reports/model1_v3_threshold_sweep.csv`.
3. **Kelas `long_sleeve` masih lemah.** F1 0,758 dengan 84 gambar uji;
   `outerwear` 0,687 karena data jaket menyusut setelah sweatshirts dan
   sweaters dipindah ke `long_sleeve`.
4. **Model 3 masih memakai data sintetis.** AUC tinggi bukan bukti generalisasi.
5. **Uji perangkat belum menyeluruh.** Login, logout, dan hapus akun belum
   diuji sistematis di HP.
6. **Rencana QA formal belum disusun.**

## 6. Langkah berikut (minggu 11)

1. Kumpulkan 150 foto lapangan, jalankan `10_eval_field.py`.
2. Gunakan ambang 0,50 yang sudah divalidasi; tinjau ulang setelah foto lapangan.
3. Review dan gabungkan branch ML, non-clothing, profile-auth, dan aset model.
4. Uji perangkat untuk login, logout, simpan outfit, dan penolakan objek.
5. Lengkapi laporan evaluasi model v3 dan perbarui model card.
6. Rencana QA dan uji regresi sebelum milestone akhir.

## 7. Catatan branch

| Branch | Isi |
|---|---|
| `main` | Versi stabil |
| `dev` | Jalur integrasi, sudah memuat PR #13-#33 |
| `wip/backup` | Cadangan lokal semua perubahan, tidak di-push |
| `feat/gallery-camera` | Sudah digantikan PR #24, boleh dihapus |
| `fix/google-login` | Sudah digantikan `feat/profile-auth`, boleh dihapus |
| `ml/model1-pipeline` | Branch lama, PR #3 ditutup; boleh dihapus |
| `pras` | Branch sampah; boleh dihapus |
