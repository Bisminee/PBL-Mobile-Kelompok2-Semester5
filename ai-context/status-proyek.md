# Status Proyek

Diperbarui: 2 November 2026 (branch `dev`)

## 1. Ringkasan

| Area | Kondisi |
|---|---|
| Aplikasi (UI) | Fondasi selesai, seluruh layar utama ada dan responsif |
| Penyimpanan (E2) | SQLite aktif; riwayat rekomendasi dan test DAO tersisa |
| Autentikasi (E3) | Selesai: login Google, profil Firestore, sesi, logout, hapus akun |
| Model 1 (E4) | Dataset 33.667 gambar, baseline 89,37 persen, YOLOv11n-cls 94,34 persen test |
| Modul warna (E5) | Ekstraksi warna ada; palet 14 warna dan test tersisa |
| Model 3 (E6) | Aturan harmoni selesai; MLP data sintetis; metrik AUC belum |
| Integrasi (E7) | Loader TFLite, inferensi, dan mesin rekomendasi jalan; fallback dan latensi tersisa |
| Fitur aplikasi (E8) | Lemari, Home, Profil, Detail, simpan outfit jalan; Admin dan CRUD lengkap tersisa |
| QA (E9) | 39 test otomatis lulus; rencana uji formal belum |
| Dokumentasi (E10) | Logbook minggu 1-6, laporan Milestone 1, model card |

## 2. Yang sudah selesai

- E1 fondasi aplikasi: tema, 14 rute, `StatefulShellRoute` Home/Lemari, kamera.
- UI Figma dan layout responsif (PR #4), termasuk 26 widget test.
- Aturan harmoni warna CIELCh dan 17 unit test (PR #2).
- E3 autentikasi Firebase (PR #8-#12): login Google, profil `users` dan
  `profiles`, sesi persisten, logout, hapus akun.
- E4 Model 1 (PR #6 dan #7): dataset 33.667 gambar dari tiga sumber bebas,
  split 70/15/15, baseline MobileNetV2 89,37 persen, YOLOv11n-cls 94,34 persen
  pada test dengan macro F1 89,48 persen, laporan evaluasi, dan model card.
- Integrasi SQLite dan TFLite (PR #13): aset `fashion_app.db`, CRUD lemari,
  simpan outfit, pemuat TFLite, klasifikasi jenis, ekstraksi warna, mesin
  rekomendasi.
- Pembersihan kode mati (PR #14): aturan harmoni dipakai pada alasan rekomendasi,
  widget tak terpakai dihapus.
- Dokumen: logbook minggu 1-6, laporan Milestone 1, timeline, pembagian tugas
  minggu 6.

## 3. Test

- 39 test lulus.
- Cakupan: harmoni warna, garment, label, color extractor, recommender, widget.
- `flutter analyze` bersih.

## 4. Penghambat

1. **Ekspor TFLite model sendiri gagal di Windows.** Ultralytics 8.4 menghapus
   dukungan TFLite di Windows; jalur `onnx2tf` pada 8.3 melewati batas waktu.
   Solusi: ekspor lewat Colab atau Linux.
2. **Model 3 masih memakai data sintetis.** AUC tinggi bukan bukti generalisasi;
   tulis sebagai keterbatasan.
3. **Uji perangkat belum.** Login, logout, dan hapus akun belum diuji di HP.
4. **Rencana QA formal belum disusun.**
5. **Label aplikasi belum sesuai model.** `labels.txt` masih 15 label lama,
   sedangkan model punya 9 kelas.

## 5. Langkah berikut

Fokus minggu 6 (2-8 November 2026):

1. Riwayat rekomendasi dan unit test DAO (Bisma).
2. Fallback aturan dan rapikan UI autentikasi (Bisma).
3. Ekspor TFLite, metrik Model 3, palet warna, dan dokumentasi ML (Bisma).
4. Rencana QA dan uji perangkat (Bisma).
5. Halaman Admin dan CRUD lemari lengkap (Izza).
6. Edit profil, label 9 kelas, dan latensi (Abim).

Rincian ada di `Pembagian Tugas/pembagian-tugas-minggu-6.md` dan
`Pembagian Tugas/panduan-kerja-bisma-minggu-6.md`.

## 6. Catatan branch

| Branch | Isi |
|---|---|
| `main` | Versi stabil, `4082938` |
| `dev` | Satu-satunya jalur integrasi, berisi seluruh pekerjaan sampai PR #14 |
| `data-training` | Branch lama, PR #5 ditutup; boleh dihapus |
| `ml/model1-pipeline` | Branch lama, PR #3 ditutup; boleh dihapus |
| `pras` | Branch sampah; boleh dihapus |

`dev-ml` sudah digabung ke `dev` dan dihapus pada 2 November 2026.
