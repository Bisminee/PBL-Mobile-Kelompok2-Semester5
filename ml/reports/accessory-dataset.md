# Riset Dataset Aksesoris

Disusun: 9 November 2026 (pembagian tugas minggu 11, branch `ml/accessory-dataset`).

Status: riset saja. Dataset aksesoris **belum** masuk pelatihan minggu ini.

Semua angka hitungan lokal di dokumen ini bisa diulang dengan:

```powershell
python ml/scripts/count_accessory_dataset.py
python ml/scripts/count_accessory_dataset.py --openimages-dir <folder berkas Open Images>
```

Keluarannya disimpan di `ml/reports/accessory_counts.json`. Opsi
`--openimages-dir` menunjuk folder berisi
`oidv7-class-descriptions-boxable.csv`, `validation-annotations-bbox.csv`, dan
`test-annotations-bbox.csv`.

## 1. Tujuan dan batasan

Model 1 saat ini mengenali 9 kelas pakaian. Aksesoris (tas, jam tangan,
kacamata, sabuk, topi, perhiasan) dibuang oleh `01_prepare_model1.py`. Dokumen
ini menilai sumber data yang bisa dipakai bila aksesoris ditambahkan nanti.

Kriteria pemilihan, sesuai kebijakan lisensi di `ml/README.md`:

1. Lisensi mengizinkan pemakaian di luar riset non-komersial (CC0, MIT, CC BY,
   atau setara).
2. Jumlah gambar per kelas cukup, target minimal sekitar 300 gambar per kelas
   untuk latih, validasi, dan uji.
3. Domain gambar dekat dengan foto pengguna (satu barang, latar sederhana) atau
   bisa dipotong per objek.
4. Mudah diunduh dan diproses ulang dengan pipeline yang sudah ada.

## 2. Ringkasan sumber

| Dataset | Lisensi | Gambar aksesoris | Domain | Status |
|---|---|---:|---|---|
| Fashion Product Images (Small) | MIT | 11.244 (dewasa) | Foto produk, latar putih | Direkomendasikan, utama |
| Clothing Dataset Full | CC0 1.0 | 161 (Hat, dewasa) | Foto barang di lantai/gantungan | Pelengkap kelas topi |
| Open Images V7 | Anotasi CC BY 4.0; gambar CC BY 2.0 per gambar | lihat bagian 3.3 | Foto dunia nyata, perlu crop bbox | Cadangan, untuk variasi |
| Fashionpedia | Per gambar; sekitar 69 persen non-komersial | lihat bagian 3.4 | Foto orang memakai | Hanya subset berlisensi bebas |
| ModaNet | Anotasi CC BY-NC 4.0 | 13 kategori termasuk bag, belt, sunglasses, headwear | Foto jalanan | Tidak dipakai |
| DeepFashion2 | Non-komersial | - | Foto orang | Tidak dipakai (sudah dikecualikan) |

## 3. Rincian per sumber

### 3.1 Fashion Product Images (Small)

- Sumber: Kaggle `paramaggarwal/fashion-product-images-small`, oleh Param Aggarwal.
- Lisensi: MIT. Dicek lewat API Kaggle (`licenseNameNullable: "MIT"`) pada
  9 November 2026. Lisensi di halaman Kaggle bisa berubah; cek ulang dan catat
  tanggalnya saat data benar-benar diunduh atau dipakai untuk pelatihan.
- Sudah ada di `ml/data/raw/fashion-products/`, jadi tidak perlu unduhan baru.
- Dihitung dari `styles.csv` lokal, `masterCategory == Accessories`, gender
  Men/Women/Unisex, dan berkas gambarnya ada. Sebagian `productDisplayName`
  memuat koma, jadi baris dipisah pada 9 koma pertama. Versi sebelumnya dokumen
  ini menulis 11.229 karena memakai pandas dengan `on_bad_lines="skip"`, yang
  diam-diam membuang 15 baris aksesoris tersebut. `01_prepare_model1.py` memakai
  cara baca yang sama, jadi pipeline saat ini juga hanya melihat 11.229; ini
  perlu diperbaiki bila aksesoris jadi ditambahkan.

