# Daftar Kerja ML Minggu 5 — Sera-Z

Tim Sera-Z · Kelas TI-3D · Semester 5
Periode: **2 – 4 November 2026**
Disusun: 27 Oktober 2026

> **CATATAN DARI BISMA**
>
> **JANGAN TAKUT SALAH PUSH, JANGAN TAKUT BIKIN KESALAHAN**
>
> **TAKUT KALAU KALIAN NGGAK ADA KONTRIBUSI DI GITHUB**

Fokus: **pekerjaan ML saja**. Mobile dijeda selama tiga hari ini agar tidak ada
yang mengerjakan dua alur sekaligus.

Total pekerjaan ML: **7,5 ho**, rata-rata 1,5 ho per orang.

---

## 1. Ruang lingkup

| Dikerjakan | Dijeda |
|---|---|
| E4.1 ekstraksi dataset + verifikasi | Fitur mobile baru |
| E4.2 gabung kelas + split | E5 modul warna |
| Latih ulang Model 1 (12 epoch) untuk mendapatkan `best.pt` | E7 integrasi |
| E4.5 evaluasi Model 1 | E8.3 dan E8.5 |
| E4.6 verifikasi ekspor + model card | E9 QA |
| E6.5 metrik Model 3 | E10 dokumentasi proyek |
| Perbaikan label dan aset model | |

Dataset mentah sudah tersedia di `D:\Kuliah\Semester5\DatasetPBL`:

- `Clothing Dataset Full.zip` (6,98 GB)
- `Fashion Product Images (Small).zip` (593 MB)
- `Clothes Dataset (Carousell).zip` (1,47 GB)

Ruang disk D: sekitar 32,8 GB. Ekstrak satu per satu, jangan sekaligus.

---

## 2. Ringkasan tugas

| Anggota | Tugas | ho | Branch | PR ke |
|---|---|---:|---|---|
| **Bisma** | E4.1 ekstrak 3 ZIP + verifikasi, E4.2 jalankan `01_prepare` dan cek split, latih ulang 12 epoch | 3,0 | `ml/dataset-eda`, `ml/train-model1` | `dev-ml` |
| **Ahmad** | E4.5 evaluasi Model 1, E4.6 verifikasi ekspor + model card | 1,5 | `ml/eval-model1` | `dev-ml` |
| **Pras** | E6.5 metrik Model 3 (AUC, precision@3) + review PR | 1,0 | `ml/model3-metrics` | `dev-ml` |
| **Abim** | Samakan label 9 kelas, daftarkan aset model, smoke test muat model | 1,0 | `chore/model-assets` | `dev` |
| **Izza** | Dokumentasi metode ML dan keterbatasan | 1,0 | `docs/ml-methods` | `dev-ml` |
| **Total** | | **7,5** | | |

---

## 3. Detail tugas

### 3.1 Bisma — dataset, split, dan latihan ulang (3,0 ho)

**E4.1 Ekstraksi dataset (1,0 ho)**

Tujuan: dataset mentah siap dibaca skrip `01_prepare_model1.py`.

Langkah:

1. Buat folder `ml/data/raw/`.
2. Ekstrak `Clothing Dataset Full.zip` ke `ml/data/raw/clothing-full/` sehingga
   `images.csv` dan `images_compressed/` berada langsung di dalamnya.
3. Ekstrak `Fashion Product Images (Small).zip` ke
   `ml/data/raw/fashion-products/` sehingga `styles.csv` dan `images/` langsung
   di dalamnya.
4. Ekstrak `Clothes Dataset (Carousell).zip` ke `ml/data/raw/carousell/`
   sehingga isinya menjadi `carousell/Clothes_Dataset/<kelas>/*.jpg`.
5. Hitung jumlah gambar per folder dan catat di grup.

Kriteria selesai: tiga folder ada, jumlah gambar masuk akal, tidak ada ZIP
setengah ekstrak.

**E4.2 Split dataset (1,0 ho)**

Langkah:

1. Ambil skrip dari branch `data-training` (lihat bagian 6).
2. Jalankan `python ml/scripts/01_prepare_model1.py`.
3. Periksa `ml/data/processed/model1/metadata.csv`: jumlah per split, per sumber,
   dan pastikan tidak ada gambar yang muncul di dua split.
4. Commit hanya kode dan ringkasan, bukan gambar.

Kriteria selesai: folder `train/`, `val/`, `test/` terbentuk, `metadata.csv` ada,
tidak ada kebocoran data.

**Latih ulang Model 1 (1,0 ho + waktu mesin)**

Langkah:

