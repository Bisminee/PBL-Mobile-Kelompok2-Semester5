# Panduan Kerja per Anggota — Sera-Z

Periode: **27 Oktober – 1 November 2026**
Cakupan: pembangunan mobile saja (E2, E3, E8.1, E8.2, E8.4, E8.6, E8.7)
Dijeda: E4, E5, E6, E7, E8.3, E8.5, E9, E10

> **CATATAN DARI BISMA**
>
> **JANGAN TAKUT SALAH PUSH, JANGAN TAKUT BIKIN KESALAHAN**
>
> **TAKUT KALAU KALIAN NGGAK ADA KONTRIBUSI DI GITHUB**

Dokumen ini menjelaskan, untuk setiap tugas: apa tujuannya, file apa yang dibuat,
langkah pengerjaannya, tugas siapa yang harus ditunggu, cara mengujinya, dan
kesalahan yang sering terjadi.

---

## 0. Aturan umum

### 0.1 Alur kerja harian

1. Pagi: `git switch dev`, `git pull`, lalu buat branch baru dari `dev`.
2. Kerjakan satu tugas saja sampai selesai.
3. `flutter analyze` dan `flutter test` sebelum commit.
4. Commit dengan awalan `feat:`, `fix:`, atau `test:`.
5. Push, buka PR ke `dev`, minta satu reviewer.
6. Setelah PR digabung, kabari grup dan perbarui status di papan Notion.
7. `main` hanya menerima penggabungan `dev` pada akhir milestone.

### 0.2 Branch: aturan dan daftar per tugas

Branch adalah ruang kerja terpisah untuk **satu tugas**. Tujuannya agar
pekerjaanmu tidak mengganggu pekerjaan orang lain dan mudah direview.

#### Aturan branch

1. **Satu tugas = satu branch = satu PR.** Jangan menggabungkan dua tugas dalam
   satu branch.
2. Branch selalu dibuat dari **`dev` terbaru**, bukan dari `main`, bukan dari
   branch anggota lain.
3. Nama branch menyebut **pekerjaan**, bukan nama orang.
4. Umur branch pendek, 1–3 hari. Setelah PR digabung, branch dihapus.
5. Pull Request mengarah ke **`dev`**. Jangan push langsung ke `dev` atau `main`.
6. Kalau tugas dipecah, branch-nya ikut dipecah. Contoh: E2.1 dan E2.2 memakai
   dua branch berbeda.
7. Jangan mencampur dua jenis pekerjaan. Branch database tidak boleh sekaligus
   mengubah tampilan.
8. Jangan membuat branch baru hanya untuk mengganti satu baris; gabungkan ke
   branch tugas yang sedang berjalan.

#### Awalan nama branch

| Awalan | Dipakai untuk | Contoh |
|---|---|---|
| `feat/` | Fitur atau kemampuan baru | `feat/wardrobe-crud` |
| `fix/` | Perbaikan bug | `fix/login-error` |
| `test/` | Menambah atau memperbaiki test | `test/dao` |
| `docs/` | Dokumentasi | `docs/readme-setup` |
| `chore/` | Perawatan kecil (paket, konfigurasi) | `chore/firebase-setup` |
| `ml/` | Pekerjaan model dan dataset (dijeda) | `ml/model1-pipeline` |
| `refactor/` | Merapikan struktur tanpa mengubah perilaku (harus disetujui tim) | `refactor/folder` |

Nama branch memakai huruf kecil dan tanda hubung. Contoh benar:
`feat/photo-storage`. Contoh salah: `Abim`, `branch-baru`, `coba`, `fix1`,
`feat/abim-kerjain-semua`.

#### Daftar branch yang harus dibuat

**Pras — penyimpanan**

| Branch | Untuk tugas | Isi perubahan | PR ke |
|---|---|---|---|
| `feat/sqflite-setup` | E2.1 setup DB | `pubspec.yaml`, `lib/services/database_helper.dart`, `test/database_test.dart` | `dev` |
| `feat/wardrobe-crud` | E2.2 CRUD lemari | `lib/services/wardrobe_dao.dart`, `toMap`/`fromMap` di `lib/models/garment.dart` | `dev` |
| `feat/photo-storage` | E2.3 simpan foto | `lib/services/photo_storage.dart`, `lib/screens/scan/camera_preview_screen.dart` | `dev` |

