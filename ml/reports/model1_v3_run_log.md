# Bukti Run Model 1 v3 (10 Kelas) — 10 November 2026

Satu kali run penuh di Google Colab, GPU Tesla T4.

## 1. Data

Dataset: `ashraq/fashion-product-images-small` + 800 foto negatif COCO 2017.
Kelas `long_sleeve` berasal dari label `Sweatshirts` dan `Sweaters`.

Kelas (10): `dress`, `long_pants`, `long_sleeve`, `other`, `outerwear`,
`shirt`, `shoes`, `shorts`, `skirt`, `tshirt`.

| Item | Nilai |
|---|---:|
| Jumlah kelas | 10 |
| Gambar test | 3.460 |
| Objek `other` di test | 120 |

Jumlah train/val tidak dicatat ulang di sini; lihat `metadata.csv` pada run
Colab. Total gambar setelah dedup berada di kisaran 23 ribu.

## 2. Pelatihan

| Item | Nilai |
|---|---|
| Nama run | `model1_hf_v3` |
| Epoch berjalan | 27 |
| Val top-1 terbaik | 0,97106 |
| Val top-5 terbaik | 0,99942 |
| Batch | 64 |
| Resolusi | 224 |
| GPU | Tesla T4 |

## 3. Evaluasi test

| Metrik | Nilai |
|---|---:|
| Akurasi | **0,9688** |
| Macro F1 | **0,8824** |
| Jumlah gambar | 3.460 |

| Sumber | n | Akurasi | Macro F1 |
|---|---:|---:|---:|
| fashion_products_hf | 3.340 | 0,9677 | 0,8693 |
| negatives (other) | 120 | 1,0000 | 1,0000 |

Kelas terlemah: `outerwear` F1 0,687 (40 gambar), `skirt` 0,714 (15),
`long_sleeve` 0,758 (84).

## 4. Penolakan objek bukan pakaian

| Ukuran | Nilai |
|---|---:|
| Objek `other` di test | 120 |
| Ditolak benar | 120 |
| Tingkat penolakan | **100 persen** |

Ambang 0,50 belum divalidasi. Jalankan:

```bash
python ml/scripts/14_threshold_sweep.py \
    --weights ml/runs/model1_hf_v3/weights/best.pt
```

## 5. Artefak

| Artefak | Ukuran |
|---|---:|
| `assets/models/yolo11n_cls.tflite` (int8) | 1,76 MB |
| Output TFLite | `[1, 10]` |
| Input TFLite | `[1, 3, 224, 224]` |
| `ml/runs/model1_hf_v3/weights/best.pt` | 3,2 MB |
