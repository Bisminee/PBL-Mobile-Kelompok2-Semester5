# Logbook Mingguan â€” Sera-Z

**Proyek:** Sera-Z â€” Aplikasi Rekomendasi Kombinasi Gaya Pakaian Berbasis Machine Learning
**Tim:** Bisma Adhiaksa (PM & QA) Â· Abim Mustawa (Mobile Dev) Â· Ahmad Falahi (ML Eng) Â· Faatihurrizki Prasojo (ML Eng) Â· Izza Dhafira Fanani (Sekretaris/Dokumentator)
**Mata kuliah:** Pemrograman Mobile Â· Pembelajaran Mesin Â· Penjaminan Mutu Perangkat Lunak (TI-3D)
**Periode:** 28 September â€“ 4 Desember 2026 (10 minggu)

---

## Cara Mengisi

- Isi **setiap minggu**, jangan menumpuk di akhir.
- Kolom **Bukti/Link** diisi tautan commit, PR, dokumen, atau foto kegiatan.
- Format tanggal: `28 Sep`.
- Status mingguan: Selesai Â· Berjalan Â· Belum mulai.

---

## Ringkasan Mingguan

| Minggu | Periode | Fokus | Status |
|--------|---------|-------|--------|
| 1 | 28 Sep â€“ 4 Okt | Fondasi aplikasi (E1): navigasi, layar, state, kamera, dokumentasi | Selesai |
| 2 | 5 â€“ 11 Okt | Logika harmoni warna (E6.4), alur Pull Request | Selesai |
| 3 | 12 â€“ 18 Okt | Pipeline Model 1 (PR #3), kualitas UI, keputusan lisensi dataset, persiapan E4.1 | Selesai |
| 4 | 19 â€“ 25 Okt | Susulan jalur ML (E4.1â€“E4.3) + evaluasi/ekspor Model 1, warna, penyimpanan, login | Selesai |
| 5 | 26 Okt â€“ 1 Nov | Latih YOLOv11n-cls, palet warna, MLP Model 3, profil & sesi, UI lemari | Selesai |
| 6 | 2 â€“ 8 Nov | Integrasi SQLite dan TFLite, auth, palet warna, QA plan | Selesai |
| 7 | 9 â€“ 15 Nov | Galeri dan crop, penutupan PR fitur, review ML, lanjutan E4.6 | Berjalan |
| 8 | 16 â€“ 22 Nov | Ranking + explainability, tab Detail, pengujian fungsional, konsolidasi evaluasi, draf laporan M1 | Belum |
| 9 | 23 â€“ 29 Nov | | Belum |
| 10 | 30 Nov â€“ 6 Des | | Belum |

Catatan: minggu 6 proyek sama dengan minggu 11 akademik (2â€“8 November 2026).
Minggu 7 proyek sama dengan minggu 12 akademik (9â€“15 November 2026).

---

## Minggu 1 â€” 28 Sep s.d. 4 Okt 2026

**Status:** Selesai
**Fokus:** Membangun fondasi aplikasi (Epic E1) dan menyiapkan dokumentasi serta pembagian tugas.

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| 28 Sep | Setup proyek | Inisialisasi repositori Git, menetapkan alur branch per fitur, `flutter create` (paket `sera_z`), menyusun struktur folder (`config`, `models`, `screens`, `services`, `widgets`) | â€” | Lanjut ke navigasi | Commit `first commit` |
| 29 Sep | Arsitektur & navigasi | Menyiapkan tema Material 3, membangun navigasi `go_router`, membuat 7 layar (Login, Sign up, Home, Kamera, Lemari, Rekomendasi, Detail) | `go_router` 18.x tidak kompatibel dengan SDK Dart proyek (menarik paket `material_ui`/`cupertino_ui`) â†’ dipin ke `^17.5.0` | Menyambungkan antar layar | `lib/main.dart`, `lib/config/app_theme.dart` |
| 30 Sep | Fitur kamera | Pratinjau kamera langsung, ganti kamera depan/belakang, ambil foto, penanganan izin Android & iOS | Developer Mode Windows belum aktif (peringatan symlink saat build plugin) | Integrasi ke alur | `lib/screens/camera_screen.dart`, `AndroidManifest.xml` |
| 1 Okt | State & alur | Menambahkan Riverpod, model data (Garment, Outfit), provider (auth, lemari, rekomendasi), dan menyambungkan alur Login â†’ Home â†’ Kamera â†’ Rekomendasi â†’ Detail | â€” | Menyiapkan penyimpanan data | `lib/services/providers.dart`, `lib/models/` |
| 2 Okt | Uji kualitas dasar | Menjalankan analisis statis (bersih) dan 2 widget test (layar awal + alur login) | â€” | Menambah test menyusul | `test/widget_test.dart` |
| 3 Okt | Dokumentasi teknis | Menyusun dokumen konteks: proposal, referensi metodologi, arsitektur data, wireframe & UX spec, penjelasan epic | Fitur *connectors* Figma tidak tersedia di versi akun â†’ pendekatan plugin flow dibatalkan | Melanjutkan dokumen interaksi manual | `context/`, `docs/wireframe-interactions.md` |
| 4 Okt | Pembagian tugas | Menyusun rincian fitur & pembagian tugas, kolam tugas tanpa pemilik, daftar epic, pemetaan branch, lalu membuat 8 branch tugas independen dan mem-push-nya | `gh` CLI belum login â†’ pembuatan PR masih manual | Mulai E2.1, E6.4, E9.1 | `Pembagian Tugas/`, commit `ab26e44` |

**Ringkasan capaian Minggu 1:** fondasi aplikasi selesai (E1), dokumentasi & pembagian tugas siap, 8 branch tugas independen sudah tersedia di GitHub.

**Kendala terbuka (dibawa ke minggu berikutnya):**
1. `gh` CLI belum login â†’ PR dibuat manual lewat GitHub.
2. Developer Mode Windows belum aktif â†’ aktifkan sebelum build plugin di desktop.
3. Fitur connector Figma tidak tersedia â†’ interaksi prototype ditambahkan manual.

---

## Minggu 2 â€” 5 s.d. 11 Okt 2026

**Status:** Berjalan
**Fokus:** Mengerjakan tugas independen pertama (logika harmoni warna), membuka alur Pull Request, dan memperbarui dokumentasi.

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| 11 Okt | Harmoni warna (E6.4) | Mengimplementasikan 4 aturan harmoni (monochromatic, analogous, complementary, neutral) pada ruang warna CIELCh; fungsi evaluasi pasangan warna dan outfit; ambang yang dapat diubah; keluaran skor 0â€“1 + nama aturan untuk *explainability* | Nilai warna uji harus dipilih di ruang Lab (bukan HSV) agar kasus komplementer terukur | Integrasi ke skor cadangan rekomendasi (E7.5) | `lib/services/color_harmony.dart`, commit `ebf6c53` |
| 11 Okt | Pengujian | Menulis 17 unit test: konversi warna, jarak hue, tiap aturan, kasus akromatik, agregasi outfit, dan ambang | â€” | Menambah test saat integrasi UI | `test/color_harmony_test.dart` |
| 11 Okt | Kualitas & rilis | Analisis statis bersih, seluruh test lulus (19), dokumentasi fitur ditulis, lalu membuka Pull Request ke `main` | â€” | Review dan gabung PR | PR #2, `docs/features/004-color-harmony-rules.md` |

**Ringkasan capaian:** Tugas independen E6.4 selesai. Logika harmoni warna siap dipakai sebagai fitur Model 3, lapisan *explainability*, dan skor cadangan.

**Kendala terbuka:**
1. Harmoni warna belum tersambung ke UI maupun Model 3 (menunggu E7.4/E7.5).
2. PR #2 menunggu review sebelum digabung ke `main`.
3. Gunakan alur branch â†’ PR untuk tugas berikutnya (bukan langsung ke `main`).

---

## Minggu 3 â€” 12 s.d. 18 Okt 2026

**Status:** Berjalan
**Fokus:** Pipeline Model 1 (PR #3), perbaikan kualitas UI (responsive layout), keputusan lisensi dataset, dan persiapan E4.1 (dataset + EDA).

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| 13 Okt | Pipeline Model 1 | Menyusun pipeline lengkap E4.1â€“E4.6: 6 script ML (persiapan dataset, penyeimbang, baseline, latih YOLOv11n-cls, evaluasi, ekspor TFLite), label maps 3 dataset, panduan teknis + rencana kerja tim; membuka PR #3 | Menunggu reviewer | Review & gabung PR #3 | PR #3, commit `febf71b` |
| 15â€“16 Okt | Kualitas UI | Memperbaiki overflow layout & menambah scrolling (Detail: `NestedScrollView` + tab pinned; `MaxWidthBox`; `BottomAppBar` adaptif); 26 widget test responsif di 4 ukuran layar; `flutter analyze` bersih, 45 test lulus | â€” | â€” | commit `5bbe1ac`, `test/layout_test.dart` |
| 16 Okt | Dataset & dokumen | Audit lisensi dataset (20+ kandidat) â†’ memilih paket bebas: Clothing Full (CC0), Fashion Product Images (MIT), Carousell (MIT); mengganti dataset non-komersial di rencana (FashionStylist â†’ Marqo/polyvore + Garments2Look; Digikala â†’ `baseColour`); menyelaraskan dokumen tugas E4/E5/E6; menulis ulang panduan Model 1 & `ml/README` (Bahasa Indonesia) | â€” | Unduh dataset | commit `f3ffa00`; PR #3 (`4183345`, `7145600`) |
| 18 Okt | Persiapan E4.1 | Menyiapkan lingkungan ML (`ml/.venv`: pandas, pillow, matplotlib), menulis skrip EDA `ml/scripts/00_eda.py`, membuat `ml/data/raw/`; mulai unduh 3 dataset manual dari Kaggle | Dataset belum selesai diunduh (manual via browser) | Jalankan EDA â†’ E4.2 | `ml/scripts/00_eda.py` |

**Ringkasan capaian:** Pipeline Model 1 diajukan lewat PR #3 (menunggu review); PR #2 (harmoni warna) digabung ke `main`; perbaikan responsive layout masuk `main` (45 test lulus); keputusan lisensi dataset difinalkan + dokumen tugas diselaraskan (E4/E5/E6); lingkungan ML + skrip EDA siap; branch bernama orang dibersihkan. Jalur ML (dataset) masih menunggu unduhan.

**Kendala terbuka:**
1. Dataset belum diunduh â†’ EDA & E4.2 bergeser (jalur kritis).
2. PR #3 menunggu reviewer.
3. Harmoni warna belum tersambung ke UI/Model 3 (menunggu E7.4/E7.5).

---

## Minggu 4 â€” 19 s.d. 25 Okt 2026

**Status:** Selesai (dokumen)
**Fokus:** Menyusun laporan kemajuan Milestone 1 dan merapikan dokumen pendukung.

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| 19â€“25 Okt | Laporan Milestone 1 | Menyusun laporan kemajuan Milestone 1 memakai template resmi (isi saja, tata letak tetap), melengkapi logbook minggu 1â€“8, membuat lampiran PDF logbook, dan merapikan dokumen pembagian tugas | Tidak ada commit kode pada rentang ini; dataset belum diunduh dan PR #3 belum direview | Membuka jalur data pada minggu 5 | `docs/`, `Pembagian Tugas/Logbook/logbook.md` (lokal) |

**Ringkasan capaian:** Laporan Milestone 1 selesai dan logbook minggu 1â€“8 lengkap.
Tidak ada perubahan kode pada minggu ini.

**Kendala terbuka:**
1. Dataset E4.1 belum diunduh (jalur kritis).
2. PR #3 belum direview.

---

## Minggu 5 â€” 26 Okt s.d. 1 Nov 2026

**Status:** Berjalan
**Fokus:** Menyiapkan dataset dan Model 1, lalu menyelesaikan autentikasi mobile.

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| 26 Okt | Konteks tim | Menambahkan branch `dev` untuk uji integrasi, `AGENTS.md`, dan folder `ai-context/` (arsitektur, konvensi kode, peta tugas, status proyek) agar anggota dan agen AI memakai konteks yang sama; memperbarui README bagian branch `dev` | `main` sudah bergerak satu commit (`2e33e55`), `dev` perlu disinkronkan | Sinkronkan `dev` dengan `main` | commit `017b787` |
| 27 Okt | Perencanaan | Menyusun ulang timeline 10 minggu sesuai kondisi nyata, membuat pembagian tugas minggu 5 dan blok ML terpisah dengan branch `dev-ml`, serta memperbarui status pada daftar jobdesk | â€” | â€” | `Pembagian Tugas/timeline.md`, `pembagian-tugas-minggu-5.md` |
| 27 Okt | Dataset Model 1 | Mengekstrak tiga dataset berlisensi bebas dari `D:\Kuliah\Semester5\DatasetPBL`: Clothing Full, Fashion Products, Carousell. Menjalankan `01_prepare_model1.py`: 34.077 gambar terfilter, 33.667 setelah deduplikasi MD5, split 70/15/15 (train 23.566, val 5.050, test 5.051) | Tanpa GPU, pelatihan berjalan di CPU | Latih Model 1 | PR #6, `ml/reports/dataset_summary.md` |
| 27â€“28 Okt | Latihan Model 1 | Melatih YOLOv11n-cls enam epoch di CPU selama 5 jam 5 menit. Akurasi validasi 94,06 persen; evaluasi test 94,34 persen dengan macro F1 89,48 persen. Menyusun laporan evaluasi, confusion matrix, akurasi per sumber, dan model card | Satu epoch memakan 41 menit; akurasi carousell paling rendah (87,79 persen) | Ekspor TFLite dan integrasi | PR #7, `ml/reports/model1-card.md` |
| 28 Okt | Autentikasi mobile | Menyiapkan Firebase (plugin Gradle, `google-services.json` diabaikan Git), membuat `AuthService` login Google, `UserRepository` untuk `users` dan `profiles`, sesi persisten dengan redirect rute, logout, dan hapus akun. Lima PR digabung ke `dev`; `flutter analyze` bersih dan 18 test lulus | Uji login di perangkat belum dilakukan; ekspor TFLite terhambat di Windows | Uji login, lanjut E2 dan E5 | PR #8â€“#12, commit `0d671cc` |
| 29 Oktâ€“1 Nov | Target sisa W5 | Menyelesaikan E2 penyimpanan, E5 modul warna, label dan aset model, metrik Model 3, serta ekspor TFLite lewat Colab | Ekspor TFLite belum berhasil di Windows | Integrasi E7 | â€” |

**Ringkasan capaian:** Dataset Model 1 siap dan terbagi rapi; Model 1 mencapai
akurasi test 94,34 persen; autentikasi mobile lengkap dari login sampai hapus
akun dan sudah tergabung di `dev`; enam PR digabung dan integrasi `dev` lulus
`flutter analyze` serta 18 test.

**Kendala terbuka:**
1. Ekspor TFLite gagal di Windows karena Ultralytics 8.4 menghapus dukungan
   TFLite dan jalur `onnx2tf` pada 8.3 melewati batas waktu.
2. `dev-ml` belum digabung ke `dev`.
3. Uji login dan hapus akun di perangkat belum dilakukan.
4. E2 penyimpanan, E5 modul warna, E8 fitur, dan E6 Model 3 belum dikerjakan.

---

## Minggu 6 â€” 2 s.d. 8 Nov 2026

**Status:** Berjalan
**Fokus:** Integrasi, penyelesaian fitur, dan persiapan QA.

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| 2 Nov | Integrasi dan pembersihan | Menggabungkan `dev-ml` ke `dev` (laporan evaluasi Model 1 dan dataset summary); menghapus branch `dev-ml`; memindahkan aturan harmoni ke alasan rekomendasi dan menghapus widget tak terpakai (PR #14); membersihkan 16 branch merged, 23 README lokal, dokumen minggu 4, dan folder `runs` | Ekspor TFLite model sendiri masih gagal di Windows | Kerjakan sisa tugas minggu | commit `88a9e22`, `bbbf8c3`, `ac1b8e1`, PR #14 |
| 2 Nov | Perencanaan | Memisahkan tabel mobile dan ML pada pembagian tugas; membuat panduan kerja khusus Bisma; menyelaraskan status di `pembagian-tugas.md`, `feature-breakdown-id.md`, `branches.md`, `timeline.md`, dan `jobdesk-per-anggota.md` | Beban Bisma tinggi | Bagi ulang tugas | commit `6d95688`, `67681c0` |
| 3 Nov | Audit notebook ML | Meninjau `Evaluasi_YOLO11n_cls.ipynb`: ekspor TFLite berhasil 6,0 MB tetapi belum int8; evaluasi memakai pipeline lama 15 kelas dengan top1 87,66 persen; aset `yolo11n_cls.tflite` di aplikasi beroutput 15 kelas float32 | Model di aplikasi bukan model 9 kelas hasil latihan | Putuskan model yang dipakai | Berkas notebook lokal |
| 4 Nov | Dokumentasi dan pembagian ulang | Memindahkan tutorial Git ke `panduan-git-dan-branch.md` dan menjadikan README sebagai deskripsi proyek; membagi ulang tugas ke Pras, Ahmad, dan Izza; memindahkan penanganan objek bukan outfit ke Abim; mengganti nama dokumen menjadi minggu 11 | â€” | Kerjakan tugas baru | commit `6b7a80f`, `87cd5a4`, `bc73581`, `e04be43` |
| 5â€“6 Nov | Implementasi mobile dan QA | E7.5 fallback rekomendasi aturan (PR #15), rapikan UI autentikasi (PR #16), profil sesuai akun Google (PR #17), palet 14 warna + 5 unit test (PR #18); menyusun `qa-plan.md` berisi 34 test case | Ekspor TFLite dan uji perangkat belum | Ekspor model, uji perangkat | PR #15â€“#18, commit `0412d01` |
| 7â€“8 Nov | Target penutup | Uji fungsional black-box, uji perangkat, ekspor TFLite, perbaikan temuan | â€” | Uji regresi dan rekap | â€” |

**Ringkasan capaian:** empat PR digabung ke `dev` pada minggu ini: fallback
rekomendasi, perbaikan UI autentikasi, profil sesuai akun Google, dan palet 14
warna. Total test naik dari 39 menjadi 46 dan `flutter analyze` bersih.
Rencana QA dengan 34 test case juga sudah disusun.

**Kendala terbuka:**
1. Ekspor TFLite model sendiri gagal di Windows, perlu Colab atau Linux.
2. Model 3 masih memakai data sintetis.
3. Uji login dan hapus akun di perangkat belum.
4. Aset model di aplikasi masih 15 kelas float32, sedangkan model latihan 9 kelas.

---

## Minggu 7 - 9 s.d. 15 Nov 2026 (minggu 12 akademik)

**Status:** Berjalan
**Fokus:** Integrasi galeri dan crop, penutupan PR fitur, review PR ML, dan perbaikan model.

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| 9 Nov | Galeri dan crop | Impor foto dari galeri (PR #20), halaman crop 1:1 (PR #21), tombol galeri kamera dan Photo Picker (PR #24) | Uji pemilih foto di perangkat belum | Uji galeri di HP | PR #20, #21, #24 |
| 9 Nov | Penutupan PR fitur | Simpan outfit dan pencarian lemari (PR #25), foto outfit dan ringkasan Home (PR #27), perbaikan overflow (PR #28), ikon aplikasi (PR #29). Test naik dari 76 menjadi 80 | Outfit lama bisa tertinggal tanpa item | Bersihkan outfit kosong | PR #25, #27, #28, #29 |
| 9 Nov | Audit ML | Aset aplikasi 15 kelas dibandingkan model latihan 9 kelas pada 270 foto: 65,6 persen lawan 86,7 persen. Ekspor float32, float16, dan int8 dynamic range diperiksa | Layout input NHWC lawan NCHW | Putuskan model final | `ml/runs/model1_yolo11n/weights/best_saved_model/` |
| 10 Nov | Arahan dosen dan AI context | Mencatat arahan dosen: klasifikasi jenis memakai satu dataset, kombinasi warna menjadi pekerjaan ML terpisah. Memperbarui `ai-context` dan `AGENTS.md` | Keputusan dataset dan kelas `other` belum final | Susun ulang pembagian tugas ML | PR #35 |
| 11 Nov | PR fitur baru | Pras mengajukan riwayat rekomendasi (PR #37), ranking dan explainability (PR #38), serta unit test DAO (PR #39). Izza mengajukan halaman Admin (PR #36) | Belum direview | Review dan uji | PR #36 sampai #39 |
| 12 Nov | PR dokumentasi dan test | Izza mengajukan unit test model (PR #41), dokumentasi ML engine (PR #42), test palet (PR #43), dokumentasi metode ML (PR #44), verifikasi CRUD lemari (PR #45), dan komentar thumbnail (PR #46) | Beberapa PR hanya menambah komentar atau kosong | Periksa isi sebelum merge | PR #41 sampai #46 |
| 13 Nov | Review dan merge | Menggabungkan #22 (evaluasi Model 3), #23 (riset aksesoris), #26 (profil/auth), #37 (riwayat), #38 (ranking), #39 (test DAO), dan #42 (dokumentasi ML engine). Test naik dari 80 menjadi 111 dan analyze bersih | #30, #31, dan #36 konflik setelah perubahan dev. #32 belum dipakai karena TFLite model v3 salah pada 3 dari 270 foto | Minta rebase #30, #31, #36; perbaiki model #32 | PR #22, #23, #26, #37, #38, #39, #42 |
| 14-15 Nov | Rencana lanjutan | Selesaikan konflik #30, #31, #36; perbaiki atau ekspor ulang model #32; kerjakan E4.6, E5.2, E5.4, E7.6; uji perangkat | Model final dan uji perangkat belum | Selesaikan dua tugas aktif per orang | - |

**Ringkasan capaian:** tujuh PR digabung pada 13 November, yaitu #22, #23,
#26, #37, #38, #39, dan #42. Test otomatis naik dari 80 menjadi 111 dan
`flutter analyze` bersih. Arahan dosen sudah dicatat di `ai-context`.
Pemeriksaan TFLite model v3 menunjukkan model belum akurat dengan
preprocessing aplikasi.

**Kendala terbuka:**
1. Aset aplikasi masih model 15 kelas; model latihan 9 kelas belum dipasang.
2. Model 10 kelas v3 di PR #32 gagal pada uji aplikasi: 3 dari 270 foto benar.
3. PR #30, #31, dan #36 konflik setelah dev berubah dan perlu rebase.
4. E4.6 ekspor final dan pemetaan label belum selesai.
5. Modul 2 K-Means di Dart (E5.2) belum dikerjakan.
6. Model 3 masih memakai data sintetis.
7. Uji perangkat untuk galeri, crop, login, dan hapus akun belum.
8. Beberapa PR baru hanya menambah komentar atau tidak memiliki perubahan.

---

## Minggu 8 â€” 16 s.d. 22 Nov 2026

**Status:** Rencana (diperbarui saat minggu berjalan)
**Fokus:** Penutupan Milestone 1: pengujian fungsional, konsolidasi evaluasi, dan draf laporan.

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| 16â€“22 Nov | Penutupan M1 | Ranking + teks explainability (E8.3); tab Detail data nyata (E8.5); eksekusi fungsional black-box + catat bug (E9.2); konsolidasi laporan evaluasi ML (E9.5); tabulasi kuesioner (E10.3); draf laporan Milestone 1 | â€” | Milestone 2: uji performa & kompatibilitas (E9.3â€“E9.4), pelacakan bug (E9.7), laporan akhir (E10.4â€“E10.5) | â€” |

**Ringkasan capaian:** (rencana â€” diperbarui saat minggu berjalan)

**Kendala terbuka:** â€”

---

## Minggu 9 â€” 23 s.d. 29 Nov 2026

**Status:** Belum mulai
**Fokus:**

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| | | | | | |

**Ringkasan capaian:**

**Kendala terbuka:**

---

## Minggu 10 â€” 30 Nov s.d. 6 Des 2026

**Status:** Belum mulai
**Fokus:**

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---------|--------|----------|---------|---------|------------|
| | | | | | |

**Ringkasan capaian:**

**Kendala terbuka:**

