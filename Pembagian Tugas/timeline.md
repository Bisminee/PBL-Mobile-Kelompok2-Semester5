# Sera-Z — Timeline Proyek (10 Minggu)

Periode: **28 September 2026 – 6 Desember 2026**
Diperbarui: **27 Oktober 2026** (akhir Minggu 4, awal Minggu 5)
Estimasi dalam jam-orang (ho). Kode tugas mengacu pada
`feature-breakdown-id.md`.

Dokumen ini menggantikan jadwal lama yang menganggap E4.1 selesai di Minggu 1.
Jadwal di bawah sudah disesuaikan dengan kondisi nyata: dataset belum diunduh,
PR #3 belum direview, dan integrasi belum bisa dimulai.

---

## 1. Ringkasan status

| Area | Kondisi per 27 Oktober 2026 |
|---|---|
| Fondasi aplikasi (E1) | Selesai, digabung lewat PR #4 |
| Aturan harmoni (E6.4) | Selesai, digabung lewat PR #2 |
| Pipeline Model 1 | Kode siap di PR #3, menunggu review |
| Dataset (E4.1) | Belum diunduh, penghambat utama |
| Pelatihan model | Belum mulai, menunggu E4.1 |
| Penyimpanan (E2), Auth (E3) | Belum mulai |
| Modul warna (E5) | Belum mulai, tidak bergantung dataset |
| Integrasi (E7) | Belum bisa mulai, menunggu artefak `.tflite` |
| QA (E9) | Belum mulai |
| Dokumentasi (E10) | Logbook minggu 1–8 dan laporan Milestone 1 tersedia |

Keterlambatan jalur ML: **sekitar 3 minggu** dari rencana awal.

---

## 2. Jadwal per minggu

