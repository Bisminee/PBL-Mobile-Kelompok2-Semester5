# Daftar Kerja Minggu 5 — Sera-Z

Tim Sera-Z · Kelas TI-3D · Semester 5
Periode: **27 Oktober – 1 November 2026**
Disusun: 27 Oktober 2026

> **CATATAN DARI BISMA**
>
> **JANGAN TAKUT SALAH PUSH, JANGAN TAKUT BIKIN KESALAHAN**
>
> **TAKUT KALAU KALIAN NGGAK ADA KONTRIBUSI DI GITHUB**

Fokus: **pembangunan mobile saja**. ML dan pemrosesan gambar belum dikerjakan.

Dikerjakan: E2 penyimpanan, E3 autentikasi, E8.1, E8.2, E8.4, E8.6, E8.7.
Dijeda: E4, E5, E6, E7, E8.3, E8.5, E9, E10.

Total 20,5 ho, rata-rata 4,1 ho per orang.

---

## 1. Ringkasan tugas

| Anggota | Tugas | ho |
|---|---|---:|
| Pras | E2.1 setup DB, E2.2 CRUD lemari, E2.3 simpan foto | 3,5 |
| Ahmad | E2.4 tabel outfit + riwayat, E2.5 muat saat start, E2.6 test DAO | 3,5 |
| Bisma | E3.1 login Google, E3.2 record cloud, E3.3 sesi, E3.4 sign out | 5,0 |
| Izza | E8.6 halaman Admin, E8.1 CRUD UI Lemari | 4,0 |
| Abim | E8.7 halaman Profil, E8.2 simpan outfit, E8.4 konten Home | 4,5 |

---

## 2. Daftar kerja per hari

### Selasa, 27 Oktober

| Orang | Tugas | Keluaran |
|---|---|---|
| Pras | E2.1 setup `sqflite`, `path_provider`, helper DB | DB terbuka, skema v1 |
| Bisma | Buat proyek Firebase + `google-services.json` lokal | Berkas kunci ada, tidak di-commit |
| Ahmad | Siapkan skema SQL `outfits` dan `recommendation_history` | Rancangan tabel siap, menunggu E2.1 |
| Izza | Rancangan layar dan skema master data E8.6 | Rancangan disetujui |
| Abim | Rangka UI statis halaman Profil (E8.7) | Tampilan jadi, belum tersambung |

### Rabu, 28 Oktober

| Orang | Tugas | Keluaran |
|---|---|---|
| Pras | E2.2 CRUD `wardrobe_items` | Tambah, ambil, hapus berjalan |
| Bisma | E3.1 `google_sign_in` + Firebase Auth | Login berhasil di perangkat |
| Ahmad | E2.4 implementasi tabel + DAO | Simpan dan daftar outfit berhasil |
| Izza | E8.6 implementasi (setelah E2.1) | Admin membaca master data |
| Abim | Lanjut E8.7 + siapkan integrasi data | UI shell selesai |

### Kamis, 29 Oktober

| Orang | Tugas | Keluaran |
|---|---|---|
| Pras | E2.3 simpan foto (hanya path di DB) | Foto tampil setelah restart |
| Bisma | Uji E3.1 + E3.2 record cloud | Profil terbentuk saat login |
| Ahmad | Selesaikan E2.4 | DAO outfit dan riwayat lulus uji manual |
| Izza | Selesaikan E8.6 | Master data dapat dikelola |
| Abim | Mulai E8.2 (setelah E2.4) | Form simpan outfit |

### Jumat, 30 Oktober

| Orang | Tugas | Keluaran |
|---|---|---|
| Pras | Review PR E2 + bantu Izza | PR E2 siap digabung |
| Bisma | E3.3 sesi persisten | Masih login setelah restart |
| Ahmad | E2.5 muat lemari dan riwayat saat start | Data muncul setelah cold start |
| Izza | Mulai E8.1 (setelah E2.2) | Daftar item dan form tambah |
| Abim | Lanjut E8.2 | Outfit tersimpan terdaftar |

### Sabtu, 31 Oktober

