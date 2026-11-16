# Pembagian Tugas Minggu 13 - Sera-Z

Tim Sera-Z - Kelas TI-3D - Semester 5
Periode: **16 - 22 November 2026** (minggu 13 akademik, minggu 8 proyek)
Disusun: 16 November 2026

Fokus minggu ini: menutup PR yang masih terbuka, menetapkan satu dataset untuk
klasifikasi jenis pakaian, memperbaiki model 10 kelas, menjalankan QA fungsional,
dan menyiapkan bahan laporan Milestone 2.

## 1. Status awal

| Item | Kondisi |
|---|---|
| Ujung `dev` | `0249f43` |
| PR digabung | 40 PR |
| Test otomatis | 111 test lulus |
| `flutter analyze` | Bersih |
| PR terbuka | #30, #31, #32, #36 |
| Blocker utama | Model v3 di #32 belum akurat; #30, #31, dan #36 konflik |

PR yang masih terbuka:

| PR | Isi | Kondisi |
|---|---|---|
| #30 | Dokumen status proyek | Konflik dengan status yang lebih baru |
| #31 | Pipeline Hugging Face dan kelas `other` | Konflik README dan penomoran script |
| #32 | Model 10 kelas dan penolakan objek | Bersih secara Git, tetapi TFLite hanya benar 3 dari 270 foto |
| #36 | Admin master data | Konflik `local_db.dart` karena versi database 3 sudah dipakai |

## 2. Arahan dosen

| Arahan | Tindak lanjut minggu ini |
|---|---|
| Klasifikasi jenis pakaian memakai satu dataset | Tetapkan satu dataset, siapkan split, dan latih ulang T1 |
| Kombinasi warna menjadi pekerjaan ML terpisah | Susun T3 sebagai tugas terpisah dengan data dan evaluasi sendiri |
| Fokus cek tipe baju | Pisahkan tas, aksesoris, dan `other` dari classifier jenis pakaian |
| Penolakan objek bukan pakaian | Putuskan `other` sebagai kelas ke-10 atau gate terpisah |

Keputusan yang harus diambil paling lambat 18 November:

1. Dataset tunggal untuk T1: Fashion Product Images Small, Carousell, atau Clothing Dataset Full.
2. `other` menjadi kelas ke-10 atau gate biner terpisah.
3. Cakupan T3: penilaian pasangan warna, ekstraksi warna, atau keduanya.

## 3. Pekerjaan mobile

| PIC | Tugas | ho | Branch | Selesai bila |
|---|---|---:|---|---|
| Izza | Rebase PR #36 Admin master data, selesaikan konflik database versi 3 ke versi 4, dan pastikan CRUD `ref_garment_type` serta `ref_color` berjalan | 2,0 | `feat/admin-master-data` | PR #36 bisa digabung dan halaman Admin bisa mengelola master data |
| Izza | Rapikan PR kecil yang sudah digabung: pastikan tidak ada komentar menggantung, tidak ada PR kosong, dan dokumentasi ML berada di folder yang benar | 0,5 | `docs/ml-methods` | Analyze bersih dan dokumen tidak berada di folder `docs/` yang di-ignore |

## 4. Pekerjaan Machine Learning

| PIC | Tugas | ho | Branch | Selesai bila |
|---|---|---:|---|---|
| Bisma | Tetapkan satu dataset untuk T1, siapkan ulang split, ekspor TFLite final, dan validasi dengan preprocessing aplikasi | 2,5 | `ml/single-dataset` | Satu dataset dipakai, model termuat, dan akurasi TFLite terukur |
| Abim | Perbaiki model v3 di #32: validasi TFLite dengan preprocessing aplikasi, ekspor ulang bila perlu, lalu rebase #31 | 3,0 | `feat/non-clothing-object`, `ml/model1-v2-pipeline` | Model 10 kelas akurat dan label sesuai database |
| Ahmad | Susun T3 kombinasi warna: dataset pasangan, fitur, model pembanding, dan evaluasi terpisah dari T1 | 2,0 | `ml/color-combination` | Ada laporan AUC atau precision@3 dan batasan data |
| Izza | Lengkapi E5.4 dengan unit test warna yang benar, bukan hanya komentar | 1,0 | `test/color-palette` | Test baru menguji kasus yang belum tercakup dan lulus |

Catatan ML:

