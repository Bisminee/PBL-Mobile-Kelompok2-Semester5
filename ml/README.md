# Pipeline Machine Learning Sera-Z (ml/)

Dokumen ini berisi panduan teknis lengkap ekosistem Machine Learning proyek Sera-Z, meliputi:
- Klasifikasi jenis pakaian (Model 1 / YOLOv11n-cls dan baseline MobileNetV2 - Epic E4)
- Ekstraksi warna dominan pakaian (Modul 2 / K-Means Clustering - Epic E5)
- Penilai kecocokan kombinasi outfit (Model 3 / Keras Multi-Layer Perceptron - Epic E6)
- Panduan unduh dataset, prosedur setelah Git Pull, dan ekspor model ke format TensorFlow Lite (TFLite) untuk aplikasi Flutter.

---

## 1. Daftar dan Penjelasan Fungsi Setiap File

Berikut adalah struktur lengkap folder `ml/` beserta penjelasan fungsi dari setiap file:

```
ml/
|-- README.md                         # Dokumentasi panduan teknis dan operasional ML
|-- requirements.txt                  # Daftar dependensi pustaka Python proyek ML
|-- label_maps/                       # Kamus pemetaan label mentah ke taksonomi 9 kelas
|   |-- clothing_full.csv             # Aturan pemetaan dataset Clothing Dataset Full
|   |-- fashion_products.csv          # Aturan pemetaan dataset Fashion Product Images
|   `-- carousell.csv                 # Aturan pemetaan dataset Carousell Clothes
|-- scripts/                          # Seluruh script otomatisasi pipeline ML (00 - 08)
|   |-- 00_download_data.py           # Unduh otomatis 3 dataset mentah Kaggle ke ml/data/raw/
|   |-- 01_prepare_model1.py          # Pembersihan, deduplikasi MD5, dan split 70/15/15
|   |-- 02_balance_train.py           # Penyeimbangan kelas data latih (oversampling train)
|   |-- 03_baseline_mobilenetv2.py    # Pelatihan model pembanding MobileNetV2 (PyTorch)
|   |-- 04_train_yolo11n.py           # Pelatihan model utama klasifikasi YOLOv11n-cls
|   |-- 05_eval_model1.py             # Evaluasi komprehensif, confusion matrix, per-sumber
|   |-- 06_export_tflite.py           # Kuantisasi int8 dan ekspor model ke format TFLite
|   |-- 07_extract_color_kmeans.py    # Modul 2: Ekstraksi 14 warna dominan (K-Means)
|   `-- 08_train_model3_mlp.py        # Model 3: Pelatihan skor kecocokan outfit (Keras MLP)
|-- data/                             # Direktori data (diabaikan oleh Git / .gitignore)
|   |-- raw/                          # Tempat penyimpanan dataset mentah unduhan Kaggle
|   |   |-- clothing-full/            # Folder ekstrak Clothing Dataset Full
|   |   |-- fashion-products/         # Folder ekstrak Fashion Product Images Small
|   |   `-- carousell/                # Folder ekstrak Clothes Dataset Carousell
|   `-- processed/model1/             # Dataset siap latih terstruktur (train, val, test)
|       |-- train/                    # Gambar latih per subfolder kelas
|       |-- val/                      # Gambar validasi per subfolder kelas
|       |-- test/                     # Gambar uji per subfolder kelas
|       `-- metadata.csv              # Metadata gabungan (path, label, sumber, MD5, split)
|-- runs/                             # Checkpoint model dan log pelatihan (di-gitignore)
|   |-- baseline_mobilenetv2.pt       # Checkpoint model baseline MobileNetV2
|   |-- model1_yolo11n/               # Output pelatihan YOLOv11n (weights/best.pt, log)
|   `-- color_kmeans_sample.png       # Visualisasi swatch 14 warna hasil K-Means
`-- reports/                          # Laporan hasil evaluasi resmi (di-commit ke Git)
    |-- model1_eval_report.txt        # Laporan metrik akurasi, precision, recall, F1-score
    |-- model1_confusion_matrix.png   # Grafik matriks kesalahan (Confusion Matrix)
    `-- model1_per_source_acc.csv     # Tabel rincian performa per sumber dataset
```

### Rincian Fungsi Setiap File Script (`ml/scripts/`):

