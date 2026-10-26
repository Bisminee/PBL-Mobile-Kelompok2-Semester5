# Panduan Branch — Sera-Z

Dokumen ini mengatur branch apa yang harus dibuat saat mengerjakan tugas, kapan
dibuat, dari mana asalnya, dan kapan dihapus.

Berlaku untuk semua anggota. Ringkasan aturan juga ada di `README.md` bagian 3.

---

## 1. Prinsip

1. **Satu tugas = satu branch = satu PR.**
2. Branch dibuat dari **`main` terbaru**, bukan dari `dev`, bukan dari branch
   anggota lain.
3. Nama branch menyebut **pekerjaan**, bukan nama orang.
4. Branch berumur pendek, 1–3 hari. Setelah PR digabung, branch dihapus.
5. `main` selalu stabil. `dev` hanya untuk uji integrasi.
6. Jangan menggabungkan dua tugas berbeda dalam satu branch.
7. Jangan membuat branch baru hanya untuk satu baris perubahan; gabungkan ke
   branch tugas yang sedang berjalan.

---

## 2. Awalan nama branch

| Awalan | Dipakai untuk | Contoh |
|---|---|---|
| `feat/` | Fitur atau kemampuan baru | `feat/wardrobe-crud` |
| `fix/` | Perbaikan bug | `fix/login-error` |
| `test/` | Menambah atau memperbaiki test | `test/dao` |
| `docs/` | Dokumentasi | `docs/readme-setup` |
| `chore/` | Perawatan kecil (paket, konfigurasi) | `chore/firebase-setup` |
| `ml/` | Model dan dataset Python (dijeda) | `ml/model1-pipeline` |
| `refactor/` | Merapikan struktur tanpa mengubah perilaku (perlu persetujuan tim) | `refactor/folder` |

Aturan penulisan:

- Huruf kecil semua, kata dipisah tanda hubung.
- Bahasa Inggris singkat, karena mengikuti nama tugas di kode.
- Benar: `feat/photo-storage`, `fix/camera-overflow`.
- Salah: `Abim`, `branch-baru`, `coba`, `fix1`, `feat/abim-semua`.

---

## 3. Daftar branch per tugas

### Pras — penyimpanan

| Branch | Tugas | Isi perubahan | PR ke |
|---|---|---|---|
| `feat/sqflite-setup` | E2.1 setup DB | `pubspec.yaml`, `lib/services/database_helper.dart`, `test/database_test.dart` | `main` |
| `feat/wardrobe-crud` | E2.2 CRUD lemari | `lib/services/wardrobe_dao.dart`, `toMap`/`fromMap` di `lib/models/garment.dart` | `main` |
| `feat/photo-storage` | E2.3 simpan foto | `lib/services/photo_storage.dart`, `lib/screens/scan/camera_preview_screen.dart` | `main` |

Catatan: branch `feat/sqflite-setup` yang ada sekarang berisi kode lama (24
commit di belakang `main`). Hapus dulu, lalu buat ulang dari `main`.

### Ahmad — lanjutan penyimpanan

| Branch | Tugas | Isi perubahan | PR ke |
|---|---|---|---|
| `feat/outfit-tables` | E2.4 tabel outfit + riwayat | `lib/services/outfit_dao.dart` | `main` |
| `feat/load-on-start` | E2.5 muat data saat start | `lib/services/providers.dart`, `lib/main.dart` | `main` |
| `test/dao` | E2.6 unit test DAO | `test/wardrobe_dao_test.dart`, `test/outfit_dao_test.dart` | `main` |

### Bisma — autentikasi

| Branch | Tugas | Isi perubahan | PR ke |
|---|---|---|---|
| `chore/firebase-setup` | Persiapan Firebase | `android/app/build.gradle.kts`, `.gitignore` (tanpa `google-services.json`) | `main` |
| `feat/google-login` | E3.1 login Google | `lib/services/auth_service.dart`, `lib/screens/auth/login_screen.dart` | `main` |
| `feat/cloud-profile` | E3.2 record cloud | `lib/services/user_repository.dart` | `main` |
| `feat/session-persist` | E3.3 sesi persisten | `lib/services/providers.dart`, `lib/config/app_router.dart` | `main` |
| `feat/sign-out` | E3.4 sign out + hapus akun | `lib/services/auth_service.dart`, `lib/screens/profile/profile_screen.dart` | `main` |

### Izza — fitur lemari dan admin

| Branch | Tugas | Isi perubahan | PR ke |
|---|---|---|---|
| `feat/wardrobe-ui` | E8.1 CRUD UI Lemari | `lib/screens/wardrobe/wardrobe_screen.dart`, `lib/widgets/wardrobe/` | `main` |
| `feat/admin-master-data` | E8.6 halaman Admin | `lib/screens/admin/admin_screen.dart`, `lib/services/master_data_dao.dart`, `lib/config/app_routes.dart`, `lib/config/app_router.dart` | `main` |

### Abim — profil, outfit, Home

| Branch | Tugas | Isi perubahan | PR ke |
|---|---|---|---|
| `feat/profile-screen` | E8.7 halaman Profil | `lib/screens/profile/profile_screen.dart` | `main` |
| `feat/save-outfit` | E8.2 simpan outfit | `lib/screens/outfit/recommendation_screen.dart`, `lib/screens/outfit/detail_screen.dart` | `main` |
| `feat/home-content` | E8.4 konten Home | `lib/screens/home/home_screen.dart`, `lib/widgets/home/` | `main` |

