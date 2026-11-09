# Tugas ML per Anggota dan Cara Kerja ML

Diperbarui: 9 November 2026
Branch acuan: `dev` (`f67732a`)

Dokumen ini menjelaskan tiga komponen ML Sera-Z, pembagian tugas ML tiap
anggota, lokasi berkasnya, dan bagaimana alurnya bekerja di aplikasi.

## 1. Tiga komponen ML

| Komponen | Fungsi | Teknologi | Status per 9 November 2026 |
|---|---|---|---|
| Model 1 | Mengenali jenis pakaian dari foto | YOLOv11n-cls, TFLite | Terlatih dan dievaluasi. Aset aplikasi masih model 15 kelas, belum model latihan sendiri |
| Modul 2 | Mengambil warna dominan pakaian | Analisis piksel HSV dan palet 14 warna | Heuristik HSV berjalan. K-Means di Dart (E5.2) belum dibuat |
| Model 3 | Memberi skor kecocokan atasan dan bawahan | MLP Keras, aturan harmoni, skor pasangan di SQLite | Aturan harmoni dan skor pasangan berjalan. MLP masih data sintetis dan belum diekspor ke TFLite |

## 2. Tugas ML per anggota

| Anggota | Tugas ML | Branch | Berkas utama | Status |
|---|---|---|---|---|
| Bisma Adhiaksa | E4.6 ekspor TFLite model sendiri | `ml/export-tflite` (belum dibuat) | `ml/runs/model1_yolo11n/weights/best_saved_model/` | Belum selesai. Ekspor float32, float16, dan dynamic range quant sudah ada, tetapi belum dipasang di aset aplikasi |
| Bisma Adhiaksa | E5.3 palet 14 warna | `feat/color-palette` | `lib/services/color_palette.dart` | Selesai lewat PR #18 |
| Ahmad Falahi | E6.5 metrik Model 3 | `ml/model3-metrics` | `ml/scripts/09_eval_model3.py`, `ml/reports/model3_metrics.json` | PR #22 terbuka, menunggu perbaikan |
| Ahmad Falahi | Riset dataset aksesoris | `ml/accessory-dataset` | `ml/reports/accessory-dataset.md` | PR #23 terbuka, menunggu perbaikan angka |
| Abim Mustawa | Label 10 kelas dan penolakan objek bukan pakaian | `feat/non-clothing-object` | `assets/models/labels.txt`, `lib/services/outfit_engine.dart` | PR #32 terbuka, menunggu pemetaan label dan model |
| Abim Mustawa | Pipeline dataset Hugging Face dan kelas `other` | `ml/model1-v2-pipeline` | `ml/scripts/09_prepare_hf.py` sampai `12_run_model1_pipeline.py`, notebook Colab | PR #31 terbuka, menunggu perbaikan nomor script dan lisensi negatif |
| Abim Mustawa | E7.6 ukur latensi dan ukuran model | `feat/latency-check` (belum dibuat) | Belum ada | Belum dikerjakan |
| Izza Dhafira Fanani | E5.4 unit test warna | `test/color-palette` (belum dibuat) | Belum ada | Belum dikerjakan |
| Izza Dhafira Fanani | Dokumentasi metode ML | `docs/ml-methods` (belum dibuat) | Belum ada | Belum dikerjakan |
| Faatihurrizki Prasojo | Tidak ada tugas ML | - | - | - |