1. `python ml/scripts/04_train_yolo11n.py --epochs 12 --patience 4 --batch 32`
2. Pakai GPU bila tersedia; kalau CPU, jalankan malam.
3. Catat waktu latih, jumlah epoch yang benar-benar berjalan, dan akurasi
   validasi terbaik.
4. Checkpoint ada di `ml/runs/model1_yolo11n/weights/best.pt`.

Kriteria selesai: `best.pt` ada, akurasi validasi tercatat, waktu latih tercatat.

Catatan: 12 epoch dipilih karena transfer learning dari ImageNet pada 9 kelas
sudah konvergen cepat. Jangan memakai 40 epoch untuk MVP.

### 3.2 Ahmad — evaluasi dan ekspor (1,5 ho)

**E4.5 Evaluasi Model 1 (1,0 ho)**

Menunggu: `best.pt` dari Bisma dan hasil split.

Langkah:

1. `python ml/scripts/05_eval_model1.py --weights ml/runs/model1_yolo11n/weights/best.pt`
2. Periksa keluaran: `model1_test_report.txt`, `model1_test_summary.json`,
   `model1_test_confusion_matrix.png`, `model1_test_per_source.csv`.
3. Commit keempat berkas ke `ml/reports/`.
4. Catat tiga kelas dengan F1 terendah dan pasangan kelas yang paling sering
   tertukar.

Kriteria selesai: akurasi test, macro F1, confusion matrix, dan akurasi per
sumber tercatat di repo.

**E4.6 Verifikasi ekspor + model card (0,5 ho)**

Langkah:

1. Pastikan `.tflite` int8 bisa dimuat dan ukurannya di bawah 20 MB.
2. Tulis model card: input 224x224 RGB, output 9 kelas, urutan kelas, ukuran,
   metrik, dan sumber data.
3. Urutan kelas wajib abjad folder: `dress, long_pants, long_sleeve, outerwear,
   shirt, shoes, shorts, skirt, tshirt`.

Kriteria selesai: model card ada dan cocok dengan berkas model.

### 3.3 Pras — metrik Model 3 dan review (1,0 ho)

**E6.5 Metrik Model 3 (0,7 ho)**

Langkah:

1. Jalankan `python ml/scripts/08_train_model3_mlp.py`.
2. Tambahkan penyimpanan JSON berisi AUC, akurasi, dan perbandingan Random Forest
   serta Logistic Regression ke `ml/reports/model3_metrics.json`.
3. Catat bahwa data latih bersifat sintetis dan dibangkitkan dari aturan harmoni
   yang sama dengan fitur input, sehingga AUC tinggi bukan bukti generalisasi.

Kriteria selesai: `model3_metrics.json` ada di repo dan angkanya bisa dikutip
laporan.

**Review PR (0,3 ho)**

Review PR ML lain: cek label, path aset, dan tidak ada berkas dataset yang ikut
ter-commit.

### 3.4 Abim — label dan aset (1,0 ho)

Langkah:

1. Samakan `assets/models/labels_clothing.txt` dengan 9 kelas training, urut
   abjad: `dress, long_pants, long_sleeve, outerwear, shirt, shoes, shorts,
   skirt, tshirt`.
2. Pindahkan model ke `lib/assets/models/` atau daftarkan `assets/models/` di
   `pubspec.yaml`.
3. Tambahkan `flutter pub get` dan pastikan aset terbaca.
4. Smoke test: muat `.tflite` lewat `tflite_flutter` dan jalankan satu inferensi
   pada gambar contoh.
5. Catat hasilnya: berhasil muat atau gagal, dengan pesan error bila gagal.

Kriteria selesai: label konsisten, aset terdaftar, model bisa dimuat aplikasi.

### 3.5 Izza — dokumentasi metode (1,0 ho)

Langkah:

1. Tulis `docs/ml-methods.md`: dataset dan lisensi, praproses, split, arsitektur
   Model 1 dan Model 3, parameter latih, metrik, dan cara reproduksi.
2. Tulis bagian keterbatasan: Model 3 berbasis data sintetis, tidak ada data
   pasangan outfit nyata, dan evaluasi hanya pada tiga dataset ini.
3. Kumpulkan tautan bukti: laporan, confusion matrix, metadata, model card.

Kriteria selesai: dokumen bisa dibaca orang lain tanpa membuka kode.

---

## 4. Jadwal harian

