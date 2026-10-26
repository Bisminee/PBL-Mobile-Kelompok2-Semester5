# ai-context — Konteks proyek untuk agen AI

Folder ini berisi ringkasan proyek yang boleh dibaca agent AI (OpenCode,
Copilot, Cursor, Claude Code) agar tidak perlu menebak struktur dan aturan tim.
Isinya **tracked di Git** supaya semua anggota memakai konteks yang sama.

| Berkas | Isi | Kapan dibaca |
|---|---|---|
| `../AGENTS.md` | Titik masuk: aturan, perintah, peta folder | Selalu, pertama |
| `arsitektur.md` | Lapisan kode, rute, model data, rencana integrasi | Sebelum mengubah kode `lib/` |
| `konvensi-kode.md` | Gaya kode, penamaan, test, commit, PR | Sebelum menulis kode |
| `peta-tugas.md` | Epic E1-E10, status, PIC minggu berjalan | Sebelum mengambil tugas |
| `status-proyek.md` | Kondisi terkini, PR, penghambat | Awal sesi kerja |

## Cara merawat

- Perbarui `status-proyek.md` setiap akhir minggu atau setiap ada PR besar.
- Perbarui `peta-tugas.md` bila status epic berubah, bukan setiap commit.
- Jangan menyalin isi `context/` atau `docs/` ke sini; rangkum hal yang
  dibutuhkan agen AI saja.
- Sumber kebenaran tetap kode dan `Pembagian Tugas/`, bukan berkas ini.

## Aturan singkat yang sering dilanggar agen

1. Bahasa Indonesia, tanpa emoji.
2. Jangan ubah `main` langsung; buat branch fitur.
3. Jangan menambah dependensi baru tanpa alasan yang dibahas di PR.
4. Jangan menghapus test atau menonaktifkan lint hanya agar build hijau.
