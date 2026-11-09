# Model Card — Model 1 v3 (Klasifikasi Jenis Pakaian, 10 Kelas)

Diperbarui: 10 November 2026

## 1. Ringkasan

| Item | Isi |
|---|---|
| Nama | `model1_hf_v3` |
| Tugas | Klasifikasi jenis pakaian dari satu foto |
| Arsitektur | YOLOv11n-cls (Ultralytics), transfer learning ImageNet |
| Dataset | `ashraq/fashion-product-images-small` + 800 foto negatif COCO 2017 |
| Input | RGB 224 x 224 piksel |
| Output | 10 kelas, urut abjad folder |
| Ukuran TFLite int8 | 1,76 MB |
| Status | Siap dipakai di aplikasi; uji foto lapangan belum |

## 2. Urutan kelas di `labels.txt`

Label model sudah dipetakan ke kosakata database (`ref_garment_type`) agar
penyimpanan ke lemari tidak gagal karena foreign key.

```
0 dress
1 pants
2 longsleeve
3 other
4 outwear
5 shirt
6 shoes
7 shorts
8 skirt
9 t_shirt
```

| Kelas latih | Label aplikasi/database |
|---|---|
| long_pants | pants |
| long_sleeve | longsleeve |
| outerwear | outwear |
| tshirt | t_shirt |
| other | other (bukan pakaian, tidak disimpan) |

`other` berarti objek di foto bukan pakaian. Aplikasi menolak hasil bila kelas
ini terpilih atau confidence di bawah `minimumGarmentConfidence`.

## 3. Data latih

| Sumber | Keterangan |
|---|---|
| fashion_products_hf | Dataset Hugging Face, 8 kelas pakaian |
| long_sleeve | Diambil dari label `Sweatshirts` dan `Sweaters` |
| negatives (COCO) | 800 foto objek bukan pakaian |

Kelas (10): `dress`, `long_pants`, `long_sleeve`, `other`, `outerwear`,
`shirt`, `shoes`, `shorts`, `skirt`, `tshirt`.

Split 70/15/15, deduplikasi MD5. Test set v3 berisi 3.460 gambar.

## 4. Hasil test

| Metrik | Nilai |
|---|---:|
| Akurasi | **96,88 persen** |
| Macro F1 | **88,24 persen** |
| Jumlah gambar | 3.460 |

Per sumber:

| Sumber | n | Akurasi | Macro F1 |
|---|---:|---:|---:|
| fashion_products_hf | 3.340 | 96,77 persen | 86,93 persen |
| negatives (other) | 120 | 100 persen | 100 persen |

Per kelas:

| Kelas | Precision | Recall | F1 | Support |
|---|---:|---:|---:|---:|
| dress | 0,800 | 0,842 | 0,821 | 57 |
| long_pants | 0,995 | 0,986 | 0,991 | 212 |
| long_sleeve | 0,704 | 0,821 | 0,758 | 84 |
| other | 1,000 | 1,000 | 1,000 | 120 |
| outerwear | 0,852 | 0,575 | 0,687 | 40 |
| shirt | 0,949 | 0,968 | 0,959 | 407 |
| shoes | 1,000 | 0,999 | 1,000 | 1.275 |
| shorts | 0,900 | 0,955 | 0,926 | 66 |
| skirt | 0,769 | 0,667 | 0,714 | 15 |
| tshirt | 0,974 | 0,965 | 0,969 | 1.184 |

Kekeliruan terbanyak: `tshirt → long_sleeve` (16), `tshirt → shirt` (13),
`tshirt → dress` (11), `shirt → tshirt` (11), `outerwear → long_sleeve` (11).

## 5. Tingkat penolakan objek bukan pakaian

| Ukuran | Nilai |
|---|---:|
| Objek `other` di test | 120 |
| Ditolak benar | 120 |
| Tingkat penolakan | **100 persen** |

Diukur pada test set, belum pada foto HP.

## 6. Keterbatasan

1. `long_sleeve` hanya sekitar 500 gambar; F1 0,758.
2. `outerwear` mengecil setelah `Sweatshirts` dan `Sweaters` dipindah ke
   `long_sleeve`; F1 turun ke 0,687 dengan 40 gambar uji.
3. `skirt` hanya 15 gambar uji, F1 0,714.
4. Uji foto lapangan (150 foto HP) belum dijalankan.
5. Model mengklasifikasikan seluruh gambar, bukan memberi kotak pembatas.
6. Ambang `minimumGarmentConfidence` 0,50 sudah divalidasi pada test set v3:
   objek `other` ditolak 100 persen, pakaian salah ditolak 0,63 persen, dan
   akurasi pakaian yang diterima 97,08 persen. Detail di
   `ml/reports/model1_v3_threshold_sweep.csv`.

## 7. Artefak

| Artefak | Lokasi |
|---|---|
| Model aplikasi | `assets/models/yolo11n_cls.tflite` |
| Label | `assets/models/labels.txt` |
| Laporan test | `ml/reports/model1_test_report.txt` |
| Ringkasan JSON | `ml/reports/model1_test_summary.json` |
| Per sumber | `ml/reports/model1_test_per_source.csv` |
| Confusion matrix test | `ml/reports/model1_test_confusion_matrix.png` |
| Confusion matrix validasi | `ml/reports/model1_v3_confusion_val.png` |
| Kurva latihan | `ml/reports/model1_v3_results.png` |
| Checkpoint | `ml/runs/model1_hf_v3/weights/best.pt` (lokal, tidak di-commit) |
