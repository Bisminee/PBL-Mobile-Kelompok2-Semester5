# Arsitektur Sera-Z

Diperbarui: 10 November 2026 (branch `dev`, commit `b00b3e5`)

## 1. Lapisan

```
main.dart
  -> ProviderScope
       -> MaterialApp.router (AppTheme, appRouter)
            -> screens/  (satu folder per alur)
                 -> widgets/  (reusable, per layar + common/)
                      -> services/  (state dan logika)
                           -> models/  (data)
```

Aturan praktis:

- Widget tidak berisi logika bisnis atau akses data langsung.
- Logika yang bisa diuji tanpa widget ditaruh di `services/`.
- Widget lintas layar ditaruh di `widgets/common/`.
- Widget khusus satu layar tetap di `widgets/<layar>/`.
- Model ML dan database hanya diakses lewat `services/`, bukan dari widget.

## 2. Berkas kunci

| Berkas | Peran |
|---|---|
| `lib/main.dart` | Inisialisasi kamera, pemuat model ML, `ProviderScope`, router |
| `lib/config/app_router.dart` | Definisi `GoRouter` dan seluruh rute |
| `lib/config/app_routes.dart` | Konstanta path rute |
| `lib/config/app_theme.dart` | Tema Material 3 |
| `lib/config/app_colors.dart` | Palet warna UI |
| `lib/config/app_sizes.dart` | Spasi, radius, breakpoint responsif |
| `lib/config/app_text_styles.dart` | Gaya teks |
| `lib/models/garment.dart` | Item lemari: id, tipe, slot, warna, path foto, formalitas, style |
| `lib/models/outfit.dart` | Paduan atasan-bawahan, skor, alasan |
| `lib/models/saved_outfit.dart` | Outfit yang tersimpan di SQLite |
| `lib/services/providers.dart` | Provider auth, lemari, sesi scan, engine, rekomendasi, outfit tersimpan |
| `lib/services/garment_classifier.dart` | Preprocessing gambar dan inferensi Model 1 |
| `lib/services/outfit_engine.dart` | Analisis deteksi, preload skor pasangan, rekomendasi slot |
| `lib/services/color_extractor.dart` | Ekstraksi warna HSV dari piksel |
| `lib/services/color_palette.dart` | Pemetaan keluarga warna ke 14 nama palet |
| `lib/services/color_harmony.dart` | Aturan harmoni warna CIELCh |
| `lib/services/recommender.dart` | Pembentukan dan peringkat outfit, fallback aturan |
| `lib/services/local_db.dart` | SQLite: lemari, outfit, preferensi, tabel ML |
| `lib/services/photo_intake.dart` | Normalisasi foto dan penyimpanan sementara |
| `lib/services/photo_source.dart` | Pemilih foto galeri |
| `assets/models/yolo11n_cls.tflite` | Aset model yang dipakai aplikasi saat ini, 15 kelas |
| `assets/db/fashion_app.db` | Tabel `ml_formality`, `ml_style`, `ml_pair_score`, `catalog_item` |

## 3. Rute

| Konstanta | Path | Layar |
|---|---|---|
| `splash` | `/` | SplashScreen |
| `onboarding` | `/onboarding` | OnboardingScreen |
| `login` | `/login` | LoginScreen |
| `signup` | `/signup` | SignUpScreen |
| `profile` | `/profile` | ProfileScreen |
| `home` | `/home` | HomeScreen (shell) |
| `wardrobe` | `/wardrobe` | WardrobeScreen (shell) |
| `camera` | `/camera` | CameraScreen |
| `cameraPreview` | `/camera-preview` | CameraPreviewScreen, butuh `PreviewArgs` |
| `cropPhoto` | `/crop-photo` | CropScreen, butuh `CropArgs` |
| `analyzing` | `/analyzing` | AnalyzingScreen |
| `detectionResult` | `/detection-result` | DetectionResultScreen |
| `recommendation` | `/recommendation` | RecommendationScreen |
| `savedOutfits` | `/saved-outfits` | SavedOutfitsScreen |
| `detail` | `/detail` | DetailScreen |
| `clothingDetail` | `/clothing-detail` | ClothingDetailScreen |

`home` dan `wardrobe` memakai `StatefulShellRoute.indexedStack` dengan
`MainShell`, sehingga state tiap tab terjaga.

## 4. State saat ini

| Provider | Tipe | Isi sekarang |
|---|---|---|
| `authProvider` | `NotifierProvider<AuthNotifier, AppUser?>` | Profil dari Firebase Auth |
| `wardrobeProvider` | `NotifierProvider<WardrobeNotifier, List<Garment>>` | Item dari SQLite |
| `scanSessionProvider` | `NotifierProvider<ScanSessionNotifier, ScanSession>` | Foto, sumber, hasil deteksi, error |
| `engineProvider` | `Provider<OutfitEngine?>` | Engine ML yang dimuat saat start, null bila gagal |
| `recommendationsProvider` | `Provider<List<Outfit>>` | Outfit dari skor pasangan dan aturan |
| `savedOutfitsProvider` | `FutureProvider<List<SavedOutfit>>` | Outfit tersimpan dari SQLite |
| `genderProvider` | `NotifierProvider<GenderNotifier, String>` | Preferensi gender untuk lookup ML |
| `photoPickerProvider` | `Provider<PhotoPicker>` | Pemilih galeri, bisa diganti saat test |

