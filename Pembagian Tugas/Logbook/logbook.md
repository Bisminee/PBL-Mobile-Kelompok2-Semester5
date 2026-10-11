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
- Status mingguan: ✅ selesai · 🟡 berjalan · ⬜ belum mulai.

---

## Ringkasan Mingguan

| Minggu | Periode | Fokus | Status |
|--------|---------|-------|--------|
| 1 | 28 Sep – 4 Okt | Fondasi aplikasi (E1): navigasi, layar, state, kamera, dokumentasi | ✅ |
| 2 | 5 – 11 Okt | | ⬜ |
| 3 | 12 – 18 Okt | | ⬜ |
| 4 | 19 – 25 Okt | | ⬜ |
| 5 | 26 Okt – 1 Nov | | ⬜ |
| 6 | 2 – 8 Nov | | ⬜ |
| 7 | 9 – 15 Nov | | ⬜ |
| 8 | 16 – 22 Nov | | ⬜ |
| 9 | 23 – 29 Nov | | ⬜ |
| 10 | 30 Nov – 6 Des | | ⬜ |

---

## Minggu 1 — 28 Sep s.d. 4 Okt 2026

**Status:** ✅ Selesai
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

**Ringkasan capaian Minggu 1:** fondasi aplikasi selesai (E1 ✅), dokumentasi & pembagian tugas siap, 8 branch tugas independen sudah tersedia di GitHub.

**Kendala terbuka (dibawa ke minggu berikutnya):**
1. `gh` CLI belum login → PR dibuat manual lewat GitHub.
2. Developer Mode Windows belum aktif → aktifkan sebelum build plugin di desktop.
3. Fitur connector Figma tidak tersedia → interaksi prototype ditambahkan manual.

---

## Minggu 2 — 5 s.d. 11 Okt 2026

**Status:** ⬜ Belum mulai
**Fokus:** _(_isi fokus minggu ini_)_

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| | | | | | |

**Ringkasan capaian:**

**Kendala terbuka:**

---

## Minggu 3 — 12 s.d. 18 Okt 2026

**Status:** ⬜ Belum mulai
**Fokus:**

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| | | | | | |

**Ringkasan capaian:**

**Kendala terbuka:**

---

## Minggu 4 — 19 s.d. 25 Okt 2026

**Status:** ⬜ Belum mulai
**Fokus:**

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| | | | | | |

**Ringkasan capaian:**

**Kendala terbuka:**

---

## Minggu 5 — 26 Okt s.d. 1 Nov 2026

**Status:** ⬜ Belum mulai
**Fokus:**

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| | | | | | |

**Ringkasan capaian:**

**Kendala terbuka:**

---

## Minggu 6 — 2 s.d. 8 Nov 2026

**Status:** ⬜ Belum mulai
**Fokus:**

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| | | | | | |

**Ringkasan capaian:**

**Kendala terbuka:**

---

## Minggu 7 — 9 s.d. 15 Nov 2026

**Status:** ⬜ Belum mulai
**Fokus:**

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| | | | | | |

**Ringkasan capaian:**

**Kendala terbuka:**

---

## Minggu 8 — 16 s.d. 22 Nov 2026

**Status:** ⬜ Belum mulai
**Fokus:**

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| | | | | | |

**Ringkasan capaian:**

**Kendala terbuka:**

---

## Minggu 9 — 23 s.d. 29 Nov 2026

**Status:** ⬜ Belum mulai
**Fokus:**

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| | | | | | |

**Ringkasan capaian:**

**Kendala terbuka:**

---

## Minggu 10 — 30 Nov s.d. 6 Des 2026

**Status:** ⬜ Belum mulai
**Fokus:**

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| | | | | | |

**Ringkasan capaian:**

**Kendala terbuka:**
