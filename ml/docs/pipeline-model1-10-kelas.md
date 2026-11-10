# Pipeline Model 1 — 10 Kelas (Versi Latihan Ulang)

Dokumen ini menjelaskan alur dan kode pipeline ML yang dipakai untuk melatih
Model 1 versi 10 kelas: dataset, penyiapan data, pelatihan, evaluasi, validasi
ambang, ekspor TFLite, dan integrasi ke aplikasi.

Dibuat: 10 November 2026
Branch: `ml/model1-v2-pipeline`
Model: `model1_hf_v3`

---

## 1. Ringkasan

| Item | Nilai |
|---|---|
| Tugas | Klasifikasi satu potong pakaian dari satu foto |
| Arsitektur | YOLOv11n-cls (Ultralytics), transfer learning ImageNet |
| Dataset utama | `ashraq/fashion-product-images-small` |
| Data negatif | 800 foto COCO 2017 untuk kelas `other` |
| Jumlah kelas | 10 (9 pakaian + `other`) |
| Input model | `[1, 3, 224, 224]` RGB |
| Output model | `[1, 10]` |
| Akurasi test | 96,88 persen |
| Macro F1 | 88,24 persen |
| Tingkat penolakan `other` | 100 persen |
| Ukuran TFLite int8 | 1,76 MB |

Kelas:

```
dress, long_pants, long_sleeve, other, outerwear,
shirt, shoes, shorts, skirt, tshirt
```

---

## 2. Peta file

| File | Fungsi |
|---|---|
| `ml/scripts/13_prepare_hf.py` | Unduh dataset HF, filter, split, simpan ke folder Ultralytics |
| `ml/scripts/11_download_negatives.py` | Unduh foto objek bukan pakaian (COCO) |
| `ml/scripts/04_train_yolo11n.py` | Latih YOLOv11n-cls |
| `ml/scripts/05_eval_model1.py` | Evaluasi pada test set katalog |
| `ml/scripts/10_eval_field.py` | Evaluasi pada foto lapangan |
| `ml/scripts/14_threshold_sweep.py` | Validasi ambang confidence |
| `ml/scripts/06_export_tflite.py` | Ekspor TFLite int8 |
| `ml/scripts/12_run_model1_pipeline.py` | Jalankan semua tahap dengan satu perintah |
| `ml/label_maps/fashion_products_v3.csv` | Pemetaan 10 kelas (versi baru) |
| `ml/label_maps/fashion_products.csv` | Pemetaan pipeline lama, tidak diubah |
| `ml/notebooks/train_model1_hf_colab.ipynb` | Notebook Colab |
| `ml/reports/model1_test_*` | Laporan evaluasi test set |
| `ml/reports/model1_v3_*` | Kurva latihan, confusion matrix validasi, run log |
| `ml/reports/model1_v3_threshold_sweep.csv` | Hasil validasi ambang |
| `assets/models/yolo11n_cls.tflite` | Model yang dipakai aplikasi |
| `assets/models/labels.txt` | Urutan label model di aplikasi |

---

## 3. Alur

```
negatives/ (COCO atau foto sendiri)
        │
        ▼
11_download_negatives.py  ──► 800 jpg
        │
        ▼
13_prepare_hf.py  ──► ml/data/processed/model1/{train,val,test}/<kelas>/
        │              metadata.csv
        ▼
04_train_yolo11n.py  ──► ml/runs/model1_hf_v3/weights/best.pt
        │
        ├──► 05_eval_model1.py  ──► ml/reports/model1_test_*
        ├──► 14_threshold_sweep.py ──► ml/reports/model1_v3_threshold_sweep.csv
        ├──► 10_eval_field.py   ──► ml/reports/field_test_*
        ▼
06_export_tflite.py  ──► assets/models/model1_yolo11n_v3.tflite
        │
        ▼
assets/models/yolo11n_cls.tflite + labels.txt  ──► APK
```

---

## 4. Dataset dan label

### 4.1 Sumber

