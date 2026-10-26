# Jobdesk per Anggota — Sera-Z

Diperbarui: 27 Oktober 2026
Prinsip: **mobile dulu, ML menyusul**. Semua tugas aplikasi (E2, E3, E5, E8)
dikerjakan lebih dulu; pelatihan model (E4, E6) dan integrasi (E7) masuk setelah
fondasi aplikasi selesai.

Estimasi dalam jam-orang (ho). Prasyarat mengikuti
`feature-breakdown-id.md`.

Perubahan 27 Oktober: tugas penyimpanan (E2) dipindahkan dari Abim ke
Faatihurrizki Prasojo (Pras). Sebagai penyeimbang, modul warna (E5) dan foto
lapangan (E10.2) pindah ke Abim.

---

## 1. Ringkasan beban

| Anggota | Fokus | Tugas mobile | ho mobile | ho ML |
|---|---|---|---:|---:|
| Faatihurrizki Prasojo | Penyimpanan | E2.1–E2.6 | 7,0 | 0 |
| Bisma Adhiaksa | Autentikasi + profil | E3.1–E3.4, E8.7 | 6,5 | 0 |
| Izza Dhafira Fanani | UI fitur + dokumentasi | E8.1, E8.4, E8.6, E10.1 | 6,0 | 0 |
| Abim Mustawa | Modul warna + foto lapangan | E5.1–E5.4, E10.2 | 7,0 | 0 |
| Ahmad Falahi | QA, dokumentasi, data ML | E9.1, E10.5, E8.2 | 5,5 | 2,0 (E4.1–E4.2) |
| **Total** | | | **32,0** | **2,0** |

Rentang beban 5,5–7,5 ho per orang, termasuk tugas ML.

---

## 2. Faatihurrizki Prasojo — penyimpanan (7,0 ho)

Rantai ini tidak bisa dipotong. Setelah E2.1 selesai, E2.2 dan E2.3 bisa
paralel; E2.4 menyusul; E2.5 dan E2.6 menutup.

| Urutan | ID | Tugas | ho | Prasyarat | Target | Kriteria selesai |
|---:|---|---|---:|---|---|---|
| 1 | E2.1 | Setup `sqflite` + `path_provider`, helper DB + migrasi versi | 1,0 | — | Minggu 5 | DB terbuka, skema v1 berjalan |
| 2 | E2.2 | CRUD `wardrobe_items` (tambah, ambil, ubah, hapus) | 1,5 | E2.1 | Minggu 5 | Item tetap ada setelah restart |
| 3 | E2.3 | Simpan foto ke folder dokumen, simpan hanya path | 1,0 | E2.1 | Minggu 5 | Foto tampil, DB tidak membengkak |
| 4 | E2.4 | Tabel `outfits` + `recommendation_history` + DAO | 1,5 | E2.1 | Minggu 6 | Simpan/daftar outfit dan riwayat berhasil |
| 5 | E2.5 | Muat lemari dan riwayat saat start (provider async) | 1,0 | E2.2, E2.4 | Minggu 6 | Data muncul setelah cold start |
| 6 | E2.6 | Unit test DAO | 1,0 | E2.2, E2.4 | Minggu 6 | Test lulus |

Yang membuka pekerjaan orang lain:

- E2.1 membuka E8.6 (Izza).
- E2.2 membuka E8.1 (Izza).
- E2.4 membuka E8.2 (Ahmad).
- E2.5 membuka E8.4 (Izza).

Karena itu E2.1 dan E2.2 tetap prioritas nomor satu di tim, meskipun pemiliknya
berganti. Branch yang dipakai: `feat/sqflite-setup` (buat ulang dari `main`
karena branch lama sudah usang).

---

## 3. Bisma Adhiaksa — autentikasi dan profil (6,5 ho)

| Urutan | ID | Tugas | ho | Prasyarat | Target | Kriteria selesai |
|---:|---|---|---:|---|---|---|
| 1 | E3.1 | `google_sign_in` + Firebase Auth | 2,0 | — | Minggu 5 | Login Google berhasil di perangkat |
| 2 | E3.2 | Record cloud `users` + `profiles` saat login pertama | 1,0 | E3.1 | Minggu 5 | Profil terbentuk di cloud |
| 3 | E3.3 | Sesi persisten (`flutter_secure_storage`) | 1,0 | E3.1 | Minggu 5 | Masih login setelah restart |
| 4 | E3.4 | Sign out + jalur hapus akun | 1,0 | E3.1 | Minggu 6 | Logout bersih, data terhapus |
| 5 | E8.7 | Halaman Profil: nama, avatar, sign out, preferensi | 1,5 | E3.4 | Minggu 6 | Profil dapat diedit |

Prasyarat teknis: proyek Firebase dan `google-services.json` harus dibuat di
hari pertama. Berkas kunci tidak boleh di-commit.

Tugas rutin: memantau PR, memperbarui papan Notion, rekap mingguan.

---

## 4. Izza Dhafira Fanani — UI fitur dan dokumentasi (6,0 ho)

