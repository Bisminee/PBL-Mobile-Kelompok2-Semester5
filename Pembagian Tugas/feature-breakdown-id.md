# Sera-Z — Rincian Fitur & Epic (Penjelasan Jobdesk)

Dokumen ini menjelaskan **Epic** (kelompok pekerjaan besar) dan **jobdesk**
(tugas di dalamnya) beserta fungsinya. Tidak ada pembagian ke peran atau orang —
semua tugas bersifat terbuka dan boleh dikerjakan siapa saja.

Untuk cara mengambil tugas dan ketergantungan, lihat `context/pembagian-tugas.md`.

---

## 1. Pengantar

- **Epic** = kelompok pekerjaan besar dengan satu tujuan (contoh: Model 1).
- **Jobdesk** = tugas kecil di dalam Epic, punya ID, estimasi, prasyarat, dan
  kriteria penerimaan.
- Setiap jobdesk dijelaskan **apa maksudnya dan mengapa perlu**, bukan siapa
  yang mengerjakan.
- Kode `E` (E1–E10) dipakai konsisten di seluruh dokumen proyek.

---

## 2. Ringkasan Status Epic

| Epic | Nama | Status |
|------|------|--------|
| E1 | Fondasi Aplikasi | ✅ Selesai |
| E2 | Penyimpanan & Data | ⬜ Belum |
| E3 | Autentikasi & Cloud | ⬜ Belum |
| E4 | Model 1 — Klasifikasi jenis pakaian | ⬜ Belum |
| E5 | Modul 2 — Ekstraksi warna | ⬜ Belum |
| E6 | Model 3 — Skor kecocokan | ⬜ Belum |
| E7 | Integrasi On-device | ⬜ Belum |
| E8 | Penyelesaian Fitur | 🟡 Sebagian |
| E9 | QA & Pengujian | 🟡 Sebagian |
| E10 | Dokumentasi | 🟡 Sebagian |

---

## 3. Penjelasan Epic

| Epic | Tujuan | Lingkup / Output |
|------|--------|------------------|
| **E1 Fondasi Aplikasi** | Menyediakan kerangka aplikasi: tema, navigasi, layar, dan alur dasar | Routing `go_router`, semua layar wireframe, state Riverpod, tangkap kamera |
| **E2 Penyimpanan & Data** | Menyimpan data pengguna secara lokal agar tidak hilang saat aplikasi ditutup | Basis data `sqflite`, CRUD lemari, riwayat, penyimpanan foto |
| **E3 Autentikasi & Cloud** | Login pengguna dan profil yang tersinkron lintas perangkat | Login Google, record `users`/`profiles`, sesi, sign out |
| **E4 Model 1** | Mengenali **jenis pakaian** dari foto | Dataset, pelatihan YOLOv11n-cls, evaluasi, ekspor TFLite |
| **E5 Modul 2** | Menentukan **warna dominan** pakaian dari gambar | Crop, K-Means di Dart, pemetaan ke 14 nama warna |
| **E6 Model 3** | Memberi **skor kecocokan** antara atasan dan bawahan | Dataset pasangan, fitur, MLP, aturan harmoni, ekspor TFLite |
| **E7 Integrasi On-device** | Menjalankan Model 1, Modul 2, dan Model 3 di dalam aplikasi | Loader TFLite, inferensi, penggantian atribut placeholder, fallback |
| **E8 Penyelesaian Fitur** | Melengkapi fitur aplikasi dengan data nyata | CRUD lemari, simpan outfit, ranking rekomendasi, Home, Detail, Admin, Profil |
| **E9 QA & Pengujian** | Memastikan kualitas lewat pengujian terstruktur | Rencana uji, fungsional, performa, kompatibilitas, usability (SUS), pelacakan bug |
| **E10 Dokumentasi** | Mencatat proses dan hasil proyek | Logbook, foto lapangan, tabulasi kuesioner, laporan, dokumentasi fitur |

---

## 4. Daftar Jobdesk per Epic