Catatan: branch `feat/sqflite-setup` yang ada sekarang berisi kode lama (24
commit di belakang `main`). Hapus dulu, lalu buat ulang dari `dev`.

**Ahmad — lanjutan penyimpanan**

| Branch | Untuk tugas | Isi perubahan | PR ke |
|---|---|---|---|
| `feat/outfit-tables` | E2.4 tabel outfit + riwayat | `lib/services/outfit_dao.dart` | `dev` |
| `feat/load-on-start` | E2.5 muat data saat start | `lib/services/providers.dart`, `lib/main.dart` | `dev` |
| `test/dao` | E2.6 unit test DAO | `test/wardrobe_dao_test.dart`, `test/outfit_dao_test.dart` | `dev` |

**Bisma — autentikasi**

| Branch | Untuk tugas | Isi perubahan | PR ke |
|---|---|---|---|
| `chore/firebase-setup` | Persiapan Firebase | `android/app/build.gradle.kts`, `.gitignore` (tanpa `google-services.json`) | `dev` |
| `feat/google-login` | E3.1 login Google | `lib/services/auth_service.dart`, `lib/screens/auth/login_screen.dart` | `dev` |
| `feat/cloud-profile` | E3.2 record cloud | `lib/services/user_repository.dart` | `dev` |
| `feat/session-persist` | E3.3 sesi persisten | `lib/services/providers.dart`, `lib/config/app_router.dart` | `dev` |
| `feat/sign-out` | E3.4 sign out + hapus akun | `lib/services/auth_service.dart`, `lib/screens/profile/profile_screen.dart` | `dev` |

**Izza — fitur lemari dan admin**

| Branch | Untuk tugas | Isi perubahan | PR ke |
|---|---|---|---|
| `feat/wardrobe-ui` | E8.1 CRUD UI Lemari | `lib/screens/wardrobe/wardrobe_screen.dart`, `lib/widgets/wardrobe/` | `dev` |
| `feat/admin-master-data` | E8.6 halaman Admin | `lib/screens/admin/admin_screen.dart`, `lib/services/master_data_dao.dart`, `lib/config/app_routes.dart`, `lib/config/app_router.dart` | `dev` |

**Abim — profil, outfit, Home**

| Branch | Untuk tugas | Isi perubahan | PR ke |
|---|---|---|---|
| `feat/profile-screen` | E8.7 halaman Profil | `lib/screens/profile/profile_screen.dart` | `dev` |
| `feat/save-outfit` | E8.2 simpan outfit | `lib/screens/outfit/recommendation_screen.dart`, `lib/screens/outfit/detail_screen.dart` | `dev` |
| `feat/home-content` | E8.4 konten Home | `lib/screens/home/home_screen.dart`, `lib/widgets/home/` | `dev` |

#### Branch yang tidak boleh dibuat

| Branch | Alasan |
|---|---|
| Nama orang (`abim`, `pras`, `bisma`) | Aturan repo: branch menyebut pekerjaan, bukan orang |
| `dev2`, `dev-baru`, `staging` | Hanya ada satu `dev` |
| `backup`, `cadangan`, `jangan-dihapus` | Hasil kerja harus masuk lewat PR, bukan disimpan di branch |
| `coba`, `tes`, `asdf` | Tidak jelas isinya dan sulit direview |
| Satu branch untuk semua tugas | Melanggar aturan satu tugas satu PR |

#### Cara membuat dan menutup branch

Membuat:

```bash
git switch dev
git pull origin dev
git switch -c feat/wardrobe-crud
git push -u origin feat/wardrobe-crud
```

Setelah PR digabung ke `dev`:

```bash
git switch dev
git pull origin dev
git branch -d feat/wardrobe-crud
git push origin --delete feat/wardrobe-crud
```

Kalau branch lama sudah usang dan akan dipakai lagi (seperti
`feat/sqflite-setup`), hapus lalu buat ulang:

```bash
git branch -D feat/sqflite-setup
git push origin --delete feat/sqflite-setup
git switch dev && git pull
git switch -c feat/sqflite-setup
```

### 0.3 Isi PR yang baik

- Judul: `feat: <ringkasan>`.
- Isi: apa yang berubah, cara menguji, tangkapan layar untuk perubahan UI.
- Wajib lulus `flutter analyze` dan `flutter test`.
- Reviewer minimal satu anggota lain.

