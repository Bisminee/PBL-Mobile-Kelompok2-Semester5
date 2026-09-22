# Sera-Z — Daftar Seluruh Jobdesk (Tanpa Pemilik) & Ketergantungan

Semua pekerjaan di dokumen ini **tidak dimiliki oleh peran tertentu**. Siapa pun
di tim boleh mengambil jobdesk mana pun selama **prasyaratnya sudah selesai**.
Tugas hanya dibedakan menjadi **Independen** (tanpa prasyarat) dan **Dependen**
(butuh prasyarat).

Kode tugas (E1–E10) mengacu pada `context/feature-breakdown-id.md`.

---

## 1. Prinsip

- **Tidak ada jobdesk khusus milik satu orang.** Semua tugas terbuka untuk umum.
- **Satu tugas, satu pemilik sementara.** Setelah diambil, isi kolom
  "Diambil oleh".
- **Maksimal 2 tugas aktif** per orang agar fokus dan tidak *overload*.
- **Tugas dependen** hanya boleh diambil setelah **semua prasyaratnya** selesai.
- **Tugas independen** boleh langsung diambil kapan saja tanpa menunggu siapa pun.
- Bila tersangkut lebih dari 1 hari, lepas tugas kembali ke daftar dan tulis catatan.

---

## 2. Cara Mengambil Jobdesk

1. Buka papan (GitHub Issues/Projects) atau dokumen ini.
2. Pilih tugas dengan label `independent` (bisa langsung) atau `dependent`
   (cek prasyarat dulu).
3. Tulis nama kalian di kolom **Diambil oleh**.
4. Kerjakan di **branch pribadi** kalian, commit, push, lalu buka PR.
5. Setelah PR digabung → tandai `done`.

### Legenda
| Simbol | Arti |
|--------|------|
| 🟢 | **Independen** — bisa mulai sekarang, siapa saja |
| 🔴 | **Dependen** — tunggu prasyarat selesai |
| 🧩 | Butuh keahlian tertentu (ML/UI/QA) — tetap boleh diambil siapa saja yang mampu |
| ✅ | Sudah selesai |

---

## 3. Jobdesk INDEPENDEN (Tanpa Prasyarat — Bisa Paralel)

8 tugas ini bisa dikerjakan serentak oleh 8 orang sekaligus tanpa saling tunggu.

| ID | Tugas | Epic | Skill | Est (ho) | Prioritas | Diambil oleh |
|----|-------|------|-------|---------:|-----------|--------------|
| E2.1 🟢 | Setup `sqflite` + `path_provider`, helper DB & migrasi | Penyimpanan | Dart dasar | 1 | Tinggi | ____ |
| E3.1 🟢 | `google_sign_in` + Firebase Auth | Auth | Flutter | 2 | Tinggi | ____ |
| E4.1 🟢🧩 | Unduh dataset + EDA + buang kelas ambigu | Model 1 | Python/ML | 1 | Tinggi | ____ |
| E5.1 🟢 | Crop tengah + *thresholding* latar | Warna | Dart/gambar | 1 | Tinggi | ____ |
| E6.4 🟢 | Aturan harmoni warna (komplementer/analog/mono/netral) | Model 3 | Logika warna | 1,5 | Tinggi | ____ |
| E9.1 🟢 | Rencana uji + ≥ 20 test case fungsional | QA | QA dasar | 2 | Tinggi | ____ |
| E10.1 🟢 | Logbook mingguan + notulen | Dokumentasi | Tulis | 3 | Sedang | ____ |
| E10.2 🟢 | Kumpulkan 150 foto lapangan | Dokumentasi | Dokumentasi | 2 | Sedang | ____ |

**Subtotal independen: 13,5 ho** — boleh jalan semua di Minggu 1.

---

## 4. Jobdesk DEPENDEN (Butuh Prasyarat)

### 4.1 Penyimpanan & Auth
| ID | Tugas | Prasyarat | Skill | Est | Prioritas | Diambil oleh |
|----|-------|-----------|-------|----:|-----------|--------------|
| E2.2 🔴 | CRUD `wardrobe_items` | E2.1 | Dart | 1,5 | Tinggi | ____ |
| E2.3 🔴 | Simpan foto ke folder dokumen; simpan hanya path | E2.1 | Dart | 1 | Sedang | ____ |
| E2.4 🔴 | Tabel `outfits` + `recommendation_history` & DAO | E2.1 | Dart | 1,5 | Tinggi | ____ |
| E2.5 🔴 | Muat lemari/riwayat saat start (provider async) | E2.2, E2.4 | Dart | 1 | Tinggi | ____ |
| E2.6 🔴 | Unit test DAO | E2.2, E2.4 | Dart test | 1 | Sedang | ____ |
| E3.2 🔴 | Record cloud `users` + `profiles` | E3.1 | Flutter/Backend | 1 | Sedang | ____ |
| E3.3 🔴 | Sesi persisten + `flutter_secure_storage` | E3.1 | Flutter | 1 | Sedang | ____ |
| E3.4 🔴 | Sign out + jalur hapus akun | E3.1 | Flutter | 1 | Sedang | ____ |

