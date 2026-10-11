# Sera-Z

Aplikasi mobile Flutter yang mengenali jenis dan warna pakaian dari foto, lalu
merekomendasikan kombinasi outfit.

Panduan ini dibuat untuk **yang belum pernah pakai Git**. Ikuti dari atas ke
bawah, cukup ketik perintah yang tertulis.

> **Aturan utama proyek ini:** branch **dinamai sesuai fitur**, bukan sesuai nama
> orang. Tidak ada branch `bisma`, `abim`, dan seterusnya. Semua tugas bersifat
> terbuka — siapa pun boleh mengerjakannya (lihat folder **`Pembagian Tugas/`**).

---

## 0. Git Itu Apa? (Baca Dulu, 2 Menit)

Bayangkan kode kita seperti **dokumen bersama**:

| Istilah | Artinya yang gampang |
|---------|----------------------|
| **Git** | "Mesin waktu" yang menyimpan setiap perubahan kode. |
| **GitHub** | Tempat penyimpanan online (seperti Google Drive) untuk kode kita. |
| **Repository (repo)** | Folder proyek yang disimpan di GitHub. |
| **Commit** | Seperti **"Save"** di game. Menyimpan perubahan di komputer kalian. |
| **Push** | **Upload** commit dari komputer ke GitHub. |
| **Pull** | **Download** perubahan terbaru dari GitHub ke komputer. |
| **Branch** | **Jalur kerja terpisah** untuk mengerjakan satu fitur tanpa mengganggu yang lain. |
| **`main`** | Branch **utama** — versi yang harus selalu aman/stabil. |
| **Pull Request (PR)** | Permintaan **"tolong gabungkan fitur saya ke `main`"**. Teman akan review dulu. |

**Aturan paling penting:**

> 🚫 **Jangan pernah mengerjakan langsung di `main`.**
> Buat **branch baru untuk setiap fitur**.

---

## 1. Pasang Alat (Sekali Saja)

1. **Git** — https://git-scm.com/downloads
2. **Flutter** (pilih *stable*) — https://docs.flutter.dev/get-started/install
3. **Android Studio** — https://developer.android.com/studio
4. Editor: **VS Code** (disarankan) atau Android Studio

Cek sudah terpasang atau belum:

```bash
flutter doctor
```

**Penjelasan:** perintah ini memeriksa kelengkapan alat. Jika ada tanda silang
merah, ikuti sarannya sampai semua centang hijau.

---

## 2. Ambil Proyek ke Laptop (Clone)

**Langkah 1 — Download (clone) proyek:**

```bash
git clone <repo-url>
```

**Penjelasan:** menyalin seluruh proyek dari GitHub ke laptop kalian.

**Langkah 2 — Masuk ke folder proyek:**

```bash
cd PBL
```

**Penjelasan:** `cd` = *change directory*, artinya "masuk ke dalam folder".

**Langkah 3 — Unduh paket yang dibutuhkan:**

```bash
flutter pub get
```

**Penjelasan:** mengunduh semua "bahan" yang dipakai proyek. Wajib dilakukan
setelah clone, dan setiap kali file `pubspec.yaml` berubah.

**Langkah 4 — Jalankan aplikasi:**

```bash
flutter run
```

**Penjelasan:** menjalankan aplikasi di HP/emulator yang terdeteksi.

---

## 3. Model Branch: Satu Branch per Fitur (Bukan per Orang)

### 3.1 Aturan
- **Tidak ada branch bernama orang.** Branch dinamai sesuai **fitur/pekerjaan**.
- Setiap fitur punya **satu branch** dan **satu Pull Request**.
- Branch dibuat dari `main` terbaru, umurnya pendek (1–3 hari).
- Setelah PR digabung, branch dihapus.

### 3.2 Apa Itu "Fitur"?

**Fitur** = pekerjaan yang *utuh, bisa diuji sendiri, dan bisa digabung lewat
satu PR*. Cek dengan pertanyaan ini — kalau **semua "ya"**, berarti satu fitur:

| Pertanyaan | Contoh |
|------------|--------|
| Bisa dijelaskan dalam **satu kalimat**? | "Pengguna bisa login dengan Google." |
| Memberi **nilai** ke pengguna? | Login membuka aplikasi |
| Bisa **diuji sendiri**? | Login bisa dites tanpa fitur lain |
| Bisa digabung **tanpa merusak `main`**? | Ya |
| Punya **kriteria penerimaan**? | "Login berhasil, sesi tersimpan" |
| Cukup **kecil** untuk satu review? | Idealnya < ~400 baris |
| Hanya melakukan **satu hal**? | Bukan "login + ubah tema" |

Kalau gagal salah satu → itu **Epic** atau **Tugas**, bukan fitur.

### 3.3 Hierarki
```
Epic    = kelompok besar          (E4: Model 1)
Fitur   = unit siap rilis         (E4.4: latih YOLOv11n-cls)
Tugas   = langkah di dalam fitur  (siapkan data, latih, evaluasi)
Bug     = fix/...                 (perbaiki warna salah)
```

### 3.4 Penamaan Branch

| Awalan | Untuk |
|--------|-------|
| `feat/` | Fitur baru |
| `fix/` | Perbaikan bug |
| `ml/` | Pekerjaan model/dataset (Python) |
| `docs/` | Dokumentasi |
| `test/` | Menambah/memperbaiki test |
| `chore/` | Tugas kecil (update paket, dll.) |

**Contoh untuk proyek kita:**

| Tugas | Nama branch |
|-------|-------------|
| E2.1 Setup `sqflite` | `feat/sqflite-setup` |
| E2.2 CRUD Lemari | `feat/wardrobe-crud` |
| E3.1 Login Google | `feat/google-login` |
| E4.4 Latih YOLOv11n-cls | `ml/yolov11n-cls` |
| E5.2 K-Means warna | `feat/color-kmeans` |
| E6.3 Latih MLP | `ml/compat-mlp` |
| E8.1 UI Lemari | `feat/wardrobe-ui` |
| E9.1 Rencana uji | `docs/test-plan` |

> Jangan buat `feat/big-ml` (terlalu besar) atau `feat/login-dan-ubah-tema`
> (dua hal sekaligus). Pecah menjadi beberapa branch.

---

## 4. Membuat Branch Fitur

**Langkah 1 — Pastikan di `main` terbaru:**

```bash
git checkout main
git pull origin main
```

**Langkah 2 — Buat branch fitur:**

```bash
git checkout -b feat/wardrobe-crud
```

**Penjelasan:** `git checkout -b` = membuat branch baru **dan** langsung pindah
ke sana. Ganti `feat/wardrobe-crud` dengan nama fitur kalian.

**Langkah 3 — Upload branch ke GitHub (sekali saja):**

```bash
git push -u origin feat/wardrobe-crud
```

---

## 5. Kerja Harian (Commit & Push)

**Langkah 1 — Lihat file yang berubah:**

```bash
git status
```

**Langkah 2 — Tandai semua perubahan:**

```bash
git add .
```

**Langkah 3 — Simpan (commit):**

```bash
git commit -m "feat: tambah CRUD lemari baju"
```

**Langkah 4 — Upload (push):**

```bash
git push
```

> **Ulangi setiap menyelesaikan satu bagian pekerjaan.**

**Awalan pesan commit:** `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`.

---

## 6. Minta Gabung ke `main` (Pull Request)

1. Buka repo di **GitHub** (browser).
2. Klik **"Compare & pull request"** untuk branch kalian.
3. Pastikan **base: `main`** dan **compare: `feat/...`** (branch kalian).
4. Isi deskripsi: **apa yang diubah** dan **cara mengetesnya**.
5. Klik **Create pull request**.
6. Minta teman **review**. Setelah setuju, klik
   **Merge pull request** → **Confirm merge**.
7. Hapus branch fitur setelah digabung (opsional).

**Penjelasan:** PR adalah cara sopan meminta izin menggabungkan fitur. `main`
tetap aman karena ada pengecekan teman.

---

## 7. Cek Update di `main` (Agar Tidak Ketinggalan)

**Langkah 1 — Lihat apa yang baru di `main`:**

```bash
git fetch origin
git log HEAD..origin/main --oneline
```