| Orang | Tugas | Keluaran |
|---|---|---|
| Pras | Bantu E8.1 bagian filter | Filter berjalan |
| Bisma | E3.4 sign out + hapus akun | Logout bersih |
| Ahmad | E2.6 unit test DAO | Test lulus |
| Izza | E8.1 empty state dan hapus item | CRUD penuh berjalan |
| Abim | Mulai E8.4 (setelah E2.5) | Home memakai data nyata |

### Minggu, 1 November

| Orang | Tugas | Keluaran |
|---|---|---|
| Pras | Rekap penyimpanan | Status terisi |
| Bisma | Uji akhir auth + rekap | Login, sesi, logout stabil |
| Ahmad | Rekap + perbarui Notion | Status terisi |
| Izza | Selesaikan E8.1 + logbook | Logbook minggu 5 |
| Abim | Selesaikan E8.4 + uji alur | Home tanpa placeholder |

---

## 3. Target akhir minggu

| Tugas | Kriteria diterima | Pemilik | Target |
|---|---|---|---|
| E2.1–E2.3 | Item lemari bertahan setelah aplikasi ditutup; foto tampil dari folder dokumen | Pras | Selesai |
| E2.4–E2.6 | Outfit dan riwayat tersimpan; data muncul saat start; test DAO lulus | Ahmad | Selesai |
| E3.1–E3.4 | Login Google, profil cloud, sesi bertahan, logout bersih | Bisma | Selesai |
| E8.6 | Master data kategori dan jenis dapat dikelola | Izza | Selesai |
| E8.1 | CRUD lemari penuh termasuk filter dan empty state | Izza | Selesai |
| E8.7 | Halaman Profil menampilkan data pengguna dan sign out | Abim | Selesai |
| E8.2 | Outfit tersimpan muncul di daftar | Abim | Berjalan |
| E8.4 | Home memakai data lemari nyata | Abim | Berjalan |

Semua PR wajib lulus `flutter analyze` dan `flutter test` sebelum digabung.

---

## 4. Tugas yang tidak dikerjakan minggu ini

| Tugas | Alasan |
|---|---|
| E4 Model 1 | ML, ditunda |
| E5 modul warna | Pemrosesan gambar, ditunda |
| E6 Model 3 | ML, ditunda |
| E7 integrasi TFLite | Menunggu artefak model |
| E8.3, E8.5 | Menunggu E7.4 |
| E9 QA, E10 dokumentasi | Ditunda agar fokus mobile |

---

## 5. Penghambat dan aksi

| Penghambat | Aksi | Penanggung | Batas |
|---|---|---|---|
| Firebase belum ada | Buat proyek dan berkas konfigurasi lokal | Bisma | 28 Okt |
| Branch `feat/sqflite-setup` usang | Buat ulang dari `dev` | Pras | 27 Okt |
| Tampilan Home dan Profil menunggu data | Bangun UI shell lebih dulu, sambungkan setelah prasyarat selesai | Abim | 27 Okt |
| `dev` perlu sinkron dengan `main` | Merge `main` ke `dev` | Bisma | 28 Okt |

---

## 6. Aturan branch

Setiap tugas dikerjakan di branch sendiri. Branch dibuat dari **`dev` terbaru**,
bukan dari `main`, bukan dari branch anggota lain. Pull Request mengarah ke
**`dev`**. Setelah PR digabung, branch dihapus. Jangan menggabungkan dua tugas
dalam satu branch.

| Anggota | Tugas | Branch | PR ke |
|---|---|---|---|
| Pras | E2.1 setup DB | `feat/sqflite-setup` | `dev` |
| Pras | E2.2 CRUD lemari | `feat/wardrobe-crud` | `dev` |
| Pras | E2.3 simpan foto | `feat/photo-storage` | `dev` |
| Ahmad | E2.4 tabel outfit + riwayat | `feat/outfit-tables` | `dev` |
| Ahmad | E2.5 muat data saat start | `feat/load-on-start` | `dev` |
| Ahmad | E2.6 unit test DAO | `test/dao` | `dev` |
| Bisma | Persiapan Firebase | `chore/firebase-setup` | `dev` |
| Bisma | E3.1 login Google | `feat/google-login` | `dev` |
| Bisma | E3.2 record cloud | `feat/cloud-profile` | `dev` |
| Bisma | E3.3 sesi persisten | `feat/session-persist` | `dev` |
| Bisma | E3.4 sign out + hapus akun | `feat/sign-out` | `dev` |
| Izza | E8.1 CRUD UI Lemari | `feat/wardrobe-ui` | `dev` |
| Izza | E8.6 halaman Admin | `feat/admin-master-data` | `dev` |
| Abim | E8.7 halaman Profil | `feat/profile-screen` | `dev` |
| Abim | E8.2 simpan outfit | `feat/save-outfit` | `dev` |
| Abim | E8.4 konten Home | `feat/home-content` | `dev` |