### 4.2 Model 1 (Klasifikasi jenis pakaian)
| ID | Tugas | Prasyarat | Skill | Est | Prioritas | Diambil oleh |
|----|-------|-----------|-------|----:|-----------|--------------|
| E4.2 🔴🧩 | Gabung jadi ±8–10 kelas + mapping kategori + split | E4.1 | Python/ML | 1 | Tinggi | ____ |
| E4.3 🔴🧩 | Baseline MobileNetV2 | E4.2 | Python/ML | 1,5 | Sedang | ____ |
| E4.4 🔴🧩 | Latih **YOLOv11n-cls** + fine-tune | E4.2 | Python/ML | 2,5 | Tinggi | ____ |
| E4.5 🔴🧩 | Evaluasi (akurasi, F1, confusion matrix) | E4.4 | Python/ML | 1 | Tinggi | ____ |
| E4.6 🔴🧩 | Ekspor TFLite (int8) | E4.4 | Python/ML | 1 | Tinggi | ____ |

### 4.3 Modul Warna & Model 3
| ID | Tugas | Prasyarat | Skill | Est | Prioritas | Diambil oleh |
|----|-------|-----------|-------|----:|-----------|--------------|
| E5.2 🔴 | K-Means (k=3–5) Lab/HSV di Dart | E5.1 | Dart | 2 | Tinggi | ____ |
| E5.3 🔴 | Petakan ke palet 14 nama warna | E5.2 | Logika warna | 1 | Sedang | ____ |
| E5.4 🔴 | Unit test warna | E5.3 | Dart test | 1 | Sedang | ____ |
| E6.1 🔴🧩 | Bangun pasangan (atasan,bawahan) + negative sampling | E4.2 | Python/ML | 2 | Tinggi | ____ |
| E6.2 🔴🧩 | Feature builder (one-hot + warna) | E6.1 | Python | 1 | Sedang | ____ |
| E6.3 🔴🧩 | Latih MLP + pembanding (RF, LogReg) | E6.2 | Python/ML | 2 | Tinggi | ____ |
| E6.5 🔴🧩 | Evaluasi AUC, precision@3 | E6.3, E6.4 | Python/ML | 1 | Tinggi | ____ |
| E6.6 🔴🧩 | Ekspor MLP ke TFLite (int8) | E6.3 | Python/ML | 1 | Tinggi | ____ |

### 4.4 Integrasi On-device
| ID | Tugas | Prasyarat | Skill | Est | Prioritas | Diambil oleh |
|----|-------|-----------|-------|----:|-----------|--------------|
| E7.1 🔴🧩 | Tambah `tflite_flutter`; loader + isolate runner | E4.6, E6.6 | Flutter/TFLite | 1,5 | Tinggi | ____ |
| E7.2 🔴🧩 | Inferensi Model 1 pada gambar ter-crop | E7.1 | Flutter/TFLite | 2 | Tinggi | ____ |
| E7.3 🔴 | Ganti atribut placeholder (jenis + warna) | E7.2, E5.2 | Flutter | 1,5 | Tinggi | ____ |
| E7.4 🔴🧩 | Sambungkan skor Model 3 ke rekomendasi | E7.1, E6.4 | Flutter/TFLite | 1,5 | Tinggi | ____ |
| E7.5 🔴 | Fallback ke skor aturan bila model gagal | E7.4 | Flutter | 1 | Tinggi | ____ |
| E7.6 🔴 | Ukur latensi & ukuran model di perangkat | E7.2, E7.4 | Flutter/Perf | 1 | Sedang | ____ |

### 4.5 Fitur Aplikasi
| ID | Tugas | Prasyarat | Skill | Est | Prioritas | Diambil oleh |
|----|-------|-----------|-------|----:|-----------|--------------|
| E8.1 🔴 | CRUD UI Lemari (tambah/hapus, filter, empty state) | E2.2 | Flutter | 2 | Tinggi | ____ |
| E8.2 🔴 | Simpan outfit → "Outfit Tersimpan" | E2.4 | Flutter | 1,5 | Sedang | ____ |
| E8.3 🔴 | Ranking rekomendasi + teks explainability | E7.4 | Flutter | 1,5 | Tinggi | ____ |
| E8.4 🔴 | Konten Home (banner, kategori, item terbaru) | E2.5 | Flutter | 1,5 | Sedang | ____ |
| E8.5 🔴 | Tab Detail (Warna/Styling/Lemari) data nyata | E8.3 | Flutter | 1,5 | Sedang | ____ |
| E8.6 🔴 | Halaman Admin: master data kategori warna/jenis | E2.1 | Flutter | 2 | Sedang | ____ |
| E8.7 🔴 | Halaman Profil (nama, avatar, sign out, preferensi) | E3.4 | Flutter | 1,5 | Sedang | ____ |

