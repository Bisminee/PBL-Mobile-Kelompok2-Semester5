# Sera-Z — Daftar Branch dan Statusnya

Diperbarui: 2 November 2026

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

| Tugas | Branch | PIC | Status |
|---|---|---|---|
| E2.4 Riwayat rekomendasi | `feat/recommendation-history` | Bisma | Belum dibuat |
| E2.6 Unit test DAO | `test/local-db` | Bisma | Belum dibuat |
| E7.5 Fallback aturan | `feat/rule-fallback` | Bisma | Belum dibuat |
| Rapikan UI autentikasi | `fix/auth-ui` | Bisma | Belum dibuat |
| Uji perangkat | `test/device-check` | Bisma | Belum dibuat |
| E4.6 Ekspor TFLite | `ml/export-tflite` | Bisma | Belum dibuat |
| E6.5 Metrik Model 3 | `ml/model3-metrics` | Bisma | Belum dibuat |
| E5.3 Palet 14 warna | `feat/color-palette` | Bisma | Belum dibuat |
| E5.4 Unit test warna | `test/color-palette` | Bisma | Belum dibuat |
| Dokumentasi metode ML | `docs/ml-methods` | Bisma | Belum dibuat |
| E9.1 Rencana uji | `test/qa-plan` | Bisma | Belum dibuat |
| Logbook minggu 6 | `docs/logbook-minggu-6` | Bisma | Belum dibuat |
| E8.6 Halaman Admin | `feat/admin-master-data` | Izza | Belum dibuat |
| E8.1 CRUD UI Lemari | `feat/wardrobe-crud-ui` | Izza | Belum dibuat |
| E8.7 Edit profil | `feat/profile-edit` | Abim | Belum dibuat |
| Label 9 kelas | `chore/model-assets` | Abim | Belum dibuat |
| E7.6 Latensi | `feat/latency-check` | Abim | Belum dibuat |

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