### 0.4 Format laporan harian di grup

```
[Tanggal] [Nama]
Selesai: <tugas + hasil>
Sedang: <tugas>
Tertahan: <kalau ada, sebutkan siapa yang ditunggu>
Besok: <rencana>
```

---

## 1. Peta ketergantungan

```
E2.1 (Pras) ─┬─► E2.2 (Pras) ─┬─► E8.1 (Izza)
             │                └─► E2.5 (Ahmad) ─► E8.4 (Abim)
             ├─► E2.3 (Pras)
             ├─► E8.6 (Izza)
             └─► E2.4 (Ahmad) ─┬─► E2.5 (Ahmad)
                                ├─► E2.6 (Ahmad)
                                └─► E8.2 (Abim)

E3.1 (Bisma) ─┬─► E3.2 (Bisma)
              ├─► E3.3 (Bisma)
              └─► E3.4 (Bisma) ─► E8.7 (Abim)
```

Siapa menunggu siapa:

| Anggota | Menunggu | Untuk tugas |
|---|---|---|
| Pras | tidak ada | E2.1 bisa mulai hari ini |
| Ahmad | Pras (E2.1) | E2.4, E2.6 |
| Ahmad | Pras (E2.2) | E2.5 |
| Bisma | tidak ada | E3.1 bisa mulai hari ini |
| Izza | Pras (E2.1) | E8.6 |
| Izza | Pras (E2.2) | E8.1 |
| Abim | Bisma (E3.4) | E8.7 |
| Abim | Ahmad (E2.4) | E8.2 |
| Abim | Ahmad (E2.5) | E8.4 |

Catatan: Abim tidak punya prasyarat yang siap hari ini. Karena itu Abim mulai
dengan membangun tampilan statis (UI shell) untuk E8.7, E8.2, dan E8.4, lalu
menyambungkan data saat prasyarat selesai.

---

## 2. Faatihurrizki Prasojo (Pras) — pondasi penyimpanan (3,5 ho)

### 2.1 E2.1 Setup sqflite + helper DB (1,0 ho)

**Tujuan:** aplikasi punya database lokal supaya data lemari tidak hilang saat
aplikasi ditutup.

**Menunggu:** tidak ada. Ini tugas pertama yang harus selesai di tim.

**File yang dibuat:**

- `lib/services/database_helper.dart`
- `test/database_test.dart`

**Paket yang ditambahkan ke `pubspec.yaml`:**

```yaml
dependencies:
  sqflite: ^2.4.1
  path: ^1.9.1
  path_provider: ^2.1.5

dev_dependencies:
  sqflite_common_ffi: ^2.3.4
```

**Langkah:**

1. Tambahkan paket, lalu `flutter pub get`.
2. Buat `DatabaseHelper` dengan pola singleton:

```dart
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static const _dbName = 'sera_z.db';
  static const _dbVersion = 1;
  Database? _db;

  Future<Database> get database async =>
      _db ??= await _open();

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _createTables,
      onUpgrade: _upgrade,
    );
  }
  // ...
}
```

3. Buat skema awal:

```sql
CREATE TABLE wardrobe_items (
  id TEXT PRIMARY KEY,
  category TEXT NOT NULL,
  color_name TEXT NOT NULL,
  color_value INTEGER NOT NULL,
  image_path TEXT,
  style TEXT,
  created_at TEXT NOT NULL
);

CREATE TABLE outfits (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  subtitle TEXT,
  top_id TEXT NOT NULL REFERENCES wardrobe_items(id) ON DELETE CASCADE,
  bottom_id TEXT NOT NULL REFERENCES wardrobe_items(id) ON DELETE CASCADE,
  score REAL NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL
);

CREATE TABLE recommendation_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  outfit_id TEXT NOT NULL REFERENCES outfits(id) ON DELETE CASCADE,
  created_at TEXT NOT NULL
);
```

4. Siapkan `onUpgrade` dengan `switch (oldVersion)` agar versi berikutnya mudah
   ditambah. Versi 2 nanti dipakai Izza untuk tabel master data.
5. Buat test yang membuka database di memori memakai `sqflite_common_ffi`:

```dart
setUpAll(() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
});
```

