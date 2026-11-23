# Logbook Minggu 9-12 - Sera-Z

**Proyek:** Sera-Z, Aplikasi Rekomendasi Kombinasi Gaya Pakaian Berbasis Machine Learning
**Tim:** Bisma Adhiaksa, Abim Mustawa, Ahmad Falahi, Faatihurrizki Prasojo, Izza Dhafira Fanani
**Kelas:** TI-3D, Semester 5
**Periode:** 10 November sampai 7 Desember 2026

> Catatan: minggu 11 dan 12 masih berupa rencana per 23 November 2026. Perbarui
> hasil aktual setelah pekerjaan selesai.

## Ringkasan

| Minggu | Periode | Fokus | Status |
|---|---|---|---|
| 9 | 10-16 Nov 2026 | Audit 16 warna, review PR, dan pengujian awal | Selesai |
| 10 | 17-23 Nov 2026 | Revisi alur mobile, rekomendasi per piece, detail outfit, ambang 70 persen | Selesai |
| 11 | 24-30 Nov 2026 | Finalisasi model TFLite, uji manual, bukti dan laporan Milestone 2 | Berjalan |
| 12 | 1-7 Des 2026 | Demo, perbaikan umpan balik, dan laporan akhir | Rencana |

## Minggu 9 - 10 sampai 16 November 2026

**Status:** Selesai
**Fokus:** Menyatukan acuan 16 warna, meninjau PR yang terbuka, dan menyiapkan pengujian.

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---|---|---|---|---|---|
| 10-13 Nov | Audit warna | Memeriksa 16 keluarga warna, harmoni CIELAB/CIELCh, dan pemetaan warna lama | Palet tampilan dan tabel ML masih 14 warna | Menyusun rencana migrasi | `color_family.dart`, `color_harmony.dart` |
| 14-15 Nov | Review PR | Memeriksa PR #51, #52, #53, dan #36 terhadap `dev` | Beberapa PR test masih bergantung pada palet lama | Menyiapkan QC gabungan | Komentar PR |
| 16 Nov | QC dan test | Menggabungkan PR #54 dan #56; menjalankan analyze dan test | Konflik kecil pada dokumen | Lanjut ke revisi mobile | PR #54, #56 |
| 16 Nov | Dokumentasi | Memperbarui alur warna dan konteks agen | Dokumen `docs/` diabaikan Git | Rangkum ke `ai-context/` | `Pembagian Tugas/alur-warna.md` |

**Ringkasan capaian:** Acuan 16 warna dan harmoni selesai. PR terkait warna dan test sudah ditinjau. Test awal bertambah menjadi 122.

**Kendala terbuka:**

1. Tabel ML masih 14 warna.
2. KMeans di Dart belum ada.
3. Beberapa PR masih konflik dengan `dev`.

## Minggu 10 - 17 sampai 23 November 2026

**Status:** Selesai
**Fokus:** Revisi alur mobile dan penyelesaian fitur Milestone 2.

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---|---|---|---|---|---|
| 17-18 Nov | Kamera dan pratinjau | Menambahkan tiga tombol simetris, crop kamera/galeri, flash, menghapus nama berkas, menyembunyikan chip kualitas palsu | Tombol outlined tidak terlihat di latar hitam | Border dan font putih, padding diperkecil | Commit `a97f408` |
| 19 Nov | Warna | Menambahkan 16 pilihan warna, mempertahankan warna hasil gambar, migrasi `ref_color` versi 4 | Warna baru belum ada di tabel ML | Catat sebagai risiko | Commit `861a7e6` |
| 19 Nov | Lemari | Menambahkan edit atribut, menu tekan lama Lihat/Edit/Hapus, dan detail pakaian | Foreign key warna baru gagal | Migrasi database versi 4 | `local_db.dart` |
| 20 Nov | Rekomendasi | Mengubah rekomendasi menjadi tiga outfit per atasan/bawahan, detail outfit tersimpan, edit/hapus, tekan lama | Duplikasi fitur dengan PR #51 | Tahan PR #51 dan rebase | PR #59 |
| 21 Nov | Ambang deteksi | Menambahkan ambang 70 persen dan layar Pakaian tidak terdeteksi | Belum ada uji foto low-confidence formal | Uji manual di Minggu 11 | PR #61 |
| 22-23 Nov | QA | Menjalankan 170 test, analyze bersih, build APK arm64, uji perangkat | Penyimpanan HP penuh | Install non-streaming | Commit `a97f408`, `861a7e6`, `eb7e812` |
| 23 Nov | Dokumentasi | Memperbarui status, arsitektur, peta tugas, README, alur warna, dan draf Milestone 2 | Beberapa placeholder laporan belum diisi | Lengkapi Minggu 11 | PR #59, #60, #61 |

**Ringkasan capaian:** Alur utama mobile berjalan. Kamera, warna, edit atribut, rekomendasi per piece, detail outfit, menu tekan lama, dan ambang 70 persen selesai. Test naik dari 122 menjadi 170.

**Kendala terbuka:**

1. Model 9 kelas belum menjadi aset aplikasi.
2. Model 10 kelas di PR #32 belum valid.
3. KMeans Dart belum ada.
4. Admin Master Data masih konflik.
5. Logbook, tangkapan layar, video, dan tag `milestone-2` belum lengkap.

## Minggu 11 - 24 sampai 30 November 2026

**Status:** Berjalan
**Fokus:** Finalisasi model, uji manual, dan bukti Milestone 2.

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---|---|---|---|---|---|
| 24-25 Nov | Model final | Ekspor TFLite model 9 kelas dan samakan label | Preprocessing dan urutan label harus sama | Uji 270 foto | `assets/models/` |
| 26 Nov | Uji manual | Menjalankan 14 kasus uji alur utama di perangkat | Hasil low-confidence perlu foto uji | Catat bug baru | Bab 4 laporan |
| 27 Nov | Bukti | Mengambil tangkapan layar, merekam video demo, membuat tag `milestone-2` | Penyimpanan perangkat | Kompres video | Lampiran A, E |
| 28-29 Nov | Laporan | Melengkapi logbook, Lampiran B, F, dan daftar tautan | Beberapa tautan harus publik | Uji incognito | Laporan M2 |
| 30 Nov | PR tersisa | Rebase PR #36 dan putuskan PR #51, #31, #32 | Konflik `local_db.dart` | Review ulang | PR terkait |

**Ringkasan capaian:** [isi setelah Minggu 11 selesai]

**Kendala terbuka:** [isi setelah Minggu 11 selesai]

## Minggu 12 - 1 sampai 7 Desember 2026

**Status:** Rencana
**Fokus:** Demo, perbaikan umpan balik, dan laporan akhir.

| Tanggal | Agenda | Kegiatan | Kendala | Rencana | Bukti/Link |
|---|---|---|---|---|---|
| 1-2 Des | Demo Day | Menyiapkan pembagian demo tiap anggota | Jadwal kelas | Latihan demo | S.5 |
| 3-4 Des | Perbaikan | Memperbaiki bug dari demo | Prioritas perbaikan | Rilis patch | Daftar bug |
| 5-6 Des | Laporan akhir | Melengkapi Bab 4.6, 5.4, 5.5, dan Lampiran | Data akhir model | Review tim | Laporan akhir |
| 7 Des | Serah terima | Ekspor PDF, uji tautan, unggah | - | Selesai | Google Form |

**Ringkasan capaian:** [isi setelah Minggu 12 selesai]

**Kendala terbuka:** [isi setelah Minggu 12 selesai]