| Sumber | Isi | Lisensi |
|---|---|---|
| `ashraq/fashion-product-images-small` | Katalog pakaian, cermin Kaggle Fashion Product Images (Small) | MIT |
| `detection-datasets/coco` | Foto objek sehari-hari untuk kelas `other` | Anotasi CC BY 4.0, gambar Flickr CC |
| Foto sendiri (opsional) | Objek bukan pakaian | Bebas |

Catatan lisensi: COCO bukan CC0/MIT. Pemakaiannya harus disetujui tim dan
dicantumkan atribusinya. Karena itu pipeline tidak mengunduh COCO otomatis,
kecuali dengan opsi `--download-coco`.

### 4.2 Pemetaan kelas

File `ml/label_maps/fashion_products_v3.csv`:

| Label dataset | Kelas model |
|---|---|
| Tshirts, Tops | tshirt |
| Shirts | shirt |
| Sweatshirts, Sweaters | long_sleeve |
| Jackets, Blazers, Rain Jacket | outerwear |
| Trousers, Jeans, Track Pants, Jeggings | long_pants |
| Shorts | shorts |
| Skirts | skirt |
| Dresses | dress |
| Sandal dan sepatu | shoes |

Pemetaan ini sengaja dipisah dari `fashion_products.csv` agar pipeline lama
(`01_prepare_model1.py`) tetap memakai pemetaan aslinya. Pada pemetaan lama,
`Sweatshirts` dan `Sweaters` masuk `outerwear`.

### 4.3 Pemetaan ke database aplikasi

| Kelas model | Label di `labels.txt` | Jenis di database |
|---|---|---|
| long_pants | pants | pants |
| long_sleeve | longsleeve | longsleeve |
| outerwear | outwear | outwear |
| tshirt | t_shirt | t_shirt |
| other | other | tidak disimpan |

Tanpa pemetaan ini, penyimpanan ke lemari gagal karena foreign key
`wardrobe_item.garment_type` mengacu ke `ref_garment_type`.

### 4.4 Split

- 70 persen train, 15 persen val, 15 persen test.
- Stratified per kelas dan per sumber.
- Deduplikasi MD5 mencegah gambar identik di train dan test.
- Foto negatif dibagi acak tanpa stratify karena jumlahnya sedikit.

---

## 5. `13_prepare_hf.py` — penjelasan per baris

File ini adalah inti penyiapan dataset. Total 279 baris.

### 5.1 Docstring dan import (baris 1-46)

| Baris | Isi | Penjelasan |
|---|---|---|
| 1-3 | `""" Sera-Z — E4.1/E4.2 ...` | Docstring: tujuan skrip. |
| 4-11 | Struktur folder hasil | Menjelaskan `train/ val/ test/` dan `metadata.csv`. |
| 13-15 | Penjelasan `--negatives` | Kelas `other` membuat model bisa menolak objek bukan pakaian. |
| 17-23 | Contoh folder negatif | Foto bebas, tanpa subfolder. |
| 25-30 | Contoh perintah | `--dry-run`, `--force`, `--negatives`, `--limit`, `--out`. |
| 32-34 | Catatan dataset | HF adalah port dari Kaggle, bukan dataset baru. |
| 36 | `from __future__ import annotations` | Agar anotasi tipe `dict[str, str]` aman di Python lama. |
| 38-42 | `argparse`, `hashlib`, `io`, `shutil`, `Path` | CLI, hash MD5, buffer gambar, hapus folder, path. |
| 44-46 | `pandas`, `train_test_split`, `tqdm` | Tabel data, split, progress bar. |

### 5.2 Konstanta (baris 48-58)