**Kriteria selesai:** database terbuka, ketiga tabel ada, test pembuka database
lulus.

**Jebakan:**

- Jangan pakai `getDatabasesPath()` untuk menyimpan foto; itu untuk database.
  Foto memakai `getApplicationDocumentsDirectory()`.
- `PRAGMA foreign_keys = ON` harus dipanggil di `onConfigure`, bukan di
  `onCreate`.
- Jangan menaruh `google-services.json` atau file besar di folder aset.

**Membuka pekerjaan:** E2.2, E2.4, E8.6. Kabari grup segera setelah PR digabung.

### 2.2 E2.2 CRUD wardrobe_items (1,5 ho)

**Tujuan:** item lemari bisa ditambah, dibaca, diubah, dan dihapus.

**Menunggu:** E2.1 (diri sendiri).

**File:** `lib/services/wardrobe_dao.dart`, tambahan `toMap`/`fromMap` di
`lib/models/garment.dart`.

**Langkah:**

1. Tambahkan `toMap()` dan `fromMap()` pada `Garment`. Simpan warna sebagai
   integer (`color.toARGB32()`; bila analyzer menolak, gunakan `color.value`).
2. Buat DAO dengan empat fungsi: `insert`, `getAll`, `update`, `delete`.
3. Urutkan `getAll` dengan `created_at DESC` agar item terbaru muncul dulu.
4. Uji manual: tambah item, tutup aplikasi, buka lagi, item masih ada.

**Kriteria selesai:** item tetap ada setelah aplikasi ditutup dan dibuka kembali.

**Jebakan:** jangan menyimpan `Color` langsung; SQLite tidak mengenal tipe itu.

**Membuka pekerjaan:** E8.1 (Izza) dan E2.5 (Ahmad).

### 2.3 E2.3 Simpan foto (1,0 ho)

**Tujuan:** foto hasil kamera disalin ke folder aplikasi, database hanya menyimpan
path.

**Menunggu:** E2.1 (diri sendiri).

**File:** `lib/services/photo_storage.dart`, ubah
`lib/screens/scan/camera_preview_screen.dart`.

**Langkah:**

1. Ambil folder dengan `getApplicationDocumentsDirectory()`.
2. Buat subfolder `photos/` bila belum ada.
3. Salin file dari path kamera dengan nama unik (misal `DateTime.now().millisecondsSinceEpoch`).
4. Simpan path hasil salin ke database, bukan file aslinya.
5. Saat item dihapus, hapus juga file fotonya.

**Kriteria selesai:** foto tampil dari folder aplikasi setelah restart, dan
ukuran database tetap kecil.

**Jebakan:** path sementara dari kamera bisa hilang setelah aplikasi ditutup;
selalu salin dulu.

---

## 3. Ahmad Falahi — lanjutan penyimpanan (3,5 ho)

### 3.1 E2.4 Tabel outfits + recommendation_history (1,5 ho)

**Tujuan:** outfit yang disimpan pengguna dan riwayat rekomendasi tersimpan
permanen.

**Menunggu:** E2.1 (Pras). Mulai 28 Oktober.

**File:** `lib/services/outfit_dao.dart`.

**Langkah:**

1. Buat DAO: `insertOutfit`, `getSavedOutfits`, `deleteOutfit`,
   `logRecommendation`, `getHistory`.
2. Simpan relasi memakai `top_id` dan `bottom_id` (foreign key ke
   `wardrobe_items`).
3. Untuk riwayat, catat `outfit_id` dan waktu.
4. Uji: simpan outfit, tutup aplikasi, buka, daftar outfit masih ada.

**Kriteria selesai:** simpan dan daftar outfit serta riwayat berhasil.

**Membuka pekerjaan:** E8.2 (Abim).

### 3.2 E2.5 Muat data saat start (1,0 ho)

**Tujuan:** lemari dan riwayat langsung tampil ketika aplikasi dibuka.

**Menunggu:** E2.2 (Pras) dan E2.4 (diri sendiri).

**File:** `lib/services/providers.dart`, `lib/main.dart`.

**Langkah:**

1. Ubah `WardrobeNotifier` menjadi memuat data dari DAO. Pilihan paling sederhana:
   tambahkan `Future<void> load()` yang dipanggil sekali saat aplikasi mulai.