0. **`00_download_data.py`**
   - **Fungsi:** Mengunduh secara otomatis ketiga dataset mentah dari Kaggle (`clothing-full`, `fashion-products`, `carousell`) ke direktori `ml/data/raw/`.
   - **Cara Kerja:** Mendeteksi ketersediaan dataset di cache `kagglehub` atau mengunduh melalui Kaggle CLI. Secara cerdas memeriksa apakah data sudah ada sebelumnya agar tidak melakukan unduhan ganda.
   - **Output:** Folder `ml/data/raw/clothing-full/`, `ml/data/raw/fashion-products/`, dan `ml/data/raw/carousell/`.

1. **`01_prepare_model1.py`**
   - **Fungsi:** Menggabungkan 3 dataset mentah menjadi satu struktur klasifikasi terpadu.
   - **Cara Kerja:** Membaca file anotasi mentah (`images.csv` dan `styles.csv`), memvalidasi integritas file gambar (membuang gambar rusak/korup), menghapus gambar duplikat berdasarkan hash MD5, memetakan label sesuai kamus `label_maps/`, menyaring data non-relevan (pakaian anak dan kategori ambigu), lalu melakukan pembagian dataset (train 70%, validation 15%, test 15%) secara terpisah per sumber data (stratified split) guna mencegah kebocoran data (*data leakage*).
   - **Output:** Folder `ml/data/processed/model1/` (`train/`, `val/`, `test/`) dan file ringkasan `metadata.csv`.

2. **`02_balance_train.py`**
   - **Fungsi:** Mengatasi ketimpangan jumlah data antar kelas (*class imbalance*) pada subset pelatihan.
   - **Cara Kerja:** Menerapkan teknik *oversampling* dengan menduplikasi file gambar pada kelas minoritas (menggunakan akhiran `_dupN`) hingga mendekati proporsi kelas mayoritas. Script ini juga menyediakan parameter pembatasan sumber data dominan (`--cap-source`).
   - **Prinsip Penting:** Hanya memodifikasi folder `train/`. Folder `val/` dan `test/` tidak disentuh agar evaluasi model tetap mencerminkan distribusi data asli yang objektif.

3. **`03_baseline_mobilenetv2.py`**
   - **Fungsi:** Membangun dan melatih model dasar (*baseline*) berbasis arsitektur MobileNetV2 sebagai tolok ukur pembanding terhadap model utama.
   - **Cara Kerja:** Menggunakan pustaka PyTorch dengan bobot *pre-trained* ImageNet (Transfer Learning) melalui 2 tahap: pembekuan *backbone* untuk melatih kepala klasifikasi (*classification head*), dilanjutkan dengan *fine-tuning* pada lapisan akhir *backbone*.
   - **Output:** File checkpoint PyTorch `ml/runs/baseline_mobilenetv2.pt`.

4. **`04_train_yolo11n.py`**
   - **Fungsi:** Melatih model utama pengklasifikasi jenis pakaian menggunakan arsitektur YOLOv11n-cls (Ultralytics).
   - **Cara Kerja:** Melakukan *fine-tuning* pada bobot *pre-trained* `yolo11n-cls.pt` dari ImageNet ke 9 kelas target pakaian Sera-Z. Mendukung argumen jumlah epoch, batch size, resolusi gambar (224x224), *early stopping*, pembobotan kelas (*class weights*), dan pemilihan perangkat (`cpu` atau `cuda`).
   - **Output:** Checkpoint bobot terbaik di `ml/runs/model1_yolo11n/weights/best.pt`, grafik kurva pelatihan, dan log metrik.

5. **`05_eval_model1.py`**
   - **Fungsi:** Melakukan pengujian dan evaluasi performa menyeluruh terhadap model klasifikasi pada subset data uji (`test/`).
   - **Cara Kerja:** Menghitung Top-1 Accuracy, Macro Precision, Recall, Macro F1-Score, menyusun matriks kesalahan (*confusion matrix*), serta menghitung akurasi terpisah untuk masing-masing sumber dataset dan foto lapangan 150 gambar (Epic E10.2).
   - **Output:** File laporan teks `ml/reports/model1_eval_report.txt`, gambar `ml/reports/model1_confusion_matrix.png`, dan file per-sumber `ml/reports/model1_per_source_acc.csv`.

6. **`06_export_tflite.py`**
   - **Fungsi:** Mengonversi model PyTorch YOLOv11n (`best.pt`) ke format TensorFlow Lite (TFLite) terkuantisasi int8 agar berukuran kecil dan efisien saat dijalankan di perangkat mobile (Flutter).
   - **Cara Kerja:** Menggunakan *Post-Training Quantization (PTQ)* int8 dengan kalibrasi sampel dari data latih, memvalidasi inferensi model TFLite, serta mengekstrak daftar label kelas ke dalam file teks.
   - **Output:** File model `assets/models/clothing_classifier.tflite` dan daftar label `assets/models/labels_clothing.txt`.

