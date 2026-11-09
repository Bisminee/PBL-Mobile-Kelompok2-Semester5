# Bukti Run Model 1 v2 — 9 November 2026

Satu kali run penuh di Google Colab, GPU Tesla T4.

## 1. Lingkungan

| Item | Nilai |
|---|---|
| Ultralytics | 8.4.208 |
| datasets | 4.8.5 |
| Torch | 2.14.1+cu130 |
| Python | 3.13.16 |
| GPU | Tesla T4 15 GB |
| Perintah | `04_train_yolo11n.py --data ml/data/processed/model1 --epochs 30 --imgsz 224 --batch 64 --workers 2 --device 0 --name model1_hf_v2` |

## 2. Data

Dataset: `ashraq/fashion-product-images-small` + 800 foto negatif COCO 2017.

| Split | fashion_products_hf | negatives | Total |
|---|---:|---:|---:|
| train | 15.795 | 560 | 16.355 |
| val | 3.332 | 120 | 3.452 |
| test | 3.341 | 120 | 3.461 |

Kelas (9): `dress`, `long_pants`, `other`, `outerwear`, `shirt`, `shoes`,
`shorts`, `skirt`, `tshirt`.

Kelas `long_sleeve` tidak ada karena dataset Hugging Face tidak menyediakan
label tersebut. Deduplikasi MD5 membuang 336 gambar identik.

## 3. Pelatihan

| Item | Nilai |
|---|---|
| Epoch berjalan | 24 (early stop, patience 8) |
| Model terbaik | epoch 16 |
| Val top-1 terbaik | 0,971 |
| Val top-5 terbaik | 1,000 |
| Waktu | 0,548 jam |

## 4. Evaluasi test

| Metrik | Nilai |
|---|---:|
| Akurasi | **0,9754** |
| Macro F1 | **0,9337** |
| Jumlah gambar | 3.461 |

| Kelas | Precision | Recall | F1 | Support |
|---|---:|---:|---:|---:|
| dress | 0,769 | 0,862 | 0,813 | 58 |
| long_pants | 0,995 | 0,991 | 0,993 | 213 |
| other | 1,000 | 1,000 | 1,000 | 120 |
| outerwear | 0,860 | 0,895 | 0,877 | 124 |
| shirt | 0,951 | 0,978 | 0,964 | 413 |
| shoes | 1,000 | 0,999 | 1,000 | 1.274 |
| shorts | 0,941 | 1,000 | 0,970 | 64 |
| skirt | 1,000 | 0,692 | 0,818 | 13 |
| tshirt | 0,978 | 0,959 | 0,968 | 1.182 |

Per sumber:

| Sumber | n | Akurasi | Macro F1 |
|---|---:|---:|---:|
| fashion_products_hf | 3.341 | 0,9746 | 0,9254 |
| negatives (other) | 120 | 1,0000 | 1,0000 |

## 5. Tingkat penolakan objek bukan pakaian

| Ukuran | Nilai |
|---|---:|
| Objek `other` di test | 120 |
| Ditolak benar (prediksi `other`) | 120 |
| Tingkat penolakan | **100 persen** |

Angka ini diukur pada test set katalog/COCO, belum pada foto HP. Ambang
confidence 0,50 belum divalidasi pada model v2. Jalankan:

```bash
python ml/scripts/14_threshold_sweep.py --weights ml/runs/model1_hf_v2/weights/best.pt
```

Hasilnya di `ml/reports/model1_v2_threshold_sweep.csv`.

## 6. Artefak

| Artefak | Lokasi | Ukuran |
|---|---|---:|
| Checkpoint terbaik | `ml/runs/model1_hf_v2/weights/best.pt` | 3,2 MB |
| TFLite int8 | `assets/models/yolo11n_cls.tflite` | 1,68 MB |
| Output TFLite | `[1, 9]` | - |
| Input TFLite | `[1, 3, 224, 224]` | - |
| Confusion matrix validasi | `ml/reports/model1_v2_confusion_val.png` | - |
| Kurva latihan | `ml/reports/model1_v2_results.png` | - |
