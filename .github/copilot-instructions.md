# Instruksi untuk GitHub Copilot

Konteks proyek ini ada di `../AGENTS.md` dan folder `../ai-context/`.
Baca `AGENTS.md` lebih dulu.

Ringkas:

- Proyek Flutter (Dart), state Riverpod, routing `go_router`.
- Semua teks UI, komentar, dan dokumentasi memakai Bahasa Indonesia.
- Tanpa emoji.
- Jangan menulis langsung ke `main`; satu fitur satu branch satu PR.
- Gunakan token desain di `lib/config/` (`app_colors`, `app_sizes`,
  `app_text_styles`) alih-alih nilai hardcode.
- Jangan menghapus atau melemahkan test.
- Test: `flutter test`; analisis: `flutter analyze`.
