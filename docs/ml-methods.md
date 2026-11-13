# Dokumentasi Metode Machine Learning (Sera-Z)

## 1. Dataset
- **Sumber Data**: Total 33.667 gambar dikumpulkan dari tiga sumber utama: Clothing Dataset Full, Fashion Product Images (Small), dan Clothes Dataset (Carousell).
- **Kelas**: Data diseimbangkan menjadi 9 kelas, yaitu: `dress`, `long_pants`, `long_sleeve`, `outerwear`, `shirt`, `shoes`, `shorts`, `skirt`, dan `tshirt`.

## 2. Praproses dan Split Data
- **Split Data**: Dataset dibagi dengan rasio 70% untuk *training*, 15% untuk *validation*, dan 15% untuk *testing*.
- **Praproses Gambar (Model 1)**: Mempertimbangkan orientasi EXIF, mengubah ukuran sisi pendek menjadi 224 piksel, memotong area persegi di tengah (*center crop*), dan menyusun tensor menjadi format NCHW `[1, 3, 224, 224]` untuk keperluan aplikasi.
- **Praproses Warna (Modul 2)**: Mengambil 50% area tengah gambar untuk menghindari dominasi warna latar belakang, lalu mengonversi nilai piksel RGB menjadi HSV.

## 3. Arsitektur Model
- **Model 1 (Klasifikasi Pakaian)**: Menggunakan arsitektur YOLOv11n-cls dengan ukuran input 224x224. *Baseline* awal juga dievaluasi menggunakan MobileNetV2.
- **Model 3 (Rekomendasi Outfit)**: Menggunakan arsitektur Multi-Layer Perceptron (MLP) Keras yang menerima 20 fitur (termasuk *one-hot encoding* jenis pakaian, nilai HSV, selisih warna, status warna netral, dan skor aturan harmoni).

## 4. Parameter Latihan dan Metrik Evaluasi
- **Pelatihan Model 1**: Dilatih selama 12 epoch dengan ukuran *batch* 32 dan *patience* 4. Evaluasi akhir menghasilkan akurasi *test* sebesar 94,34% dan macro F1 sebesar 89,48%.
- **Pelatihan Model 3**: Dilatih selama 35 epoch menggunakan 6.000 pasangan data sintetis (4.800 latih, 1.200 uji). Hasil metrik evaluasi menunjukkan AUC 0,976 dan precision@3 sebesar 0,455.

## 5. Keterbatasan (Limitations)
1. **Data Sintetis**: Model 3 (rekomendasi pasangan) dilatih murni menggunakan data sintetis yang dibangkitkan berdasarkan heuristik aturan harmoni warna, sehingga tingginya angka metrik AUC belum tentu mencerminkan kemampuan generalisasi pada penilaian *style* manusia di dunia nyata.
2. **Ketiadaan Data Nyata**: Saat ini belum ada data riwayat pasangan *outfit* yang benar-benar nyata (*real-world outfit pairing*) dari pengguna untuk melatih model rekomendasi.
3. **Evaluasi Terbatas**: Kinerja model klasifikasi (Model 1) sejauh ini baru dievaluasi secara terbatas pada distribusi karakteristik dari tiga dataset publik tersebut.

## 6. Cara Reproduksi dan Bukti
- Laporan lengkap evaluasi, *confusion matrix*, dan metrik performa (per sumber) tersedia di direktori `ml/reports/`.
- Ringkasan distribusi *split* dataset dapat dilihat pada file `ml/data/processed/model1/metadata.csv`.
- Spesifikasi teknis dari Model 1 (termasuk detail tensor dan metrik evaluasi) dicatat dalam *model card* di `docs/model1-card.md`.