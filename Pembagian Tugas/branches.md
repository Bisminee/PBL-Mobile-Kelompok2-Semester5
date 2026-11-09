# Sera-Z – Daftar Branch dan Statusnya

Diperbarui: 9 November 2026

Branch dibuat **per tugas**, bukan per orang. Satu tugas = satu branch = satu
Pull Request. Branch tugas dibuat dari `dev` dan PR diarahkan ke `dev`.

---

## 1. Branch tetap

| Branch | Fungsi | Status |
|---|---|---|
| `main` | Versi stabil, tujuan penggabungan akhir | Aktif, `2e33e55`, tertinggal dari `dev` |
| `dev` | Integrasi seluruh pekerjaan mobile dan ML | Aktif, `f67732a` |

`dev-ml` sudah dihapus dan seluruh isinya digabung ke `dev` pada 2 November 2026.

---

## 2. Branch tugas minggu 11

### 2.1 Sudah digabung

| Tugas | Branch | PR | PIC |
|---|---|---|---|
| Impor foto dari galeri | `feat/gallery-import` | #20 | Bisma |
| Halaman crop 1:1 | `feat/gallery-crop` | #21 | Bisma |
| Tombol galeri di kamera dan Photo Picker | `feat/camera-gallery` | #24 | Bisma |
| Simpan outfit, daftar outfit, pencarian lemari | `feat/save-outfit` | #25 | Abim |
| Foto outfit dan ringkasan kategori Home | `feat/home-content` | #27 | Abim |
| Perbaikan overflow teks | `fix/ui-overflow-warna` | #28 | Abim |
| Ikon aplikasi Sera-Z | `chore/app-icon` | #29 | Abim |
| E7.5 Fallback aturan | `feat/rule-fallback` | #15 | Bisma |
| Rapikan UI autentikasi | `fix/auth-ui` | #16 | Bisma |
| Profil sesuai akun Google | `feat/google-profile` | #17 | Bisma |
| Palet 14 warna | `feat/color-palette` | #18 | Bisma |
| Tab Detail data nyata | `feat/detail-data` | #19 | Ahmad |

### 2.2 Terbuka dan menunggu perbaikan

| Tugas | Branch | PR | PIC | Status |
|---|---|---|---|---|
| Edit profil dan autentikasi | `feat/profile-auth` | #26 | Abim | Perlu perbaikan |
| Dokumen status proyek | `docs/status-minggu-6` | #30 | Abim | Perlu perbaikan |
| Pipeline dataset Hugging Face dan kelas `other` | `ml/model1-v2-pipeline` | #31 | Abim | Perlu perbaikan |
| Penolakan objek bukan pakaian dan label 10 kelas | `feat/non-clothing-object` | #32 | Abim | Perlu perbaikan |
| Metrik Model 3 | `ml/model3-metrics` | #22 | Ahmad | Perlu perbaikan |
| Riset dataset aksesoris | `ml/accessory-dataset` | #23 | Ahmad | Perlu perbaikan |

### 2.3 Belum dibuat

| Tugas | Branch rencana | PIC |
|---|---|---|
| Uji perangkat | `test/device-check` | Bisma |
| E4.6 Ekspor TFLite | `ml/export-tflite` | Bisma |
| E9.2 Uji fungsional | `test/functional` | Ahmad |
| E2.4 Riwayat rekomendasi | `feat/recommendation-history` | Pras |
| E2.6 Unit test DAO | `test/local-db` | Pras |
| E8.3 Ranking dan explainability | `feat/ranking-explainability` | Pras |
| E10.2 Foto lapangan | `docs/field-photos` | Pras |
| E8.6 Halaman Admin | `feat/admin-master-data` | Izza |
| E8.1 CRUD UI Lemari | `feat/wardrobe-crud-ui` | Izza |
| Thumbnail Lemari dan Home | `feat/wardrobe-thumbnails` | Izza |
| E5.4 Unit test warna | `test/color-palette` | Izza |
| Dokumentasi metode ML | `docs/ml-methods` | Izza |
| Sinkron gambar ke folder aplikasi | `feat/photo-sync` | Abim |
| E7.6 Latensi | `feat/latency-check` | Abim |

