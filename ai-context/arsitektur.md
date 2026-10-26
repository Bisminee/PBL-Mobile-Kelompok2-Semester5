# Arsitektur Sera-Z

## 1. Lapisan

```
main.dart
  └─ ProviderScope
       └─ MaterialApp.router (AppTheme, appRouter)
            └─ screens/  (satu folder per alur)
                 └─ widgets/  (reusable, per layar + common/)
                      └─ services/  (state dan logika)
                           └─ models/  (data)
```

Aturan praktis:

- Widget tidak boleh berisi logika bisnis atau akses data langsung.
- Logika yang bisa diuji tanpa widget ditaruh di `services/` (contoh:
  `color_harmony.dart`).
- Widget yang dipakai lebih dari satu layar ditaruh di `widgets/common/`.
- Widget khusus satu layar tetap di `widgets/<layar>/`.

## 2. Berkas kunci

| Berkas | Peran |
|---|---|
| `lib/main.dart` | Inisialisasi kamera, `ProviderScope`, `MaterialApp.router` |
| `lib/config/app_router.dart` | Definisi `GoRouter` dan seluruh rute |
| `lib/config/app_routes.dart` | Konstanta path rute |
| `lib/config/app_theme.dart` | Tema Material 3 |
| `lib/config/app_colors.dart` | Palet warna |
| `lib/config/app_sizes.dart` | Spasi, radius, breakpoint responsif |
| `lib/config/app_text_styles.dart` | Gaya teks (memakai `google_fonts`) |
| `lib/config/app_assets.dart` | Path aset gambar |
| `lib/models/garment.dart` | Item lemari: id, kategori, nama warna, nilai warna, path foto, gaya |
| `lib/models/outfit.dart` | Paduan atasan-bawahan + skor |
| `lib/services/providers.dart` | Provider Riverpod: auth, lemari, rekomendasi |
| `lib/services/camera_service.dart` | Inisialisasi dan kontrol kamera |
| `lib/services/color_harmony.dart` | Aturan harmoni warna (komplementer, analog, monokrom, netral) |
| `lib/services/recommender.dart` | Penyusun rekomendasi outfit (masih placeholder) |

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
| `cameraPreview` | `/camera-preview` | CameraPreviewScreen (butuh `extra` path gambar) |
| `analyzing` | `/analyzing` | AnalyzingScreen |
| `detectionResult` | `/detection-result` | DetectionResultScreen |
| `recommendation` | `/recommendation` | RecommendationScreen |
| `detail` | `/detail` | DetailScreen |
| `clothingDetail` | `/clothing-detail` | ClothingDetailScreen |

`home` dan `wardrobe` memakai `StatefulShellRoute.indexedStack` dengan
`MainShell`, sehingga state tiap tab terjaga.

## 4. State saat ini

| Provider | Tipe | Isi sekarang |
|---|---|---|
| `authProvider` | `NotifierProvider<AuthNotifier, AppUser?>` | Login palsu in-memory |
| `wardrobeProvider` | `NotifierProvider<WardrobeNotifier, List<Garment>>` | List kosong in-memory |
| `recommendationsProvider` | `Provider<List<Outfit>>` | Outfit placeholder dari item terakhir |

Belum ada lapisan data nyata. Rencana penggantian:

- `wardrobeProvider` → DAO `sqflite` (E2).
- `authProvider` → Firebase Auth + record `users`/`profiles` (E3).
- `recommendationsProvider` → skor MLP + aturan harmoni (E6, E7).

## 5. Rencana integrasi ML (E7)

1. `tflite_flutter` dimuat di isolate agar UI tidak tersendat.
2. Foto hasil kamera di-crop, lalu Model 1 mengisi jenis pakaian.
3. Modul 2 (K-Means Dart) mengisi nama warna dominan.
4. Model 3 memberi skor kecocokan; aturan harmoni menjadi penjelas dan fallback.
5. Atribut placeholder pada `Garment` diganti hasil nyata.

## 6. Responsif

- Breakpoint dan lebar maksimum konten ada di `app_sizes.dart` dan
  `widgets/common/responsive.dart`.
- Layar harus aman di layar kecil (overflow) dan lebar (konten tidak memanjang).
- Detail memakai tab pinned; hindari `Column` tanpa scroll pada konten panjang.

## 7. Test

| Berkas | Cakupan |
|---|---|
| `test/color_harmony_test.dart` | Aturan harmoni warna (17 test) |
| `test/widget_test.dart` | Smoke test aplikasi (splash tampil) |

Test baru wajib menyertai logika baru yang bisa diuji tanpa widget.
