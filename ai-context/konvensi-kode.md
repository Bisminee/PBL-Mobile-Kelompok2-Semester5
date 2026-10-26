# Konvensi Kode dan Kerja

## 1. Gaya kode Dart/Flutter

- Ikuti `flutter_lints` (lihat `analysis_options.yaml`); target `flutter analyze`
  tanpa error dan warning.
- Format dengan `dart format` sebelum commit.
- `const` sedapat mungkin; hindari `var` bila tipe jelas.
- Satu berkas satu tanggung jawab; widget panjang dipecah menjadi widget privat
  atau widget terpisah di `widgets/`.
- Komentar ditulis dalam **Bahasa Indonesia**, menjelaskan **mengapa**, bukan
  mengulang kode.
- Tanpa emoji di kode, komentar, string UI, dokumentasi, dan pesan commit.

## 2. Penamaan

| Jenis | Gaya | Contoh |
|---|---|---|
| Kelas, enum, typedef | UpperCamelCase | `WardrobeNotifier`, `Garment` |
| Variabel, fungsi, parameter | lowerCamelCase | `colorName`, `buildOutfits` |
| Berkas | snake_case | `camera_preview_screen.dart` |
| Path rute | kebab-case | `/camera-preview` |
| Kunci database dan kolom | snake_case | `wardrobe_items`, `image_path` |
| Provider | camelCase berakhiran `Provider` | `wardrobeProvider` |
| Branch | awalan + fitur | `feat/wardrobe-crud` |

Nama berkas layar berakhiran `_screen.dart`, widget `_card.dart`,
`_row.dart`, `_bar.dart` sesuai bentuknya.

## 3. UI

- Gunakan token dari `app_colors.dart`, `app_sizes.dart`,
  `app_text_styles.dart`. Jangan menulis `Color(0x...)` atau ukuran baru bila
  token sudah ada.
- Semua teks yang terlihat pengguna memakai Bahasa Indonesia.
- Setiap layar harus diuji minimal di lebar 360 dp (HP kecil) dan 800 dp
  (tablet): tidak boleh overflow.
- Konten panjang harus bisa di-scroll; jangan mengandalkan `Column` polos.
- Aplikasi memakai Material 3; ikuti pola desain yang sudah ada, jangan
  memperkenalkan gaya baru tanpa membahasnya.

## 4. Test

- Logika murni (perhitungan, aturan, pemetaan) wajib punya unit test.
- Widget test dipakai untuk alur atau kondisi tampilan yang penting.
- Jangan menghapus atau melemahkan test agar pipeline hijau.
- Perintah: `flutter test`, atau satu berkas: `flutter test test/<berkas>.dart`.

## 5. Git

### Branch

| Awalan | Untuk | Contoh |
|---|---|---|
| `feat/` | Fitur baru | `feat/sqflite-setup` |
| `fix/` | Perbaikan bug | `fix/camera-overflow` |
| `ml/` | Model, dataset, skrip Python | `ml/model1-pipeline` |
| `docs/` | Dokumentasi | `docs/test-plan` |
| `test/` | Menambah test | `test/color-kmeans` |
| `chore/` | Perawatan | `chore/update-deps` |

- Branch dibuat dari `dev` terbaru, umur pendek (1-3 hari).
- PR mengarah ke `dev`, bukan ke `main`. `main` hanya menerima penggabungan
  `dev` pada akhir milestone.
- Tidak ada branch bernama orang.
- Aturan lengkap dan daftar nama branch per tugas ada di
  `Pembagian Tugas/pembagian-tugas-minggu-5.docx` bagian 6.

### Commit

Format: `<awalan>: <ringkasan singkat>` dengan awalan `feat`, `fix`, `docs`,
`refactor`, `test`, `chore`, `ml`. Contoh: `feat: tambah CRUD lemari baju`.

### Pull Request

- Satu fitur satu PR; jelaskan **apa yang berubah** dan **cara mengujinya**.
- Sertakan tangkapan layar untuk perubahan UI.
- PR harus lulus `flutter analyze` dan `flutter test` sebelum digabung.
- Reviewer minimal satu anggota lain.

## 6. Dokumentasi

- Dokumentasi fitur di `docs/features/` (lokal, tidak di-commit).
- Dokumen yang dibagikan tim dan perlu ada di repo ditaruh di `ai-context/`
  atau `Pembagian Tugas/`.
- Logbook mingguan di `Pembagian Tugas/Logbook/logbook.md`.
- Laporan milestone memakai template `.docx`; isi kontennya saja, jangan ubah
  tata letak, gambar, atau tabel template.

## 7. Larangan

1. Push langsung ke `dev` atau `main`.
2. Commit `build/`, `.dart_tool/`, `ml/data/`, `ml/.venv/`, model `.pt`,
   `google-services.json`, atau API key.
3. Menambah dependensi tanpa membahasnya di PR.
4. Menonaktifkan lint atau test agar build hijau.
5. Memakai emoji pada berkas proyek.
6. Mengubah isi folder `context/` atau `docs/` lalu menganggapnya tersedia di
   repo; keduanya diabaikan Git.