Kolom **Penjelasan** menerangkan maksud tugas. Tidak ada kolom pemilik.

### E1 — Fondasi Aplikasi ✅ (Selesai)
Tema Material 3, routing `go_router` (7 layar), state Riverpod, alur
Login → Home → Kamera → Rekomendasi → Detail, serta tangkap kamera.

### E2 — Penyimpanan & Data
| ID | Jobdesk | Penjelasan | Est | Prasyarat | Kriteria Penerimaan |
|----|---------|------------|----:|-----------|---------------------|
| E2.1 | Setup `sqflite` + `path_provider` | Menyiapkan basis data lokal dan akses folder aplikasi; membuat helper DB + migrasi versi | 1 | — | DB terbuka, skema versi berjalan |
| E2.2 | CRUD `wardrobe_items` | Fungsi tambah/ambil/hapus item lemari agar data pakaian tersimpan permanen | 1,5 | E2.1 | Item tetap ada setelah restart |
| E2.3 | Simpan foto ke folder dokumen | Menyalin foto hasil kamera ke folder aplikasi dan menyimpan **hanya path**-nya di DB (bukan BLOB) | 1 | E2.1 | Gambar tampil, DB tidak membengkak |
| E2.4 | Tabel `outfits` + `recommendation_history` | Menyimpan outfit yang disimpan pengguna dan riwayat rekomendasi | 1,5 | E2.1 | Simpan/daftar outfit & riwayat berhasil |
| E2.5 | Muat data saat start | Memuat lemari dan riwayat otomatis ketika aplikasi dibuka (provider async) | 1 | E2.2, E2.4 | Data muncul setelah cold start |
| E2.6 | Unit test DAO | Menguji lapisan akses data agar tidak mudah rusak saat diubah | 1 | E2.2, E2.4 | Test lulus |

### E3 — Autentikasi & Cloud
| ID | Jobdesk | Penjelasan | Est | Prasyarat | Kriteria Penerimaan |
|----|---------|------------|----:|-----------|---------------------|
| E3.1 | Login Google | Menghubungkan `google_sign_in` dengan Firebase Auth (atau verifikasi FastAPI) agar pengguna bisa masuk | 2 | — | Login Google berhasil |
| E3.2 | Record cloud `users` + `profiles` | Membuat data pengguna & profil di cloud saat login pertama | 1 | E3.1 | Profil terbentuk |
| E3.3 | Sesi persisten | Menyimpan token dengan `flutter_secure_storage` agar tetap login setelah restart | 1 | E3.1 | Masih login setelah restart |
| E3.4 | Sign out + hapus akun | Menyediakan keluar akun dan jalur penghapusan data (privasi) | 1 | E3.1 | Logout bersih, data terhapus |

### E4 — Model 1: Klasifikasi jenis pakaian
| ID | Jobdesk | Penjelasan | Est | Prasyarat | Kriteria Penerimaan |
|----|---------|------------|----:|-----------|---------------------|
| E4.1 | Dataset + EDA | Mengunduh Clothing Dataset Full, memeriksa sebaran, dan membuang kelas ambigu | 1 | — | Dataset bersih + laporan singkat |
| E4.2 | Gabung kelas + mapping + split | Menggabungkan kelas serupa menjadi ±8–10 kelas, memetakan ke kategori fungsional, membagi 70/15/15 | 1 | E4.1 | Tabel mapping + split tersimpan |
| E4.3 | Baseline MobileNetV2 | Melatih model pembanding sederhana sebagai patokan akurasi | 1,5 | E4.2 | Akurasi baseline tercatat |
| E4.4 | Latih YOLOv11n-cls | Melatih model utama (transfer learning + fine-tune) untuk klasifikasi jenis pakaian | 2,5 | E4.2 | Model terlatih + checkpoint |
| E4.5 | Evaluasi model | Mengukur akurasi, macro F1, dan confusion matrix untuk laporan | 1 | E4.4 | Target ≥ 80% terdokumentasi |
| E4.6 | Ekspor TFLite | Mengonversi model ke TFLite int8 agar ringan di perangkat | 1 | E4.4 | `.tflite` siap dipakai |