| Hari | Bisma | Ahmad | Pras | Abim | Izza |
|---|---|---|---|---|---|
| Sen 2 Nov | Ekstrak 3 ZIP, jalankan `01_prepare` | Siapkan skrip evaluasi, cek `best.pt` | Mulai metrik Model 3 | Perbaiki label 9 kelas | Susun kerangka dokumen |
| Sel 3 Nov | Latih ulang 12 epoch, verifikasi `metadata.csv` | E4.5 evaluasi, commit laporan | Simpan JSON metrik, review PR | Daftarkan aset, smoke test | Tulis metode dan dataset |
| Rab 4 Nov | Finalisasi split dan bobot | Model card, tutup PR | Finalisasi laporan MLP | Uji muat model | Finalisasi dokumen, rekap |

Kalau latihan berjalan di CPU, jadwal latihan digeser ke Senin malam dan
evaluasi dilakukan Selasa pagi.

---

## 5. Keluaran yang harus ada

| Keluaran | Dari | Letak |
|---|---|---|
| Dataset siap latih + `metadata.csv` | E4.1–E4.2 | `ml/data/processed/model1/` |
| `best.pt` hasil 12 epoch | Latihan ulang | `ml/runs/model1_yolo11n/weights/` |
| Laporan evaluasi + confusion matrix + per-source | E4.5 | `ml/reports/` |
| Model card | E4.6 | `docs/model1-card.md` |
| `model3_metrics.json` | E6.5 | `ml/reports/` |
| Label 9 kelas + aset terdaftar | Perbaikan aset | `assets/models/`, `pubspec.yaml` |
| Dokumentasi metode | Izza | `docs/ml-methods.md` |

---

## 6. Alur branch `dev-ml`

```
dev ──► dev-ml ──► ml/... ──PR──► dev-ml ──► (stabil) PR ke dev
```

Membuat `dev-ml` sekali saja:

```bash
git switch dev
git pull origin dev
git switch -c dev-ml
git push -u origin dev-ml
```

Membuat branch tugas ML:

```bash
git switch dev-ml
git pull origin dev-ml
git switch -c ml/dataset-eda
git push -u origin ml/dataset-eda
```

Aturan:

1. Branch ML selalu dibuat dari `dev-ml`, bukan dari `dev` atau `main`.
2. PR tugas ML mengarah ke `dev-ml`.
3. `chore/model-assets` adalah pengecualian: dibuat dari `dev` dan PR ke `dev`,
   karena menyentuh konfigurasi aplikasi.
4. Merge `dev` ke `dev-ml` setiap akhir minggu agar tidak tertinggal.
5. `dev-ml` digabung ke `dev` lewat PR setelah blok ML stabil. Jangan langsung
   ke `main`.
6. PR #5 (`data-training`) tidak dipakai. Pekerjaannya dibuat ulang di branch
   tugas di atas.

Skrip ML diambil dari branch `data-training` lewat worktree sementara:

```bash
git worktree add C:\temp\ml-work data-training
# salin folder ml/ dan assets/ ke branch tugas
git worktree remove C:\temp\ml-work
```

---

## 7. Penghambat dan aksi

| Penghambat | Aksi | Penanggung | Batas |
|---|---|---|---|
| Folder `ml/` belum ada di `dev` | Ambil dari `data-training` lewat worktree | Bisma | 2 Nov |
| `best.pt` belum ada | Latih ulang 12 epoch | Bisma | 3 Nov |
| Latihan di CPU lambat | Jalankan malam atau pakai Colab T4 | Bisma | 2 Nov |
| Label aplikasi beda dengan label training | Samakan ke 9 kelas abjad | Abim | 3 Nov |
| Angka AUC tidak tersimpan | Tambahkan JSON di skrip 08 | Pras | 3 Nov |
| Ruang disk 32,8 GB | Ekstrak satu per satu, hapus ZIP hanya setelah verifikasi | Bisma | 2 Nov |
| Tidak ada data pasangan outfit | Tulis sebagai keterbatasan, jangan diklaim validasi nyata | Izza | 4 Nov |

---

## 8. Aturan kerja

1. Maksimal 2 tugas aktif per orang.
2. Satu tugas = satu branch = satu PR.
3. Mobile tidak dikerjakan selama blok ini.
4. `flutter analyze` dan `flutter test` hanya wajib untuk PR yang menyentuh
   `lib/`.
5. Jangan commit dataset, `best.pt`, atau berkas `.zip`.
6. Setiap PR menyertakan bukti: metrik, tangkapan layar, atau berkas laporan.
7. Status diperbarui setiap hari; rekap diisi Rabu, 4 November 2026.

---

## 9. Yang tidak dikerjakan

E5 modul warna, E7 integrasi TFLite, E8.3 dan E8.5, E9 QA, dan E10 dokumentasi
proyek. Semua menyusul setelah blok ML ini selesai dan dievaluasi.
