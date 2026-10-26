# AGENTS.md — Konteks Proyek Sera-Z

Berkas ini titik masuk untuk agen AI (OpenCode, Claude Code, Copilot, Cursor).
Baca berkas ini lebih dulu; detail ada di folder `ai-context/`.

## 1. Apa proyek ini

Sera-Z adalah aplikasi mobile Flutter untuk tugas PBL (TI-3D, Semester 5).
Fungsinya: mengenali **jenis pakaian** dari foto, mengekstrak **warna dominan**,
memberi **skor kecocokan** atasan-bawahan, lalu menyarankan outfit.

Semua model berjalan **on-device** lewat TFLite; target perangkat Android.

Tiga komponen ML:

| Komponen | Isi | Status |
|---|---|---|
| Model 1 | YOLOv11n-cls, klasifikasi jenis pakaian | pipeline siap (PR #3), belum dilatih |
| Modul 2 | K-Means di Dart, 14 nama warna | belum mulai |
| Model 3 | MLP skor kecocokan + aturan harmoni | aturan harmoni selesai, MLP belum |

## 2. Perintah penting

| Perintah | Fungsi |
|---|---|
| `flutter pub get` | Ambil dependensi setelah clone atau setelah `pubspec.yaml` berubah |
| `flutter analyze` | Analisis statis; target: tanpa error/warning |
| `flutter test` | Jalankan seluruh test |
| `flutter test test/color_harmony_test.dart` | Jalankan satu berkas test |
| `flutter run` | Jalankan di perangkat/emulator |
| `flutter build apk --debug` | Cek build Android tanpa perangkat |
| `dart format lib test` | Rapikan format |

## 3. Aturan wajib

1. **Bahasa Indonesia** untuk teks UI, komentar, dokumentasi, dan pesan commit.
   Nama kelas, variabel, dan berkas tetap bahasa Inggris.
2. **Tanpa emoji** di kode, dokumen, pesan commit, maupun balasan chat.
3. **Branch fitur dibuat dari `dev`, dan PR mengarah ke `dev`.** Jangan push
   langsung ke `main` maupun `dev`. Satu fitur = satu branch = satu PR. Branch
   dinamai fitur (`feat/`, `fix/`, `ml/`, `docs/`, `test/`, `chore/`), bukan nama
   orang. Setelah milestone stabil, `dev` digabung ke `main` lewat PR terpisah.
4. Maksimal **2 tugas aktif** per orang; selesaikan satu PR sebelum mengambil
   tugas berikutnya.
5. Jangan commit rahasia (`google-services.json`, API key) dan artefak:
   `build/`, `.dart_tool/`, `ml/data/`, `ml/.venv/`, `ml/runs/`, `*.pt`.
6. Folder `context/` dan `docs/` diabaikan Git. Jangan mengandalkannya sebagai
   berkas yang tersedia di repo; rangkum hal penting ke `ai-context/`.
7. Laporan milestone memakai template `.docx` yang sudah ada: isi kontennya,
   jangan ubah tata letak, gambar, atau tabel template.

## 4. Peta folder

```
lib/
  main.dart                 Titik masuk: ProviderScope + MaterialApp.router
  config/                   Rute, tema, warna, ukuran, gaya teks, aset
  models/                   Garment, Outfit
  screens/                  Layar per alur (auth, home, scan, wardrobe, outfit, profile)
  services/                 camera_service, color_harmony, recommender, providers
  widgets/                  Widget reusable per layar + common/
test/                       color_harmony_test.dart, widget_test.dart
Pembagian Tugas/            Epics E1-E10, rincian jobdesk, logbook, pembagian minggu
ai-context/                 Konteks proyek untuk agen AI
```

## 5. Arsitektur singkat

- `main.dart` memanggil `CameraService.init()` lalu menjalankan `ProviderScope`.
- Routing memakai `go_router`: definisi di `lib/config/app_router.dart`, path di
  `lib/config/app_routes.dart`. Tambah rute di dua berkas itu sekaligus.
- Tema dan token desain ada di `lib/config/` (`app_colors`, `app_sizes`,
  `app_text_styles`, `app_theme`). Jangan menulis warna/ukuran baru secara
  hardcode bila token sudah tersedia.
- State memakai Riverpod. `lib/services/providers.dart` masih berisi data
  placeholder in-memory (`authProvider`, `wardrobeProvider`,
  `recommendationsProvider`).
- `lib/services/color_harmony.dart` berisi aturan harmoni warna (sudah diuji).
  `lib/services/recommender.dart` masih membangun outfit placeholder.

## 6. Alur layar

Splash → Onboarding → Login/SignUp → Home (tab Home dan Lemari) → Kamera →
Preview → Analyzing → Detection Result → Rekomendasi → Detail.
Profil dibuka dari navigasi utama.

## 7. Status singkat (26 Oktober 2026)

- Fondasi UI selesai dan sudah digabung ke `main` (PR #4). 18 test lulus.
- Pipeline Model 1 diajukan lewat PR #3, menunggu review.
- Dataset E4.1 belum terunduh sehingga pelatihan model belum bisa mulai.
- Penyimpanan (E2), autentikasi (E3), dan modul warna (E5) baru akan dimulai.
- Rincian status dan penghambat: `ai-context/status-proyek.md`.

## 8. Dokumen lanjutan

| Berkas | Isi |
|---|---|
| `ai-context/arsitektur.md` | Lapisan kode, rute, model data, rencana integrasi |
| `ai-context/konvensi-kode.md` | Gaya kode, penamaan, test, commit, PR |
| `ai-context/peta-tugas.md` | Epic E1-E10, status, PIC minggu berjalan |
| `ai-context/status-proyek.md` | Kondisi terkini, PR, penghambat, langkah berikut |

## 9. Catatan lingkungan

- Flutter stable, Dart SDK `^3.12.2`.
- Jika build Android gagal karena Kotlin daemon, jalankan `flutter clean`,
  lalu `android\gradlew.bat --stop`, lalu `flutter run`.
- Peringatan JDK 25 soal native access saat build tidak berbahaya.
- Dataset dan venv ML tidak ada di repo; keduanya diunduh/dibuat lokal.
