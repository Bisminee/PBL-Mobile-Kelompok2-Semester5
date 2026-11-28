# Riset Style dan Dataset (M6.5a)

Diperbarui: 28 November 2026
PIC: Abim Mustawa
Branch: `ml/style-research`
Status: riset selesai, taksonomi diusulkan, belum ada pelatihan model

## 1. Ringkasan keputusan

1. Taksonomi style yang dipakai produk diusulkan tetap 9 label yang sudah ada
   di UI: `casual`, `minimalist`, `vintage`, `streetwear`, `preppy`, `elegant`,
   `commuter`, `sporty`, dan `feminine`. `unspecified` tetap menjadi fallback
   tampilan, bukan kelas model.
2. Rekomendasi utama: **tetap memakai lookup `ml_style`** pada M6.5b. Belum ada
   satu pun citra berlabel style di repositori, sehingga classifier citra belum
   bisa dilatih atau dievaluasi secara jujur.
3. Sebelum lookup dipakai dengan model 9 kelas, empat kunci jenis harus
   dinormalisasi. Tanpa itu, style untuk `long_pants`, `long_sleeve`,
   `outerwear`, dan `tshirt` akan kosong setelah M1.2 dipasang.
4. Tidak ada model final yang dilatih pada tahap ini. Keputusan pindah ke
   classifier citra ditunda sampai dataset berlabel tersedia.

## 2. Taksonomi style

| Label | Arti operasional | Contoh isyarat |
|---|---|---|
| `casual` | Santai untuk pemakaian sehari-hari | kaos, denim, sneakers |
| `minimalist` | Potongan sederhana, warna netral, sedikit detail | monokrom, tanpa motif |
| `vintage` | Gaya era lama | potongan retro, wash lama |
| `streetwear` | Urban dan kasual tegas | oversized, logo, sneakers |
| `preppy` | Rapi bernuansa akademik | kemeja, blazer, polo |
| `elegant` | Sopan dan berkesan mewah | dress, bahan jatuh, aksen halus |
| `commuter` | Rapi untuk kerja dan perjalanan harian | kemeja, celana rapi, blazer |
| `sporty` | Aktif atau bernuansa olahraga | jersey, training, sepatu lari |
| `feminine` | Siluet dan detail feminin | floral, rok, aksen lembut |
| `unspecified` | Fallback saat lookup tidak menemukan baris | tampil sebagai "Umum" |

Label di atas sudah sama dengan `styleValues` di
`lib/models/garment_labels.dart`. Tidak ada label baru yang perlu ditambahkan
ke UI.

Catatan: beberapa label saling tumpang tindih (`casual` dengan `minimalist`,
`elegant` dengan `commuter`). Satu pakaian bisa masuk lebih dari satu style.
Karena itu keluaran yang disarankan adalah top-3 beserta probabilitas, bukan
satu label tunggal. UI saat ini baru menampilkan `topStyle`; ini batasan produk,
bukan batasan data.

## 3. Sumber label yang tersedia

Satu-satunya label style di repositori adalah tabel `ml_style` di
`assets/db/fashion_app.db`. Tabel ini berisi prediksi siap pakai, bukan label
per citra.

| Item | Nilai |
|---|---:|
| Baris | 4.788 |
| Kombinasi unik (`garment_type`, `color_family`, `gender`, `age_group`) | 1.596 |
| Baris per kombinasi | 3 (top-3 style) |
| Jenis pakaian | 19 |
| Keluarga warna | 14 |
| Gender | 3 (`male`, `female`, `unisex`) |
| Kelompok usia | 2 (`adult`, `child`) |
| Label style | 9 |
| Rata-rata probabilitas top-1 | 0,505 |

Sebaran baris per label:

| Style | Baris | Porsi |
|---|---:|---:|
| streetwear | 808 | 16,88 persen |
| minimalist | 750 | 15,66 persen |
| casual | 730 | 15,25 persen |
| sporty | 652 | 13,62 persen |
| vintage | 617 | 12,89 persen |
| feminine | 400 | 8,35 persen |
| elegant | 341 | 7,12 persen |
| commuter | 289 | 6,04 persen |
| preppy | 201 | 4,20 persen |

Sebaran top-1 per kombinasi:

| Style | Kombinasi | Porsi |
|---|---:|---:|
| casual | 304 | 19,05 persen |
| sporty | 281 | 17,61 persen |
| streetwear | 237 | 14,85 persen |
| feminine | 194 | 12,16 persen |
| minimalist | 160 | 10,03 persen |
| vintage | 145 | 9,09 persen |
| commuter | 109 | 6,83 persen |
| preppy | 101 | 6,33 persen |
| elegant | 65 | 4,07 persen |

Cara mengulang pengukuran:

```sql
SELECT style, COUNT(*) FROM ml_style GROUP BY style ORDER BY COUNT(*) DESC;
```

Catatan pemakaian: 2.394 baris (50 persen) memakai `age_group = 'child'`,
tetapi `OutfitEngine.analyze` selalu memakai `age = 'adult'` dan provider tidak
mengirim usia. Separuh tabel saat ini tidak pernah dibaca. Jika mode anak tidak
direncanakan, baris child bisa dibuang pada M6.5b agar tabel lebih kecil.

Temuan provenance: tidak ada script pembuat `ml_style` di repositori dan tidak
ada metadata sumber di tabel. Angka di atas dapat diukur ulang, tetapi asal
labelnya tidak dapat ditelusuri. M6.5b perlu mencatat provenance sebelum
mengklaim baseline style.

## 4. Ketersediaan data citra berlabel

