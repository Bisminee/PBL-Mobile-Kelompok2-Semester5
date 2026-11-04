# Sera-Z — Daftar Branch dan Statusnya

Diperbarui: 4 November 2026

Branch dibuat **per tugas**, bukan per orang. Satu tugas = satu branch = satu
Pull Request. Branch tugas dibuat dari `dev` dan PR diarahkan ke `dev`.

---

## 1. Branch tetap

| Branch | Fungsi | Status |
|---|---|---|
| `main` | Versi stabil, tujuan penggabungan akhir | Aktif |
| `dev` | Integrasi seluruh pekerjaan mobile dan ML | Aktif |

`dev-ml` sudah dihapus dan seluruh isinya digabung ke `dev` pada 2 November 2026.

---

## 2. Branch tugas minggu 6

| Tugas | Branch | PIC | Kategori |
|---|---|---|---|
| E8.6 Halaman Admin | `feat/admin-master-data` | Izza | Mobile |
| E8.1 CRUD UI Lemari | `feat/wardrobe-crud-ui` | Izza | Mobile |
| Thumbnail Lemari dan Home | `feat/wardrobe-thumbnails` | Izza | Mobile |
| E5.4 Unit test warna | `test/color-palette` | Izza | ML |
| Dokumentasi metode ML | `docs/ml-methods` | Izza | ML |
| E2.4 Riwayat rekomendasi | `feat/recommendation-history` | Pras | Mobile |
| E2.6 Unit test DAO | `test/local-db` | Pras | Mobile |
| E8.3 Ranking dan explainability | `feat/ranking-explainability` | Pras | Mobile |
| E10.2 Foto lapangan | `docs/field-photos` | Pras | Dokumen |
| E8.5 Tab Detail data nyata | `feat/detail-data` | Ahmad | Mobile |
| E6.5 Metrik Model 3 | `ml/model3-metrics` | Ahmad | ML |
| Dataset aksesoris | `ml/accessory-dataset` | Ahmad | ML |
| E9.2 Uji fungsional | `test/functional` | Ahmad | QA |
| E8.7 Edit profil | `feat/profile-edit` | Abim | Mobile |
| Sinkron gambar | `feat/photo-sync` | Abim | Mobile |
| Penanganan objek bukan outfit | `feat/non-clothing-object` | Abim | Mobile |
| Label 9 kelas | `chore/model-assets` | Abim | ML |
| E7.6 Latensi | `feat/latency-check` | Abim | ML |
| Uji perangkat | `test/device-check` | Bisma | Mobile |
| E7.5 Fallback aturan | `feat/rule-fallback` | Bisma | Mobile |
| Rapikan UI autentikasi | `fix/auth-ui` | Bisma | Mobile |
| Profil sesuai akun Google | `feat/google-profile` | Bisma | Mobile |
| E4.6 Ekspor TFLite | `ml/export-tflite` | Bisma | ML |
| E5.3 Palet 14 warna | `feat/color-palette` | Bisma | ML |
| E9.1 Rencana uji | `test/qa-plan` | Bisma | QA |
| Logbook minggu 6 | `docs/logbook-minggu-6` | Bisma | Dokumen |

---

## 3. Riwayat PR yang sudah digabung

| PR | Branch | Isi | Status |
|---|---|---|---|
| #1 | Kamera | Fondasi kamera | Merged |
| #2 | `feat/color-harmony-rules` | E6.4 aturan harmoni | Merged |
| #4 | `feat/app-foundation` | UI Figma dan fondasi | Merged |
| #6 | `ml/dataset-eda` | Dataset dan split | Merged ke `dev` |
| #7 | `ml/train-model1` | Laporan evaluasi Model 1 | Merged ke `dev` |
| #8 | `chore/firebase-setup` | Plugin Google Services | Merged |
| #9 | `feat/google-login` | E3.1 login Google | Merged |
| #10 | `feat/cloud-profile` | E3.2 profil Firestore | Merged |
| #11 | `feat/session-persist` | E3.3 sesi dan redirect | Merged |
| #12 | `feat/sign-out` | E3.4 logout dan hapus akun | Merged |
| #13 | `feat/SQLite-...-yolo11n` | SQLite, TFLite, mesin rekomendasi | Merged |
| #14 | `refactor/cleanup-dead-code` | Bersihkan kode mati | Merged |

PR #3 dan #5 ditutup karena digantikan pekerjaan di `dev`.

---

## 4. Branch lama

| Branch | Kondisi | Tindakan |
|---|---|---|
| `ml/model1-pipeline` | PR #3 ditutup | Boleh dihapus |
| `data-training` | PR #5 ditutup | Boleh dihapus |
| `pras` | Hanya `.vscode` dan laporan build | Boleh dihapus |

---

## 5. Catatan

- Nama branch tidak memakai nama orang.
- Branch dibuat dari `dev`, bukan dari `main`.
- Setelah PR digabung, branch tugas dihapus.
- Jangan commit dataset, `ml/data`, `ml/runs`, `ml/.venv`, `*.pt`, atau
  `google-services.json`.
