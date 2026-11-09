# Model Card — Model 1 v2 (Klasifikasi Jenis Pakaian, 9 Kelas)

Diperbarui: 9 November 2026

## 1. Ringkasan

| Item | Isi |
|---|---|
| Nama | `model1_hf_v2` |
| Tugas | Klasifikasi jenis pakaian dari satu foto |
| Arsitektur | YOLOv11n-cls (Ultralytics), transfer learning ImageNet |
| Dataset | `ashraq/fashion-product-images-small` + 800 foto negatif COCO 2017 |
| Input | RGB 224 x 224 piksel |
| Output | 9 kelas, urut abjad folder |
| Ukuran TFLite int8 | 1,68 MB |
| Status | Siap dipakai di aplikasi; uji foto lapangan belum |

## 2. Urutan kelas

```
0 dress
1 long_pants
2 other
3 outerwear
4 shirt
5 shoes
6 shorts
7 skirt
8 tshirt
```

`other` berarti objek di foto bukan pakaian. Aplikasi menolak hasil bila kelas
ini terpilih atau confidence di bawah 0,50.

## 3. Data latih

| Sumber | Jumlah |
|---|---:|
| fashion_products_hf | 15.795 |
| negatives (COCO) | 560 |
| **Total train** | **16.355** |

Split 70/15/15 stratified per kelas. Val 3.452, test 3.461.
Deduplikasi MD5 membuang 336 gambar identik lintas split.

Kelas `long_sleeve` tidak ada karena dataset Hugging Face tidak menyediakan
label tersebut; atasan lengan panjang masuk ke `shirt`, `tshirt`, atau
`outerwear`.

## 4. Pelatihan

| Parameter | Nilai |
|---|---|
| Epoch berjalan | 24 (early stop, patience 8) |
| Model terbaik | epoch 16 |
| Batch | 64 |
| Resolusi | 224 |
| Perangkat | Tesla T4 |
| Seed | 42 |

Validasi terbaik: top-1 97,1 persen, top-5 100 persen.

## 5. Hasil test

| Metrik | Nilai |
|---|---:|
| Akurasi | **97,54 persen** |
| Macro F1 | **93,37 persen** |
| Jumlah gambar | 3.461 |

Per sumber:

| Sumber | n | Akurasi | Macro F1 |
|---|---:|---:|---:|
| fashion_products_hf | 3.341 | 97,46 persen | 92,54 persen |
| negatives (other) | 120 | 100 persen | 100 persen |

Per kelas (F1):

| Kelas | F1 | Support |
|---|---:|---:|
| shoes | 1,000 | 1.274 |
| other | 1,000 | 120 |
| long_pants | 0,993 | 213 |
| shorts | 0,970 | 64 |
| tshirt | 0,968 | 1.182 |
| shirt | 0,964 | 413 |
| outerwear | 0,877 | 124 |
| skirt | 0,818 | 13 |
| dress | 0,813 | 58 |

Kekeliruan terbanyak: `tshirt → shirt` (19), `tshirt → outerwear` (15),
`tshirt → dress` (13), `outerwear → tshirt` (11), `dress → tshirt` (7).

## 6. Keterbatasan

1. `long_sleeve` tidak dikenali sebagai kelas terpisah.
2. `skirt` hanya 13 gambar uji, jadi F1-nya belum stabil.
3. Uji foto lapangan (150 foto HP) belum dijalankan.
4. Model mengklasifikasikan seluruh gambar, bukan memberi kotak pembatas.
5. Model int8 dapat sedikit berbeda dari model float saat di perangkat.

## 7. Artefak

| Artefak | Lokasi |
|---|---|
| Model aplikasi | `assets/models/yolo11n_cls.tflite` |
| Label | `assets/models/labels.txt` |
| Laporan test | `ml/reports/model1_v2_test_report.txt` |
| Ringkasan JSON | `ml/reports/model1_v2_test_summary.json` |
| Per sumber | `ml/reports/model1_v2_per_source.csv` |
| Confusion matrix validasi | `ml/reports/model1_v2_confusion_val.png` |
| Kurva latihan | `ml/reports/model1_v2_results.png` |
| Checkpoint | `ml/runs/model1_hf_v2/weights/best.pt` (lokal, tidak di-commit) |
