# Model Card — Model 1 (Klasifikasi Jenis Pakaian)

Diperbarui: 28 Oktober 2026

## 1. Ringkasan

| Item | Isi |
|---|---|
| Nama | `model1_yolo11n` |
| Tugas | Klasifikasi jenis pakaian dari satu foto |
| Arsitektur | YOLOv11n-cls (Ultralytics), transfer learning dari bobot ImageNet |
| Framework | PyTorch 2.14.1 (CPU), Ultralytics 8.4.190 |
| Input | Gambar RGB 224 x 224 piksel |
| Output | Probabilitas 9 kelas, urut abjad folder |
| Ukuran checkpoint | 3,1 MB (`best.pt`) |
| Status | Siap dipakai untuk integrasi TFLite |

## 2. Urutan kelas

Urutan ini wajib dipakai saat memuat model di aplikasi:

```
0 dress
1 long_pants
2 long_sleeve
3 outerwear
4 shirt
5 shoes
6 shorts
7 skirt
8 tshirt
```

Setiap kelas dipetakan ke kategori fungsional:

| Kelas model | Kategori aplikasi |
|---|---|
| dress | Terusan |
| long_pants, shorts, skirt | Bawahan |
| long_sleeve, shirt, tshirt | Atasan |
| outerwear | Luaran |
| shoes | Alas kaki |

## 3. Data latih

| Sumber | Lisensi | Gambar setelah filter |
|---|---|---:|
| Clothing Dataset Full | CC0 | 3.730 |
| Fashion Product Images (Small) | MIT | 22.847 |
| Clothes Dataset (Carousell) | MIT | 7.500 |

Setelah deduplikasi MD5: 33.667 gambar. Split 70/15/15 per sumber dan
stratified per kelas: train 23.566, val 5.050, test 5.051.

Kelas ambigu dibuang, pakaian anak dihapus, dan gender dibatasi Men, Women,
Unisex. Detail lengkap ada di `ml/reports/dataset_summary.md`.

## 4. Pelatihan

| Parameter | Nilai |
|---|---|
| Epoch | 6 (patience 3, tidak terpicu) |
| Batch | 32 |
| Resolusi | 224 |
| Optimizer | Default Ultralytics |
| Seed | 42 |
| Perangkat | CPU |
| Waktu | 18.308 detik (5 jam 5 menit) |

Perintah reproduksi:

```bash
ml/.venv/Scripts/python.exe ml/scripts/04_train_yolo11n.py --epochs 6 --patience 3 --batch 32 --device cpu --name model1_yolo11n
```

## 5. Hasil evaluasi

Evaluasi pada test set berisi 5.051 gambar:

| Metrik | Nilai |
|---|---:|
| Akurasi | **94,34 persen** |
| Macro F1 | 89,48 persen |
| Macro precision | 89,3 persen |
| Macro recall | 89,9 persen |

Per sumber:

| Sumber | n | Akurasi | Macro F1 |
|---|---:|---:|---:|
| carousell | 1.114 | 87,79 persen | 83,90 persen |
| clothing_full | 560 | 90,71 persen | 88,46 persen |
| fashion_products | 3.377 | 97,10 persen | 91,60 persen |

Kelas terkuat: shoes (F1 0,999), tshirt (0,958), long_pants (0,954).
Kelas terlemah: long_sleeve (0,763), dress (0,799), skirt (0,827).

Kekeliruan paling sering: tshirt ke dress (29), outerwear ke tshirt (24),
shirt ke outerwear (23).

Bukti lengkap: `ml/reports/model1_test_report.txt`,
`model1_test_summary.json`, `model1_test_confusion_matrix.png`,
`model1_test_per_source.csv`.

## 6. Keterbatasan

1. **Foto studio vs foto nyata.** Sebagian besar data berasal dari katalog
   produk dengan latar polos. Akurasi pada foto pengguna dengan latar ramai
   kemungkinan lebih rendah; akurasi carousell (87,8 persen) menjadi gambaran
   terdekat.
2. **Kelas minoritas.** `long_sleeve` hanya 395 gambar latih dan `dress` 836,
   sehingga F1 keduanya paling rendah.
3. **Kategori tidak seimbang.** Satu sumber menyumbang 66,9 persen data latih;
   penyeimbangan belum diterapkan.
4. **Bukan deteksi objek.** Model mengklasifikasikan seluruh gambar, bukan
   memberi kotak pembatas. Cropping tetap menjadi tanggung jawab aplikasi.
5. **Belum diuji pada foto lapangan.** 150 foto lapangan (E10.2) belum
   dikumpulkan, sehingga belum ada uji ketahanan domain nyata.

## 7. Penggunaan yang disarankan

- Panggil model pada gambar yang sudah di-crop ke area pakaian.
- Gunakan ambang keyakinan, misalnya tolak prediksi di bawah 0,5 dan minta
  pengguna mengambil ulang foto.
- Perlakukan kelas `long_sleeve` dan `dress` dengan hati-hati; tampilkan
  keyakinan agar pengguna bisa menilai.

## 8. Artefak

| Artefak | Lokasi | Status |
|---|---|---|
| Checkpoint latih | `ml/runs/model1_yolo11n/weights/best.pt` | Lokal, tidak di-commit |
| Model TFLite int8 | `assets/models/` | Dibuat pada langkah ekspor |
| Label | `assets/models/labels_clothing.txt` | Perlu disamakan dengan urutan kelas di atas |
| Laporan evaluasi | `ml/reports/model1_test_*` | Di-commit |

## 9. Lisensi dan etika

Dataset berlisensi CC0 dan MIT, sehingga aman untuk keperluan akademik. Model
tidak menyimpan data pribadi. Foto pengguna sebaiknya diproses di perangkat dan
tidak diunggah ke server.
