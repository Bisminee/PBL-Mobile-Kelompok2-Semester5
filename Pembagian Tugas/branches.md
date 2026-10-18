# Sera-Z — Daftar Branch & Tugasnya

Branch dibuat **per fitur**, bukan per orang. Tujuannya agar setiap pekerjaan
punya jalur sendiri dan tidak saling mengganggu. **Satu branch = satu fitur =
satu Pull Request.**

---

## 1. Cara Pakai

Panduan langkah demi langkah (clone, branch, commit, push, Pull Request) ada di
[`README.md`](../README.md) bagian **3–9**.

Ringkasnya: pindah ke branch tugas kalian (`git checkout <branch>`), kerjakan,
lalu commit dan push. **Jangan bekerja langsung di `main`.**

---

## 2. Branch Utama

| Branch | Fungsi | Status |
|--------|--------|--------|
| `main` | Versi stabil. Jangan push langsung ke sini. | Aktif |
| `feat/app-foundation` | Fondasi aplikasi (E1: kamera, navigasi, layar, state) | ✅ Selesai, sudah digabung ke `main` |

---

## 3. Branch Tugas Independen (Tanpa Prasyarat)

Boleh dikerjakan kapan saja, siapa saja, dan paralel.

| Tugas | Branch | Isi Pekerjaan | Prasyarat | Status |
|-------|--------|---------------|-----------|--------|
| E2.1 | `feat/sqflite-setup` | Setup basis data lokal + migrasi | — | ⬜ Belum mulai |
| E3.1 | `feat/google-login` | Login dengan akun Google | — | ⬜ Belum mulai |
| E4.1 | `ml/dataset-eda` | Unduh dataset + eksplorasi data | — | ⬜ Belum mulai |
| E5.1 | `feat/color-crop` | Crop gambar + pemisahan latar | — | ⬜ Belum mulai |
| E6.4 | `feat/color-harmony-rules` | Aturan harmoni warna | — | ✅ Selesai — PR #2 (digabung ke `main`) |
| E9.1 | `docs/test-plan` | Rencana uji + ≥ 20 test case | — | ⬜ Belum mulai |
| E10.1 | `docs/logbook` | Logbook mingguan + notulen | — | ✅ Selesai (Minggu 1–2 terisi) |
| E10.2 | `docs/field-photos` | Kumpulkan 150 foto lapangan | — | ⬜ Belum mulai |

### Riwayat PR

| PR | Branch | Judul | Status |
|----|--------|-------|--------|
| #1 | (Kamera / fondasi) | Kamera | ✅ Merged |
| #2 | `feat/color-harmony-rules` | feat: color harmony rules (E6.4) | ✅ Merged |

---

## 4. Catatan

- Branch untuk **tugas dependen** dibuat setelah prasyaratnya selesai
  (lihat `pembagian-tugas.md` untuk daftar ketergantungan).
- Nama branch **tidak memakai nama orang**.
- Setelah PR digabung ke `main`, branch fitur boleh dihapus.
- Daftar tugas lengkap: `pembagian-tugas.md` · penjelasan epic: `Epics/`.