| Baris | Isi | Penjelasan |
|---|---|---|
| 48 | `ROOT = Path(__file__).resolve().parents[2]` | Naik dari `ml/scripts/` ke root repo. |
| 49 | `LABEL_MAPS = ROOT / "ml" / "label_maps"` | Lokasi kamus label. |
| 50 | `DEFAULT_OUT = .../processed/model1` | Folder hasil default. |
| 51 | `DEFAULT_REPO = "ashraq/..."` | Dataset default. |
| 53 | `SEED = 42` | Agar split dan sampling bisa diulang. |
| 54 | `MIN_PER_CLASS = 5` | Kelas dengan sampel kurang dari 5 dibuang. |
| 55 | `GENDERS = ("Men", "Women", "Unisex")` | Pakaian anak dan gender lain disaring. |
| 56 | `SOURCE = "fashion_products_hf"` | Penanda asal data di metadata. |
| 57 | `NEGATIVE_CLASS = "other"` | Nama kelas negatif. |
| 58 | `IMG_EXT = {...}` | Ekstensi gambar yang diterima. |

### 5.3 `load_mapping` (baris 61-68)

| Baris | Isi | Penjelasan |
|---|---|---|
| 61 | `def load_mapping(name: str)` | Menerima nama file kamus. |
| 62-66 | Docstring | Menjelaskan pemisahan dari kamus pipeline lama. |
| 67 | `pd.read_csv(LABEL_MAPS / name)` | Baca CSV. |
| 68 | `return dict(zip(...))` | Ubah dua kolom menjadi kamus `label mentah -> kelas`. |

### 5.4 `build_index` (baris 71-79)

| Baris | Isi | Penjelasan |
|---|---|---|
| 71 | `def build_index(repo_id: str)` | Ambil metadata dataset. |
| 72 | Docstring | Tanpa mendekode gambar agar cepat. |
| 73 | `from datasets import load_dataset` | Import lokal agar skrip tetap bisa dipakai untuk fungsi lain tanpa `datasets`. |
| 75 | `print(...)` | Info unduhan parquet. |
| 76 | `ds = load_dataset(repo_id, split="train")` | Muat split train. |
| 77 | `select_columns(["id","gender","articleType"])` | Hanya tiga kolom yang dibutuhkan. |
| 78 | `reset_index().rename(... "row")` | Simpan indeks baris untuk mengambil gambar nanti. |
| 79 | `return meta` | Tabel metadata. |

### 5.5 `filter_and_split` (baris 82-120)

| Baris | Isi | Penjelasan |
|---|---|---|
| 82-84 | Definisi fungsi | Input metadata, kamus, rasio val/test, limit. |
| 85 | Docstring | Filter lalu split stratified. |
| 86-89 | `meta[articleType.isin(mapping) & gender.isin(GENDERS)]` | Buang label yang tidak dipetakan dan gender di luar daftar. |
| 90 | `df["target"] = map(mapping)` | Nama kelas model. |
| 91 | `df["source_label"]` | Label asli untuk audit. |
| 92 | `df["source"] = SOURCE` | Penanda sumber. |
| 93 | `df["src_path"] = None` | Penanda baris berasal dari HF, bukan file lokal. |
| 95 | `counts = groupby(...).transform("size")` | Hitung jumlah per kelas. |
| 96 | `dropped = (counts < MIN_PER_CLASS).sum()` | Hitung baris yang akan dibuang. |
| 97 | `df = df[counts >= MIN_PER_CLASS]` | Buang kelas terlalu kecil. |
| 98-99 | `print` | Laporan jumlah yang dibuang. |
| 101-105 | `--limit` | Sampling proporsional per kelas untuk uji cepat. |
| 107 | `sample(frac=1)` | Acak urutan sebelum split. |
| 109-111 | `train_test_split(... test_size=val+test, stratify=target)` | Pisahkan train dari gabungan val+test. |
| 112 | `rel_val = val_size / (val+test)` | Proporsi val di dalam sisa data. |
| 113-114 | Split kedua | Pisahkan val dan test. |
| 116-120 | `concat` | Gabungkan dengan kolom `split`. |

### 5.6 `load_negatives` (baris 123-153)