| subCategory | Gambar | Catatan |
|---|---:|---|
| Bags | 3.053 | Handbags 1.757, Backpacks 720, Clutches 289, lainnya |
| Watches | 2.518 | |
| Jewellery | 1.079 | Earrings, pendant, necklace, ring, bangle; 94 persen Women |
| Eyewear | 1.070 | Semuanya Sunglasses |
| Wallets | 933 | |
| Belts | 811 | |
| Socks | 685 | |
| Headwear | 291 | Sebagian besar Caps |
| Ties | 258 | |
| Lainnya | 546 | Scarves, cufflinks, stoles, mufflers, gloves, dan lain-lain |
| **Total** | **11.244** | |

Kelebihan: lisensi jelas, jumlah besar, format sama dengan data Model 1 sehingga
`label_maps/fashion_products.csv` cukup diperluas.

Kekurangan: semua foto produk dengan latar putih. Data Model 1 sudah 66,9
persen dari sumber ini, jadi menambah aksesoris dari sumber yang sama
memperbesar dominasinya (mitigasi di bagian 4.1). Headwear hanya 291 gambar.

### 3.2 Clothing Dataset Full

- Sumber: Kaggle `agrigorev/clothing-dataset-full`.
- Lisensi: CC0 1.0 (Public Domain). Dicek lewat API Kaggle pada 9 November 2026;
  cek ulang saat unduh.
- Sudah ada di `ml/data/raw/clothing-full/`.
- Satu-satunya label aksesoris: `Hat`, 171 baris, 161 setelah membuang `kids`.

Berguna untuk menambah topi dengan foto bergaya pengguna (bukan foto studio).

### 3.3 Open Images V7

- Sumber: Google, `storage.googleapis.com/openimages`.
- Lisensi: anotasi CC BY 4.0. Gambar dari Flickr dan dicantumkan sebagai
  CC BY 2.0, tetapi Google menyatakan tidak menjamin status lisensi tiap
  gambar. Atribusi per gambar wajib dicatat, dan lisensi tiap gambar perlu
  dicek ulang dari metadata (kolom `License` pada berkas
  `*-images-with-rotation.csv`) saat diunduh.
- Kelas aksesoris yang ada, dicek ulang oleh script pada berkas
  `oidv7-class-descriptions-boxable.csv` (601 kelas): Handbag, Backpack, Belt,
  Glasses, Sunglasses, Hat, Sun hat, Fedora, Cowboy hat, Watch, Necklace,
  Scarf, Tie, Glove, Fashion accessory (`/m/0463sg`), Briefcase. Semua 16 kelas
  ditemukan.
- Jumlah gambar berisi kotak objek, dihitung dari berkas anotasi bbox split
  validasi dan uji (split latih 2,2 GB belum dihitung, jumlahnya jauh lebih
  besar):

| Kelas | Validasi | Uji |
|---|---:|---:|
| Handbag | 61 | 198 |
| Backpack | 24 | 74 |
| Belt | 11 | 33 |
| Glasses | 258 | 819 |
| Sunglasses | 134 | 439 |
| Hat (tanpa subtipe) | 145 | 393 |
| Watch | 29 | 90 |
| Necklace | 56 | 160 |
| Scarf | 26 | 83 |
| Tie | 97 | 320 |
| Sun hat | 60 | 254 |
| Fedora | 67 | 213 |
| Cowboy hat | 40 | 160 |
| Glove | 49 | 142 |
| Briefcase | 5 | 17 |
| Fashion accessory | 999 | 3.014 |

