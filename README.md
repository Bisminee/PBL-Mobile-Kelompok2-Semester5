# Sera-Z

Aplikasi mobile Flutter yang mengenali jenis dan warna pakaian dari foto, lalu
merekomendasikan kombinasi outfit.

Panduan ini dibuat untuk **yang belum pernah pakai Git**. Ikuti dari atas ke
bawah, cukup ketik perintah yang tertulis.

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
| **Branch** | **Salinan kerja pribadi**. Kalian mengerjakan bagian kalian di sini tanpa mengganggu teman. |
| **`main`** | Branch **utama** — versi yang harus selalu aman/stabil. |
| **Pull Request (PR)** | Permintaan **"tolong gabungkan pekerjaan saya ke `main`"**. Teman akan review dulu. |

**Aturan paling penting:**

> 🚫 **Jangan pernah mengerjakan langsung di `main`.**
> Setiap orang punya **branch pribadi** masing-masing. `main` = hasil final.

Ganti `<repo-url>` di bawah dengan URL GitHub kalian.

---

## 1. Pasang Alat (Sekali Saja)

Pasang di laptop:

1. **Git** — https://git-scm.com/downloads
2. **Flutter** (pilih *stable*) — https://docs.flutter.dev/get-started/install
3. **Android Studio** — https://developer.android.com/studio
4. Editor: **VS Code** (disarankan) atau Android Studio

Cek sudah terpasang atau belum:

```bash
flutter doctor
```

**Penjelasan:** perintah ini memeriksa apakah alat sudah lengkap. Jika ada tanda
silang merah, ikuti sarannya sampai semua centang hijau.

---

## 2. Ambil Proyek ke Laptop (Clone)

**Langkah 1 — Download (clone) proyek:**

```bash
git clone <repo-url>
```

**Penjelasan:** menyalin seluruh proyek dari GitHub ke laptop kalian.
Ganti `<repo-url>` dengan link repo kalian (contoh:
`https://github.com/tim-kami/sera-z.git`).

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

**Langkah 4 — Cek HP/emulator yang siap:**

```bash
flutter devices
```

**Penjelasan:** menampilkan daftar perangkat yang bisa dipakai untuk menjalankan
aplikasi.

**Langkah 5 — Jalankan aplikasi:**

```bash
flutter run
```

**Penjelasan:** menjalankan aplikasi di perangkat tadi. Kalau ada lebih dari satu
perangkat, tentukan dengan `flutter run -d <device-id>`.

> Kalian **tidak perlu** menyalin folder `build/` atau `.dart_tool/`. Folder itu
> dibuat otomatis oleh Flutter.

---

## 3. Buat Branch Pribadi (Sekali Saja)

Setiap orang cukup membuat **satu branch pribadi** dan dipakai terus.

**Langkah 1 — Pastikan berada di `main` dan ambil versi terbaru:**

```bash
git checkout main
git pull origin main
```

**Penjelasan:**
- `git checkout main` = pindah ke branch `main`.
- `git pull origin main` = download perubahan terbaru dari `main`.

**Langkah 2 — Buat branch pribadi lalu upload:**

```bash
git checkout -b bisma
git push -u origin bisma
```

**Penjelasan:**
- `git checkout -b bisma` = membuat branch baru bernama `bisma` **dan** langsung
  pindah ke sana.
- `git push -u origin bisma` = upload branch `bisma` ke GitHub. Cukup sekali;
  nanti cukup `git push`.

> Ganti `bisma` dengan nama kalian: `abim`, `falahi`, `rizki`, atau `izza`.
> Branch ini dipakai sampai proyek selesai — **tidak perlu bikin branch baru**
> tiap mau ubah sesuatu.

---

## 4. Kerja Harian (Yang Sering Kalian Lakukan)

Lakukan langkah ini setiap kali mau mengerjakan sesuatu.

**Langkah 1 — Pindah ke branch pribadi:**

```bash
git checkout bisma
```

**Penjelasan:** memastikan kalian bekerja di branch sendiri, bukan `main`.

**Langkah 2 — Ambil update terbaru (opsional tapi disarankan):**

```bash
git pull origin main
```

**Penjelasan:** memastikan pekerjaan kalian dimulai dari versi terbaru.

**Langkah 3 — Edit kode** seperti biasa (buka `lib/` di editor).

**Langkah 4 — Lihat file apa yang berubah:**

```bash
git status
```

**Penjelasan:** menampilkan daftar file yang kalian ubah. Berguna untuk memastikan
tidak ada file yang salah ikut.

**Langkah 5 — Tandai semua perubahan untuk disimpan:**

```bash
git add .
```

**Penjelasan:** memilih file yang akan dimasukkan ke "save". Tanda titik (`.`)
artinya semua file yang berubah.