| Baris | Isi | Penjelasan |
|---|---|---|
| 123-124 | Definisi | Folder negatif dan rasio split. |
| 125 | Docstring | Kelas `other`. |
| 126 | `rglob("*")` filter ekstensi | Ambil semua gambar, termasuk subfolder. |
| 127-128 | Jika kosong | Berhenti dengan pesan jelas. |
| 130-137 | DataFrame negatif | Kolom `row=None`, `id`, `target=other`, `source=negatives`, `src_path`. |
| 139 | Komentar | Negatif sedikit, jadi tanpa stratify. |
| 140-144 | Split 70/15/15 | Sama seperti data pakaian. |
| 146-147 | Print jumlah | Laporan. |
| 149-153 | `concat` | Tambahkan kolom `split`. |

### 5.7 `image_bytes` (baris 156-172)

| Baris | Isi | Penjelasan |
|---|---|---|
| 156 | Definisi | Mengembalikan byte dan ekstensi, atau None. |
| 157 | Docstring | Mendukung dua sumber. |
| 158-163 | Jika `src_path` ada | Baca file langsung dari folder negatif. |
| 165-168 | Ambil `ds[row]["image"]` | Dekode gambar HF pada indeks baris. |
| 170-171 | `BytesIO` + `save JPEG quality=95` | Menyeragamkan format. |
| 172 | `return bytes, ".jpg"` | Hasil. |

### 5.8 `save_split` (baris 175-204)

| Baris | Isi | Penjelasan |
|---|---|---|
| 175-176 | Definisi | Dataset, tabel, folder output, set hash. |
| 177 | Docstring | Simpan per split, dedup MD5. |
| 178-179 | Inisialisasi | Daftar metadata dan penghitung duplikat. |
| 180 | `tqdm(df.itertuples())` | Iterasi baris dengan progress. |
| 181-184 | `image_bytes` | Ambil byte; lewati jika gagal. |
| 186 | `md5(data)` | Hash isi gambar. |
| 187-190 | Cek `seen_hashes` | Buang duplikat lintas split. |
| 192 | `fname = source_id.ext` | Nama unik. |
| 193-194 | Bentuk path | `out/split/kelas/nama.jpg`. |
| 195 | `write_bytes` | Simpan gambar. |
| 197-200 | Baris metadata | `split,target,source,source_label,file,orig_id`. |
| 202-203 | Print duplikat | Laporan. |
| 204 | `return rows` | Metadata untuk CSV. |

### 5.9 `main` (baris 207-279)

| Baris | Isi | Penjelasan |
|---|---|---|
| 208-209 | Parser | Deskripsi CLI. |
| 210 | `--repo-id` | Dataset HF. |
| 211-212 | `--out` | Folder hasil. |
| 213-214 | `--negatives` | Folder kelas `other`. |
| 215-217 | `--label-map` | Default `fashion_products_v3.csv` (10 kelas). |
| 218-219 | `--val`, `--test` | Rasio split. |
| 220-221 | `--limit` | Uji cepat. |
| 222-225 | `--force`, `--dry-run` | Timpa hasil atau hanya laporan. |
| 228-229 | Validasi rasio | Harus > 0 dan total < 1. |
| 231-236 | Cek folder output | Hapus jika `--force`, atau berhenti jika sudah ada. |
| 238 | `mapping = load_mapping(args.label_map)` | Muat kamus v3. |
| 239 | `meta = build_index(...)` | Ambil metadata. |
| 240 | Print total baris | Laporan. |
| 242 | `filter_and_split` | Hasil data pakaian dengan split. |
| 244-247 | Jika `--negatives` | Muat dan gabungkan kelas `other`. |
| 248-249 | Peringatan < 200 | Kelas `other` bisa lemah. |
| 250-252 | Tanpa negatif | Info bahwa model tidak bisa menolak objek. |
| 254-255 | Tabel jumlah | Cek kewarasan per split dan kelas. |
| 257-259 | `--dry-run` | Berhenti tanpa menyimpan. |
| 261-262 | Muat dataset penuh | Untuk mengambil gambar. |
| 264-269 | Loop split | Simpan train, val, test. |
| 271-272 | Tulis `metadata.csv` | Bukti dan kebutuhan evaluasi. |
| 273 | Total gambar | Laporan. |
| 274-275 | Perintah lanjutan | Menunjuk ke `04_train_yolo11n.py`. |
| 278-279 | Entry point | `main()`. |