"Fashion accessory" adalah kelas induk yang luas. Isinya campuran dan perlu
diperiksa manual sebelum dipakai; jangan langsung dipetakan ke satu kelas usulan.

Kelebihan: foto dunia nyata, cocok untuk menguji ketahanan model.

Kekurangan: objek sering kecil dan dipakai orang, sehingga perlu dipotong dari
bbox dan disaring menurut ukuran. Belt dan Watch sedikit. Pengunduhan per kelas
paling mudah lewat FiftyOne atau `downloader.py` resmi.

### 3.4 Fashionpedia

- Sumber: `fashionpedia.github.io`, di-host CVDF.
- Kategori aksesoris: glasses, hat, headband, tie, glove, watch, belt,
  bag/wallet, scarf, umbrella, sock, tights.
- Lisensi **per gambar**. Dari berkas `instances_attributes_val2020.json`
  (1.158 gambar):

| Lisensi | Proporsi |
|---|---:|
| CC BY-NC-ND 2.0 | 54,6 persen |
| CC BY 2.0 | 13,2 persen |
| CC BY-NC 2.0 | 9,9 persen |
| CC BY-SA 2.0 | 6,4 persen |
| Unsplash | 6,0 persen |
| CC BY-NC-SA 2.0 | 4,8 persen |
| Pexels | 2,3 persen |
| CC BY-ND 2.0 | 2,2 persen |
| Burst dan freestocks | 0,6 persen |

Sekitar 69 persen non-komersial. Hanya 355 dari 1.158 gambar (31 persen) yang
berlisensi bebas. Gambar CC BY-ND juga perlu dihindari karena hasil crop
termasuk turunan.

Jumlah objek aksesoris pada split validasi: bag/wallet 205 gambar, belt 159,
glasses 130, headband 105, watch 82, hat 74, scarf 48.

Kesimpulan: dapat dipakai hanya bila difilter per gambar menurut field
`license`, dan jumlahnya setelah filter kecil.

### 3.5 ModaNet dan DeepFashion2

- ModaNet: anotasi CC BY-NC 4.0 di atas gambar PaperDoll; repositori eBay sudah
  diarsipkan. Non-komersial, jadi tidak dipakai.
- DeepFashion2: hanya untuk riset non-komersial. Sudah tercantum di daftar
  dataset yang tidak dipakai pada `ml/README.md`.

## 4. Rekomendasi

1. **Sumber utama: Fashion Product Images (Small).** Data sudah ada di lokal,
   lisensinya MIT, dan jumlahnya cukup. Usulan kelas awal dan jumlahnya
   (pemetaan `articleType` ada di `CLASS_MAP` pada script hitung):

| Kelas usulan | Fashion Product Images | Clothing Dataset Full | Total | articleType |
|---|---:|---:|---:|---|
| `bag` | 3.989 | - | 3.989 | Handbags, Backpacks, Clutches, Duffel Bag, Laptop Bag, Messenger Bag, Mobile Pouch, Rucksacks, Waist Pouch, Wallets |
| `watch` | 2.518 | - | 2.518 | Watches |
| `eyewear` | 1.070 | - | 1.070 | Sunglasses |
| `belt` | 810 | - | 810 | Belts |
| `hat` | 284 | 161 | 445 | Caps, Hat (Headband tidak ikut) |

   Kelas `bag` hampir 9 kali `hat`, jadi perlu dibatasi atau diseimbangkan
   lewat `02_balance_train.py` sebelum dilatih.
2. **Topi diperkuat dengan Clothing Dataset Full** (161 gambar CC0) supaya kelas
   `hat` tidak hanya foto studio.
3. **Open Images V7 dipakai sebagai set uji ketahanan**, bukan data latih
   utama, dengan crop dari bbox, ukuran minimal objek, dan berkas atribusi
   (ImageID, URL, author) di `ml/reports/`.