7. **`07_extract_color_kmeans.py`**
   - **Fungsi:** Implementasi Modul 2 (Epic E5) untuk mengekstraksi warna dominan pakaian secara otomatis tanpa model pembelajaran berbobot besar.
   - **Cara Kerja:** Melakukan *center crop* pada gambar pakaian untuk menghilangkan gangguan latar belakang, menerapkan algoritma *unsupervised clustering* K-Means dengan 3 pusat klaster (k=3), mengonversi warna dari RGB ke ruang warna HSV, dan memetakan nilai HSV tersebut ke dalam 14 palet warna terstandarisasi Sera-Z.
   - **Output:** Visualisasi swatch warna di `ml/runs/color_kmeans_sample.png`.

8. **`08_train_model3_mlp.py`**
   - **Fungsi:** Implementasi Model 3 (Epic E6) untuk memprediksi tingkat kecocokan kombinasi pakaian (atasan dan bawahan).
   - **Cara Kerja:** Membangun arsitektur jaringan saraf tiruan *Keras Multi-Layer Perceptron (MLP)* dengan 20 fitur input (vektor kategori pakaian, representasi HSV, selisih delta warna, teori harmoni roda warna, dan indikator warna netral).
   - **Output:** Model terkuantisasi `assets/models/model3_compatibility.tflite` (berukuran ~7.6 KB) dan metadata fitur `assets/models/model3_metadata.json`.

---

## 2. Dataset yang Digunakan dan Kebijakan Lisensi

Proyek Sera-Z mengutamakan kepatuhan etika dan legalitas data. Seluruh dataset yang digunakan berlisensi **bebas (CC0 dan MIT)**, sehingga aman untuk keperluan akademik maupun komersial:

| Nama Dataset | Sumber / Kreator | Jumlah Data Asli | Lisensi | Peran dalam Proyek |
|---|---|---|---|---|
| **Clothing Dataset Full** | Alexey Grigorev (Kaggle) | ~5.400 foto | CC0 1.0 Universal (Public Domain) | Dataset utama untuk pelatihan dan evaluasi uji Model 1 |
| **Fashion Product Images (Small)** | Param Aggarwal (Kaggle) | ~44.000 produk | MIT License | Dataset sekunder untuk variasi katalog dan acuan warna Modul 2 |
| **Clothes Dataset (Carousell)** | Ryan Badai (Kaggle) | ~4.000 foto | MIT License | Dataset uji ketahanan (*robustness test*) pada foto marketplace non-studio |

### Kebijakan Terhadap Dataset Non-Komersial:
Dataset populer seperti **DeepFashion, DeepFashion2, Digikala, FashionStylist, dan Fashion & Color TIDAK DIGUNAKAN** dalam proyek ini. Dataset-dataset tersebut memiliki pembatasan ketat *Non-Commercial Research Only* atau lisensi yang tidak jelas, yang berisiko melanggar hak cipta apabila aplikasi dirilis secara publik.

### Taksonomi 9 Kelas Target Sera-Z:
Semua label mentah dari ketiga dataset disatukan ke dalam 9 kelas fungsional (dipetakan pada `ml/label_maps/`):
- **Kategori Atasan:** `tshirt`, `shirt`, `long_sleeve`
- **Kategori Bawahan:** `long_pants`, `shorts`, `skirt`
- **Kategori Luaran & Terusan:** `outerwear`, `dress`
- **Kategori Alas Kaki:** `shoes`

Label di luar kategori ini (misalnya pakaian anak, pakaian dalam, aksesoris, perhiasan, atau label tidak jelas) otomatis disaring dan dibuang oleh script `01_prepare_model1.py`.

---

## 3. Cara Mengunduh Dataset

### Cara Utama: Menggunakan Script Otomatis (Cukup Jalankan Ini Saja)

Anda **cukup menjalankan 1 perintah script ini**:
```powershell
python ml/scripts/00_download_data.py
```
Script ini akan otomatis mengunduh ketiga dataset dari Kaggle (via library `kagglehub` atau Kaggle CLI) langsung ke folder `ml/data/raw/` dan otomatis mendeteksi jika data sudah ada agar tidak mengunduh ulang.

Jika script di atas sudah berhasil dijalankan, Anda **TIDAK PERLU** melakukan langkah manual apa pun lagi di bawah ini.