Alur data nyata:

- `wardrobeProvider` memuat item dari `wardrobe_item`.
- `recommendationsProvider` memakai `engineProvider`; bila null, memakai
  `buildRuleOutfits`.
- `scanSessionProvider` menyimpan hasil `OutfitEngine.analyze`.

## 5. Integrasi ML saat ini

Urutan saat aplikasi dibuka:

1. `main.dart` memuat `GarmentClassifier` dari `assets/models/yolo11n_cls.tflite`.
2. `OutfitEngine` dibuat dan `preload()` membaca sekitar 51 ribu skor pasangan.
3. `engineProvider` di-override dengan engine tersebut.
4. Bila gagal, engine null dan rekomendasi memakai aturan.

Urutan saat foto dianalisis:

1. Foto dari kamera atau galeri dinormalisasi di `photo_intake.dart`.
2. `preprocessForModel` membakar EXIF, resize sisi pendek 224, crop tengah,
   menyusun tensor NCHW, dan membagi piksel dengan 255.
3. `GarmentClassifier.predictInput` menjalankan TFLite dan mengambil top-3.
4. `extractColor` menghitung warna dominan dengan HSV.
5. `LocalDb.predictFormality` dan `predictStyles` membaca tabel ML.
6. `Detection` dibentuk, lalu disimpan ke lemari bila pengguna menyetujui.

Urutan saat outfit dicocokkan:

1. `recommendationsProvider` mengambil atasan dan bawahan.
2. `buildOutfits` mencari skor pasangan di `ml_pair_score`.
3. Skor diubah menjadi persentil dan digabung dengan harmoni serta formalitas.
4. Bila engine tidak tersedia, `buildRuleOutfits` memakai harmoni.

## 6. Komponen ML dan batas tugas

| Kode | Komponen | Sifat | Status |
|---|---|---|---|
| T1 | Klasifikasi jenis pakaian | Model terlatih | Model 9 kelas selesai; aset aplikasi masih 15 kelas |
| T2 | Ekstraksi warna | Aturan atau unsupervised | HSV dan palet 14 selesai; K-Means Dart belum |
| T3 | Kombinasi warna | Model terlatih atau aturan | MLP sintetis; aplikasi memakai tabel dan aturan |
| T4 | Penolakan non-cloth | Kelas tambahan atau gate | PR #32; TFLite v3 belum valid |

Arahan dosen 10 November 2026: T1 memakai satu dataset, T3 dipisah dari T1.
Keputusan dataset dan bentuk T4 belum final.

## 7. Keterbatasan integrasi saat ini

1. Aset aplikasi 15 kelas, bukan model latihan 9 kelas.
2. Model latihan memakai input NHWC, sedangkan kode menyusun NCHW.
3. Label model latihan dan kosakata database berbeda.
4. Model v3 10 kelas ada di PR #32, tetapi TFLite gagal pada uji preprocessing
   aplikasi: 3 dari 270 foto benar.
5. Tidak ada test integrasi inferensi TFLite.
6. Preload 51 ribu skor dilakukan sebelum `runApp`, berpotensi memperlambat start.

## 8. Responsif

- Breakpoint dan lebar maksimum konten ada di `app_sizes.dart` dan
  `widgets/common/responsive.dart`.
- Layar harus aman di 360 dp dan 800 dp.
- Konten panjang harus bisa di-scroll.
- Detail memakai tab pinned; hindari `Column` tanpa scroll.

## 9. Test

| Berkas | Cakupan |
|---|---|
| `test/color_harmony_test.dart` | Aturan harmoni warna, 17 test |
| `test/color_extractor_test.dart` | Enam warna dasar |
| `test/color_palette_test.dart` | Palet 14 warna, 5 test |
| `test/recommender_test.dart` | Pembentukan outfit, 8 test |
| `test/outfit_detail_test.dart` | Tab detail outfit, 9 test |
| `test/camera_preview_test.dart` | Pratinjau kamera dan galeri |
| `test/photo_intake_test.dart` | Normalisasi foto |
| `test/image_crop_test.dart` | Crop dan rotasi |
| `test/home_summary_test.dart` | Ringkasan kategori Home |
| `test/widget_test.dart` | Smoke test aplikasi |

Total `dev`: 80 test lulus. Test belum mencakup inferensi TFLite di perangkat.
Test baru wajib menyertai logika baru yang bisa diuji tanpa widget.