### E5 — Modul 2: Ekstraksi warna
| ID | Jobdesk | Penjelasan | Est | Prasyarat | Kriteria Penerimaan |
|----|---------|------------|----:|-----------|---------------------|
| E5.1 | Crop + thresholding latar | Memotong area tengah dan memisahkan latar agar warna pakaian lebih bersih | 1 | — | Area warna lebih akurat |
| E5.2 | K-Means di Dart | Mengelompokkan piksel (k=3–5) di ruang Lab/HSV untuk menemukan warna dominan | 2 | E5.1 | Warna dominan benar pada sampel |
| E5.3 | Pemetaan palet 14 warna | Mengubah nilai warna ke nama (merah, navy, krem, dll.) via jarak terdekat | 1 | E5.2 | Nama warna sesuai |
| E5.4 | Unit test warna | Menguji logika warna pada gambar dengan warna yang diketahui | 1 | E5.3 | Test lulus |

### E6 — Model 3: Skor kecocokan
| ID | Jobdesk | Penjelasan | Est | Prasyarat | Kriteria Penerimaan |
|----|---------|------------|----:|-----------|---------------------|
| E6.1 | Dataset pasangan + negative sampling | Membentuk pasangan (atasan, bawahan) yang cocok dan pasangan acak yang tidak cocok | 2 | E4.2 | Dataset pasangan berlabel |
| E6.2 | Feature builder | Menyusun fitur input: kategori (one-hot) + nilai warna (HSV/Lab + selisih hue) | 1 | E6.1 | Vektor fitur terdefinisi |
| E6.3 | Latih MLP + pembanding | Melatih model skor 0–1 dan membandingkan dengan Random Forest & Logistic Regression | 2 | E6.2 | Metrik vs baseline |
| E6.4 | Aturan harmoni warna | Membuat skor aturan (komplementer, analog, monokromatik, netral) sebagai penjelas & cadangan | 1,5 | — | Skor aturan 0–1 |
| E6.5 | Evaluasi model | Mengukur AUC dan precision@3 serta membandingkan dengan baseline aturan | 1 | E6.3, E6.4 | Target AUC ≥ 0,75 |
| E6.6 | Ekspor MLP TFLite | Mengonversi MLP ke TFLite int8 untuk dijalankan di perangkat | 1 | E6.3 | `.tflite` jalan di perangkat |

### E7 — Integrasi On-device
| ID | Jobdesk | Penjelasan | Est | Prasyarat | Kriteria Penerimaan |
|----|---------|------------|----:|-----------|---------------------|
| E7.1 | Loader TFLite + isolate | Menambahkan `tflite_flutter` dan menjalankan inferensi di isolate agar UI tidak tersendat | 1,5 | E4.6, E6.6 | Model termuat tanpa blok UI |
| E7.2 | Inferensi Model 1 | Menjalankan Model 1 pada gambar ter-crop dan mengembalikan jenis + confidence | 2 | E7.1 | Kategori & confidence benar |
| E7.3 | Ganti atribut placeholder | Mengganti atribut palsu (Atasan/merah) dengan hasil Model 1 & Modul 2 | 1,5 | E7.2, E5.2 | Atribut nyata tampil |
| E7.4 | Skor Model 3 di rekomendasi | Memakai skor MLP + aturan harmoni untuk mengurutkan rekomendasi | 1,5 | E7.1, E6.4 | Ranking memakai model |
| E7.5 | Fallback aturan | Tetap memberi rekomendasi bila model gagal dimuat | 1 | E7.4 | Rekomendasi tetap jalan |
| E7.6 | Ukur latensi & ukuran | Mengukur waktu inferensi dan ukuran model di perangkat nyata | 1 | E7.2, E7.4 | ≤ 3 dtk/foto; ≤ 20 MB |