---

## 6. `11_download_negatives.py` — penjelasan per bagian

| Baris | Isi | Penjelasan |
|---|---|---|
| 1-26 | Docstring | Tujuan, lisensi COCO, cara pakai, prasyarat. |
| 27-32 | Import | `argparse`, `Path`, `tqdm`. |
| 34-36 | Konstanta | Root, folder output, dataset COCO. |
| 38-65 | `KATEGORI_DALAM_RUANG` | Daftar kategori COCO yang relevan (laptop, meja, orang, botol, dll). |
| 68-75 | Docstring `nama_kategori` | Menangani perbedaan versi `datasets`. |
| 76-78 | Ambil `objects.category` | Jika kosong, kembalikan set kosong. |
| 79-80 | Jika sudah string | Langsung pakai. |
| 82-90 | Cari `ClassLabel` | Dukung `Sequence.feature` maupun dict. |
| 92-94 | `names` tidak ada | Kembalikan None agar foto diterima, bukan semua dibuang. |
| 95 | Konversi indeks | `names[c]` untuk int. |
| 99-118 | Argumen CLI | `--count`, `--out`, `--prefer-indoor`, `--exclude-person-only`, `--max-size`. |
| 120-121 | Validasi count | Harus > 0. |
| 123-124 | Buat folder | `mkdir(parents=True)`. |
| 126-131 | Cek hasil lama | Jika sudah cukup, berhenti agar tidak menimpa. |
| 133-136 | Import `datasets` | Pesan jika belum terpasang. |
| 138-139 | Load streaming | Tidak mengunduh seluruh COCO. |
| 141-143 | Loop | Penghitung dan progress. |
| 144 | Kategori baris | Untuk filter. |
| 146-148 | Buang foto hanya orang | Default aktif. |
| 149-155 | Filter indoor | Hanya jika kategori diketahui. |
| 157-160 | Validasi gambar | Minimal sisi 200 px. |
| 162-166 | Perkecil | Maksimal 640 px. |
| 168-171 | Simpan | Nama `coco_<image_id>.jpg`. |
| 169-170 | Lewati file ada | Idempoten. |
| 174-175 | Berhenti | Jika target tercapai. |
| 177-181 | Laporan | Jumlah, dilewati, perintah lanjutan. |

---

## 7. `14_threshold_sweep.py` — penjelasan per bagian

| Baris | Isi | Penjelasan |
|---|---|---|
| 1-19 | Docstring | Tujuan, cara pakai, output, prasyarat. |
| 20-26 | Import | `argparse`, `pandas`, `tqdm`. |
| 28-32 | Konstanta | Root, dataset, laporan, weights v3, nama kelas negatif. |
| 35-42 | Argumen | `--data`, `--weights`, `--out`, `--chunk`. |
| 44-49 | Validasi file | Metadata dan weights harus ada. |
| 51-54 | Import Ultralytics | Pesan jika belum ada. |
| 56-59 | Baca test | Filter `split == test`, cek file ada. |
| 60-61 | Test kosong | Berhenti. |
| 63-65 | Muat model | Daftar prediksi dan confidence. |
| 67-73 | Prediksi batch | `model.predict` per 64 gambar, simpan top1 dan confidence. |
| 76-77 | Tempel ke tabel | Kolom `pred` dan `conf`. |
| 79-80 | Pisah pakaian dan negatif | Berdasarkan label benar. |
| 82-104 | Loop ambang | 0,30 sampai 0,90 langkah 0,05. |
| 86-88 | Foto pakaian diterima | Prediksi bukan `other` dan confidence >= ambang. |
| 89-92 | Akurasi | Proporsi prediksi benar pada yang diterima. |
| 93 | Salah tolak | `1 - diterima/total pakaian`. |
| 94-97 | Penolakan negatif | Prediksi `other` atau confidence < ambang. |
| 98-104 | Simpan baris | Threshold, jumlah, akurasi, salah tolak, tolak benar. |
| 106-109 | Simpan CSV | Tabel ke `ml/reports`. |
| 111-120 | Pilih ambang | Syarat: negatif ditolak >= 95 persen dan pakaian salah tolak <= 10 persen. |
| 122-128 | Cetak | Ambang rekomendasi dan lokasi CSV. |