Awalan branch yang dipakai: `feat/` untuk fitur, `fix/` untuk bug, `test/` untuk
test, `docs/` untuk dokumentasi, `chore/` untuk konfigurasi, `ml/` untuk model
(dijeda), dan `refactor/` untuk merapikan struktur.

Branch yang tidak boleh dibuat: nama orang (`abim`, `pras`), `dev2`, `backup`,
`coba`, atau satu branch untuk semua tugas.

Membuat dan menutup branch:

```bash
git switch dev
git pull origin dev
git switch -c feat/wardrobe-crud
git push -u origin feat/wardrobe-crud

# setelah PR digabung ke dev
git switch dev
git pull origin dev
git branch -d feat/wardrobe-crud
git push origin --delete feat/wardrobe-crud
```

Catatan: branch `feat/sqflite-setup` yang ada sekarang berisi kode lama (24 commit
di belakang `main`). Hapus dulu, lalu buat ulang dari `dev` sebelum E2.1
dikerjakan.

Branch usang lain yang perlu dibersihkan: `docs/test-plan`, `docs/field-photos`,
`docs/logbook`, `feat/color-crop`, `feat/google-login`, `ml/dataset-eda`,
`data-training`, `feat/app-foundation`, `feat/color-harmony-rules`. Semuanya
sudah tergabung ke `main` atau hanya berisi commit kosong.

## 7. Aturan kerja

1. Maksimal 2 tugas aktif per orang.
2. Satu tugas = satu branch = satu PR; untuk mobile, branch dibuat dari `dev`
   dan PR mengarah ke `dev`.
3. `main` hanya menerima penggabungan `dev` pada akhir milestone.
4. Tugas yang prasyaratnya belum selesai tidak diambil.
5. Anggota yang selesai lebih cepat boleh mengambil tugas mobile lain yang belum
   selesai, tetap maksimal 2 tugas aktif.
6. `flutter analyze` dan `flutter test` wajib lulus sebelum PR dibuka.
7. Status di papan Notion diperbarui setiap hari; rekap diisi Minggu, 1 November.

## 8. Blok ML terpisah (2 – 4 November 2026)

ML tidak dicampur dengan mobile. Setelah mobile selesai 1 November, pekerjaan ML
dijalankan sendiri selama tiga hari memakai branch integrasi `dev-ml`.

| Anggota | Tugas ML | ho |
|---|---|---:|
| Bisma | E4.1 ekstrak dataset, E4.2 split, latih ulang 12 epoch untuk `best.pt` | 3,0 |
| Ahmad | E4.5 evaluasi Model 1, E4.6 verifikasi ekspor + model card | 1,5 |
| Pras | E6.5 metrik Model 3 + review PR | 1,0 |
| Abim | Label 9 kelas + aset model + smoke test | 1,0 |
| Izza | Dokumentasi metode ML | 1,0 |
| **Total** | | **7,5** |

Alur branch ML:

```
dev ──► dev-ml ──► ml/... ──PR──► dev-ml ──► (stabil) PR ke dev
```

- `dev-ml` dibuat sekali dari `dev`.
- Branch tugas ML dibuat dari `dev-ml`, PR ke `dev-ml`.
- Pengecualian: `chore/model-assets` dari `dev`, PR ke `dev`.
- PR #5 (`data-training`) tidak dipakai; pekerjaan dibuat ulang di branch tugas.

Rincian lengkap: `Pembagian Tugas/pembagian-tugas-ml-minggu-5.docx`.
