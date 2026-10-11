# E5 — Modul 2: Ekstraksi Warna

**Status:** ⬜ Belum

## 1. Apa yang harus dilakukan
- Memotong gambar ke **area pakaian** dan mengurangi gangguan latar.
- Menentukan **warna dominan** dari gambar pakaian.
- Memetakan warna dominan ke **nama warna** yang mudah dipahami pengguna
  (sekitar 14 nama: hitam, putih, abu-abu, krem, cokelat, merah, merah muda,
  oranye, kuning, hijau, hijau army, biru muda, navy, ungu).
- Menyediakan **beberapa komposisi warna** (mis. hitam 78%, abu 14%, putih 8%)
  untuk ditampilkan di layar Hasil Deteksi.
- Menulis **unit test** untuk memastikan hasil warna konsisten.

## 2. Bagaimana melakukannya
- Lakukan praproses: potong bagian tengah gambar dan pisahkan latar secara
  sederhana agar warna latar tidak ikut terhitung.
- Kelompokkan piksel menjadi beberapa kelompok warna, lalu ambil kelompok
  terbesar yang bukan latar sebagai warna dominan.
- Kerjakan di ruang warna yang lebih dekat dengan persepsi manusia (bukan RGB
  mentah) agar hasil lebih wajar.
- Bandingkan warna hasil dengan daftar nama warna; pilih yang paling dekat.
- Hitung proporsi tiap kelompok untuk komposisi warna.
- Uji dengan gambar yang warnanya sudah diketahui (merah, navy, krem, dsb.).

## 3. Target yang harus dicapai
- Akurasi nama warna **≥ 80%** pada foto berlabel manual (target antara: ≥ 70%).
- Modul berjalan **cepat** dan tidak memerlukan model terlatih.
- Hasil warna stabil pada pencahayaan yang berbeda (tidak mudah berubah).
- Komposisi warna tampil di layar dan masuk akal bagi pengguna.
- Unit test warna lulus.

## 4. Ketergantungan
- **E1** (kamera & layar hasil) untuk pengujian di aplikasi.
- Dipakai oleh **E7** (mengganti atribut warna placeholder) dan
  **E6** (warna menjadi fitur untuk skor kecocokan).

## 5. Referensi
- Dataset referensi warna: `../dataset-fashion-color-recommendation.md`
- Teori harmoni warna: `../referensi-metodologi.md`
