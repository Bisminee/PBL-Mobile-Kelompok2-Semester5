# Jobdesk per Anggota — Sera-Z

Diperbarui: 27 Oktober 2026
Prinsip: **pembangunan mobile dulu**. ML dan pemrosesan gambar dijeda.

## Ruang lingkup

| Dikerjakan sekarang | Dijeda |
|---|---|
| E2 Penyimpanan (7,0 ho) | E4 Model 1 (Python) |
| E3 Autentikasi (5,0 ho) | E5 Modul warna (pemrosesan gambar) |
| E8.1, E8.2, E8.4, E8.6, E8.7 (8,5 ho) | E6 Model 3 (Python) |
| | E7 Integrasi TFLite |
| | E8.3 dan E8.5 (menunggu E7.4) |
| | E9 QA dan E10 dokumentasi |

Total pekerjaan mobile: **20,5 ho**, dibagi ke 5 orang, rata-rata 4,1 ho.

Estimasi dalam jam-orang (ho). Prasyarat mengikuti
`feature-breakdown-id.md`.

---

## 1. Ringkasan beban

| Anggota | Tugas | ho | Porsi |
|---|---|---:|---:|
| Faatihurrizki Prasojo | E2.1, E2.2, E2.3 | 3,5 | 17 persen |
| Ahmad Falahi | E2.4, E2.5, E2.6 | 3,5 | 17 persen |
| Bisma Adhiaksa | E3.1, E3.2, E3.3, E3.4 | 5,0 | 24 persen |
| Izza Dhafira Fanani | E8.1, E8.6 | 4,0 | 20 persen |
| Abim Mustawa | E8.2, E8.4, E8.7 | 4,5 | 22 persen |
| **Total** | | **20,5** | **100** |

Rentang 3,5-5,0 ho. Selisih ini muncul karena ukuran tugas tidak bisa dibelah
lebih kecil lagi tanpa memutus rantai kerja. Pras dan Ahmad memegang rantai
penyimpanan yang harus berurutan; Bisma memegang rantai autentikasi utuh.

---

## 2. Faatihurrizki Prasojo — pondasi penyimpanan (3,5 ho)

| Urutan | ID | Tugas | ho | Prasyarat | Target | Kriteria selesai |
|---:|---|---|---:|---|---|---|
| 1 | E2.1 | Setup `sqflite` + `path_provider`, helper DB + migrasi versi | 1,0 | — | 28 Okt | DB terbuka, skema v1 berjalan |
| 2 | E2.2 | CRUD `wardrobe_items` (tambah, ambil, ubah, hapus) | 1,5 | E2.1 | 29 Okt | Item tetap ada setelah restart |
| 3 | E2.3 | Simpan foto ke folder dokumen, simpan hanya path | 1,0 | E2.1 | 30 Okt | Foto tampil, DB tidak membengkak |

Branch: `feat/sqflite-setup` (buat ulang dari `main`, branch lama usang).

Yang dibuka: E8.6 (butuh E2.1) dan E8.1 (butuh E2.2). Karena itu E2.1 adalah
tugas pertama yang harus selesai di seluruh tim.

---

## 3. Ahmad Falahi — lanjutan penyimpanan (3,5 ho)

| Urutan | ID | Tugas | ho | Prasyarat | Target | Kriteria selesai |
|---:|---|---|---:|---|---|---|
| 1 | E2.4 | Tabel `outfits` + `recommendation_history` + DAO | 1,5 | E2.1 | 30 Okt | Simpan/daftar outfit dan riwayat berhasil |
| 2 | E2.5 | Muat lemari dan riwayat saat start (provider async) | 1,0 | E2.2, E2.4 | 31 Okt | Data muncul setelah cold start |
| 3 | E2.6 | Unit test DAO | 1,0 | E2.2, E2.4 | 1 Nov | Test lulus |

Ahmad mulai setelah E2.1 selesai (28 Okt), bukan menunggu E2.3.

Yang dibuka: E8.2 (butuh E2.4) dan E8.4 (butuh E2.5).

---

## 4. Bisma Adhiaksa — autentikasi (5,0 ho)

| Urutan | ID | Tugas | ho | Prasyarat | Target | Kriteria selesai |
|---:|---|---|---:|---|---|---|
| 1 | E3.1 | `google_sign_in` + Firebase Auth | 2,0 | — | 29 Okt | Login Google berhasil di perangkat |
| 2 | E3.2 | Record cloud `users` + `profiles` saat login pertama | 1,0 | E3.1 | 30 Okt | Profil terbentuk di cloud |
| 3 | E3.3 | Sesi persisten (`flutter_secure_storage`) | 1,0 | E3.1 | 31 Okt | Masih login setelah restart |
| 4 | E3.4 | Sign out + jalur hapus akun | 1,0 | E3.1 | 1 Nov | Logout bersih, data terhapus |