1. Model v3 tidak boleh digabung sebelum diuji dengan `preprocessForModel` yang sama dengan aplikasi.
2. Dataset negatif untuk `other` harus disetujui tim. COCO tetap opt-in dan perlu atribusi.
3. T2 ekstraksi warna tetap terpisah dari T1. K-Means di Dart belum menjadi prioritas minggu ini bila T1 belum selesai.

## 5. QA dan dokumentasi

| PIC | Tugas | ho | Branch | Selesai bila |
|---|---|---:|---|---|
| Ahmad | E9.2 uji fungsional black-box: jalankan alur utama dan catat bug | 2,0 | `test/functional` | Daftar kasus, hasil, dan bug terdokumentasi |
| Bisma | Uji perangkat: galeri, crop, login, logout, dan hapus akun | 1,5 | `test/device-check` | Semua alur berhasil di minimal satu HP Android |
| Bisma | Logbook minggu 13 dan rekap status | 0,5 | `docs/logbook-13` | Logbook terisi sampai 22 November |
| Pras | E10.2 kumpulkan 150 foto lapangan | 2,0 | `docs/field-photos` | 150 foto terkumpul dan tercatat |
| Pras | E9.3 uji performa: latensi inferensi dan ukuran model | 1,0 | `test/performance` | Latensi di bawah 3 detik dan model di bawah 20 MB |

## 6. Ringkasan beban

| Anggota | Mobile | ML | QA dan dokumen | Total |
|---|---:|---:|---:|---:|
| Bisma Adhiaksa | 0 | 2,5 | 2,0 | **4,5** |
| Abim Mustawa | 0 | 3,0 | 0 | **3,0** |
| Ahmad Falahi | 0 | 2,0 | 2,0 | **4,0** |
| Faatihurrizki Prasojo | 0 | 0 | 3,0 | **3,0** |
| Izza Dhafira Fanani | 2,5 | 1,0 | 0 | **3,5** |
| **Total** | **2,5** | **8,5** | **7,0** | **18,0** |

Setiap anggota memegang maksimal dua tugas aktif.

## 7. Rencana harian

| Hari | Bisma | Abim | Ahmad | Pras | Izza |
|---|---|---|---|---|---|
| Senin, 16 Nov | Tetapkan dataset T1 | Cek ulang TFLite v3 | Siapkan dataset T3 | Mulai foto lapangan | Rebase #36 |
| Selasa, 17 Nov | Siapkan split satu dataset | Perbaiki ekspor model | Latih pembanding T3 | Foto lapangan | Perbaiki konflik database |
| Rabu, 18 Nov | Latih atau ekspor model | Rebase #31 | Evaluasi T3 | Foto lapangan | Uji Admin |
| Kamis, 19 Nov | Validasi TFLite | Uji model dengan preprocessing aplikasi | Mulai E9.2 | Uji performa | Test warna |
| Jumat, 20 Nov | Uji perangkat | Perbaiki temuan | E9.2 lanjutan | Rekap foto | Rapikan dokumentasi |
| Sabtu, 21 Nov | Logbook dan rekap | Finalisasi PR | Rekap bug | Rekap performa | Finalisasi PR |
| Minggu, 22 Nov | Review hasil | Review hasil | Review hasil | Review hasil | Review hasil |

## 8. Kriteria selesai

1. PR #30, #31, #32, dan #36 selesai atau ditutup dengan alasan jelas.
2. Satu dataset T1 ditetapkan dan didokumentasikan.
3. Model final dapat dimuat aplikasi dan diuji pada data yang tidak dipakai melatih.
4. `flutter analyze` bersih dan seluruh test lulus.
5. Uji fungsional dan uji perangkat menghasilkan catatan bug.
6. Logbook minggu 13 terisi.
7. Bahan laporan Milestone 2 terkumpul.

## 9. Risiko

| Risiko | Mitigasi |
|---|---|
| Model v3 tetap tidak akurat | Siapkan opsi kembali ke model 9 kelas atau ekspor float16 |
| Konflik database #36 dan #37 | Naikkan versi database ke 4 dan gabungkan migrasi |
| Dataset negatif `other` belum disetujui | Gunakan foto tim sendiri, bukan COCO |
| Waktu uji perangkat terbatas | Uji satu HP terlebih dahulu, catat versi Android |
| Pekerjaan T3 melebar | Batasi pada satu dataset pasangan warna dan satu metrik |