**Langkah 2 — Update `main` di laptop:**

```bash
git checkout main
git pull origin main
```

**Langkah 3 — Bawa update itu ke branch fitur kalian:**

```bash
git checkout feat/wardrobe-crud
git merge main
```

---

## 8. Kalau Muncul Konflik

Konflik terjadi kalau kalian dan teman mengubah **baris yang sama**. Git akan
menandai file itu seperti ini:

```
<<<<<<< HEAD
kode kalian
=======
kode teman
>>>>>>> main
```

**Cara menyelesaikan:**

1. Buka file tersebut di editor.
2. Pilih kode yang benar (hapus kode yang tidak dipakai beserta tanda
   `<<<<<<<`, `=======`, `>>>>>>>`).
3. Simpan, lalu:

```bash
git add .
git commit -m "merge: selesaikan konflik dengan main"
git push
```

> Konflik itu **normal** dan bukan tanda kesalahan.

---

## 9. Ringkasan Cepat

```bash
# ---- SEKALI SAJA ----
git clone <repo-url>
cd PBL
flutter pub get

# ---- SETIAP FITUR BARU ----
git checkout main
git pull origin main
git checkout -b feat/nama-fitur
# ... kerjakan fitur ...
git status
git add .
git commit -m "feat: deskripsi singkat"
git push -u origin feat/nama-fitur

# ---- SAAT SIAP GABUNG ----
# buka GitHub -> Compare & pull request -> Create pull request
```

---

## 10. Jangan Di-commit (Sudah Otomatis Diabaikan)

- `build/`, `.dart_tool/`, `.idea/`, `*.iml`
- `.flutter-plugins-dependencies`
- `android/local.properties`, `android/.gradle/`, `ios/Pods/`
- **Rahasia/kunci** (API key, `google-services.json`) — jangan pernah di-upload
- Folder `context/` (dokumentasi internal, sengaja diabaikan)

---

## 11. Arti Semua Perintah (Kamus Kilat)

### Git

| Perintah | Artinya yang gampang |
|----------|----------------------|
| `git clone <url>` | Download proyek dari GitHub. |
| `git checkout <branch>` | Pindah ke branch lain. |
| `git checkout -b <branch>` | Bikin branch baru + pindah ke sana. |
| `git pull origin main` | Download + gabungkan versi terbaru `main`. |
| `git fetch origin` | Cek update dari GitHub (belum mengubah file kalian). |
| `git status` | Lihat file apa yang berubah. |
| `git diff` | Lihat detail perubahan baris per baris. |
| `git add .` | Tandai semua perubahan untuk disimpan. |
| `git commit -m "pesan"` | Simpan perubahan (seperti "Save"). |
| `git push` | Upload commit ke GitHub. |
| `git push -u origin <branch>` | Upload branch baru (cukup sekali, `-u` menghubungkan). |
| `git branch` | Lihat daftar branch. `*` = branch aktif. |
| `git branch -d <branch>` | Hapus branch lokal yang sudah digabung. |
| `git log --oneline -10` | Lihat 10 riwayat commit terakhir. |
| `git merge main` | Gabungkan versi `main` ke branch kalian. |
| `git remote -v` | Lihat link GitHub yang terhubung. |

### Flutter

| Perintah | Artinya yang gampang |
|----------|----------------------|
| `flutter doctor` | Cek alat sudah lengkap atau belum. |
| `flutter pub get` | Unduh paket/bahan yang dibutuhkan proyek. |
| `flutter devices` | Lihat HP/emulator yang siap dipakai. |
| `flutter run` | Jalankan aplikasi. |
| `flutter clean` | Hapus file build sementara (kalau error aneh). |
| `flutter test` | Jalankan test. |

---

## 12. Butuh Bantuan?

- Baca pesan error dari atas ke bawah — biasanya ada petunjuknya.
- Coba `git status` dulu untuk melihat kondisi kalian.
- Kalau bingung, tanya di grup tim dan sebutkan perintah yang barusan dijalankan
  beserta pesan errornya.
- Referensi resmi: https://docs.flutter.dev dan https://git-scm.com/doc