---

### Jalur Alternatif / Cadangan (Hanya Jika Script Mengalami Kendala Koneksi)

Langkah di bawah ini hanya sebagai alternatif cadangan jika script otomatis di atas mengalami kegagalan jaringan atau limit API:

#### Alternatif 1: Menggunakan Kaggle CLI Manual
1. Pastikan Anda memiliki akun Kaggle dan unduh token API `kaggle.json` dari menu Account Settings.
2. Simpan file `kaggle.json` ke direktori: `%USERPROFILE%\.kaggle\kaggle.json`.
3. Jalankan perintah unduh otomatis:
   ```powershell
   kaggle datasets download -d agrigorev/clothing-dataset-full -p ml/data/raw/clothing-full --unzip
   kaggle datasets download -d paramaggarwal/fashion-product-images-small -p ml/data/raw/fashion-products --unzip
   kaggle datasets download -d ryanbadai/clothes-dataset -p ml/data/raw/carousell --unzip
   ```

#### Alternatif 2: Mengunduh Manual lewat Browser
Jika tidak menggunakan API sama sekali, unduh file zip dari tautan web berikut:
1. **Clothing Dataset Full:** `https://www.kaggle.com/datasets/agrigorev/clothing-dataset-full`
   - Ekstrak isi file zip ke dalam: `ml/data/raw/clothing-full/` (harus berisi file `images.csv` dan folder `images/`).
2. **Fashion Product Images (Small):** `https://www.kaggle.com/datasets/paramaggarwal/fashion-product-images-small`
   - Ekstrak isi file zip ke dalam: `ml/data/raw/fashion-products/` (harus berisi file `styles.csv` dan folder `images/`).
3. **Clothes Dataset (Carousell):** `https://www.kaggle.com/datasets/ryanbadai/clothes-dataset`
   - Ekstrak isi file zip ke dalam: `ml/data/raw/carousell/`.

---

## 4. Panduan Menjalankan Pipeline (Langkah demi Langkah)

### Langkah 0: Setup Lingkungan Python Virtual Environment

Jalankan perintah ini satu kali pada awal setup:

```powershell
# 1. Buat virtual environment menggunakan Python 3.11 atau versi stabil
py -3.11 -m venv ml\.venv

# 2. Aktifkan virtual environment
ml\.venv\Scripts\activate

# 3. Instal semua dependensi pustaka
pip install -r ml/requirements.txt
```

---

### Langkah 1: Persiapan dan Pembagian Dataset
> **Catatan:** Jika folder `ml/data/processed/model1/` sudah ada di komputer Anda, lewati langkah ini.

```powershell
python ml/scripts/01_prepare_model1.py
```
Script akan memeriksa folder raw, membuang gambar duplikat/rusak, membagi data (70/15/15), dan menyusun folder `ml/data/processed/model1/`.

---

### Langkah 2: Penyeimbangan Data Latih (Oversampling)

```powershell
python ml/scripts/02_balance_train.py --apply
```
Script akan menduplikasi gambar pada kelas minoritas khusus di folder `train/` agar jumlah sampel antar kelas menjadi seimbang.

---

### Langkah 3: Melatih Model Baseline MobileNetV2

```powershell
# Mode default (5 epoch fase 1 + 10 epoch fase 2)
python ml/scripts/03_baseline_mobilenetv2.py

# Alternatif mode cepat untuk CPU laptop (2 epoch fase 1 + 3 epoch fase 2)
python ml/scripts/03_baseline_mobilenetv2.py --epochs1 2 --epochs2 3 --batch 32
```
Output checkpoint akan tersimpan di `ml/runs/baseline_mobilenetv2.pt`.

---

### Langkah 4: Melatih Model Utama YOLOv11n-cls

```powershell
# Mode cepat CPU laptop (5 epoch sudah mencapai akurasi lebih dari 80%)
python ml/scripts/04_train_yolo11n.py --epochs 5 --batch 32 --device cpu

# Mode standar (40 epoch untuk hasil optimal di Google Colab / GPU)
python ml/scripts/04_train_yolo11n.py --epochs 40 --batch 32
```
Proses ini menampilkan indikator progres langsung (progress bar) per detik. Model terbaik tersimpan di `ml/runs/model1_yolo11n/weights/best.pt`.

---

### Langkah 5: Evaluasi Model dan Pembuatan Laporan