---

## 3. Riwayat PR yang sudah digabung

| PR | Branch | Isi | Status |
|---|---|---|---|
| #1 | Kamera | Fondasi kamera | Merged |
| #2 | `feat/color-harmony-rules` | E6.4 aturan harmoni | Merged |
| #4 | `feat/app-foundation` | UI Figma dan fondasi | Merged |
| #6 | `ml/dataset-eda` | Dataset dan split | Merged |
| #7 | `ml/train-model1` | Laporan evaluasi Model 1 | Merged |
| #8 | `chore/firebase-setup` | Plugin Google Services | Merged |
| #9 | `feat/google-login` | E3.1 login Google | Merged |
| #10 | `feat/cloud-profile` | E3.2 profil Firestore | Merged |
| #11 | `feat/session-persist` | E3.3 sesi dan redirect | Merged |
| #12 | `feat/sign-out` | E3.4 logout dan hapus akun | Merged |
| #13 | `feat/SQLite-...-yolo11n` | SQLite, TFLite, mesin rekomendasi | Merged |
| #14 | `refactor/cleanup-dead-code` | Bersihkan kode mati | Merged |
| #15 | `feat/rule-fallback` | E7.5 fallback aturan | Merged |
| #16 | `fix/auth-ui` | Rapikan UI autentikasi | Merged |
| #17 | `feat/google-profile` | Profil sesuai akun Google | Merged |
| #18 | `feat/color-palette` | E5.3 palet 14 warna | Merged |
| #19 | `feat/detail-data` | E8.5 tab Detail | Merged |
| #20 | `feat/gallery-import` | Impor foto galeri | Merged |
| #21 | `feat/gallery-crop` | Crop manual foto galeri | Merged |
| #24 | `feat/camera-gallery` | Tombol galeri kamera dan Photo Picker | Merged |
| #25 | `feat/save-outfit` | Simpan outfit dan pencarian lemari | Merged |
| #27 | `feat/home-content` | Foto outfit dan ringkasan Home | Merged |
| #28 | `fix/ui-overflow-warna` | Perbaikan overflow | Merged |
| #29 | `chore/app-icon` | Ikon aplikasi | Merged |

PR #3 dan #5 ditutup karena digantikan pekerjaan di `dev`.

---

## 4. Branch yang bisa dihapus

Branch berikut sudah digabung ke `dev`, tetapi masih ada di remote:

| Branch | PR |
|---|---|
| `feat/color-palette` | #18 |
| `feat/detail-data` | #19 |
| `feat/google-profile` | #17 |
| `feat/rule-fallback` | #15 |
| `fix/auth-ui` | #16 |
| `feat/gallery-import` | #20 |
| `feat/gallery-crop` | #21 |
| `feat/camera-gallery` | #24 |
| `feat/save-outfit` | #25 |
| `feat/home-content` | #27 |
| `fix/ui-overflow-warna` | #28 |
| `chore/app-icon` | #29 |

Branch lama yang juga bisa dihapus:

| Branch | Kondisi |
|---|---|
| `ml/model1-pipeline` | PR #3 ditutup |
| `pras` | Hanya `.vscode` dan laporan build |
| `feat/gallery-camera` | Tidak dipakai, digantikan `feat/camera-gallery` |
| `fix/google-login` | Tidak dipakai |

---

## 5. Catatan

- Nama branch tidak memakai nama orang.
- Branch dibuat dari `dev`, bukan dari `main`.
- Setelah PR digabung, branch tugas dihapus.
- Jangan commit dataset, `ml/data`, `ml/runs`, `ml/.venv`, `*.pt`, atau
  `google-services.json`.
