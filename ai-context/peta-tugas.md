# Peta Tugas dan PIC

Diperbarui: 23 November 2026 (setelah PR #52)

Sumber kebenaran: `Pembagian Tugas/feature-breakdown-id.md`,
`Pembagian Tugas/pembagian-tugas-minggu-11.md`, dan
`Pembagian Tugas/tugas-ml-per-anggota.md`.

Pembagian mobile dan ML terbaru: `Pembagian Tugas/pembagian-tugas-minggu-14.md`
(25 November 2026).

## 1. Epic dan status

| Epic | Nama | Status |
|---|---|---|
| E1 | Fondasi aplikasi | Selesai |
| E2 | Penyimpanan dan data | Selesai untuk lemari, outfit, riwayat, dan migrasi versi 4 |
| E3 | Autentikasi dan cloud | Selesai |
| E4 | Model 1 klasifikasi jenis | Model 9 kelas selesai; E4.6 dan pemasangan model belum |
| E5 | Modul 2 ekstraksi warna | Acuan 16 warna selesai; E5.2 K-Means dan E5.4 test belum |
| E6 | Model 3 skor kecocokan | Aturan dan skor pasangan jalan; data nyata dan ekspor MLP belum |
| E7 | Integrasi on-device | E7.1 sampai E7.5 jalan; E7.6 latensi belum |
| E8 | Penyelesaian fitur | CRUD lemari, edit atribut, detail outfit, dan tekan lama selesai; Admin belum |
| E9 | QA dan pengujian | 170 test, analyze bersih, APK diuji di HP; QA fungsional penuh belum |
| E10 | Dokumentasi | Berjalan |

## 2. Arahan ML per 10 November 2026

Arahan dosen: klasifikasi jenis pakaian memakai satu dataset, sedangkan
kombinasi warna menjadi pekerjaan ML terpisah.

| Kode | Tugas ML | Isi | Data | PIC | Status |
|---|---|---|---|---|---|
| T1 | Klasifikasi jenis pakaian | Satu model, satu label jenis | Satu dataset, belum dipilih | Bisma dan Abim | Perlu disusun ulang |
| T2 | Ekstraksi warna | Warna dominan per item, terpisah dari jenis | Gambar item | Izza dan Bisma | Sebagian: acuan 16 warna selesai, ekstraksi HSV, K-Means Dart belum |
| T3 | Kombinasi warna | Skor cocok atau tidaknya dua warna | Dataset pasangan warna atau outfit | Ahmad dan Bisma | Prototipe sintetis, belum data nyata |
| T4 | Penolakan non-cloth | Menerima pakaian atau menolak objek lain | Foto pakaian dan negatif | Abim | PR #32, model TFLite belum valid |

Keputusan yang belum diambil:

1. Dataset tunggal untuk T1: Fashion Product Images Small, Carousell, atau Clothing Dataset Full.
2. `other` menjadi kelas ke-10 atau gate terpisah.
3. Cakupan T3: penilaian pasangan warna, ekstraksi warna, atau keduanya.

## 3. PIC tugas saat ini

| Anggota | Tugas utama | Berkas atau PR | Status |
|---|---|---|---|
| Bisma | Pipeline Model 1, palet, dokumentasi ML, integrasi rekomendasi | `ml/scripts/`, PR #18, #33 | Model 9 kelas selesai; E4.6 belum |
| Pras | Integrasi TFLite, mesin outfit, harmoni, database ML | PR #13, `garment_classifier.dart`, `outfit_engine.dart` | Selesai |
| Abim | Pipeline 10 kelas, penolakan objek, database pendukung | PR #31 dan #32 | PR terbuka; TFLite v3 belum valid |
| Ahmad | Evaluasi Model 3, riset dataset aksesoris | PR #22 dan #23 | Perbaikan selesai, menunggu review |
| Izza | Unit test warna, dokumentasi metode ML | Belum ada branch | Belum ada bukti di GitHub |

## 4. Tugas aplikasi yang tersisa

| Tugas | PIC | Status |
|---|---|---|
| E2.4 Riwayat rekomendasi | Pras | Selesai |
| E2.6 Unit test DAO | Pras | Selesai |
| E7.6 Latensi dan ukuran model | Abim | Belum |
| E8.1 CRUD UI Lemari lengkap | Izza | Selesai: tambah, lihat, edit, hapus, tekan lama |
| E8.6 Halaman Admin | Izza | Belum |
| E8.3 Ranking dan explainability | Pras | Sebagian: ranking per piece dan alasan sudah ada |
| E5.2 K-Means di Dart | Belum ada PIC | Belum |
| E5.4 Unit test warna | Izza | Sebagian: 16 keluarga dan palet sudah diuji |
| Dokumentasi metode ML | Izza | Belum |
| E10.2 Foto lapangan | Pras | Belum |
| Uji perangkat | Bisma | Belum |

## 5. Aturan pengambilan tugas

1. Ambil tugas yang prasyaratnya sudah selesai.
2. Maksimal dua tugas aktif per orang.
3. Satu tugas = satu branch = satu PR.
4. Branch dari `dev`, PR ke `dev`.
5. Perbarui status di logbook dan papan tugas.

## 6. Definisi selesai

1. Berjalan di perangkat Android nyata lewat alur utama.
2. Test terkait lulus, termasuk uji inferensi model bila menyentuh ML.
3. Digabung lewat PR yang direview ke `dev`.
4. Tercatat di laporan ML atau dokumentasi fitur.
5. Untuk model: metrik diukur pada data uji yang tidak dipakai melatih.