### E8 — Penyelesaian Fitur
| ID | Jobdesk | Penjelasan | Est | Prasyarat | Kriteria Penerimaan |
|----|---------|------------|----:|-----------|---------------------|
| E8.1 | CRUD UI Lemari | Melengkapi layar Lemari: tambah/hapus, filter, dan tampilan saat kosong | 2 | E2.2 | CRUD penuh berjalan |
| E8.2 | Simpan outfit | Menyimpan paduan ke bagian "Outfit Tersimpan" | 1,5 | E2.4 | Outfit tersimpan terdaftar |
| E8.3 | Ranking + explainability | Menampilkan skor dan alasan kecocokan pada tiap rekomendasi | 1,5 | E7.4 | Alasan tampil per outfit |
| E8.4 | Konten Home | Mengisi Home dengan data nyata: banner, kategori cepat, item terbaru | 1,5 | E2.5 | Tanpa placeholder |
| E8.5 | Tab Detail | Menampilkan data nyata di tab Warna/Styling/Lemari | 1,5 | E8.3 | Tab menampilkan data item |
| E8.6 | Halaman Admin | CRUD master data kategori warna & jenis pakaian | 2 | E2.1 | Master data dapat dikelola |
| E8.7 | Halaman Profil | Menampilkan & mengubah profil, sign out, preferensi | 1,5 | E3.4 | Profil dapat diedit |

### E9 — QA & Pengujian
| ID | Jobdesk | Penjelasan | Est | Prasyarat | Kriteria Penerimaan |
|----|---------|------------|----:|-----------|---------------------|
| E9.1 | Rencana uji + test case | Menyusun rencana dan ≥ 20 test case fungsional, termasuk kasus negatif | 2 | — | Test case terdokumentasi |
| E9.2 | Eksekusi fungsional | Menjalankan test case dan mencatat bug | 2 | E8.* | Hasil tercatat |
| E9.3 | Uji performa | Mengukur latensi, memori, dan ukuran model | 1 | E7.6 | Memenuhi target |
| E9.4 | Uji kompatibilitas | Menguji di ≥ 3 perangkat/versi Android | 1 | E8.* | Matriks lulus |
| E9.5 | Konsolidasi evaluasi ML | Menggabungkan hasil evaluasi model ke satu laporan | 1 | E4.5, E6.5 | Metrik terdokumentasi |
| E9.6 | Usability + SUS | Menguji ke 10–20 responden dan mengukur SUS + kecocokan rekomendasi | 2 | E8.7 | Skor SUS + penilaian |
| E9.7 | Pelacakan bug + regression | Memantau perbaikan bug dan menguji ulang agar tidak muncul lagi | 2 | E9.2 | Daftar bug tertutup |

### E10 — Dokumentasi
| ID | Jobdesk | Penjelasan | Est | Prasyarat | Kriteria Penerimaan |
|----|---------|------------|----:|-----------|---------------------|
| E10.1 | Logbook mingguan | Mencatat aktivitas tim tiap minggu beserta notulen | 3 | — | Diperbarui tiap minggu |
| E10.2 | Foto lapangan | Mengumpulkan 150 foto nyata untuk set uji | 2 | — | Set foto siap |
| E10.3 | Tabulasi kuesioner | Mengolah data kuesioner usability menjadi tabel siap laporan | 1,5 | E9.6 | Data siap |
| E10.4 | Laporan milestone & akhir | Menyusun laporan capaian dan laporan akhir proyek | 3 | E9.* | Laporan dikumpulkan |
| E10.5 | Dokumentasi fitur | Menulis dokumentasi fitur di `docs/` dan merawat README | 2 | E8.* | Dokumentasi mutakhir |

---

## 5. Definisi Selesai (berlaku untuk semua jobdesk)

1. Berjalan di perangkat Android nyata lewat alur utama.
2. Test terkait lulus (unit/widget/metrik model).
3. Digabung lewat PR yang direview ke `main` (jangan push langsung ke `main`).
4. Didokumentasikan di `docs/features/` (atau laporan ML untuk model).
