# Panduan untuk Anggota Tim Baru — Cara Mengerjakan Tugas

Panduan ini untuk yang **belum pernah pakai GitHub**. Ikuti urutannya, cukup
ketik perintah yang tertulis.

> Ganti `https://github.com/Bisminee/PBL-Mobile-Kelompok2-Semester5.git` dengan
> link repo tim kalau berbeda.

---

## 0. Istilah Cepat

| Istilah | Arti sederhana |
|---------|----------------|
| **Repo** | Folder proyek yang ada di GitHub. |
| **Clone** | Men-download proyek dari GitHub ke laptop. |
| **Branch** | "Meja kerja" sendiri untuk satu tugas. |
| **Update** | Perubahan baru yang dikirim teman kalian ke GitHub. |
| **Pull** | Mengambil update terbaru dari GitHub ke laptop. |
| **Commit** | Menyimpan perubahan (seperti **Save**). |
| **Push** | Mengirim commit dari laptop ke GitHub. |
| **PR (Pull Request)** | Permintaan menggabungkan pekerjaan kalian ke `main`. |

**Aturan emas:** jangan bekerja langsung di `main`. Setiap tugas punya
branch sendiri (lihat file `branches.md`).

---

## 1. Sekali Saja di Awal (Persiapan)

1. Pasang **Git**: https://git-scm.com/downloads
2. Pasang **Flutter**: https://docs.flutter.dev/get-started/install
3. Download proyek ke laptop:

```bash
git clone https://github.com/Bisminee/PBL-Mobile-Kelompok2-Semester5.git
cd "PBL-Mobile-Kelompok2-Semester5"
flutter pub get
```

Kalau muncul tulisan `Got dependencies!` berarti berhasil.

---

## 2. Setiap Kali Mau Mengerjakan Tugas (WAJIB, urut)

Ini urutan yang harus dilakukan **setiap kali** sebelum mulai kerja:

### Langkah 1 — Masuk ke folder proyek
```bash
cd "PBL-Mobile-Kelompok2-Semester5"
```

### Langkah 2 — Ambil update terbaru dari `main`
```bash
git checkout main
git pull origin main
```
Kalau ada update, akan muncul daftar file yang berubah.

### Langkah 3 — Pindah ke branch tugas kalian
Lihat dulu tugasnya di file `branches.md`, lalu:
```bash
git checkout feat/google-login      # contoh
```
Ganti dengan branch sesuai tugas kalian.

### Langkah 4 — Bawa update terbaru ke branch kalian (penting!)
```bash
git merge main
```
Kalau sudah, baru **mulai mengerjakan**.

### Langkah 5 — Kerjakan tugasnya (edit kode di editor)

### Langkah 6 — Simpan & kirim
```bash
git status                 # lihat file yang berubah
git add .                  # tandai semua perubahan
git commit -m "feat: deskripsi singkat pekerjaan"
git push
```

### Langkah 7 — Buat Pull Request di GitHub
Buka repo di browser → akan muncul tombol **"Compare & pull request"** →
**Create pull request**.

---

## 3. Cara Tahu Ada Update, dan Seperti Apa Bentuknya

**Update = perubahan baru dari teman kalian** yang sudah masuk ke `main`.

### Cara paling cepat mengecek
```bash
git checkout main
git pull origin main
```

### Tulisan yang menandakan TIDAK ada update
```
Already up to date.
```
Artinya aman, tidak ada yang baru.

### Tulisan yang menandakan ADA update
```
remote: Enumerating objects...
From github.com:Bisminee/PBL-Mobile-Kelompok2-Semester5
   0bffbc4..23b639c  main       -> origin/main
Updating 0bffbc4..23b639c
Fast-forward
 Pembagian Tugas/Logbook/logbook.md | 10 +++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)
```
Artinya ada perubahan baru (contoh: file `logbook.md` berubah). Setelah ini,
laptop kalian otomatis sudah versi terbaru.

### Cara lain: cek status
```bash
git fetch
git status
```

Tulisan **"Your branch is behind 'origin/main' by N commits"** = kalian
tertinggal N perubahan → jalankan `git pull origin main`.

Tulisan **"Your branch is up to date"** = sudah paling baru.

### Cek lewat browser (kalau tidak mau pakai terminal)
Buka repo di GitHub → lihat bagian **Commits**. Kalau ada commit baru dari teman,
berarti ada update.

### Tanda-tanda kalian sudah ketinggalan (tanpa membaca tulisan)
- Ada **file baru** yang muncul setelah `git pull` (mis. `Pembagian Tugas/...`).
- Teman bilang "sudah aku push".
- Saat mau membuat PR, GitHub bilang **"This branch is out-of-date"**.

**Jika ada update → wajib jalankan Langkah 2 dan Langkah 4 di atas.**

---

## 4. Yang Tidak Boleh Dilakukan

- ❌ Bekerja langsung di branch `main`.
- ❌ `git push origin main` (kecuali diminta ketua tim).
- ❌ Meng-commit folder `build/`, `.dart_tool/`, atau file besar.
- ❌ Meng-commit kunci rahasia (API key, token).
- ❌ Mengubah file milik orang lain tanpa bilang.

---

## 5. Kalau Ada Masalah

| Masalah | Yang dilakukan |
|---------|----------------|
| `error: Your local changes would be overwritten` | Simpan dulu: `git add .` → `git commit -m "wip"`, baru `git pull`. |
| Muncul tanda `<<<<<<<` di file (konflik) | Pilih kode yang benar, hapus tanda konflik, lalu `git add .` → `git commit -m "merge: selesaikan konflik"` → `git push`. |
| Bingung sekarang di mana | `git status` — selalu tunjukkan posisi dan kondisi. |
| Salah branch | `git checkout <branch-yang-benar>` (perubahan belum di-commit akan ikut terbawa). |
| Error aneh saat build | `flutter clean` lalu `flutter pub get`. |
| Tidak yakin sama sekali | Jangan hapus apa pun. Kirim isi `git status` ke grup tim. |

---

## 6. Kamus Perintah Singkat

| Perintah | Arti |
|----------|------|
| `git status` | Lihat posisi & file yang berubah. |
| `git checkout main` | Pindah ke `main`. |
| `git checkout feat/xxx` | Pindah ke branch tugas. |
| `git pull origin main` | Ambil update terbaru. |
| `git merge main` | Bawa update `main` ke branch kalian. |
| `git add .` | Tandai semua perubahan untuk disimpan. |
| `git commit -m "..."` | Simpan perubahan. |
| `git push` | Kirim ke GitHub. |
| `flutter pub get` | Unduh bahan proyek. |
| `flutter run` | Jalankan aplikasi. |
| `flutter test` | Jalankan test. |

---

## 7. Ringkasan Super Singkat

**Setiap kali mau kerja:**
```
1. git checkout main
2. git pull origin main      ← ambil update
3. git checkout <branch tugas>
4. git merge main            ← bawa update ke branch
5. kerjakan
6. git add . → git commit -m "..." → git push
7. buat Pull Request di GitHub
```

Kalau ragu, jalankan `git status` dulu. Itu selalu aman dan tidak menghapus apa pun.
