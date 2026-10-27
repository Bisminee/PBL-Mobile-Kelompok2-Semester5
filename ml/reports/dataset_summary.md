# Ringkasan Dataset Model 1

Dibuat: 27 Oktober 2026 dari run `01_prepare_model1.py` (seed 42).

## 1. Bahan mentah

| Dataset | Berkas gambar | Setelah filter dan mapping |
|---|---:|---:|
| Clothing Dataset Full | 11.524 | 3.730 |
| Fashion Product Images (Small) | 88.882 | 22.847 |
| Clothes Dataset (Carousell) | 7.500 | 7.500 |
| **Total sebelum dedup** | | **34.077** |

Filter yang dipakai: kelas harus ada di `ml/label_maps/`, pakaian anak dibuang
(Clothing Full), gender dibatasi Men/Women/Unisex (Fashion Products), dan gambar
harus lolos verifikasi Pillow.

Deduplikasi MD5 membuang **410 gambar identik**, menyisakan **33.667 gambar**.

## 2. Split 70/15/15 (per sumber, stratified per kelas)

| Kelas | Train | Val | Test |
|---|---:|---:|---:|
| dress | 836 | 180 | 179 |
| long_pants | 2.116 | 454 | 453 |
| long_sleeve | 395 | 84 | 85 |
| outerwear | 3.365 | 721 | 721 |
| shirt | 2.642 | 567 | 566 |
| shoes | 6.231 | 1.334 | 1.336 |
| shorts | 857 | 184 | 183 |
| skirt | 518 | 111 | 111 |
| tshirt | 6.606 | 1.415 | 1.417 |
| **Total** | **23.566** | **5.050** | **5.051** |

## 3. Proporsi sumber di data latih

| Sumber | Proporsi |
|---|---:|
| fashion_products | 66,9 persen |
| carousell | 22,1 persen |
| clothing_full | 11,1 persen |

Satu sumber melewati 60 persen. Jika ingin diseimbangkan, jalankan:

```bash
python ml/scripts/02_balance_train.py --apply --cap-source fashion_products:0.6
```

## 4. Evaluasi awal (model 1 epoch, untuk uji pipeline)

Model uji: `model1_smoke`, 1 epoch, 224 px, batch 32, CPU.

| Metrik | Nilai |
|---|---:|
| Akurasi validasi | 88,75 persen |
| Akurasi test | 88,2 persen |
| Macro F1 test | 77,3 persen |
| Waktu latih 1 epoch | sekitar 42 menit (CPU) |

Akurasi per sumber pada test:

| Sumber | n | Akurasi | Macro F1 |
|---|---:|---:|---:|
| carousell | 1.114 | 75,7 persen | 56,0 persen |
| clothing_full | 560 | 78,6 persen | 72,4 persen |
| fashion_products | 3.377 | 94,0 persen | 76,7 persen |

Kekeliruan terbanyak: shirt ke outerwear (101), outerwear ke tshirt (71),
dress ke outerwear (38), shirt ke tshirt (37), skirt ke outerwear (28).

## 5. Catatan

- Model final dilatih 6 epoch di CPU karena satu epoch membutuhkan sekitar 42
  menit. Target akurasi 80 persen sudah terlampaui pada epoch pertama.
- Angka final akan diperbarui setelah latihan 6 epoch selesai, memakai
  `05_eval_model1.py`.
- Data mentah dan hasil latihan tidak di-commit; hanya ringkasan ini dan laporan
  evaluasi.
