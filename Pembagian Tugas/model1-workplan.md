# Sera-Z — Rencana Kerja Model 1 (Saran Pembagian untuk Tim)

> **Sifat dokumen: SARAN, tidak mengikat.** Nama di kolom "Saran pemegang" sudah
> diisi berdasarkan peran di proposal, tapi tetap boleh ditukar sesuai aturan
> repo (`pembagian-tugas.md`): tugas terbuka untuk siapa pun. Isi kolom
> **"Diambil oleh"** setelah tim sepakat, lalu update `branches.md`.

**Tim & peran (proposal Kelompok 2):**

| Nama | NIM | Peran |
|------|-----|-------|
| Bisma Adhiaksa | 244107020216 | Project Manager & QA/Tester |
| Abim Mustawa | 244107020078 | Mobile Dev |
| Ahmad Falahi | 244107020152 | ML Engineer |
| Faatihurrizki Prasojo | 244107020142 | ML Engineer |
| Izza Dhafira Fanani | 244107020106 | Secretary / Documenter |

Lingkup: **Model 1 (E4.1–E4.6)** + dua tugas pendukung (E10.2 foto lapangan
untuk uji ketahanan, E9.5 konsolidasi laporan evaluasi). Panduan teknis lengkap
di **`ml/README.md`** (versi docx: `Pembagian Tugas/model1-panduan.docx`).

---

## 1. Peta Tugas & Ketergantungan

| ID | Tugas | Est (ho) | Prasyarat | Artefak | Branch |
|----|-------|---------:|-----------|---------|--------|
| E4.1 🟢🧩 | Unduh 3 dataset + EDA + buang kelas ambigu | 1 | — | laporan EDA, `ml/label_maps/*.csv` | `ml/dataset-eda` |
| E4.2 🔴🧩 | Gabung 9 kelas + mapping + split 70/15/15 | 1 | E4.1 | `ml/data/processed/model1/` + `metadata.csv` | `ml/merge-classes-split` |
| E4.3 🔴🧩 | Baseline MobileNetV2 | 1,5 | E4.2 | `ml/runs/baseline_mobilenetv2.pt` + report | `ml/baseline-mobilenetv2` |
| E4.4 🔴🧩 | Latih YOLOv11n-cls + fine-tune | 2,5 | E4.2 | `ml/runs/model1_yolo11n/weights/best.pt` | `ml/yolov11n-cls` |
| E4.5 🔴🧩 | Evaluasi (akurasi, macro F1, confusion matrix, per-sumber) | 1 | E4.4 | `ml/reports/model1_test_*` | `ml/model1-eval` |
| E4.6 🔴🧩 | Ekspor TFLite int8 | 1 | E4.4 | `assets/models/model1_yolo11n_v1.tflite` | `ml/tflite-export` |
| E10.2 🟢 | Kumpulkan 150 foto lapangan | 2 | — | `ml/data/field_photos/` | `docs/field-photos` |
| E9.5 🔴 | Konsolidasi laporan evaluasi ML | 1 | E4.5 | bagian ML di laporan | `docs/ml-eval-report` |

**Total ± 11 jam-orang (ho)** → rata-rata 2–3 ho per orang.

Jalur kritis: `E4.1 → E4.2 → E4.4 → E4.5 → E4.6 → (E7.1)`. Jangan biarkan
E4.1/E4.2 menganggur — semua paket lain menunggunya.

---

## 2. Saran Pembagian (5 Paket)

| Paket | Tugas | Est | Saran pemegang | Diambil oleh |
|-------|-------|----:|----------------|--------------|
| **A — Pengelola Data** | E4.1 + E4.2 | 2,0 | Faatihurrizki Prasojo (ML) | ____ |
| **B — Model** | E4.3 baseline + E4.4 YOLOv11n | 4,0 | Ahmad Falahi (ML) | ____ |
| **C — Evaluasi** | E4.5 + E9.5 | 2,0 | Bisma Adhiaksa (PM/QA) | ____ |
| **D — Ekspor & Jembatan E7** | E4.6 | 1,0 | Abim Mustawa (Mobile) | ____ |
| **E — Foto Lapangan** | E10.2 | 2,0 | Izza Dhafira Fanani (Dokumentator) | ____ |

Catatan beban:
- Ahmad memegang **2 tugas berurutan** (E4.3 baru bisa mulai setelah E4.2 selesai).
  Kalau terasa berat saat minggu berjalan, **E4.3 baseline boleh ditawarkan** ke
  anggota lain (aturan repo: maks 2 tugas aktif; seam menganggur).
- Faatihurrizki selesai lebih awal (minggu 1–2) → bisa langsung lanjut ke
  **E6.1 (dataset pasangan Model 3)** yang juga bergantung pada E4.2 miliknya.

---

## 3. Detail per Paket (Langkah + Review)

### Paket A — Faatihurrizki Prasojo (E4.1, E4.2) — paling kritis
- [ ] Unduh 3 dataset ke `ml/data/raw/` (perintah di `ml/README.md` §2)
- [ ] EDA: cek distribusi kelas, contoh gambar, catat label noisy → tulis `ml/reports/eda.md`
- [ ] Lengkapi `ml/label_maps/*.csv` (semua keputusan mapping + ALASAN)
- [ ] Jalankan `python ml/scripts/01_prepare_model1.py --dry-run` → cek → jalankan penuh
- [ ] Verifikasi sanity: jumlah per kelas, duplikat antar split = 0, proporsi sumber
- **Output yang diserahkan:** folder `processed/model1/` + `metadata.csv` + label maps
- **PR direview oleh:** Ahmad Falahi (pemakai data) — pastikan split tidak bocor