Catatan: Nomor script `09` saat ini dipakai dua PR sekaligus, yaitu
`09_eval_model3.py` (#22) dan `09_prepare_hf.py` (#31). Salah satu harus
dinomori ulang sebelum keduanya digabung.

## 3. Bagaimana Model 1 bekerja

### 3.1 Pelatihan

| Tahap | Isi | Berkas |
|---|---|---|
| Dataset | 33.667 gambar dari Clothing Dataset Full, Fashion Product Images Small, dan Carousell | `ml/scripts/01_prepare_model1.py` |
| Kelas | 9 kelas: dress, long_pants, long_sleeve, outerwear, shirt, shoes, shorts, skirt, tshirt | `ml/scripts/02_balance_train.py` |
| Baseline | MobileNetV2, akurasi test 89,37 persen | `ml/scripts/03_baseline_mobilenetv2.py` |
| Latihan utama | YOLOv11n-cls, 224 x 224, split 70/15/15 | `ml/scripts/04_train_yolo11n.py` |
| Evaluasi | Akurasi test 94,34 persen, macro F1 89,48 persen | `ml/scripts/05_eval_model1.py`, `ml/reports/model1-card.md` |
| Ekspor | TFLite float32, float16, dan dynamic range quant | `ml/scripts/06_export_tflite.py` |

### 3.2 Alur di aplikasi

```
Foto
  -> preprocessForModel: decode, bakal orientasi EXIF, resize sisi pendek 224,
     potong persegi tengah, susun tensor
  -> GarmentClassifier.predictInput: TFLite softmax
  -> jenis pakaian + confidence
  -> ekstraksi warna dari piksel
  -> lookup formalitas dan style di SQLite (ml_formality, ml_style)
  -> Detection
  -> OutfitEngine dan rekomendasi
```

Berkas aplikasi:

| Berkas | Fungsi |
|---|---|
| `lib/services/garment_classifier.dart` | Memuat model dan label, menjalankan inferensi |
| `lib/services/outfit_engine.dart` | Menggabungkan hasil model, warna, formalitas, dan style |
| `assets/models/yolo11n_cls.tflite` | Aset model yang dipakai aplikasi saat ini |
| `assets/models/labels.txt` | Urutan label model |

### 3.3 Kondisi penting

1. Aset aplikasi saat ini adalah model 15 kelas berukuran 5,97 MB, bukan model
   9 kelas hasil latihan.
2. Model latihan kita memakai input NHWC `[1, 224, 224, 3]`, sedangkan kode
   aplikasi menyusun NCHW `[1, 3, 224, 224]`. Model belum bisa ditukar tanpa
   mengubah preprocessing atau mengekspor ulang.
3. Uji pada 270 foto test menunjukkan aset 15 kelas di aplikasi benar 65,6
   persen, sedangkan model latihan kita 86,7 persen pada sampel yang sama.
4. Ekspor float16 2,99 MB memiliki akurasi yang sama dengan float32 pada
   sampel. Dynamic range quant 1,53 MB sekitar 5 poin lebih rendah.

## 4. Bagaimana Modul 2 bekerja

| Tahap | Isi | Berkas |
|---|---|---|
| Crop area | Ambil area tengah 50 persen agar latar tidak mendominasi | `lib/services/color_extractor.dart` |
| Klasifikasi warna piksel | Ubah RGB ke HSV, lalu masukkan ke keluarga warna | `lib/services/color_extractor.dart` |
| Palet tampilan | Petakan keluarga warna ke 14 nama palet | `lib/services/color_palette.dart` |
| Penyimpanan | Simpan `color_family`, `color_hex`, dan komposisi warna | `wardrobe_item` |
| Pemakaian | Warna dipakai untuk rekomendasi dan alasan harmoni | `lib/services/color_harmony.dart`, `outfit_engine.dart` |

Yang belum: K-Means di Dart (E5.2). Saat ini warna ditentukan oleh ambang HSV,
bukan pengelompokan K-Means seperti pada eksperimen Python
`ml/scripts/07_extract_color_kmeans.py`.

## 5. Bagaimana Model 3 bekerja

### 5.1 Fitur

Satu pasangan atasan dan bawahan diubah menjadi 20 fitur:

1. One-hot jenis atasan, 4 nilai.
2. One-hot jenis bawahan, 5 nilai.
3. HSV atasan, 3 nilai.
4. HSV bawahan, 3 nilai.
5. Selisih hue, saturasi, dan value, 3 nilai.
6. Skor aturan harmoni, 1 nilai.
7. Penanda warna netral, 1 nilai.

### 5.2 Pelatihan dan evaluasi

| Tahap | Isi | Berkas |
|---|---|---|
| Dataset | Sintetis 6.000 pasangan, 4.800 latih dan 1.200 uji | `ml/scripts/08_train_model3_mlp.py` |
| Model | MLP Keras 20 fitur, 35 epoch | `ml/scripts/08_train_model3_mlp.py` |
| Pembanding | Random Forest, Logistic Regression, aturan harmoni | `ml/scripts/09_eval_model3.py` |
| Hasil | MLP AUC 0,976 dan P@3 0,455; RF AUC 0,978 dan P@3 0,515; aturan AUC 0,912 dan P@3 0,424 | `ml/reports/model3_metrics.json` |

Keterbatasan: label dibuat dari aturan harmoni, dan aturan itu juga menjadi
salah satu fitur. AUC tinggi menunjukkan model meniru aturan, bukan bukti
generalisasi ke penilaian manusia.

### 5.3 Alur di aplikasi

```
Pasangan atasan dan bawahan
  -> warna dan jenis dari lemari
  -> skor pasangan dari tabel ml_pair_score (51.352 baris)
  -> persentil skor
  -> aturan harmoni sebagai alasan dan cadangan
  -> Outfit dengan skor dan alasan
```

Tabel pendukung di `assets/db/fashion_app.db`:

| Tabel | Isi |
|---|---|
| `ml_formality` | 1.596 baris prediksi formalitas |
| `ml_style` | 4.788 baris prediksi style |
| `ml_pair_score` | 51.352 skor pasangan jenis dan warna |
| `catalog_item` | 3.304 item katalog untuk saran slot kosong |

## 6. Letak berkas ML

| Jenis | Lokasi |
|---|---|
| Script pelatihan dan evaluasi | `ml/scripts/` |
| Notebook Colab | `ml/notebooks/` |
| Laporan dan model card | `ml/reports/` |
| Bobot dan ekspor lokal | `ml/runs/` (tidak masuk Git) |
| Aset model aplikasi | `assets/models/` |
| Database tabel ML | `assets/db/fashion_app.db` |
| Kode inferensi | `lib/services/` |

## 7. Ringkasan yang belum selesai

| Tugas | PIC | Penghambat |
|---|---|---|
| E4.6 ekspor dan pemasangan model final | Bisma | Keputusan 9 atau 10 kelas, layout input, dan label |
| E5.2 K-Means di Dart | Belum ada PIC | Belum masuk pembagian minggu 11 |
| E5.4 unit test warna | Izza | Belum dibuat |
| Dokumentasi metode ML | Izza | Belum dibuat |
| E6.5 metrik Model 3 | Ahmad | PR #22 menunggu perbaikan |
| Dataset aksesoris | Ahmad | PR #23 menunggu perbaikan angka |
| Model 10 kelas dan penolakan objek | Abim | PR #31 dan #32 menunggu perbaikan |
| E7.6 latensi dan ukuran model | Abim | Belum dibuat |
| Model 3 data nyata | Belum ada PIC | Dataset pasangan nyata belum tersedia |
