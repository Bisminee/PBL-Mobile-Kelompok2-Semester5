# Model 1 — Klasifikasi Jenis Pakaian (ml/)

Pipeline ML untuk **E4.1–E4.6**: menyiapkan dataset, menggabungkan 3 dataset
menjadi satu, melatih **YOLOv11n-cls** (+ baseline MobileNetV2), mengevaluasi,
dan mengekspor ke **TFLite int8** untuk aplikasi.

> Semua dataset di pipeline ini **lisensi bersih** (CC0/MIT): aman untuk
> akademik maupun komersial. Lihat `context/datasets-tambahan.md` §5.

---

## 0. Prasyarat & Setup

```powershell
# 1. Virtual environment Python (sekali saja)
py -3.11 -m venv ml\.venv
ml\.venv\Scripts\activate

# 2. Library
pip install ultralytics scikit-learn pandas pillow matplotlib kaggle tensorflow

# 3. Kaggle API key: taruh kaggle.json di %USERPROFILE%\.kaggle\ (sekali saja)

# 4. Branch kerja (jangan di main)
git checkout -b ml/dataset-eda
```

Training di laptop tanpa GPU bisa lambat — boleh pakai **Colab (GPU T4 gratis)**:
unggah folder `ml/` + dataset ke Google Drive, jalankan script yang sama.

---

## 1. Struktur Folder

```
ml/
├─ README.md                  # dokumen ini
├─ scripts/
│  ├─ 01_prepare_model1.py        # E4.1–E4.2: gabung 3 dataset → folder train/val/test
│  ├─ 02_balance_train.py         # E4.4: seimbangkan kelas (train saja)
│  ├─ 03_baseline_mobilenetv2.py  # E4.3: baseline pembanding
│  ├─ 04_train_yolo11n.py         # E4.4: latih YOLOv11n-cls
│  ├─ 05_eval_model1.py           # E4.5: evaluasi + confusion matrix + per-sumber
│  └─ 06_export_tflite.py         # E4.6: ekspor int8 → assets/models/
├─ label_maps/                # tabel pemetaan label (bukti keputusan, dipakai 01_)
│  ├─ clothing_full.csv
│  ├─ fashion_products.csv
│  └─ carousell.csv
├─ data/                      # (di-gitignore)
│  ├─ raw/                    # hasil unduhan Kaggle
│  └─ processed/model1/       # hasil gabungan + metadata.csv
├─ runs/                      # (di-gitignore) checkpoint & log training
└─ reports/                   # hasil evaluasi (di-commit untuk laporan E4.5)
```

---

## 2. Unduh Dataset

```powershell
kaggle datasets download -d agrigorev/clothing-dataset-full           -p ml/data/raw/clothing-full    --unzip
kaggle datasets download -d paramaggarwal/fashion-product-images-small -p ml/data/raw/fashion-products --unzip
kaggle datasets download -d ryanbadai/clothes-dataset                 -p ml/data/raw/carousell        --unzip
```

| Dataset | Isi | Label | Lisensi |
|---|---|---|---|
| Clothing Dataset Full | ~5,4k foto, 20 kelas | `images.csv`: `image`, `label`, `kids` | CC0 |
| Fashion Product Images (Small) | ~44k produk, foto 60×80 | `styles.csv`: `articleType`, `baseColour`, `gender` | MIT |
| Clothes Dataset (Carousell) | 15 kelas, label Indonesia | folder/nama file per kelas | MIT |

> Biarkan `ml/data/` **tidak di-commit** (sudah di `.gitignore`). Yang di-commit:
> script + label maps + laporan evaluasi. Foto lapangan 150 (E10.2) simpan di
> `ml/data/field_photos/` (juga di-gitignore, serahkan via Drive).

---

## 3. Konsep Penggabungan (baca dulu)

Lima prinsip — ini yang membedakan penggabungan yang benar dan yang gagal:

| # | Prinsip | Artinya |
|---|---------|---------|
| 1 | Satu ruang label | Semua label → **9 kelas target** (tabel di `label_maps/`) |
| 2 | Satu struktur folder | `train/<kelas>/*.jpg`, `val/<kelas>/*.jpg`, `test/<kelas>/*.jpg` |
| 3 | Catat asal data | Kolom `source` di `metadata.csv` → evaluasi per-sumber |
| 4 | Anti-bocor | Dedup md5 + split **per dataset** sebelum digabung |
| 5 | Jaga keseimbangan | Cek proporsi sumber & kelas; atur di train saja |

**Taksonomi 9 kelas** (fungsi untuk Model 3):

| Kelas | Fungsi | Kelas | Fungsi |
|---|---|---|---|
| `tshirt` | atasan | `long_pants` | bawahan |
| `shirt` | atasan | `shorts` | bawahan |
| `long_sleeve` | atasan | `skirt` | bawahan |
| `outerwear` | luaran | `dress` | terusan |
| `shoes` | alas kaki | | |

Aturan pemetaan: label ambigu/ragu dan jumlah kecil → **buang** (mis. `Not sure`,
`Skip`, `Others`, `Body`, `Hat`, `Undershirt`, Saree, Innerwear). Kidswear
(`kids=True`) dibuang, gender hanya Men/Women/Unisex. Alasan tiap keputusan
tertulis di `label_maps/*.csv` dan dibahas di laporan E4.2.