```powershell
python ml/scripts/05_eval_model1.py
```
Script akan menguji model pada data `test/` dan menghasilkan:
- `ml/reports/model1_eval_report.txt` (Akurasi, F1-Score, Presisi, Recall)
- `ml/reports/model1_confusion_matrix.png` (Grafik matriks prediksi)
- `ml/reports/model1_per_source_acc.csv` (Ketahanan per sumber data)

---

### Langkah 6: Ekspor Model ke Format TFLite untuk Flutter

```powershell
python ml/scripts/06_export_tflite.py
```
Script melakukan kuantisasi int8 dan menyalin file siap pakai langsung ke folder aset aplikasi:
- `assets/models/clothing_classifier.tflite`
- `assets/models/labels_clothing.txt`

---

### Langkah 7: Ekstraksi Warna Dominan K-Means (Modul 2 / Epic E5)

```powershell
python ml/scripts/07_extract_color_kmeans.py
```
Script memproses sampel pakaian dengan algoritma K-Means ($k=3$), memetakan warna ke 14 palet HSV standar, dan menyimpan visualisasi di `ml/runs/color_kmeans_sample.png`.

---

### Langkah 8: Pelatihan Model 3 Kecocokan Outfit (Keras MLP / Epic E6)

```powershell
python ml/scripts/08_train_model3_mlp.py
```
Script melatih jaringan neural Keras MLP dengan 20 fitur aturan estetika warna dan mengekspor model serta metadata langsung ke:
- `assets/models/model3_compatibility.tflite`
- `assets/models/model3_metadata.json`

---

## 5. Prosedur Git Push dan Git Pull untuk Tim Machine Learning

Bagi tim ML dan developer aplikasi, ikuti panduan berikut agar sinkronisasi kode berjalan lancar tanpa merusak repositori atau membebani Git.

### A. Panduan Melakukan Git Push

**Pertanyaan umum: Apakah harus menunggu proses data training selesai untuk melakukan push?**
**Jawabannya: TIDAK PERLU.** Anda dapat melakukan `git commit` dan `git push` kapan saja ketika ada perubahan script atau dokumentasi, tanpa perlu menunggu training lokal selesai. Training adalah proses komputasi mandiri di komputer Anda dan tidak terikat dengan Git.

Berikut rincian aturan file yang boleh dan dilarang di-push ke Git:

| Kategori | File / Folder | Status Git | Alasan / Tindakan |
|---|---|---|---|
| Script Pipeline | `ml/scripts/*.py` | Boleh Di-push | Kode otomatisasi yang wajib dibagikan ke seluruh tim. |
| Dependensi | `ml/requirements.txt` | Boleh Di-push | Agar lingkungan pustaka tim selalu sinkron. |
| Kamus Label | `ml/label_maps/*.csv` | Boleh Di-push | Bukti keputusan taksonomi 9 kelas pakaian. |
| Dokumentasi | `ml/README.md` | Boleh Di-push | Panduan teknis dan operasional resmi. |
| Laporan Evaluasi | `ml/reports/*` | Boleh Di-push | Hasil metrik, matriks kesalahan, dan akurasi per-sumber untuk laporan PBL. |
| Model Akhir Aplikasi | `assets/models/*.tflite`, `*.json`, `*.txt` | Boleh Di-push | Model int8 terkuantisasi (ukuran kecil <= 6 MB) yang siap dijalankan Flutter. |
| Dataset Mentah | `ml/data/raw/` | DILARANG Di-push | Otomatis diabaikan (`.gitignore`). Ukuran gigabyte akan membuat repo berat. |
| Dataset Proses | `ml/data/processed/` | DILARANG Di-push | Otomatis diabaikan (`.gitignore`). Cukup di-generate lewat script 01. |
| Checkpoint Mentah | `ml/runs/*.pt` | DILARANG Di-push | Otomatis diabaikan (`.gitignore`). Bobot PyTorch lokal tidak perlu masuk Git. |
| Virtual Environment | `ml/.venv/`, `.venv/` | DILARANG Di-push | Otomatis diabaikan (`.gitignore`). Bersifat lokal untuk setiap PC. |

**Langkah Menjalankan Git Push:**
```powershell
# 1. Periksa status perubahan
git status

# 2. Tambahkan perubahan script, laporan, dan aset model
git add ml/ "Pembagian Tugas/" pubspec.yaml pubspec.lock assets/

# 3. Buat commit pesan yang jelas
git commit -m "feat(ml): update pipeline, dokumentasi, dan hasil evaluasi"

# 4. Kirim ke branch kerja Anda di GitHub
git push origin <nama-branch>
```

