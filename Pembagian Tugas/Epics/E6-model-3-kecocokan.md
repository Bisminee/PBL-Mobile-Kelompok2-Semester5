# E6 — Model 3: Skor Kecocokan

**Status:** 🟡 Sebagian — E6.4 (aturan harmoni warna) selesai, sudah digabung ke `main` lewat PR #2

## 1. Apa yang harus dilakukan
- Menyusun **data pasangan pakaian** (atasan–bawahan) yang dianggap cocok.
- Membuat **contoh pasangan tidak cocok** dengan cara mengacak pasangan.
- Menentukan **fitur masukan**: kategori pakaian dan informasi warna
  (termasuk selisih warna antar item).
- Melatih **model penilai kecocokan** yang menghasilkan skor 0–1.
- Menyiapkan **model pembanding** (metode statistik sederhana) untuk
  memastikan model utama lebih baik.
- Menyusun **aturan harmoni warna** (komplementer, analog, monokromatik, netral)
  sebagai penjelas dan cadangan.
- **Mengevaluasi** kualitas ranking rekomendasi.
- Menyiapkan model agar dapat dijalankan di perangkat.

## 2. Bagaimana melakukannya
- Ambil data outfit dari dataset yang memiliki informasi gaya dan acara.
- Bentuk pasangan positif (cocok) dan negatif (tidak cocok) dengan jumlah
  seimbang agar model tidak bias.
- Susun fitur yang menggabungkan **kategori** dan **warna** kedua item.
- Latih model penilai, lalu bandingkan hasilnya dengan aturan harmoni dan model
  pembanding.
- Gabungkan skor model dengan skor aturan harmoni sebagai **skor akhir**, agar
  setiap rekomendasi punya alasan yang bisa dijelaskan.
- Evaluasi dengan metrik ranking (AUC dan precision@3), bukan hanya akurasi.
- Pastikan model tetap memberi hasil wajar untuk kombinasi yang belum pernah
  dilihat.

## 3. Target yang harus dicapai
- **AUC ≥ 0,75** (target antara: ≥ 0,70), lebih baik daripada baseline aturan.
- **Precision@3** baik, artinya 3 rekomendasi teratas relevan.
- **≥ 70%** rekomendasi dinilai "cocok" oleh responden uji.
- Setiap rekomendasi memiliki **alasan yang dapat dipahami** pengguna.
- Ukuran model ringan dan dapat dijalankan di perangkat.

## 4. Ketergantungan
- **E4** (kategori pakaian) dan **E5** (warna) — keduanya menjadi fitur.
- Menjadi prasyarat untuk **E7** (integrasi skor ke halaman rekomendasi).

## 5. Referensi
- Dataset pasangan: `../fashionstylist.md`
- Paper kompatibilitas: `../referensi-metodologi.md`
