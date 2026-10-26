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
| 5 | 26 Okt – 1 Nov | Membuka jalur data | Review dan gabung PR #3, E4.1 dataset + EDA, E4.2 split, E5.1 crop, E2.1, E3.1, E9.1 | — | Berjalan |
| 6 | 2 – 8 Nov | Latih Model 1 dan modul warna | E4.3 baseline, E4.4 latih YOLOv11n-cls, E5.2 K-Means, E2.2–E2.3, E3.2–E3.3 | — | Rencana |
| 7 | 9 – 15 Nov | Ekspor model dan Model 3 | E4.5 evaluasi, E4.6 ekspor TFLite, E6.1 pasangan, E6.2 fitur, E2.4–E2.6, E8.6 | — | Rencana |
| 8 | 16 – 22 Nov | Model 3 dan awal integrasi | E6.3 latih MLP, E6.5 evaluasi, E7.1 loader, E7.2 inferensi Model 1, E8.1, E3.4 | CP-3 Milestone 2 (20 Nov) | Rencana |
| 9 | 23 – 29 Nov | Integrasi penuh dan QA awal | E6.6 ekspor MLP, E7.3–E7.6, E8.2–E8.5, E9.2 uji fungsional | — | Rencana |
| 10 | 30 Nov – 6 Des | Freeze, QA, laporan | E9.3–E9.7, E10.3–E10.5, polish, demo | CP-4 Final (4 Des) | Rencana |

Catatan: CP-3 Milestone 2 digeser dari 13 Nov ke **20 Nov** karena E7 baru bisa
mulai setelah E4.6 dan E6.6. CP-4 tetap 4 Desember.

---

## 3. Jadwal per epic

| Epic | Tugas tersisa | Target minggu | Penanggung sementara |
|---|---|---|---|
| E2 Penyimpanan | E2.1–E2.6 (7,0 ho) | 5–7 | Abim Mustawa |
| E3 Autentikasi | E3.1–E3.4 (5,0 ho) | 5–8 | Bisma Adhiaksa |
| E4 Model 1 | E4.1–E4.6 (8,0 ho) | 5–7 | Faatihurrizki (data), Ahmad (latih) |
| E5 Modul warna | E5.1–E5.4 (5,0 ho) | 5–6 | Faatihurrizki |
| E6 Model 3 | E6.1–E6.3, E6.5–E6.6 (7,0 ho) | 7–9 | Ahmad (latih), Bisma (evaluasi) |
| E7 Integrasi | E7.1–E7.6 (9,5 ho) | 8–9 | Ahmad (E7.1–E7.2), Izza (E7.4–E7.6) |
| E8 Fitur aplikasi | E8.1–E8.7 (11,5 ho) | 5–9 | Izza (UI), Bisma (outfit, profil) |
| E9 QA | E9.1–E9.7 (11,0 ho) | 5, 9–10 | Bisma (rencana), seluruh tim (eksekusi) |
| E10 Dokumentasi | E10.1–E10.5 (11,5 ho) | 5–10 | Izza (logbook, laporan), tim (foto) |

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
| CP-3 Milestone 2 | 20 Nov 2026 | Model terintegrasi, fitur inti, uji fungsional | Rencana, berisiko |
| CP-4 Final | 4 Des 2026 | Aplikasi rilis, laporan akhir, demo | Rencana |

---

## 6. Risiko dan mitigasi

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Dataset E4.1 belum diunduh | Seluruh E4, E6, E7 bergeser | Selesaikan unduhan paling lambat 29 Okt; sementara itu kerjakan E5, E2, E3 |
| PR #3 belum direview | Kode pipeline tidak bisa dipakai | Review paling lambat 28 Okt, satu reviewer cukup |
| Akurasi model di bawah 80 persen | Target laporan tidak tercapai | Siapkan baseline MobileNetV2 dan fine-tune; catat hasil apa adanya |
| Integrasi TFLite mepet | E7 dan E8.3 tidak selesai | Mulai E7.1 segera setelah artefak pertama ada, jangan menunggu model sempurna |
| Beban QA menumpuk di akhir | Bug tidak tertangani | E9.1 disusun minggu 5, uji fungsional bertahap sejak minggu 9 |
| Firebase belum dikonfigurasi | E3.1 dan E8.7 tertahan | Buat proyek Firebase dan `google-services.json` minggu 5 (jangan di-commit) |

---

## 7. Aturan pelaksanaan

1. Satu tugas = satu branch = satu PR; PR mengarah ke `main`, `dev` dipakai untuk
   uji integrasi.
2. Maksimal 2 tugas aktif per orang.
3. Tugas yang tertahan prasyarat tidak diambil; pindah ke tugas independen.
4. Setiap Jumat: perbarui status di papan Notion dan logbook.
5. Setiap Minggu: rekap mingguan dan perbarui dokumen ini bila ada pergeseran.
6. Scope freeze pada 30 November: setelah itu hanya perbaikan bug, pengujian, dan
   laporan.

---

## 8. Prioritas eksekusi: mobile dulu, ML menyusul

Jalur kritis di atas bersifat teknis: tanpa E4/E6, integrasi tidak bisa jalan.
Namun urutan **pengerjaan harian** disusun agar aplikasi bisa dipakai lebih dulu.
ML tetap berjalan sebagai tugas latar, bukan ditinggalkan.

| Prioritas | Tugas | Alasan | Perkiraan |
|---|---|---|---|
| P0 | E2.1, E2.2 | Membuka empat tugas fitur sekaligus | Minggu 5 |
| P0 | E3.1 | Membuka autentikasi lanjutan dan halaman Profil | Minggu 5 |
| P0 | E5.1 | Tanpa prasyarat, tidak butuh dataset | Minggu 5 |
| P0 | E9.1 | Harus ada sebelum pengujian; tidak butuh kode | Minggu 5 |
| P0 | Review PR #3 | Kode ML berhenti selama PR belum digabung | 28 Okt |
| P1 | E4.1, E4.2 | Lead time unduh; menghambat seluruh jalur ML | Minggu 5–6 |
| P1 | E2.3, E3.2, E3.3, E5.2, E8.6 | Lanjutan langsung dari P0 | Minggu 5–6 |
| P2 | E4.3, E4.4, E5.3, E5.4, E2.4, E2.5 | Fondasi model dan penyimpanan lanjutan | Minggu 6 |
| P2 | E6.1–E6.3, E4.5, E4.6 | Model 3 dan artefak TFLite | Minggu 7 |
| P3 | E7.1–E7.6 | Integrasi, menunggu `.tflite` | Minggu 8–9 |
| P3 | E8.3, E8.5 | Menunggu skor Model 3 (E7.4) | Minggu 8–9 |

Konsekuensi yang perlu disadari: menunda E4.1 sampai mobile selesai akan
menggeser E7, E8.3, E9.2, dan laporan akhir. Karena itu E4.1 tetap dijadwalkan
minggu ini sebagai tugas latar dengan beban 1 ho.