2. Panggil di `main()` setelah `WidgetsFlutterBinding.ensureInitialized()`.
3. Tampilkan indikator loading singkat di layar Lemari bila data belum siap.
4. Uji dengan cold start: tutup paksa aplikasi, buka lagi, data muncul.

**Kriteria selesai:** data muncul otomatis setelah cold start.

**Membuka pekerjaan:** E8.4 (Abim).

### 3.3 E2.6 Unit test DAO (1,0 ho)

**Tujuan:** lapisan database tidak mudah rusak saat kode diubah.

**Menunggu:** E2.2 dan E2.4 (Pras dan diri sendiri).

**File:** `test/wardrobe_dao_test.dart`, `test/outfit_dao_test.dart`.

**Langkah:**

1. Pakai `sqflite_common_ffi` seperti test E2.1.
2. Uji kasus: insert lalu getAll, update, delete, dan cascade delete foto/outfit.
3. Minimal 6 test.

**Kriteria selesai:** semua test lulus di `flutter test`.

---

## 4. Bisma Adhiaksa — autentikasi (5,0 ho)

### 4.1 Persiapan Firebase (lakukan 27 Oktober, sebelum E3.1)

**Menunggu:** tidak ada.

**Langkah:**

1. Buat proyek di Firebase Console.
2. Tambahkan aplikasi Android dengan package name `com.example.sera_z`
   (sesuai `android/app/build.gradle.kts`).
3. Unduh `google-services.json`, taruh di `android/app/`.
4. Tambahkan plugin `com.google.gms.google-services` di Gradle.
5. Pastikan `google-services.json` **tidak** di-commit (tambahkan ke
   `.gitignore` bila perlu).
6. Aktifkan metode login Google di Firebase Authentication.
7. Tambahkan SHA-1 debug ke Firebase (wajib untuk Google Sign-In).

**Jebakan:** tanpa SHA-1, Google Sign-In gagal dengan kode error 10.

### 4.2 E3.1 Login Google (2,0 ho)

**Tujuan:** pengguna bisa masuk memakai akun Google.

**Menunggu:** persiapan Firebase.

**Paket:** `firebase_core`, `firebase_auth`, `google_sign_in`.

**File:** `lib/services/auth_service.dart`, ubah `lib/screens/auth/login_screen.dart`.

**Langkah:**

1. Inisialisasi Firebase di `main()` sebelum `runApp`.
2. Buat `AuthService.signInWithGoogle()`:

```dart
final googleUser = await GoogleSignIn().signIn();
final googleAuth = await googleUser!.authentication;
final credential = GoogleAuthProvider.credential(
  accessToken: googleAuth.accessToken,
  idToken: googleAuth.idToken,
);
await FirebaseAuth.instance.signInWithCredential(credential);
```

3. Ganti pemanggilan `authProvider.notifier.signIn()` di layar login dengan
   `AuthService`.
4. Tampilkan pesan error yang jelas bila gagal.

**Kriteria selesai:** login Google berhasil di perangkat nyata, bukan hanya
emulator.

### 4.3 E3.2 Record cloud users + profiles (1,0 ho)

**Tujuan:** data pengguna dan profil terbentuk di cloud saat login pertama.

**Menunggu:** E3.1.

**Paket:** `cloud_firestore`.

**File:** `lib/services/user_repository.dart`.

**Langkah:**

1. Setelah login, baca `users/{uid}`.
2. Bila belum ada, buat dokumen `users/{uid}` berisi email, nama, dan waktu daftar.
3. Buat juga `profiles/{uid}` berisi nama tampilan, URL avatar, dan preferensi.
4. Jangan menimpa data lama setiap login; hanya buat bila belum ada.

**Kriteria selesai:** dokumen muncul di Firestore setelah login pertama.

### 4.4 E3.3 Sesi persisten (1,0 ho)

**Tujuan:** pengguna tidak perlu login ulang setiap membuka aplikasi.

**Menunggu:** E3.1.

**File:** `lib/services/providers.dart`, `lib/config/app_router.dart`.

**Langkah:**

1. Firebase Auth menyimpan sesi otomatis; yang perlu dilakukan adalah
   mendengarkan `authStateChanges()`.
2. Arahkan pengguna ke Home bila sudah login, ke Login bila belum.
3. Bila ingin menyimpan token tambahan, gunakan `flutter_secure_storage`,
   jangan `shared_preferences`.
