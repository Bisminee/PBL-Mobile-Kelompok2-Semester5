# Logbook Mingguan — Sera-Z

**Proyek:** Sera-Z — Aplikasi Rekomendasi Kombinasi Gaya Pakaian Berbasis Machine Learning
**Tim:** Bisma Adhiaksa (PM & QA) · Abim Mustawa (Mobile Dev) · Ahmad Falahi (ML Eng) · Faatihurrizki Prasojo (ML Eng) · Izza Dhafira Fanani (Sekretaris/Dokumentator)
**Mata kuliah:** Pemrograman Mobile · Pembelajaran Mesin · Penjaminan Mutu Perangkat Lunak (TI-3D)
**Periode:** 28 September – 4 Desember 2026 (10 minggu)

---

## Cara Mengisi

- Isi **setiap minggu**, jangan menumpuk di akhir.
- Kolom **Bukti/Link** diisi tautan commit, PR, dokumen, atau foto kegiatan.
- Format tanggal: `28 Sep`.
- Status mingguan: Selesai · Berjalan · Belum mulai.

---

## Ringkasan Mingguan

| Minggu | Periode | Fokus | Status |
|--------|---------|-------|--------|
| 1 | 28 Sep – 4 Okt | Fondasi aplikasi (E1): navigasi, layar, state, kamera, dokumentasi | Selesai |
| 2 | 5 – 11 Okt | Logika harmoni warna (E6.4), alur Pull Request | Berjalan |
| 3 | 12 – 18 Okt | Pipeline Model 1 (PR #3), kualitas UI, keputusan lisensi dataset, persiapan E4.1 | Berjalan |
| 4 | 19 – 25 Okt | Susulan jalur ML (E4.1–E4.3) + evaluasi/ekspor Model 1, warna, penyimpanan, login | Belum |
| 5 | 26 Okt – 1 Nov | Latih YOLOv11n-cls, palet warna, MLP Model 3, profil & sesi, UI lemari | Belum |
| 6 | 2 – 8 Nov | Evaluasi & ekspor MLP, integrasi loader TFLite, konten Home | Belum |
| 7 | 9 – 15 Nov | Sign out, ranking + fallback + latensi, halaman Admin & Profil, uji usability | Belum |
| 8 | 16 – 22 Nov | Ranking + explainability, tab Detail, pengujian fungsional, konsolidasi evaluasi, draf laporan M1 | Belum |
| 9 | 23 – 29 Nov | | Belum |
| 10 | 30 Nov – 6 Des | | Belum |

---

## Minggu 1 — 28 Sep s.d. 4 Okt 2026

**Status:** Selesai
**Fokus:** Membangun fondasi aplikasi (Epic E1) dan menyiapkan dokumentasi serta pembagian tugas.

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| 28 Sep | Setup proyek | Inisialisasi repositori Git, menetapkan alur branch per fitur, `flutter create` (paket `sera_z`), menyusun struktur folder (`config`, `models`, `screens`, `services`, `widgets`) | — | Lanjut ke navigasi | Commit `first commit` |
| 29 Sep | Arsitektur & navigasi | Menyiapkan tema Material 3, membangun navigasi `go_router`, membuat 7 layar (Login, Sign up, Home, Kamera, Lemari, Rekomendasi, Detail) | `go_router` 18.x tidak kompatibel dengan SDK Dart proyek (menarik paket `material_ui`/`cupertino_ui`) → dipin ke `^17.5.0` | Menyambungkan antar layar | `lib/main.dart`, `lib/config/app_theme.dart` |
| 30 Sep | Fitur kamera | Pratinjau kamera langsung, ganti kamera depan/belakang, ambil foto, penanganan izin Android & iOS | Developer Mode Windows belum aktif (peringatan symlink saat build plugin) | Integrasi ke alur | `lib/screens/camera_screen.dart`, `AndroidManifest.xml` |
| 1 Okt | State & alur | Menambahkan Riverpod, model data (Garment, Outfit), provider (auth, lemari, rekomendasi), dan menyambungkan alur Login → Home → Kamera → Rekomendasi → Detail | — | Menyiapkan penyimpanan data | `lib/services/providers.dart`, `lib/models/` |
| 2 Okt | Uji kualitas dasar | Menjalankan analisis statis (bersih) dan 2 widget test (layar awal + alur login) | — | Menambah test menyusul | `test/widget_test.dart` |
| 3 Okt | Dokumentasi teknis | Menyusun dokumen konteks: proposal, referensi metodologi, arsitektur data, wireframe & UX spec, penjelasan epic | Fitur *connectors* Figma tidak tersedia di versi akun → pendekatan plugin flow dibatalkan | Melanjutkan dokumen interaksi manual | `context/`, `docs/wireframe-interactions.md` |
| 4 Okt | Pembagian tugas | Menyusun rincian fitur & pembagian tugas, kolam tugas tanpa pemilik, daftar epic, pemetaan branch, lalu membuat 8 branch tugas independen dan mem-push-nya | `gh` CLI belum login → pembuatan PR masih manual | Mulai E2.1, E6.4, E9.1 | `Pembagian Tugas/`, commit `ab26e44` |

**Ringkasan capaian Minggu 1:** fondasi aplikasi selesai (E1), dokumentasi & pembagian tugas siap, 8 branch tugas independen sudah tersedia di GitHub.

**Kendala terbuka (dibawa ke minggu berikutnya):**
1. `gh` CLI belum login → PR dibuat manual lewat GitHub.
2. Developer Mode Windows belum aktif → aktifkan sebelum build plugin di desktop.
3. Fitur connector Figma tidak tersedia → interaksi prototype ditambahkan manual.

---

## Minggu 2 — 5 s.d. 11 Okt 2026

**Status:** Berjalan
**Fokus:** Mengerjakan tugas independen pertama (logika harmoni warna), membuka alur Pull Request, dan memperbarui dokumentasi.

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| 11 Okt | Harmoni warna (E6.4) | Mengimplementasikan 4 aturan harmoni (monochromatic, analogous, complementary, neutral) pada ruang warna CIELCh; fungsi evaluasi pasangan warna dan outfit; ambang yang dapat diubah; keluaran skor 0–1 + nama aturan untuk *explainability* | Nilai warna uji harus dipilih di ruang Lab (bukan HSV) agar kasus komplementer terukur | Integrasi ke skor cadangan rekomendasi (E7.5) | `lib/services/color_harmony.dart`, commit `ebf6c53` |
| 11 Okt | Pengujian | Menulis 17 unit test: konversi warna, jarak hue, tiap aturan, kasus akromatik, agregasi outfit, dan ambang | — | Menambah test saat integrasi UI | `test/color_harmony_test.dart` |
| 11 Okt | Kualitas & rilis | Analisis statis bersih, seluruh test lulus (19), dokumentasi fitur ditulis, lalu membuka Pull Request ke `main` | — | Review dan gabung PR | PR #2, `docs/features/004-color-harmony-rules.md` |

**Ringkasan capaian:** Tugas independen E6.4 selesai. Logika harmoni warna siap dipakai sebagai fitur Model 3, lapisan *explainability*, dan skor cadangan.

**Kendala terbuka:**
1. Harmoni warna belum tersambung ke UI maupun Model 3 (menunggu E7.4/E7.5).
2. PR #2 menunggu review sebelum digabung ke `main`.
3. Gunakan alur branch → PR untuk tugas berikutnya (bukan langsung ke `main`).

---

## Minggu 3 — 12 s.d. 18 Okt 2026

**Status:** Berjalan
**Fokus:** Pipeline Model 1 (PR #3), perbaikan kualitas UI (responsive layout), keputusan lisensi dataset, dan persiapan E4.1 (dataset + EDA).

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| 13 Okt | Pipeline Model 1 | Menyusun pipeline lengkap E4.1–E4.6: 6 script ML (persiapan dataset, penyeimbang, baseline, latih YOLOv11n-cls, evaluasi, ekspor TFLite), label maps 3 dataset, panduan teknis + rencana kerja tim; membuka PR #3 | Menunggu reviewer | Review & gabung PR #3 | PR #3, commit `febf71b` |
| 15–16 Okt | Kualitas UI | Memperbaiki overflow layout & menambah scrolling (Detail: `NestedScrollView` + tab pinned; `MaxWidthBox`; `BottomAppBar` adaptif); 26 widget test responsif di 4 ukuran layar; `flutter analyze` bersih, 45 test lulus | — | — | commit `5bbe1ac`, `test/layout_test.dart` |
| 16 Okt | Dataset & dokumen | Audit lisensi dataset (20+ kandidat) → memilih paket bebas: Clothing Full (CC0), Fashion Product Images (MIT), Carousell (MIT); mengganti dataset non-komersial di rencana (FashionStylist → Marqo/polyvore + Garments2Look; Digikala → `baseColour`); menyelaraskan dokumen tugas E4/E5/E6; menulis ulang panduan Model 1 & `ml/README` (Bahasa Indonesia) | — | Unduh dataset | commit `f3ffa00`; PR #3 (`4183345`, `7145600`) |
| 18 Okt | Persiapan E4.1 | Menyiapkan lingkungan ML (`ml/.venv`: pandas, pillow, matplotlib), menulis skrip EDA `ml/scripts/00_eda.py`, membuat `ml/data/raw/`; mulai unduh 3 dataset manual dari Kaggle | Dataset belum selesai diunduh (manual via browser) | Jalankan EDA → E4.2 | `ml/scripts/00_eda.py` |

**Ringkasan capaian:** Pipeline Model 1 diajukan lewat PR #3 (menunggu review); PR #2 (harmoni warna) digabung ke `main`; perbaikan responsive layout masuk `main` (45 test lulus); keputusan lisensi dataset difinalkan + dokumen tugas diselaraskan (E4/E5/E6); lingkungan ML + skrip EDA siap; branch bernama orang dibersihkan. Jalur ML (dataset) masih menunggu unduhan.

**Kendala terbuka:**
1. Dataset belum diunduh → EDA & E4.2 bergeser (jalur kritis).
2. PR #3 menunggu reviewer.
3. Harmoni warna belum tersambung ke UI/Model 3 (menunggu E7.4/E7.5).

---

## Minggu 4 — 19 s.d. 25 Okt 2026

**Status:** Rencana (diperbarui saat minggu berjalan)
**Fokus:** Menyusul jalur ML (dataset + EDA + split) dan memulai pekerjaan paralel: warna, penyimpanan, autentikasi.

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| 19–25 Okt | Susulan & target W4 | Menyusul: unduh dataset + EDA (E4.1), merge/split (E4.2), baseline (E4.3). Target: evaluasi & ekspor TFLite (E4.5–E4.6), K-Means warna (E5.2), pasangan Model 3 (E6.1), penyimpanan (E2.5–E2.6), login (E3.1) | Jalur ML masih mengejar ketertinggalan | Latih YOLOv11n-cls (E4.4); palet warna (E5.3–E5.4); fitur + MLP (E6.2–E6.3); profil & sesi (E3.2–E3.3); UI lemari (E8.1–E8.2) | — |

**Ringkasan capaian:** (rencana — diperbarui saat minggu berjalan)

**Kendala terbuka:** —

---

## Minggu 5 — 26 Okt s.d. 1 Nov 2026

**Status:** Rencana (diperbarui saat minggu berjalan)
**Fokus:** Pelatihan model utama (YOLOv11n-cls), modul warna, Model 3, dan fitur aplikasi.

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| 26 Okt–1 Nov | Pelatihan & fitur | Latih YOLOv11n-cls + fine-tune (E4.4); palet 14 warna + unit test (E5.3–E5.4); feature builder + MLP (E6.2–E6.3); record cloud & sesi (E3.2–E3.3); UI lemari + outfit tersimpan (E8.1–E8.2) | — | Evaluasi + ekspor MLP (E6.5–E6.6); loader TFLite (E7.1–E7.3); konten Home (E8.4) | — |

**Ringkasan capaian:** (rencana — diperbarui saat minggu berjalan)

**Kendala terbuka:** —

---

## Minggu 6 — 2 s.d. 8 Nov 2026

**Status:** Rencana (diperbarui saat minggu berjalan)
**Fokus:** Integrasi model ke aplikasi (TFLite) dan penyelesaian fitur.

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| 2–8 Nov | Integrasi | Evaluasi MLP (E6.5); ekspor TFLite MLP (E6.6); loader + inferensi Model 1 (E7.1–E7.3); konten Home (E8.4) | — | Sign out & hapus akun (E3.4); ranking + fallback + latensi (E7.4–E7.6); halaman Admin & Profil (E8.6–E8.7); uji usability (E9.6) | — |

**Ringkasan capaian:** (rencana — diperbarui saat minggu berjalan)

**Kendala terbuka:** —

---

## Minggu 7 — 9 s.d. 15 Nov 2026

**Status:** Rencana (diperbarui saat minggu berjalan)
**Fokus:** Penyempurnaan integrasi, fitur lanjutan, dan mulai pengujian usability.

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| 9–15 Nov | Penyempurnaan | Sign out + jalur hapus akun (E3.4); skor Model 3 di rekomendasi + fallback + ukur latensi (E7.4–E7.6); halaman Admin (E8.6); halaman Profil (E8.7); mulai uji usability + SUS (E9.6) | — | Ranking + explainability (E8.3); tab Detail (E8.5); pengujian fungsional (E9.2); konsolidasi evaluasi ML (E9.5) | — |

**Ringkasan capaian:** (rencana — diperbarui saat minggu berjalan)

**Kendala terbuka:** —

---

## Minggu 8 — 16 s.d. 22 Nov 2026

**Status:** Rencana (diperbarui saat minggu berjalan)
**Fokus:** Penutupan Milestone 1: pengujian fungsional, konsolidasi evaluasi, dan draf laporan.

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| 16–22 Nov | Penutupan M1 | Ranking + teks explainability (E8.3); tab Detail data nyata (E8.5); eksekusi fungsional black-box + catat bug (E9.2); konsolidasi laporan evaluasi ML (E9.5); tabulasi kuesioner (E10.3); draf laporan Milestone 1 | — | Milestone 2: uji performa & kompatibilitas (E9.3–E9.4), pelacakan bug (E9.7), laporan akhir (E10.4–E10.5) | — |

**Ringkasan capaian:** (rencana — diperbarui saat minggu berjalan)

**Kendala terbuka:** —

---

## Minggu 9 — 23 s.d. 29 Nov 2026

**Status:** Belum mulai
**Fokus:**

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| | | | | | |

**Ringkasan capaian:**

**Kendala terbuka:**

---

## Minggu 10 — 30 Nov s.d. 6 Des 2026

**Status:** Belum mulai
**Fokus:**

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| | | | | | |

**Ringkasan capaian:**

**Kendala terbuka:**
