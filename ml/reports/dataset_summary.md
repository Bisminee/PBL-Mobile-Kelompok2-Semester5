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

## 4. Evaluasi model final

Model: `model1_yolo11n`, 6 epoch, 224 px, batch 32, CPU.

| Metrik | Nilai |
|---|---:|
| Akurasi validasi terbaik | 94,06 persen (epoch 6) |
| Akurasi test | **94,34 persen** |
| Macro F1 test | 89,48 persen |
| Jumlah gambar test | 5.051 |
| Waktu latih 6 epoch | 18.308 detik (5 jam 5 menit) |
| Ukuran `best.pt` | 3,1 MB |

Per kelas pada test:

| Kelas | Precision | Recall | F1 | Support |
|---|---:|---:|---:|---:|
| dress | 0,734 | 0,877 | 0,799 | 179 |
| long_pants | 0,954 | 0,954 | 0,954 | 453 |
| long_sleeve | 0,750 | 0,776 | 0,763 | 85 |
| outerwear | 0,899 | 0,906 | 0,903 | 721 |
| shirt | 0,921 | 0,929 | 0,925 | 566 |
| shoes | 0,999 | 0,999 | 0,999 | 1.336 |
| shorts | 0,924 | 0,929 | 0,926 | 183 |
| skirt | 0,887 | 0,775 | 0,827 | 111 |
| tshirt | 0,970 | 0,946 | 0,958 | 1.417 |

Akurasi per sumber pada test:

| Sumber | n | Akurasi | Macro F1 |
|---|---:|---:|---:|
| carousell | 1.114 | 87,79 persen | 83,90 persen |
| clothing_full | 560 | 90,71 persen | 88,46 persen |
| fashion_products | 3.377 | 97,10 persen | 91,60 persen |

Kekeliruan terbanyak: tshirt ke dress (29), outerwear ke tshirt (24), shirt ke
outerwear (23), tshirt ke shirt (19), outerwear ke shirt (19).

Perbandingan dengan uji 1 epoch: akurasi test naik dari 88,2 menjadi 94,34
persen, dan akurasi carousell naik paling besar, dari 75,7 menjadi 87,8 persen.

## 5. Catatan

- Target proposal (akurasi minimal 80 persen) terlampaui: test 94,34 persen.
- Kelas terlemah adalah long_sleeve (F1 0,763) dan dress (F1 0,799), keduanya
  berjumlah sedikit pada data latih.
- Model dilatih di CPU tanpa GPU, sehingga 6 epoch memakan waktu sekitar 5 jam.
- Data mentah dan hasil latihan tidak di-commit; hanya ringkasan ini, laporan
  evaluasi, dan model card.
