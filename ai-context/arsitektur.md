# Arsitektur Sera-Z

Diperbarui: 23 November 2026 (setelah PR #59)

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
| `lib/services/providers.dart` | Provider auth, lemari, sesi scan, engine, rekomendasi per piece, outfit tersimpan |
| `lib/services/garment_classifier.dart` | Preprocessing gambar dan inferensi Model 1 |
| `lib/services/outfit_engine.dart` | Analisis deteksi, preload skor pasangan, rekomendasi slot |
| `lib/services/color_extractor.dart` | Ekstraksi warna HSV dari piksel |
| `lib/services/color_family.dart` | 16 keluarga warna, tone, netral, pencocokan Lab, harmoni |
| `lib/services/color_palette.dart` | Pemetaan keluarga warna ke nama palet tampilan |
| `lib/services/color_harmony.dart` | Aturan harmoni warna CIELCh |
| `lib/services/recommender.dart` | Rekomendasi per piece, peringkat outfit, fallback aturan |
| `lib/services/saved_outfit_actions.dart` | Menu tekan lama outfit: detail, edit, hapus |
| `lib/models/saved_outfit.dart` | Outfit tersimpan dan konversi ke layar detail |
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
| `recommendation` | `/recommendation` | RecommendationScreen, `extra` opsional berupa `Garment` |
| `recommendationHistory` | `/recommendation-history` | RecommendationHistoryScreen |
| `savedOutfits` | `/saved-outfits` | SavedOutfitsScreen |
| `detail` | `/detail` | DetailScreen, `extra` berupa `Outfit` |
| `clothingDetail` | `/clothing-detail` | ClothingDetailScreen, `?edit=1` membuka form edit |

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
| `recommendationGroupsProvider` | `Provider<List<RecommendationGroup>>` | Maksimal tiga outfit untuk setiap atasan/bawahan |
| `savedOutfitsProvider` | `FutureProvider<List<SavedOutfit>>` | Outfit tersimpan dari SQLite |
| `recommendationHistoryProvider` | `FutureProvider.autoDispose<List<SavedOutfit>>` | Riwayat rekomendasi yang dibuka |
| `genderProvider` | `NotifierProvider<GenderNotifier, String>` | Preferensi gender untuk lookup ML |
| `photoPickerProvider` | `Provider<PhotoPicker>` | Pemilih galeri, bisa diganti saat test |

Alur data nyata:

- `wardrobeProvider` memuat item dari `wardrobe_item`, mendukung tambah, edit
  atribut, dan hapus.
- `recommendationsProvider` memakai `engineProvider`; bila null, memakai
  `buildRuleOutfits`.
- `recommendationGroupsProvider` membentuk pasangan per piece. Outfit yang sudah
  tersimpan disaring di layar rekomendasi.
- `scanSessionProvider` menyimpan hasil `OutfitEngine.analyze` dan warna pilihan
  pengguna. Komposisi warna asli tidak dihapus saat warna diganti.
- `savedOutfitsProvider` dan `recommendationHistoryProvider` dibaca ulang
  setelah simpan, edit, atau hapus outfit.

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
6. `Detection` dibentuk. Pengguna dapat mengoreksi jenis, formalitas, dan warna.
7. Setelah disimpan, `WardrobeNotifier.addDetected` menyalin foto dan menulis
   `wardrobe_item`.
8. `WardrobeNotifier.update` dipakai oleh edit atribut tanpa mengganti foto.

Urutan saat outfit dicocokkan:

1. `recommendationGroupsProvider` mengambil setiap atasan dan bawahan.
2. `buildOutfitsForAnchor` mencari pasangan dan skor di `ml_pair_score`.
3. Skor diubah menjadi persentil dan digabung dengan harmoni serta formalitas.
4. Setiap piece mendapat maksimal tiga outfit.
5. Bila engine tidak tersedia, `buildRuleOutfitsForAnchor` memakai harmoni.
6. Layar menyaring outfit yang sudah tersimpan, lalu pengguna membuka detail
   dan menyimpan atau menghapusnya.

## 6. Komponen ML dan batas tugas

| Kode | Komponen | Sifat | Status |
|---|---|---|---|
| T1 | Klasifikasi jenis pakaian | Model terlatih | Model 9 kelas selesai; aset aplikasi masih 15 kelas |
| T2 | Ekstraksi warna | Aturan atau unsupervised | Acuan 16 keluarga selesai; ekstraksi piksel masih HSV; K-Means Dart belum |
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
7. Tabel ML masih 14 warna; `ref_color` sudah memiliki 16 warna untuk data
   pengguna.
8. Segmentasi pakaian belum ada; warna masih memakai crop tengah dan HSV.
9. Web belum bisa dikompilasi karena `tflite_flutter` dan `ffi`.

## 8. Responsif

- Breakpoint dan lebar maksimum konten ada di `app_sizes.dart` dan
  `widgets/common/responsive.dart`.
- Layar harus aman di 360 dp dan 800 dp.
- Konten panjang harus bisa di-scroll.
- Detail memakai tab pinned; hindari `Column` tanpa scroll.

## 9. Test

| Berkas | Cakupan |
|---|---|
| `test/color_harmony_test.dart` | Aturan harmoni warna |
| `test/color_family_test.dart` | 16 keluarga warna dan pencocokan Lab |
| `test/color_extractor_test.dart` | Warna dasar dari piksel |
| `test/color_palette_test.dart` | Nama palet tampilan |
| `test/recommender_test.dart` | Outfit, rekomendasi per piece, penyaringan tersimpan |
| `test/saved_outfit_test.dart` | Konversi outfit tersimpan ke detail |
| `test/saved_outfit_card_test.dart` | Tap dan tekan lama kartu outfit |
| `test/clothing_detail_test.dart` | Form edit atribut pakaian |
| `test/camera_preview_test.dart` | Pratinjau, crop, nama berkas, layar 320 px |
| `test/camera_overlay_test.dart` | Tombol flash |
| `test/local_db_test.dart` | DAO, migrasi, update atribut, hapus outfit |
| `test/outfit_detail_test.dart` | Tab detail outfit |
| `test/image_crop_test.dart` | Crop dan rotasi |
| `test/widget_test.dart` | Smoke test aplikasi |

Total: 135 test lulus. Test belum mencakup inferensi TFLite di perangkat.
Test baru wajib menyertai logika baru yang bisa diuji tanpa widget.
