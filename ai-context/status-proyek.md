# Status Proyek

Diperbarui: 26 Oktober 2026 (branch `dev`)

## 1. Ringkasan

| Area | Kondisi |
|---|---|
| Aplikasi (UI) | Fondasi selesai, semua layar wireframe ada dan responsif |
| Penyimpanan (E2) | Belum mulai; data lemari masih in-memory |
| Autentikasi (E3) | Belum mulai; login masih palsu in-memory |
| Model 1 (E4) | Pipeline 6 skrip siap di PR #3, belum dilatih karena dataset belum ada |
| Modul warna (E5) | Belum mulai |
| Model 3 (E6) | Aturan harmoni selesai dan sudah digabung; MLP belum |
| Integrasi (E7) | Belum bisa mulai, menunggu E4.6 dan E6.6 |
| QA (E9) | Test warna dan smoke test berjalan; rencana uji belum disusun |
| Dokumentasi (E10) | Logbook minggu 1-8 dan laporan milestone 1 selesai |

## 2. Yang sudah selesai

- E1 fondasi aplikasi: tema, 14 rute, `StatefulShellRoute` Home/Lemari,
  tangkap kamera.
- PR #4 (UI Figma dan fondasi) digabung ke `main` pada `4082938`.
- Perbaikan layout responsif: overflow dihapus, `NestedScrollView` pada Detail,
  batas lebar konten, navigasi adaptif.
- Aturan harmoni warna (`lib/services/color_harmony.dart`) beserta 17 test,
  digabung lewat PR #2.
- PR #3 (pipeline Model 1): enam skrip ML, label map tiga dataset, panduan
  Model 1 versi Bahasa Indonesia. Menunggu review.
- Dokumen: logbook minggu 1-8, laporan milestone 1, keputusan lisensi dataset
  bebas (Clothing Full CC0, Fashion Product Images MIT, Carousell MIT).
- `AGENTS.md` dan `ai-context/` ditambahkan di branch `dev`.

## 3. Test

- `test/color_harmony_test.dart`: 17 test.
- `test/widget_test.dart`: 1 smoke test splash.
- Total 18 test lulus, `flutter analyze` bersih.

## 4. Penghambat

1. **Dataset belum terunduh (E4.1).** Tiga zip Kaggle harus masuk ke
   `ml/data/raw/`. Tanpa ini, E4.2-E4.6 dan seluruh E7 tertahan.
2. **PR #3 belum direview.** Jalur ML menunggu penggabungan pipeline.
3. **E7 menunggu artefak model.** Integrasi baru bisa mulai setelah E4.6 dan
   E6.6 menghasilkan `.tflite`.
4. **Firebase belum dikonfigurasi.** `google-services.json` belum ada, sehingga
   E3.1 akan memerlukan setup proyek Firebase dan berkas kunci (jangan commit).

## 5. Langkah berikut

Urutan yang disarankan:

1. Review dan gabungkan PR #3.
2. Unduh tiga dataset, jalankan EDA, lalu E4.2 (split).
3. Sambil menunggu data: E2.1-E2.2 (Abim), E3.1 (Bisma), E5.1-E5.2
   (Faatihurrizki), E8.1 dan E8.6 (Izza).
4. Setelah split siap: E4.3 baseline dan E4.4 pelatihan (Ahmad).
5. Setelah model jadi: E4.5 evaluasi, E4.6 ekspor, lalu E7.

## 6. Catatan branch

| Branch | Isi |
|---|---|
| `main` | Versi stabil; semua rute UI sudah ada |
| `dev` | Integrasi dan uji bersama; berisi `AGENTS.md` dan `ai-context/` |
| `ml/model1-pipeline` | PR #3, pipeline Model 1 |
| `feat/color-harmony-rules` | Sudah digabung lewat PR #2 |
| `feat/app-foundation` | Sudah digabung lewat PR #4 |

Branch lama yang hanya berisi commit kosong atau dokumen sebaiknya dihapus
agar tidak membingungkan.