---

### B. Prosedur yang Harus Dilakukan Setelah Melakukan Git Pull

Ketika Anda menarik perubahan terbaru dari repositori:

```powershell
git pull origin <nama-branch>
```

Lakukan 4 langkah verifikasi berikut:

1. **Periksa dan Sinkronkan Dependensi Python:**
   Jika ada pembaruan pustaka di `ml/requirements.txt`, jalankan:
   ```powershell
   ml\.venv\Scripts\activate
   pip install -r ml/requirements.txt
   ```

2. **Kondisi Dataset Lokal Tetap Aman (Tidak Terhapus):**
   Karena folder `ml/data/` dan `ml/runs/` tercantum di `.gitignore`, Git tidak akan menghapus atau menimpa dataset yang sudah Anda miliki di laptop.
   - Jika Anda baru melakukan clone di komputer baru dan folder `ml/data/processed/model1/` belum ada, jalankan `python ml/scripts/00_download_data.py` lalu `python ml/scripts/01_prepare_model1.py`.
   - Jika dataset sudah ada di komputer Anda, **JANGAN** jalankan ulang script 01 dengan opsi `--force` agar data latih yang sudah seimbang tidak ter-reset.

3. **Perbarui Aset Model pada Flutter:**
   Jika rekan tim mengunggah file model baru di `assets/models/`, jalankan perintah berikut di root folder proyek:
   ```powershell
   flutter pub get
   ```
   Perintah ini mendaftarkan file `.tflite` dan `.json` baru ke dalam build pipeline aplikasi Flutter.

4. **Penanganan Konflik Kode:**
   Jika Git pull terhalang karena Anda memiliki perubahan lokal yang belum di-commit:
   ```powershell
   git stash              # Simpan sementara perubahan lokal
   git pull origin <branch>
   git stash pop          # Kembalikan perubahan lokal Anda
   ```

---

## 6. Alternatif Pelatihan Cepat Menggunakan Google Colab (GPU Gratis)

Jika spesifikasi komputer lokal Anda tidak memiliki GPU diskrit (NVIDIA CUDA) dan pelatihan 40 epoch di CPU terasa lambat:

1. Kompres folder `ml/scripts/`, `ml/label_maps/`, dan `ml/data/processed/model1/` menjadi satu file zip.
2. Buka **Google Colab** (`colab.research.google.com`), buat notebook baru, dan ubah runtime ke **T4 GPU** (*Runtime* -> *Change runtime type* -> *T4 GPU*).
3. Unggah file zip ke Google Drive atau langsung ke sesi Colab, lalu ekstrak:
   ```python
   !unzip -q data_model1.zip -d ./
   !pip install ultralytics
   ```
4. Jalankan script pelatihan YOLOv11n:
   ```python
   !python ml/scripts/04_train_yolo11n.py --epochs 40 --batch 32 --device 0
   ```
   Pada GPU T4, 40 epoch akan selesai dalam waktu **kurang lebih 15 hingga 20 menit**.
5. Unduh file `best.pt` yang dihasilkan dari folder `ml/runs/model1_yolo11n/weights/best.pt`, lalu letakkan kembali di folder lokal Anda untuk dievaluasi dan diekspor menggunakan script `05_` dan `06_`.

---

## 7. Prinsip Rekayasa dan Hal yang Dilarang

| Hal yang Dilarang | Prosedur yang Benar |
|---|---|
| Melakukan split data setelah penggabungan tanpa deduplikasi | Lakukan hashing MD5 dan split 70/15/15 secara terpisah per sumber data. |
| Melakukan penambahan data (oversampling) pada subset val atau test | Oversampling HANYA boleh diterapkan pada folder `train/`. Data val dan test harus murni. |
| Membiarkan satu sumber dataset mendominasi lebih dari 60% data latih | Gunakan argumen pembatasan proporsi `--cap-source` pada script `02_balance_train.py`. |
| Mengubah hyperparameter berdasarkan performa data uji (*test set*) | Data uji dibekukan. Penyesuaian hyperparameter hanya boleh mengacu pada data validasi (`val/`). |
| Melakukan commit dataset gambar mentah atau bobot besar ke Git | Biarkan `.gitignore` mengabaikan folder `ml/data/` dan `ml/runs/`. Yang di-commit adalah script, kamus label, dan laporan evaluasi. |
| Memodifikasi kamus label tanpa pencatatan | Seluruh perubahan aturan pemetaan label wajib dicatat pada file `ml/label_maps/*.csv`. |