**Langkah 6 — Simpan perubahan (commit):**

```bash
git commit -m "feat: tambah tombol login google"
```

**Penjelasan:** menyimpan perubahan sebagai satu riwayat. Teks dalam tanda kutip
adalah keterangan singkat perubahan kalian.

**Langkah 7 — Upload ke GitHub (push):**

```bash
git push
```

**Penjelasan:** mengirim commit dari laptop ke branch pribadi di GitHub.

> **Ulangi Langkah 1–7 setiap kali menyelesaikan satu bagian pekerjaan.**

**Tips penulisan pesan commit:**

| Awalan | Untuk perubahan apa |
|--------|---------------------|
| `feat:` | Fitur baru |
| `fix:` | Perbaikan bug |
| `docs:` | Dokumentasi |
| `refactor:` | Rapikan kode tanpa ubah fungsi |
| `test:` | Menambah/mengubah test |
| `chore:` | Tugas kecil (update package, dll.) |

Contoh: `fix: perbaiki warna terdeteksi salah`

---

## 5. Minta Gabung ke `main` (Pull Request)

Kalau pekerjaan di branch pribadi sudah siap:

1. Buka repo kalian di **GitHub** (browser).
2. Akan muncul tombol **"Compare & pull request"** — klik itu.
   (Kalau tidak muncul: klik tab **Pull requests** → **New pull request**.)
3. Pastikan:
   - **base:** `main`
   - **compare:** `bisma` (branch kalian)
4. Isi deskripsi: **apa yang diubah** dan **cara mengetesnya**.
5. Klik **Create pull request**.
6. Minta teman untuk **review**. Kalau sudah setuju, klik
   **Merge pull request** → **Confirm merge**.
7. Selesai! Branch pribadi kalian **tidak dihapus** — tetap dipakai lagi.

**Penjelasan:** Pull Request = cara sopan meminta izin menggabungkan pekerjaan
kalian. Fitur ini yang membuat `main` tetap aman karena ada pengecekan teman.

---

## 6. Cek Update di `main` (Agar Tidak Ketinggalan)

Kalau teman kalian sudah merge pekerjaannya, `main` jadi lebih baru dari branch
kalian. Ikuti ini untuk menyamakan:

**Langkah 1 — Lihat apa yang baru di `main`:**

```bash
git fetch origin
git log HEAD..origin/main --oneline
```

**Penjelasan:**
- `git fetch origin` = cek kabar terbaru dari GitHub (belum mengubah file kalian).
- `git log HEAD..origin/main --oneline` = daftar commit di `main` yang belum ada
  di branch kalian.

**Langkah 2 — Update `main` di laptop:**

```bash
git checkout main
git pull origin main
```

**Langkah 3 — Bawa update itu ke branch pribadi:**

```bash
git checkout bisma
git merge main
```

**Penjelasan:** `git merge main` menggabungkan versi `main` terbaru ke branch
kalian, supaya tetap selaras.

---

## 7. Kalau Muncul Konflik

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

> Tenang, konflik itu **normal** dan bukan tanda kesalahan. Ini tugas biasa saat
> kerja tim.

---

## 8. Ringkasan Cepat (Simpan Halaman Ini)

```bash
# ---- SEKALI SAJA ----
git clone <repo-url>
cd PBL
flutter pub get

# ---- SEKALI SAJA (buat branch pribadi) ----
git checkout main
git pull origin main
git checkout -b bisma
git push -u origin bisma

# ---- SETIAP KALI KERJA ----
git checkout bisma
git pull origin main
# ... edit kode ...
git status
git add .
git commit -m "feat: deskripsi singkat"
git push

# ---- SAAT SIAP GABUNG ----
# buka GitHub -> Compare & pull request -> Create pull request
```

---

## 9. Jangan Di-commit (Sudah Otomatis Diabaikan)

- `build/`, `.dart_tool/`, `.idea/`, `*.iml`
- `.flutter-plugins-dependencies`
- `android/local.properties`, `android/.gradle/`, `ios/Pods/`
- **Rahasia/kunci** (API key, `google-services.json`) — jangan pernah di-upload
- PDF besar (bagikan lewat Google Drive saja)

---

## 10. Arti Semua Perintah (Kamus Kilat)

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

## 11. Butuh Bantuan?

- Baca pesan error dari atas ke bawah — biasanya ada petunjuknya.
- Coba `git status` dulu untuk melihat kondisi kalian.
- Kalau bingung, tanya di grup tim dan sebutkan perintah yang barusan dijalankan
  beserta pesan errornya.
- Referensi resmi: https://docs.flutter.dev dan https://git-scm.com/doc