### Paket B — Ahmad Falahi (E4.3, E4.4)
- [ ] Tunggu E4.2 selesai (data siap)
- [ ] E4.3: `python ml/scripts/03_baseline_mobilenetv2.py` → catat acc + macro F1
- [ ] (Opsional) `python ml/scripts/02_balance_train.py` → tambah `--apply` bila perlu
- [ ] E4.4: `python ml/scripts/04_train_yolo11n.py` (lokal/Colab GPU) → catat hyperparameter
- **Output:** `best.pt` + kurva training + angka baseline
- **PR direview oleh:** E4.3 → Bisma Adhiaksa · E4.4 → Faatihurrizki Prasojo

### Paket C — Bisma Adhiaksa (E4.5, E9.5)
- [ ] Sebelum E4.4 selesai: susun protokol evaluasi (metrik, per-sumber, uji foto lapangan)
- [ ] Setelah best.pt ada: `python ml/scripts/05_eval_model1.py`
- [ ] Tulis bagian evaluasi laporan: top-1, macro F1, confusion matrix, akurasi per sumber, target ≥ 80% / F1 ≥ 0,75
- [ ] E9.5: gabungkan hasil Model 1 (+ nanti warna & Model 3) ke satu laporan
- **PR direview oleh:** Izza Dhafira Fanani (cek kelengkapan angka untuk laporan)

### Paket D — Abim Mustawa (E4.6)
- [ ] Setelah E4.4: `python ml/scripts/06_export_tflite.py`
- [ ] Verifikasi file `.tflite` + ukuran (≤ 20 MB)
- [ ] Siapkan serah terima ke E7.1 (kamu juga yang mengerjakan E7.1 — jembatan alami)
- **Output:** `assets/models/model1_yolo11n_v1.tflite` + model card singkat
- **PR direview oleh:** Bisma Adhiaksa (QA verifikasi artefak)

### Paket E — Izza Dhafira Fanani (E10.2)
- [ ] Jalan paralel sejak Minggu 1: kumpulkan 150 foto (cahaya gelap, latar ramai, blur, mirror selfie, non-pakaian)
- [ ] Katalog: nama file rapi + tabel keterangan (`ml/data/field_photos/katalog.csv`)
- [ ] Semua anggota boleh menyumbang foto — kamu yang mengelola & mendokumentasikan
- **Output:** `ml/data/field_photos/` siap dipakai uji E4.5
- **Verifikasi oleh:** Bisma Adhiaksa (saat eksekusi E4.5)

---

## 4. Rencana Mingguan (target: selesai ≤ Minggu 3, buffer Minggu 4)

| Minggu | Faatihurrizki | Ahmad | Bisma | Abim | Izza |
|--------|---------------|-------|-------|------|------|
| **1** | E4.1 tuntas → mulai E4.2 | Setup env, pelajari Ultralytics, latihan dataset kecil | Susun protokol evaluasi + setup script 05 | Setup env + pelajari script export | E10.2 mulai + katalog |
| **2** | E4.2 tuntas → PR merged | E4.3 baseline (setelah E4.2) | Siapkan evaluasi + review PR A | Uji coba export (dry-run) | E10.2 lanjut |
| **3** | Review PR B, bantu | E4.4 model utama → serahkan best.pt | E4.5 evaluasi + E9.5 bagian laporan | E4.6 export → serah terima E7.1 | E10.2 tuntas + katalog |
| **4** | Buffer: robustness foto lapangan, revisi, DoD | | | | |

> Jadwal realistis: latihan model baru bisa mulai setelah **E4.2 merged**. Kalau
> tertunda, Ahmad & Faatihurrizki bantu Paket A, jangan menganggur.

---

## 5. Aturan Kerja

1. **Satu tugas = satu branch = satu PR** (`branches.md`); dilarang push ke `main`.
2. PR **wajib direview** minimal 1 orang (lihat "PR direview oleh" tiap paket).
3. Semua keputusan mapping/param dicatat (laporan E4.2 + logbook mingguan).
4. **Jangan commit:** dataset (`ml/data/`), bobot (`*.pt`) — sudah di `.gitignore`.
   Yang di-commit: script, label maps, `ml/reports/`.
5. Update logbook (`Pembagian Tugas/Logbook/logbook.md`) tiap Jumat.
6. Tersangkut > 1 hari → lepas tugas ke daftar, tulis catatan (aturan repo).

---

## 6. Serah Terima ke E7.1 (Integrasi)

Diserahkan Abim (E4.6) ke dirinya sendiri di peran E7 — **model card mini**
(tempel di PR):

- [ ] Input: ukuran (`224×224`), format (RGB, normalisasi dari Ultralytics)
- [ ] Output: urutan **9 kelas** (urut abjad folder!) + contoh output
- [ ] Metrik: akurasi test, macro F1, confusion matrix (file di `ml/reports/`)
- [ ] Ukuran file + estimasi latensi (diukur ulang di perangkat, E7.6)
- [ ] Dataset + lisensi (CC0/MIT) untuk laporan

---

## 7. Cara Mengubah Dokumen Ini

Nama di kolom "Saran pemegang" **boleh ditukar** sesuai kesepakatan tim — papan
resmi tetap `pembagian-tugas.md`. Bila paket ditukar, update tabel §2 dan kolom
status di `branches.md` agar tidak ada dua orang mengerjakan hal sama.
