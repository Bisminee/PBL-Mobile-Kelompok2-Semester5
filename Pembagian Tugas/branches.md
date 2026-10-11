# Sera-Z — Daftar Branch & Tugasnya

Branch dibuat **per fitur**, bukan per orang. Tujuannya agar setiap pekerjaan
punya jalur sendiri dan tidak saling mengganggu. **Satu branch = satu fitur =
satu Pull Request.**

---

## 1. Cara Pakai

```bash
# ambil versi terbaru
git checkout main
git pull origin main

# pindah ke branch tugas yang mau dikerjakan
git checkout feat/google-login

# kerjakan, lalu simpan & upload
git add .
git commit -m "feat: ..."
git push
```

---

## 2. Branch Utama

| Branch | Fungsi | Status |
|--------|--------|--------|
| `main` | Versi stabil. Jangan push langsung ke sini. | Aktif |
| `feat/app-foundation` | Fondasi aplikasi (E1: kamera, navigasi, layar, state) | ✅ Selesai, sudah digabung ke `main` |

---

## 3. Branch Tugas Independen (Tanpa Prasyarat)

Boleh dikerjakan kapan saja, siapa saja, dan paralel.

| Tugas | Branch | Isi Pekerjaan | Prasyarat |
|-------|--------|---------------|-----------|
| E2.1 | `feat/sqflite-setup` | Setup basis data lokal + migrasi | — |
| E3.1 | `feat/google-login` | Login dengan akun Google | — |
| E4.1 | `ml/dataset-eda` | Unduh dataset + eksplorasi data | — |
| E5.1 | `feat/color-crop` | Crop gambar + pemisahan latar | — |
| E6.4 | `feat/color-harmony-rules` | Aturan harmoni warna | — |
| E9.1 | `docs/test-plan` | Rencana uji + ≥ 20 test case | — |
| E10.1 | `docs/logbook` | Logbook mingguan + notulen | — |
| E10.2 | `docs/field-photos` | Kumpulkan 150 foto lapangan | — |

---

## 4. Catatan

- Branch untuk **tugas dependen** dibuat setelah prasyaratnya selesai
  (lihat `pembagian-tugas.md` untuk daftar ketergantungan).
- Nama branch **tidak memakai nama orang**.
- Setelah PR digabung ke `main`, branch fitur boleh dihapus.
- Daftar tugas lengkap: `pembagian-tugas.md` · penjelasan epic: `Epics/`.