| Minggu | Tanggal | Fokus | Tugas utama | Milestone | Status |
|---|---|---|---|---|---|
| 1 | 28 Sep – 4 Okt | Fondasi | E1 fondasi aplikasi, alur rute, state Riverpod, logbook | CP-1 Proposal (2 Okt) | Selesai |
| 2 | 5 – 11 Okt | Kamera dan aturan warna | E1 lanjutan (kamera), E6.4 aturan harmoni (PR #2) | — | Selesai |
| 3 | 12 – 18 Okt | Pipeline ML dan kualitas UI | PR #3 pipeline Model 1, perbaikan layout responsif, keputusan lisensi dataset | — | Selesai |
| 4 | 19 – 25 Okt | Laporan Milestone 1 | Penyusunan laporan Milestone 1, logbook minggu 1–8 | CP-2 Milestone 1 (24 Okt) | Selesai (laporan), jalur ML tertinggal |
| 5 | 26 Okt – 1 Nov | Pondasi mobile | E2.1–E2.4, E3.1, E8.6 | — | Berjalan |
| 6 | 2 – 8 Nov | Menyelesaikan mobile | E2.5–E2.6, E3.2–E3.4, E8.1, E8.2, E8.4, E8.7 | — | Rencana |
| 7 | 9 – 15 Nov | Mulai ML dan pemrosesan gambar | E5.1–E5.2, E4.1–E4.3 | — | Rencana |
| 8 | 16 – 22 Nov | Latih model | E4.4–E4.6, E6.1–E6.2, E5.3–E5.4 | CP-3 Milestone 2 (27 Nov) | Rencana |
| 9 | 23 – 29 Nov | Integrasi dan QA awal | E6.3–E6.6, E7.1–E7.5, E8.3, E8.5, E9.2 | — | Rencana |
| 10 | 30 Nov – 6 Des | Freeze, QA, laporan | E7.6, E9.3–E9.7, E10.3–E10.5, demo | CP-4 Final (4 Des) | Rencana |

Catatan: CP-3 Milestone 2 digeser dari 13 Nov ke **27 Nov** karena ML baru dimulai
minggu 7. CP-4 tetap 4 Desember.

---

## 3. Jadwal per epic

| Epic | Tugas tersisa | Target minggu | Penanggung sementara |
|---|---|---|---|
| E2 Penyimpanan | E2.1–E2.6 (7,0 ho) | 5–6 | Pras (E2.1–E2.3), Ahmad (E2.4–E2.6) |
| E3 Autentikasi | E3.1–E3.4 (5,0 ho) | 5–6 | Bisma Adhiaksa |
| E8 Fitur aplikasi | E8.1, E8.2, E8.4, E8.6, E8.7 (8,5 ho) | 5–6 | Izza (E8.1, E8.6), Abim (E8.2, E8.4, E8.7) |
| E4 Model 1 | E4.1–E4.6 (8,0 ho) | 7–8 | Ahmad |
| E5 Modul warna | E5.1–E5.4 (5,0 ho) | 7–8 | Abim |
| E6 Model 3 | E6.1–E6.3, E6.5–E6.6 (7,0 ho) | 8–9 | Pras (data), Ahmad (latih), Bisma (evaluasi) |
| E7 Integrasi | E7.1–E7.6 (9,5 ho) | 9–10 | Ahmad, Izza, Abim |
| E8 Fitur lanjutan | E8.3, E8.5 (3,0 ho) | 9 | Izza |
| E9 QA | E9.1–E9.7 (11,0 ho) | 9–10 | Bisma dan seluruh tim |
| E10 Dokumentasi | E10.1–E10.5 (11,5 ho) | 9–10 | Izza |

Penanggung sementara hanya berlaku untuk minggu berjalan dan boleh ditukar.
Aturan tetap: maksimal 2 tugas aktif per orang.

---

## 4. Urutan ketergantungan yang menentukan tanggal

```
E4.1 dataset ─► E4.2 split ─► E4.4 latih ─► E4.5 evaluasi
                                    └────► E4.6 ekspor TFLite ─┐
E4.2 ─► E6.1 pasangan ─► E6.2 fitur ─► E6.3 MLP ─► E6.5 eval   │
                                            └────► E6.6 ekspor ─┤
                                                                ▼
                                              E7.1 loader ─► E7.2 inferensi
                                                    └──────► E7.4 skor Model 3
                                                                  └► E8.3 ranking
                                                                        └► E8.5 detail
E5.1 ─► E5.2 K-Means ─► E5.3 palet ─► E5.4 test        (paralel, mandiri)
E2.1 ─► E2.2 ─► E8.1 ; E2.4 ─► E8.2 ; E2.5 ─► E8.4
E3.1 ─► E3.4 ─► E8.7 ─► E9.6
```

Jalur kritis: **E4.1 → E4.2 → E4.4 → E4.6 → E7.1 → E7.4 → E8.3 → E9.2 → E10.4**.

---

## 5. Milestone

| Milestone | Tanggal | Isi | Kondisi |
|---|---|---|---|
| CP-1 Proposal | 2 Okt 2026 | Proposal proyek | Selesai |
| CP-2 Milestone 1 | 24 Okt 2026 | Laporan kemajuan, desain, rencana ML | Selesai (laporan); pelatihan model menyusul |
| CP-3 Milestone 2 | 27 Nov 2026 | Model terintegrasi, fitur inti, uji fungsional | Rencana, berisiko |
| CP-4 Final | 4 Des 2026 | Aplikasi rilis, laporan akhir, demo | Rencana |

---

## 6. Risiko dan mitigasi

| Risiko | Dampak | Mitigasi |
|---|---|---|
| ML dan pemrosesan gambar dijeda sampai mobile selesai | E7, E8.3, E9.2, dan laporan bergeser | Mobile diselesaikan 1 Nov, ML mulai 9 Nov; CP-3 digeser ke 27 Nov |
| PR #3 belum direview | Kode pipeline tidak bisa dipakai saat ML dimulai | Review sebelum 9 Nov, tidak perlu minggu ini |
| Akurasi model di bawah 80 persen | Target laporan tidak tercapai | Siapkan baseline MobileNetV2 dan fine-tune; catat hasil apa adanya |
| Integrasi TFLite mepet | E7 dan E8.3 tidak selesai | Mulai E7.1 segera setelah artefak pertama ada, jangan menunggu model sempurna |
| Beban QA menumpuk di akhir | Bug tidak tertangani | E9.1 disusun minggu 5, uji fungsional bertahap sejak minggu 9 |
| Firebase belum dikonfigurasi | E3.1 dan E8.7 tertahan | Buat proyek Firebase dan `google-services.json` minggu 5 (jangan di-commit) |

---

## 7. Aturan pelaksanaan

1. Satu tugas = satu branch = satu PR; branch dibuat dari `dev` dan PR mengarah
   ke `dev`. `main` hanya menerima penggabungan `dev` pada akhir milestone.
2. Maksimal 2 tugas aktif per orang.
3. Tugas yang tertahan prasyarat tidak diambil; pindah ke tugas independen.
4. Setiap Jumat: perbarui status di papan Notion dan logbook.
5. Setiap Minggu: rekap mingguan dan perbarui dokumen ini bila ada pergeseran.
6. Scope freeze pada 30 November: setelah itu hanya perbaikan bug, pengujian, dan
   laporan.

---

## 8. Prioritas eksekusi: mobile dulu, ML menyusul

Semua pekerjaan ML dan pemrosesan gambar dijeda. Fokus minggu 5–6 hanya
pembangunan aplikasi.

| Prioritas | Tugas | Alasan | Perkiraan |
|---|---|---|---|
| P0 | E2.1 | Membuka E8.1, E8.6, dan seluruh E2 lanjutan | 28 Okt |
| P0 | E2.2 | Membuka E8.1 | 29 Okt |
| P0 | E3.1 | Membuka E3.2–E3.4 dan E8.7 | 29 Okt |
| P0 | E2.4 | Membuka E8.2 | 30 Okt |
| P1 | E2.3, E2.5, E2.6 | Melengkapi penyimpanan | 31 Okt–1 Nov |
| P1 | E3.2–E3.4 | Melengkapi autentikasi | 30 Okt–1 Nov |
| P1 | E8.6, E8.1 | Fitur lemari dan admin | 29 Okt–1 Nov |
| P1 | E8.7, E8.2, E8.4 | Profil, outfit, Home | 31 Okt–1 Nov |
| P2 | E5 modul warna | Pemrosesan gambar, menyusul | Minggu 7 |
| P2 | E4 Model 1 | ML, menyusul | Minggu 7 |
| P3 | E6 Model 3 | ML, menyusul | Minggu 8 |
| P3 | E7 integrasi TFLite | Menunggu artefak model | Minggu 9 |
| P3 | E8.3, E8.5 | Menunggu E7.4 | Minggu 9 |
| P3 | E9 QA, E10 dokumentasi | Menyusul setelah fitur stabil | Minggu 9–10 |

Konsekuensi: menghentikan ML sampai mobile selesai menggeser seluruh jalur
integrasi. CP-3 Milestone 2 dijadwalkan ulang ke **27 November** dan scope freeze
tetap 30 November.