Hasil pada model v3:

| Ambang | Akurasi pakaian | Pakaian salah ditolak | Bukan pakaian ditolak |
|---:|---:|---:|---:|
| 0,50 | 97,08 persen | 0,63 persen | 100 persen |
| 0,60 | 97,77 persen | 1,95 persen | 100 persen |
| 0,70 | 98,27 persen | 3,11 persen | 100 persen |

Ambang final di aplikasi: 0,50.

---

## 8. `10_eval_field.py` — penjelasan per bagian

| Baris | Isi | Penjelasan |
|---|---|---|
| 1-34 | Docstring | Struktur folder foto lapangan dan perintah. |
| 35-48 | Import | `matplotlib`, `numpy`, `pandas`, `PIL`, metrik sklearn. |
| 50-57 | Konstanta | Root, laporan, weights, folder field, ukuran 224. |
| 60-79 | `preprocess` | Meniru aplikasi: resize sisi pendek, center crop, RGB ke BGR. |
| 65-68 | Buka gambar | Kembalikan None jika rusak. |
| 70-72 | Resize | Skala berdasarkan sisi pendek. |
| 74-76 | Crop tengah | 224 x 224. |
| 78-79 | Array BGR | Ultralytics membaca numpy sebagai BGR. |
| 82-97 | `kumpulkan` | Nama folder teratas = label benar. |
| 100-106 | Argumen | `--weights`, `--field`, `--reject-below` default 0,50. |
| 108-116 | Validasi | Weights ada, Ultralytics terpasang. |
| 118-120 | Baca foto | Print jumlah per kelas. |
| 122-127 | Validasi nama folder | Peringatan jika folder tidak dikenal model. |
| 131-147 | Prediksi per foto | Preprocess, `predict`, simpan prediksi dan confidence. |
| 149-150 | Foto rusak | Laporan. |
| 152-156 | Tandai ditolak | `pred == other` atau confidence < ambang. Simpan CSV per gambar. |
| 158-166 | Evaluasi negatif | Hitung tingkat penolakan objek. |
| 168-181 | Evaluasi pakaian | Akurasi hanya pada yang tidak ditolak, plus salah tolak. |
| 183-195 | Classification report | Simpan confusion matrix. |
| 197-203 | Per kelas | Akurasi dan jumlah ditolak. |
| 205-228 | Simpan laporan | `field_test_report.txt` dan `field_test_summary.json`. |

---

## 9. `12_run_model1_pipeline.py` — penjelasan per bagian