| Sumber | Status | Jumlah citra berlabel style |
|---|---|---:|
| Repositori ini | Tidak ada | 0 |
| `ml/data/` lokal | Diabaikan Git; tidak ada di mesin ini | Tidak terukur |
| Fashion Product Images (Small) | Kandidat, metadata `usage` | Belum diukur |

Dataset Fashion Product Images sudah dipakai untuk Model 1 dan metadata-nya
memuat kolom `usage` (misalnya Casual, Sports, Formal, Ethnic, Smart Casual,
Party). Kolom itu tidak sama dengan 9 label produk dan hanya bisa memetakan
sebagian label (`casual`, `sporty`, `commuter`, `elegant`). Label produk juga
tidak selalu sama dengan style visual.

Karena `ml/data/` tidak ada di repositori, jumlah citra per label belum bisa
dihitung sekarang. Angka 0 di tabel berarti belum ada label yang tersedia untuk
dipakai, bukan berarti dataset tidak pernah ada.

## 5. Kompatibilitas lookup dengan model 9 kelas

Ini temuan paling penting untuk M6.5b dan M6.5c.

`ml_style` memakai kosakata 19 jenis pakaian lama. Model 9 kelas memakai
kosakata berikut:

| Kelas model 9 | Kunci di `ml_style` | Status |
|---|---|---|
| dress | dress | cocok |
| shirt | shirt | cocok |
| shoes | shoes | cocok |
| shorts | shorts | cocok |
| skirt | skirt | cocok |
| long_pants | pants | berbeda |
| long_sleeve | longsleeve | berbeda |
| outerwear | outwear | berbeda |
| tshirt | t_shirt | berbeda |

Hanya 5 dari 9 kelas yang punya kunci sama persis. Setelah M1.2 memasang model
9 kelas, `LocalDb.predictStyles` akan mengembalikan daftar kosong untuk empat
kelas lainnya. Akibatnya `Detection.styles` kosong dan UI menampilkan style "-".
Bug ini belum terlihat sekarang karena aset aplikasi masih memakai model lama
15 kelas yang kosakatanya cocok dengan tabel.

Perbaikan yang diusulkan: normalisasi kunci di satu tempat sebelum query, dengan
alias berikut.

```text
long_pants  -> pants
long_sleeve -> longsleeve
outerwear   -> outwear
tshirt      -> t_shirt
```

Normalisasi ini harus menjadi bagian M6.5b dan diuji untuk kesembilan kelas.
`garment_labels.dart` tidak boleh diubah menjadi kosakata ganda; cukup tambahkan
satu fungsi alias yang dipakai `predictStyles`.

## 6. Perbandingan lookup dan classifier citra

| Aspek | Lookup `ml_style` | Classifier citra |
|---|---|---|
| Data latih | Sudah ada, 4.788 baris | 0 citra berlabel |
| Pelatihan | Tidak perlu | Perlu | 
| Keluaran | Top-3 style dan probabilitas | Probabilitas per kelas |
| Isyarat visual | Tidak ada; hanya jenis, warna, gender, usia | Ada |
| Ukuran model | 0 MB tambahan | Perlu aset dan loader baru |
| Latensi | Query SQLite, di bawah 10 ms | Perlu inferensi gambar |
| Risiko utama | Label tidak telusur dan kosakata tidak cocok | Tidak bisa dievaluasi tanpa data |
| Status | Layak dipakai sekarang | Belum layak |

Opsi hybrid (classifier bila confidence tinggi, lookup sebagai fallback) baru
masuk akal setelah classifier punya data uji. Jangan dikerjakan di M6.5b.

## 7. Rekomendasi untuk M6.5b

1. Setujui taksonomi 9 label di bagian 2 sebagai taksonomi resmi.
2. Tambahkan normalisasi kunci di bagian 5 dan unit test untuk 9 kelas.
3. Evaluasi lookup pada data nyata: minimal 100 foto pakaian dari perangkat,
   dengan label style manual. Laporkan top-1 dan top-3 accuracy serta macro F1.
4. Jika macro F1 lookup di bawah 70 persen, jangan langsung melatih classifier.
   Kumpulkan dulu dataset berlabel. Keputusan tetap memakai lookup dicatat
   sebagai keputusan eksplisit sesuai ambang M6.5b.
5. Classifier citra baru dikerjakan jika tersedia minimal 300 citra berlabel per
   kelas (2.700 citra untuk 9 kelas) dengan taksonomi yang sama. Di bawah itu,
   hasil tidak layak diklaim sebagai model final.
6. Simpan keluaran sebagai top-3, bukan satu label, agar label yang tumpang
   tindih tidak dipaksa menjadi satu jawaban.

## 8. Rencana split bila classifier dikerjakan

| Aturan | Nilai |
|---|---|
| Pembagian | 70 persen train, 15 persen validasi, 15 persen test |
| Pengelompokan | Berdasarkan ID produk, bukan nama berkas |
| Kebocoran | Satu ID produk hanya boleh muncul di satu split |
| Stratifikasi | Per label style dan per sumber dataset |
| Deduplikasi | Hash persepsi sebelum split |
| Seed | 42 |
| Pencatatan | Jumlah per label, sumber, dan lisensi ditulis di laporan |

Split belum dijalankan karena belum ada citra berlabel.

## 9. Batas kerja dan serah terima

| Penerima | Yang diserahkan |
|---|---|
| Bisma | Taksonomi 9 label, temuan ketidakcocokan 4 kunci, usulan normalisasi |
| Falah | Dampak M1.2 terhadap style dan slot; kesembilan kelas harus diuji setelah model baru dipasang |

Yang tidak dikerjakan di branch ini: pelatihan model, ekspor TFLite, perubahan
kode aplikasi, dan penyalinan dataset. Branch ini hanya berisi dokumen keputusan
agar taksonomi disetujui sebelum M6.5b dimulai.