---

## 4. Branch yang tidak boleh dibuat

| Branch | Alasan |
|---|---|
| Nama orang (`abim`, `pras`, `bisma`) | Branch menyebut pekerjaan, bukan orang |
| `dev2`, `dev-baru`, `staging` | Hanya ada satu `dev` |
| `backup`, `cadangan`, `jangan-dihapus` | Hasil kerja masuk lewat PR, bukan disimpan di branch |
| `coba`, `tes`, `asdf` | Tidak jelas isinya dan sulit direview |
| Satu branch untuk semua tugas | Melanggar aturan satu tugas satu PR |

Branch `dev` tidak dibuat ulang dan tidak dipakai per orang. `dev` adalah satu
branch bersama untuk uji integrasi.

---

## 5. Alur kerja lengkap

### 5.1 Membuat branch

```bash
git switch main
git pull origin main
git switch -c feat/wardrobe-crud
git push -u origin feat/wardrobe-crud
```

Perintah `push -u` cukup sekali, untuk menghubungkan branch lokal dengan remote.

### 5.2 Bekerja dan commit

```bash
git status
git add lib/services/wardrobe_dao.dart
git commit -m "feat: tambah DAO lemari"
git push
```

Commit kecil dan sering lebih baik daripada satu commit besar. Awalan commit:
`feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`, `ml:`.

### 5.3 Membuka Pull Request

1. Buka repo di GitHub.
2. Klik **Compare & pull request** untuk branch yang baru di-push.
3. Pastikan **base: `main`**, **compare: branch kamu**.
4. Isi judul dan deskripsi: apa yang berubah, cara menguji, tangkapan layar bila
   ada perubahan UI.
5. Minta satu reviewer.
6. Setelah disetujui dan pemeriksaan lulus, klik **Merge pull request**.

### 5.4 Setelah PR digabung

```bash
git switch main
git pull origin main
git branch -d feat/wardrobe-crud
git push origin --delete feat/wardrobe-crud
```

Branch yang sudah digabung dan tidak dihapus akan menumpuk dan membingungkan.

---

## 6. Menyusul `main` yang bergerak

```bash
git switch feat/wardrobe-crud
git merge main
```

Selesaikan konflik bila ada, lalu `git add`, `git commit`, `git push`.

Jangan memakai `git rebase` pada branch yang sudah di-push dan sedang direview,
kecuali disepakati tim.

---

## 7. Konflik

Konflik muncul bila dua orang mengubah baris yang sama. Tanda di file:

```
<<<<<<< HEAD
kode kamu
=======
kode dari main
>>>>>>> main
```

Langkah:

1. Buka file, pilih kode yang benar, hapus penanda.
2. `git add <file>`
3. `git commit -m "merge: selesaikan konflik dengan main"`
4. `git push`

Konflik itu normal, bukan tanda kesalahan.

---

## 8. Branch usang

Branch yang isinya sudah ada di `main` atau tertinggal jauh sebaiknya dihapus.
Kalau masih akan dipakai, buat ulang dari `main`:

```bash
git branch -D feat/sqflite-setup
git push origin --delete feat/sqflite-setup
git switch main && git pull origin main
git switch -c feat/sqflite-setup
```

Daftar branch yang perlu dibersihkan saat ini:

| Branch | Kondisi |
|---|---|
| `feat/sqflite-setup` | 25 commit di belakang `main`, isinya kode lama |
| `docs/test-plan` | Tidak ada perubahan, sudah tergabung |
| `docs/field-photos` | Tidak ada perubahan |
| `docs/logbook` | Sudah tergabung ke `main` |
| `feat/color-crop` | Hanya commit kosong |
| `feat/google-login` | Hanya commit kosong |
| `ml/dataset-eda` | Hanya commit kosong |
| `data-training` | Sudah tergabung ke `main` |
| `feat/app-foundation` | Sudah digabung lewat PR #4 |
| `feat/color-harmony-rules` | Sudah digabung lewat PR #2 |

Branch yang masih dipakai: `main`, `dev`, `ml/model1-pipeline` (PR #3, ditunda).

---

## 9. Hubungan dengan `dev`

| Branch | Fungsi |
|---|---|
| `main` | Versi stabil, tujuan semua PR |
| `dev` | Uji integrasi bersama, bukan tujuan PR |
| `feat/...` | Pekerjaan satu tugas, dibuat dari `main` |

Alur yang benar: `main` → branch fitur → PR ke `main` → setelah stabil, `main`
di-merge ke `dev` untuk uji bersama.

Alur yang salah: mengerjakan langsung di `dev`, atau membuka PR dari `dev`.

---

## 10. Checklist sebelum membuka PR

- [ ] Branch dibuat dari `main` terbaru dan namanya sesuai tugas.
- [ ] Hanya berisi satu tugas.
- [ ] `flutter analyze` tanpa error dan warning.
- [ ] `flutter test` lulus.
- [ ] Tidak ada `google-services.json`, API key, atau file build yang ikut.
- [ ] Deskripsi PR menjelaskan perubahan dan cara menguji.
- [ ] Reviewer sudah diminta.
- [ ] Branch dihapus setelah PR digabung.