| Baris | Isi | Penjelasan |
|---|---|---|
| 1-31 | Docstring | Urutan tahap dan opsi. |
| 32-46 | Import dan path | Root, scripts, data, runs, assets. |
| 48-57 | `DEPENDENSI` | Modul dan nama paket pip. |
| 60-71 | `cek_dependensi` | Berhenti dengan perintah pip yang tepat. |
| 74-90 | `cek_perangkat` | Turunkan ke CPU jika CUDA tidak ada. |
| 93-99 | `jalankan` | Jalankan script lain lewat `subprocess`, berhenti jika gagal. |
| 102-105 | `jumlah_foto` | Hitung file di folder. |
| 108-129 | Argumen | Device, epoch, batch, imgsz, workers, nama, negatif, finetune, skip. |
| 132-133 | Cek dependensi dan device | Sebelum mulai. |
| 136-150 | Tahap 1: negatif | Pakai folder yang ada; COCO hanya jika `--download-coco`. |
| 153-160 | Tahap 2: prepare | Panggil `13_prepare_hf.py --force`, tambah `--negatives` jika ada. |
| 162-163 | Cek dataset | Berhenti jika `--skip-prepare` tanpa dataset. |
| 166-197 | Tahap 3: latih | Finetune dari `best.pt` terbaru atau mulai dari ImageNet. |
| 199-209 | Cari best.pt | Jika nama run tidak ada, pakai yang terbaru. |
| 212-213 | Tahap 4: eval | `05_eval_model1.py`. |
| 216-219 | Tahap 5: foto lapangan | Hanya jika ada minimal 20 foto. |
| 222-239 | Tahap 6: ekspor | Dilewati di Windows; di Linux/Colab menjalankan `06_export_tflite.py`. |

---

## 10. Perubahan pada `04`, `05`, `06`

### `04_train_yolo11n.py`

| Baris | Perubahan | Alasan |
|---|---|---|
| 22-34 | `sanity_check(data)` | Menerima folder dataset apa pun, bukan hanya `model1`. |
| 45-46 | `--workers` | Di Colab 2 vCPU, `workers=8` terlalu berat. |
| 47-48 | `--lr0` | Fine-tuning dari `best.pt` butuh learning rate 0,001. |
| 51-52 | `--data` | Menunjuk dataset hasil `13_prepare_hf.py`. |
| 62 | `sanity_check(Path(args.data))` | Cek folder yang diberikan. |
| 67 | `data=args.data` | Ultralytics memakai folder itu. |
| 72 | `workers=args.workers` | DataLoader sesuai perangkat. |
| 80-81 | `lr0` opsional | Hanya dikirim jika diisi. |
| 94-97 | Pesan checkpoint | Menunjuk ke `best.pt` dan `05_eval`. |

### `05_eval_model1.py`

| Baris | Perubahan | Alasan |
|---|---|---|
| 52-53 | `--data` | Evaluasi dataset mana pun. |
| 73 | `model.val(data=str(data))` | Ultralytics memakai folder yang diberikan. |
| 79-81 | `metadata.csv` dari `data` | Test set mengikuti dataset. |

### `06_export_tflite.py`

| Baris | Perubahan | Alasan |
|---|---|---|
| 24-26 | `--data` | Data kalibrasi int8 bisa dari dataset mana pun. |
| 45-46 | `model.export(..., data=args.data)` | Kuantisasi memakai data yang benar. |
| 80-83 | Jumlah kelas dinamis | Tidak lagi hardcode 9 kelas; mengikuti output model. |

---

## 11. Perintah lengkap

### 11.1 Unduh negatif

```bash
# Foto sendiri (disarankan)
# taruh di ml/data/raw/negatives/

# Atau COCO bila disetujui
python ml/scripts/11_download_negatives.py --count 800
```

### 11.2 Siapkan dataset

```bash
python ml/scripts/13_prepare_hf.py \
    --force \
    --negatives ml/data/raw/negatives
```

Default memakai `fashion_products_v3.csv`. Untuk pipeline lama:

```bash
python ml/scripts/13_prepare_hf.py --label-map fashion_products.csv
```

### 11.3 Latih

```bash
python ml/scripts/04_train_yolo11n.py \
    --data ml/data/processed/model1 \
    --epochs 30 --imgsz 224 --batch 64 \
    --workers 2 --device 0 --name model1_hf_v3
```

### 11.4 Evaluasi

```bash
python ml/scripts/05_eval_model1.py \
    --data ml/data/processed/model1 \
    --weights ml/runs/model1_hf_v3/weights/best.pt
```

### 11.5 Validasi ambang

```bash
python ml/scripts/14_threshold_sweep.py \
    --weights ml/runs/model1_hf_v3/weights/best.pt
```

### 11.6 Ekspor TFLite