4. **Jangan memakai ModaNet dan DeepFashion2.** Fashionpedia hanya boleh dipakai
   setelah difilter ke lisensi CC BY, CC BY-SA, Unsplash, Pexels, Burst, dan
   freestocks.
5. **Perhiasan ditunda.** Objeknya kecil dan 94 persen berlabel Women, sehingga
   rawan bias dan sulit dikenali dari foto ponsel.
6. **Cek ulang lisensi saat unduh.** Lisensi di atas dicek pada 9 November
   2026. Saat data diunduh atau dipakai untuk pelatihan, periksa lagi lisensi
   tiap sumber (dan lisensi per gambar untuk Open Images dan Fashionpedia), lalu
   catat tanggal dan hasilnya di `ml/reports/`.

### 4.1 Mitigasi dominasi Fashion Product Images

Data Model 1 sudah 66,9 persen dari Fashion Product Images. Bila aksesoris juga
diambil dari sumber ini, model makin terbiasa dengan foto studio latar putih
dan bisa gagal pada foto pengguna. Mitigasi yang diusulkan:

1. **Batasi jumlah per kelas** dari Fashion Product Images (misalnya maksimal
   sekitar 800 gambar per kelas aksesoris) agar `bag` dan `watch` tidak
   membanjiri data.
2. **Tambah foto non-studio** untuk tiap kelas: crop Open Images dari bbox,
   subset Fashionpedia berlisensi bebas, dan Clothing Dataset Full untuk topi.
3. **Augmentasi latar**: ganti latar putih dengan latar acak atau tekstur
   (random crop, perubahan warna, tempel ke latar foto lantai/kasur) supaya
   model tidak belajar "latar putih berarti aksesoris".
4. **Evaluasi per sumber**: pakai pola `05_eval_model1.py` yang sudah memecah
   metrik per sumber, dan jadikan akurasi pada set uji non-studio (Open Images)
   sebagai syarat lulus, bukan hanya akurasi keseluruhan.
5. **Uji dengan foto ponsel tim** (beberapa puluh foto aksesoris nyata) sebelum
   model dipakai di aplikasi.

## 5. Dampak ke aplikasi dan langkah berikut

- Menambah kelas berarti `labels.txt`, urutan kelas, dan ekspor TFLite berubah.
  Urutan 9 kelas yang sekarang wajib tetap; kelas baru ditambahkan di belakang
  atau dibuat model terpisah.
- Mesin rekomendasi perlu aturan untuk aksesoris karena Model 3 hanya menilai
  pasangan atasan dan bawahan.
- Langkah berikut yang diusulkan:
  1. Diskusikan dengan tim apakah aksesoris masuk Model 1 atau model terpisah.
  2. Perluas `ml/label_maps/fashion_products.csv` dan `clothing_full.csv`.
  3. Siapkan skrip unduh Open Images per kelas beserta atribusi.
  4. Latih dan evaluasi pada minggu berikutnya.

## 6. Sumber

- Kaggle API: `https://www.kaggle.com/api/v1/datasets/view/paramaggarwal/fashion-product-images-small`
  dan `.../agrigorev/clothing-dataset-full` (field `licenseNameNullable`).
- Open Images: `https://storage.googleapis.com/openimages/web/index.html`,
  `https://github.com/openimages/dataset`, berkas
  `oidv7-class-descriptions-boxable.csv`, `validation-annotations-bbox.csv`,
  `test-annotations-bbox.csv`.
- Fashionpedia: `https://fashionpedia.github.io/home/Fashionpedia_download.html`,
  `https://github.com/cvdfoundation/fashionpedia`, berkas
  `instances_attributes_val2020.json`.
- ModaNet: `https://github.com/eBay/modanet`.
- Hitungan Fashion Product Images, Clothing Dataset Full, dan Open Images
  dihasilkan oleh `ml/scripts/count_accessory_dataset.py` dari berkas lokal
  `styles.csv`, `images.csv`, dan berkas anotasi Open Images di atas.