Prasyarat teknis: proyek Firebase dan `google-services.json` dibuat 28 Okt.
Berkas kunci tidak boleh di-commit.

Yang dibuka: E8.7 (butuh E3.4).

---

## 5. Izza Dhafira Fanani — fitur lemari dan admin (4,0 ho)

| Urutan | ID | Tugas | ho | Prasyarat | Target | Kriteria selesai |
|---:|---|---|---:|---|---|---|
| 1 | E8.6 | Halaman Admin: master data kategori warna dan jenis | 2,0 | E2.1 | 29-30 Okt | Master data dapat dikelola |
| 2 | E8.1 | CRUD UI Lemari: tambah/hapus, filter, empty state | 2,0 | E2.2 | 31 Okt-1 Nov | CRUD penuh berjalan |

Boleh mulai dengan rancangan layar dan skema master data sebelum E2.1 selesai,
lalu menyambungkan ke database setelah Pras menyelesaikan E2.1/E2.2.

---

## 6. Abim Mustawa — outfit, home, dan profil (4,5 ho)

| Urutan | ID | Tugas | ho | Prasyarat | Target | Kriteria selesai |
|---:|---|---|---:|---|---|---|
| 1 | E8.7 | Halaman Profil: nama, avatar, sign out, preferensi | 1,5 | E3.4 | 31 Okt-1 Nov | Profil dapat diedit |
| 2 | E8.2 | Simpan outfit ke "Outfit Tersimpan" | 1,5 | E2.4 | 31 Okt | Outfit tersimpan terdaftar |
| 3 | E8.4 | Konten Home: banner, kategori cepat, item terbaru | 1,5 | E2.5 | 1 Nov | Tanpa placeholder |

Semua tugas Abim bergantung pada pekerjaan orang lain. Mulai dengan membangun
tampilan statis (UI shell) sejak 27 Okt, lalu menyambungkan data saat prasyarat
selesai. Jangan menunggu diam.

---

## 7. Ketergantungan yang harus dijaga

```
E2.1 (Pras) ─┬─► E2.2 (Pras) ─┬─► E2.5 (Ahmad) ─► E8.4 (Abim)
             │                └─► E8.1 (Izza)
             ├─► E2.3 (Pras)
             └─► E2.4 (Ahmad) ─┬─► E2.5 (Ahmad)
                                ├─► E2.6 (Ahmad)
                                └─► E8.2 (Abim)
E2.1 ─► E8.6 (Izza)

E3.1 (Bisma) ─┬─► E3.2 (Bisma)
              ├─► E3.3 (Bisma)
              └─► E3.4 (Bisma) ─► E8.7 (Abim)
```

Titik kritis: **E2.1 (Pras)**. Kalau E2.1 mundur, E8.1, E8.2, E8.4, E8.6, dan
E2.4-E2.6 semuanya ikut mundur.

---

## 8. Setelah mobile selesai

Baru dimulai setelah E2, E3, dan E8.1-E8.7 (yang tidak menunggu ML) lulus uji:

| Urutan | Pekerjaan | Mulai |
|---|---|---|
| 1 | E5 modul warna (pemrosesan gambar) | Minggu 7 |
| 2 | E4.1-E4.6 Model 1 | Minggu 7 |
| 3 | E6.1-E6.6 Model 3 | Minggu 8 |
| 4 | E7.1-E7.6 integrasi TFLite | Minggu 9 |
| 5 | E8.3, E8.5 | Minggu 9 |
| 6 | E9 QA dan E10 dokumentasi | Minggu 9-10 |

---

## 9. Aturan

1. Maksimal 2 tugas aktif per orang.
2. Satu tugas = satu branch = satu PR. Nama branch per tugas ada di
   `Pembagian Tugas/pembagian-tugas-minggu-5.docx` bagian 6.
3. Tugas yang prasyaratnya belum selesai tidak diambil.
4. Kalau tertahan lebih dari satu hari, lepas tugas dan tulis catatan.
5. Anggota yang selesai lebih cepat boleh mengambil tugas mobile lain yang
   belum selesai, dengan tetap maksimal 2 tugas aktif.
6. Status Notion dan logbook diperbarui setiap hari.