### 4.6 QA & Dokumentasi
| ID | Tugas | Prasyarat | Skill | Est | Prioritas | Diambil oleh |
|----|-------|-----------|-------|----:|-----------|--------------|
| E9.2 🔴 | Eksekusi fungsional black-box + catat bug | E8.* | QA | 2 | Tinggi | ____ |
| E9.3 🔴 | Uji performa (latensi, memori, ukuran model) | E7.6 | QA | 1 | Sedang | ____ |
| E9.4 🔴 | Uji kompatibilitas (≥ 3 perangkat) | E8.* | QA | 1 | Sedang | ____ |
| E9.5 🔴 | Konsolidasi laporan evaluasi ML | E4.5, E6.5 | QA/ML | 1 | Sedang | ____ |
| E9.6 🔴 | Uji usability + SUS (10–20 responden) | E8.7 | QA/UX | 2 | Tinggi | ____ |
| E9.7 🔴 | Pelacakan bug + regression | E9.2 | QA | 2 | Sedang | ____ |
| E10.3 🔴 | Tabulasi data kuesioner | E9.6 | Dokumentasi | 1,5 | Sedang | ____ |
| E10.4 🔴 | Laporan milestone & akhir | E9.* | Tulis | 3 | Tinggi | ____ |
| E10.5 🔴 | Dokumentasi fitur di `docs/` + README | E8.* | Tulis | 2 | Sedang | ____ |

---

## 5. Peta Ketergantungan

```
Penyimpanan : E2.1 ─┬─► E2.2 ─┐
                    ├─► E2.3  ├─► E2.5 ─► E8.1, E8.4
                    └─► E2.4 ─┘        └─► E2.6

Auth        : E3.1 ─┬─► E3.2
                    ├─► E3.3
                    └─► E3.4 ─► E8.7 ─► E9.6 ─► E10.3

Model 1     : E4.1 ─► E4.2 ─┬─► E4.3
                            └─► E4.4 ─┬─► E4.5 ─► E9.5
                                      └─► E4.6

Warna/Model3: E5.1 ─► E5.2 ─► E5.3 ─► E5.4
              E4.2 ─► E6.1 ─► E6.2 ─► E6.3 ─┬─► E6.5 ─► E9.5
              E6.4 ────────────────────────┘
              E6.3 ─► E6.6

Integrasi   : E4.6, E6.6 ─► E7.1 ─┬─► E7.2 ─► E7.3
                                  └─► E7.4 ─► E7.5
              E5.2 ─► E7.3
              E7.2, E7.4 ─► E7.6 ─► E9.3

Fitur       : E2.2 ─► E8.1
              E2.4 ─► E8.2
              E7.4 ─► E8.3 ─► E8.5
              E2.5 ─► E8.4
              E2.1 ─► E8.6
              E3.4 ─► E8.7

QA/Dok      : E9.1 ─► E9.2 ─► E9.7
              E8.* ─► E9.2, E9.4, E10.5
              E9.* ─► E10.4
```

**Jalur kritis:** `E4.1 → E4.2 → E4.4/E6.3 → E7.1 → E7.4 → E8.3 → E9.2 → E10.4`.
Artinya: siapa pun yang memegang tugas ini menentukan tanggal selesai proyek —
utamakan agar cepat diambil di Minggu 1.

---

## 6. Rekap Beban

| Kategori | Jumlah tugas | Total estimasi |
|----------|-------------:|---------------:|
| Independen | 8 | 13,5 ho |
| Dependen | 40 | 64 ho |
| **Total** | **48** | **77,5 ho** |

**Ketersediaan tim:** 5 orang × 10 minggu ≈ **50 orang-minggu**. Artinya beban
perlu dibagi rata, dan tugas independen harus dikerjakan paralel sejak awal.

**Aturan keseimbangan:** jika satu orang sudah memegang 2 tugas, ia tidak boleh
mengambil lagi sampai salah satu selesai. PM hanya memantau papan, bukan
menentukan siapa mengambil apa.

---

## 7. Label Papan yang Disarankan

`independent` · `dependent` · `blocked` · `ml` · `ui` · `qa` · `docs` · `done`

## 8. Definisi Selesai (berlaku untuk semua tugas)

1. Berjalan di perangkat Android nyata lewat alur utama.
2. Test terkait lulus (unit/widget/metrik model).
3. Digabung lewat PR yang direview ke `main` (jangan push langsung ke `main`).
4. Didokumentasikan di `docs/features/` (atau laporan ML untuk model).

## 9. Aturan Serah-Terima

- Penanggung tugas ML (E4/E6) → penanggung integrasi (E7): serahkan `.tflite`
  + *model card* singkat (input, output, urutan label, metrik).
- Penanggung fitur (E8) → penanggung QA (E9): serahkan APK yang bisa diuji.
- Penanggung foto lapangan (E10.2) → penanggung uji ketahanan (E4.5): serahkan
  set foto **sebelum** pengujian.