| Urutan | ID | Tugas | ho | Prasyarat | Target | Kriteria selesai |
|---:|---|---|---:|---|---|---|
| 1 | E8.6 | Halaman Admin: master data kategori warna dan jenis | 2,0 | E2.1 | Minggu 5 | Master data dapat dikelola |
| 2 | E8.1 | CRUD UI Lemari: tambah/hapus, filter, empty state | 2,0 | E2.2 | Minggu 6 | CRUD penuh berjalan |
| 3 | E8.4 | Konten Home: banner, kategori cepat, item terbaru | 1,5 | E2.5 | Minggu 6 | Tanpa placeholder |
| 4 | E10.1 | Logbook mingguan (0,5 per minggu) | 0,5 | — | Rutin | Terisi setiap Minggu |
| 5 | E8.3 | Ranking rekomendasi + teks explainability | 1,5 | E7.4 | Minggu 8 | Alasan tampil per outfit |
| 6 | E8.5 | Tab Detail data nyata | 1,5 | E8.3 | Minggu 8 | Tab menampilkan data item |

E8.3 dan E8.5 sengaja ditaruh terakhir karena menunggu integrasi Model 3.

---

## 5. Abim Mustawa — modul warna dan foto lapangan (7,0 ho)

| Urutan | ID | Tugas | ho | Prasyarat | Target | Kriteria selesai |
|---:|---|---|---:|---|---|---|
| 1 | E5.1 | Crop tengah + thresholding latar | 1,0 | — | Minggu 5 | Area warna lebih akurat pada 5 sampel |
| 2 | E5.2 | K-Means (k=3–5) Lab/HSV di Dart | 2,0 | E5.1 | Minggu 5–6 | Warna dominan benar pada 8 dari 10 gambar |
| 3 | E5.3 | Pemetaan palet 14 nama warna | 1,0 | E5.2 | Minggu 6 | Nama warna sesuai |
| 4 | E5.4 | Unit test warna | 1,0 | E5.3 | Minggu 6 | Test lulus |
| 5 | E10.2 | 150 foto lapangan untuk set uji | 2,0 | — | Minggu 5–6 | Set foto siap |

Branch: `feat/color-crop` untuk E5.1, lalu `feat/color-kmeans` untuk E5.2.

---

## 6. Ahmad Falahi — QA, dokumentasi, dan data ML (7,5 ho)

Sementara mobile belum selesai, Ahmad mengambil pekerjaan yang tidak menunggu
kode, ditambah tugas data ML yang punya waktu tunggu panjang.

| Urutan | ID | Tugas | ho | Prasyarat | Target | Kriteria selesai |
|---:|---|---|---:|---|---|---|
| 1 | — | Review PR #3 (rutin) | — | — | 28 Okt | PR digabung |
| 2 | E9.1 | Rencana uji + minimal 20 test case fungsional | 2,0 | — | Minggu 5 | Test case terdokumentasi |
| 3 | E4.1 | Unduh dataset + EDA + buang kelas ambigu | 1,0 | — | Minggu 5 | Dataset bersih + laporan EDA |
| 4 | E4.2 | Gabung kelas + mapping + split 70/15/15 | 1,0 | E4.1 | Minggu 5–6 | Mapping + split tersimpan |
| 5 | E10.5 | Dokumentasi fitur di `docs/` + README | 2,0 | E8.* | Minggu 6–7 | Dokumentasi mutakhir |
| 6 | E8.2 | Simpan outfit ke "Outfit Tersimpan" | 1,5 | E2.4 | Minggu 6 | Outfit tersimpan terdaftar |

E4.1 hanya butuh waktu unduh, bukan pengerjaan penuh. Jalankan di sela E9.1.

---

## 7. Fase ML setelah mobile

Dikerjakan mulai minggu 6, setelah E2 dan E3 berjalan dan E5 selesai.

| Tugas | ho | Prasyarat | Penanggung sementara |
|---|---:|---|---|
| E4.3 Baseline MobileNetV2 | 1,5 | E4.2 | Ahmad |
| E4.4 Latih YOLOv11n-cls + fine-tune | 2,5 | E4.2 | Ahmad |
| E4.5 Evaluasi (akurasi, F1, confusion matrix) | 1,0 | E4.4 | Ahmad |
| E4.6 Ekspor TFLite int8 | 1,0 | E4.4 | Ahmad |
| E6.1 Dataset pasangan + negative sampling | 2,0 | E4.2 | Faatihurrizki |
| E6.2 Feature builder | 1,0 | E6.1 | Faatihurrizki |
| E6.3 Latih MLP + pembanding | 2,0 | E6.2 | Ahmad |
| E6.5 Evaluasi AUC + precision@3 | 1,0 | E6.3, E6.4 | Bisma |
| E6.6 Ekspor MLP ke TFLite | 1,0 | E6.3 | Abim |
| E7.1 Loader TFLite + isolate | 1,5 | E4.6, E6.6 | Ahmad |
| E7.2 Inferensi Model 1 | 2,0 | E7.1 | Ahmad |
| E7.3 Ganti atribut placeholder | 1,5 | E7.2, E5.2 | Abim |
| E7.4 Skor Model 3 di rekomendasi | 1,5 | E7.1, E6.4 | Izza |
| E7.5 Fallback aturan | 1,0 | E7.4 | Izza |
| E7.6 Ukur latensi dan ukuran model | 1,0 | E7.2, E7.4 | Bisma |

Catatan: Faatihurrizki mengerjakan E6.1–E6.2 setelah rantai E2 selesai, karena
penyimpanan tetap prioritas lebih tinggi.

---

## 8. Aturan

1. Maksimal 2 tugas aktif per orang.
2. Satu tugas = satu branch = satu PR.
3. Tugas di kolom prasyarat belum boleh diambil sebelum prasyaratnya digabung.
4. Bila tertahan lebih dari satu hari, lepas tugas dan tulis catatan.
5. Status Notion dan logbook diperbarui setiap hari.