4. Uji: login, tutup paksa aplikasi, buka lagi, masih login.

### 4.5 E3.4 Sign out + hapus akun (1,0 ho)

**Tujuan:** pengguna bisa keluar dan menghapus datanya.

**Menunggu:** E3.1.

**Langkah:**

1. `FirebaseAuth.instance.signOut()` dan `GoogleSignIn().signOut()`.
2. Bersihkan state lokal (lemari dan riwayat di memori), tetapi jangan hapus
   database kecuali pengguna memilih hapus akun.
3. Jalur hapus akun: konfirmasi, hapus dokumen Firestore, lalu hapus akun
   Firebase.
4. Setelah logout, arahkan ke layar Login.

**Membuka pekerjaan:** E8.7 (Abim).

---

## 5. Izza Dhafira Fanani — fitur lemari dan admin (4,0 ho)

### 5.1 E8.6 Halaman Admin master data (2,0 ho)

**Tujuan:** admin bisa mengelola daftar kategori pakaian dan nama warna.

**Menunggu:** E2.1 (Pras). Boleh mulai rancangan lebih dulu.

**File:** `lib/screens/admin/admin_screen.dart`,
`lib/services/master_data_dao.dart`,
`lib/services/providers.dart`, `lib/config/app_routes.dart`,
`lib/config/app_router.dart`.

**Langkah:**

1. Tambahkan tabel lewat migrasi versi 2 di `DatabaseHelper`:

```sql
CREATE TABLE master_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  kind TEXT NOT NULL
);

CREATE TABLE master_colors (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  hex TEXT NOT NULL
);
```

2. Isi data awal: Atasan, Bawahan, Luaran, Terusan, Alas kaki; dan 14 nama warna.
3. Buat layar admin dengan dua tab: Kategori dan Warna.
4. Tambahkan rute `/admin` di `app_routes.dart` dan `app_router.dart`.
5. Tambahkan tombol masuk ke admin dari halaman Profil (sementara).

**Kriteria selesai:** master data bisa ditambah, diubah, dan dihapus, dan
perubahan bertahan setelah restart.

**Jebakan:** koordinasi dengan Pras sebelum mengubah versi database. Jangan
membuat `DatabaseHelper` kedua.

### 5.2 E8.1 CRUD UI Lemari (2,0 ho)

**Tujuan:** layar Lemari memakai data nyata, bukan daftar contoh.

**Menunggu:** E2.2 (Pras).

**File:** `lib/screens/wardrobe/wardrobe_screen.dart`,
`lib/widgets/wardrobe/clothing_grid_card.dart` (bila perlu).

**Langkah:**

1. Saat ini `wardrobe_screen.dart` memakai daftar statis `_items`. Hapus daftar
   itu dan baca dari `wardrobeProvider`.
2. Tambahkan tombol tambah item yang membuka form (kategori, nama warna, foto).
3. Tambahkan aksi hapus dengan konfirmasi.
4. Pertahankan filter yang sudah ada (`Semua`, `Atasan`, `Bawahan`, `Sepatu`),
   tetapi ambil pilihan dari master data bila sudah ada.
5. Buat empty state: gambar, teks "Lemari masih kosong", dan tombol tambah.
6. Muat ulang daftar setelah tambah atau hapus.

**Kriteria selesai:** CRUD penuh berjalan dan data bertahan setelah restart.

**Jebakan:** jangan memanggil DAO langsung dari widget; lewat provider atau
controller.

---

## 6. Abim Mustawa — profil, outfit, Home (4,5 ho)

Semua tugas Abim menunggu orang lain. Mulai dengan tampilan statis, lalu
sambungkan data.

### 6.1 E8.7 Halaman Profil (1,5 ho)

**Tujuan:** halaman Profil menampilkan data pengguna dan bisa mengubah preferensi.

**Menunggu:** E3.4 (Bisma). UI bisa dibuat lebih dulu.

**File:** `lib/screens/profile/profile_screen.dart`.

**Langkah:**

1. Halaman sudah ada dan sudah memanggil `authProvider.notifier.signOut()`.
   Ganti sumber data ke `AuthService`/Firebase setelah Bisma selesai.
