# E3 — Autentikasi & Cloud

**Status:** ⬜ Belum

## 1. Apa yang harus dilakukan
- Menyediakan **login dengan akun Google**.
- Membuat **data pengguna dan profil** di cloud saat login pertama.
- Menjaga **sesi login** agar pengguna tetap masuk setelah aplikasi dibuka ulang.
- Menyediakan **keluar akun** dan **jalur hapus akun/data**.
- Menyimpan data sensitif (token) dengan aman di perangkat.

## 2. Bagaimana melakukannya
- Tentukan penyedia autentikasi (mis. layanan auth siap pakai) atau server
  sendiri yang memverifikasi identitas Google.
- Alur: pengguna menekan login → aplikasi memperoleh identitas dari Google →
  identitas diverifikasi → pengguna dikenali oleh sistem.
- Simpan **token sesi di penyimpanan aman perangkat**, bukan di basis data
  lokal biasa.
- Buat catatan **pengguna** dan **profil** di cloud (nama, email, foto profil).
- Pastikan data pribadi (warna kulit, bentuk tubuh) bersifat **opsional**,
  dengan persetujuan pengguna, dan dapat dihapus.
- Uji: login, tutup aplikasi, buka lagi, keluar, login lagi.

## 3. Target yang harus dicapai
- Pengguna dapat **login memakai akun Google** tanpa mengisi password.
- Setelah menutup aplikasi, pengguna **tetap dalam keadaan login**.
- Profil pengguna tersimpan dan dapat ditampilkan di halaman Profil.
- Keluar akun bekerja bersih; data dapat dihapus atas permintaan pengguna.
- Tidak ada password atau token yang tersimpan dalam bentuk teks terbuka.

## 4. Ketergantungan
- **E1** (layar Login & navigasi).
- Menjadi prasyarat untuk **E8** (halaman Profil & Pengaturan).

## 5. Referensi
- Rancangan data & privasi: `../arsitektur-data.md`
- Ketentuan di proposal: login akun termasuk ruang lingkup yang dikerjakan.