---

## 4. Urutan Menjalankan (Quickstart)

```powershell
ml\.venv\Scripts\activate

python ml/scripts/01_prepare_model1.py --dry-run    # cek dulu tanpa menyalin
python ml/scripts/01_prepare_model1.py              # jalankan (buat processed/model1/)
python ml/scripts/02_balance_train.py               # laporan; tambah --apply utk eksekusi
python ml/scripts/03_baseline_mobilenetv2.py        # E4.3 baseline
python ml/scripts/04_train_yolo11n.py               # E4.4 model utama
python ml/scripts/05_eval_model1.py                 # E4.5 evaluasi
python ml/scripts/06_export_tflite.py               # E4.6 → assets/models/
```

| Script | Jobdesk | Output |
|---|---|---|
| `01_prepare_model1.py` | E4.1–E4.2 | `ml/data/processed/model1/` + `metadata.csv` |
| `02_balance_train.py` | bagian E4.4 | train seimbang (dup file `_dupN`), laporan proporsi |
| `03_baseline_mobilenetv2.py` | E4.3 | `ml/runs/baseline_mobilenetv2.pt` + metrik |
| `04_train_yolo11n.py` | E4.4 | `ml/runs/model1_yolo11n/weights/best.pt` |
| `05_eval_model1.py` | E4.5 | `ml/reports/` (report txt, confusion matrix png, per-sumber csv) |
| `06_export_tflite.py` | E4.6 | `assets/models/model1_yolo11n_v1.tflite` |

---

## 5. Penjelasan Singkat Tiap Langkah

**01 — Persiapan.** Membaca `images.csv` / `styles.csv`, menerapkan label map,
memvalidasi gambar (buang file rusak), dedup md5, lalu **split 70/15/15 per
dataset** (stratified per kelas, seed 42) dan menyalin ke struktur Ultralytics.
Test set utama = Clothing Dataset Full (dipakai angka laporan); test per-sumber
lain tersimpan via kolom `source` untuk uji robustness.

**02 — Penyeimbang.** Oversampling kelas minoritas hanya di **train** (duplikasi
file, suffix `_dupN`) sampai ~50% kelas terbesar. Opsi `--cap-source
fashion_products:0.6` memindahkan kelebihan sumber dominan ke folder
`_excluded/` (tidak dihapus). Val/test tidak boleh disentuh.

**03 — Baseline.** MobileNetV2 (ImageNet) transfer learning 2 fase: freeze
backbone → unfreeze blok akhir. Angka ini jadi pembanding klaim "YOLOv11n lebih
baik" di laporan.

**04 — Model utama.** YOLOv11n-cls pretrained ImageNet, early stopping
(`patience`), seed 42. Jika versi Ultralytics mendukung `cls_pw`, pembobotan
kelas otomatis dipakai; kalau tidak, andalkan hasil `02_`.

> Catatan: dokumentasi Ultralytics terbaru menampilkan YOLO26; proyek kita
> memakai `yolo11n-cls.pt` agar konsisten dengan proposal. Default transform
> training = `RandomResizedCrop` (bisa memotong pinggiran) — lihat docs
> "Custom transforms" jika akurasi mentok.

**05 — Evaluasi.** Angka wajib: top-1, macro F1, confusion matrix, **akurasi
per sumber**, + 150 foto lapangan (E10.2, uji robustness). Target: akurasi
≥ 80% dan F1 ≥ 0,75 di test (target antara 75%).

**06 — Ekspor.** TFLite **int8** (kalibrasi dari data train). Verifikasi
interpreter sebelum diserahkan. Nama file: `model1_yolo11n_v1.tflite`
(≤ ~6 MB biasanya). Serahkan ke E7.1 bersama *model card* (input 224×224,
output urutan 9 kelas, metrik).

---

## 6. Kesalahan Umum

| ❌ Jangan | ✅ Lakukan |
|---|---|
| Split setelah gabung tanpa dedup | Dedup md5, split per dataset |
| Oversample val/test | Hanya train |
| Satu sumber > 60% train dibiarkan | `--cap-source` atau subsample |
| Tuning di test set | Test beku; tuning di val |
| Commit dataset/bobot ke Git | `.gitignore` sudah diatur; commit script + laporan |
| Ubah label map tanpa catatan | Semua perubahan mapping masuk laporan (E4.2) |

---

## 7. Referensi

- Format dataset & training classify (Ultralytics):
  https://docs.ultralytics.com/datasets/classify/ · https://docs.ultralytics.com/tasks/classify/
- Semua argumen training: https://docs.ultralytics.com/usage/cfg/
- Panduan class imbalance: https://y-t-g.github.io/tutorials/yolo-class-balancing
- Dataset: [Clothing Full (CC0)](https://www.kaggle.com/datasets/agrigorev/clothing-dataset-full) ·
  [Fashion Product Images (MIT)](https://www.kaggle.com/datasets/paramaggarwal/fashion-product-images-small) ·
  [Carousell (MIT)](https://www.kaggle.com/datasets/ryanbadai/clothes-dataset)
- Dokumen proyek: `Pembagian Tugas/Epics/E4-model-1-klasifikasi.md`,
  `context/datasets-tambahan.md`, `context/implementasi-plan.md`