2. Tampilkan nama, email, dan avatar (gunakan inisial bila avatar kosong).
3. Tambahkan form ubah nama tampilan yang menulis ke `profiles/{uid}`.
4. Tambahkan preferensi sederhana (notifikasi, tema) yang disimpan lokal.
5. Pastikan tombol keluar benar-benar mengakhiri sesi.

**Kriteria selesai:** profil dapat diedit dan sign out bekerja.

### 6.2 E8.2 Simpan outfit (1,5 ho)

**Tujuan:** pengguna bisa menyimpan paduan outfit ke daftar "Outfit Tersimpan".

**Menunggu:** E2.4 (Ahmad).

**File:** `lib/screens/outfit/recommendation_screen.dart`,
`lib/screens/outfit/detail_screen.dart`,
`lib/screens/profile/profile_screen.dart` (daftar outfit).

**Langkah:**

1. Tambahkan tombol "Simpan Outfit" pada kartu rekomendasi dan halaman detail.
2. Panggil `outfitDao.insertOutfit(...)`.
3. Tampilkan snackbar konfirmasi.
4. Buat daftar outfit tersimpan (bisa di Profil atau tab Lemari).
5. Uji: simpan, tutup aplikasi, buka, outfit masih ada.

**Jebakan:** tombol simpan harus nonaktif bila outfit sudah tersimpan, agar
tidak ada duplikat.

### 6.3 E8.4 Konten Home (1,5 ho)

**Tujuan:** Home menampilkan data nyata: sapaan pengguna, item terbaru, dan
kategori cepat.

**Menunggu:** E2.5 (Ahmad).

**File:** `lib/screens/home/home_screen.dart`,
`lib/widgets/home/home_hero_banner.dart`.

**Langkah:**

1. Ganti data contoh dengan `wardrobeProvider` dan `authProvider`.
2. Tampilkan maksimal 4 item terbaru.
3. Kartu kategori menampilkan jumlah item per kategori.
4. Bila lemari kosong, tampilkan ajakan menambah item (bukan angka nol).
5. Pastikan tetap rapi di layar kecil (360 dp) dan lebar (800 dp).

**Kriteria selesai:** tidak ada lagi data placeholder di Home.

---

## 7. Ringkasan jadwal

| Hari | Pras | Ahmad | Bisma | Izza | Abim |
|---|---|---|---|---|---|
| Sel 27 | E2.1 | skema SQL | Firebase | rancangan E8.6 | UI statis E8.7 |
| Rab 28 | E2.2 | E2.4 | E3.1 | E8.6 | lanjut E8.7 |
| Kam 29 | E2.3 | E2.4 selesai | E3.2 | E8.6 selesai | E8.2 mulai |
| Jum 30 | review | E2.5 | E3.3 | E8.1 | E8.2 |
| Sab 31 | bantu E8.1 | E2.6 | E3.4 | E8.1 | E8.4 |
| Min 1 | rekap | rekap | uji auth | E8.1 selesai | E8.4 selesai |

---

## 8. Kalau selesai lebih cepat

Boleh mengambil tugas mobile lain yang belum selesai, dengan syarat:

1. Tetap maksimal 2 tugas aktif.
2. Prasyaratnya sudah selesai.
3. Kabari pemilik aslinya di grup agar tidak dobel.
4. Buat branch baru untuk tugas yang kamu ambil; jangan memakai branch orang
   lain dan jangan mengubah kodenya.

Urutan bantuan yang disarankan:

| Selesai duluan | Bisa membantu |
|---|---|
| Pras | E8.1 bagian filter, review PR Ahmad |
| Ahmad | E8.2, E8.4 |
| Bisma | E8.7 |
| Izza | E8.4 |
| Abim | review PR Pras dan Ahmad |

---

## 9. Kalau tertahan

1. Tulis di grup: tugas apa, tertahan oleh siapa, sudah berapa lama.
2. Bila lebih dari satu hari, lepas tugas dan ambil tugas lain yang siap.
3. Jangan mengerjakan tugas orang lain tanpa kabar.
4. Jangan mengubah kode di branch orang lain.

---

## 10. Yang belum boleh dikerjakan

E4, E5, E6, E7, E8.3, E8.5, E9, E10. Semua menunggu keputusan setelah mobile
selesai. Termasuk mengunduh dataset dan menulis rencana uji.