```bash
python ml/scripts/06_export_tflite.py \
    --data ml/data/processed/model1 \
    --weights ml/runs/model1_hf_v3/weights/best.pt \
    --out-name model1_yolo11n_v3.tflite
```

### 11.7 Semua sekaligus

```bash
python ml/scripts/12_run_model1_pipeline.py \
    --device 0 --epochs 30 --name model1_hf_v3
```

---

## 12. Hasil

| Metrik | Nilai |
|---|---:|
| Akurasi test | 96,88 persen |
| Macro F1 | 88,24 persen |
| Jumlah test | 3.460 |
| `other` ditolak | 120/120 (100 persen) |
| Ukuran TFLite | 1,76 MB |

Per kelas:

| Kelas | F1 | Support |
|---|---:|---:|
| dress | 0,821 | 57 |
| long_pants | 0,991 | 212 |
| long_sleeve | 0,758 | 84 |
| other | 1,000 | 120 |
| outerwear | 0,687 | 40 |
| shirt | 0,959 | 407 |
| shoes | 1,000 | 1.275 |
| shorts | 0,926 | 66 |
| skirt | 0,714 | 15 |
| tshirt | 0,969 | 1.184 |

Bukti:

- `ml/reports/model1_test_report.txt`
- `ml/reports/model1_test_summary.json`
- `ml/reports/model1_test_confusion_matrix.png`
- `ml/reports/model1_v3_run_log.md`
- `ml/reports/model1-v3-card.md`

---

## 13. Integrasi ke aplikasi

1. Salin `model1_yolo11n_v3.tflite` menimpa `assets/models/yolo11n_cls.tflite`.
2. Pastikan `assets/models/labels.txt` berisi 10 label sesuai database:

```
dress
pants
longsleeve
other
outwear
shirt
shoes
shorts
skirt
t_shirt
```

3. Build ulang:

```powershell
flutter clean
flutter pub get
flutter run
```

4. Konstanta di `lib/services/outfit_engine.dart`:

```dart
const String notGarmentType = 'other';
const double minimumGarmentConfidence = 0.50;
```

`other` ditolak lewat kelas, confidence rendah ditolak lewat ambang.

---

## 14. Troubleshooting

| Gejala | Penyebab | Solusi |
|---|---|---|
| `Jumlah output model (10) tidak sama dengan jumlah label (9/15)` | Model dan `labels.txt` tidak cocok | Samakan jumlah dan urutan label |
| `Library datasets belum terpasang` | Dependensi kurang | `pip install datasets==4.8.5` |
| `Tidak ada gambar di .../negatives` | Folder kosong | Unduh atau isi foto sendiri |
| `metadata.csv tidak ada` | Prepare belum selesai | Jalankan `13_prepare_hf.py` sampai selesai |
| Ekspor TFLite gagal di Windows | Ultralytics 8.4 | Jalankan di Colab/Linux |
| `AttributeError: 'dict' object has no attribute 'feature'` | Perbedaan versi `datasets` | Gunakan `11_download_negatives.py` versi terbaru atau pin `datasets==4.8.5` |
| Simpan ke lemari gagal | Label tidak sesuai database | Gunakan `t_shirt`, `pants`, `longsleeve`, `outwear` |

---

## 15. Keterbatasan

1. Dataset utama adalah katalog yang sama dengan pipeline lama, bukan dataset
   baru sepenuhnya. Yang baru adalah kelas `other` dan pemetaan `long_sleeve`.
2. `long_sleeve` hanya sekitar 500 gambar; F1 0,758.
3. `outerwear` menyusut karena `Sweatshirts` dan `Sweaters` dipindah ke
   `long_sleeve`; F1 0,687.
4. Uji foto lapangan 150 foto belum dijalankan.
5. Model mengklasifikasikan seluruh gambar, bukan memberi kotak pembatas.
6. COCO bukan CC0/MIT; pemakaiannya harus disetujui dan diberi atribusi.
7. Model int8 dapat sedikit berbeda dari model float di perangkat.
