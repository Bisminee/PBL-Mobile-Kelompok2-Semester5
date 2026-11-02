# Sera-Z — Timeline Proyek (10 Minggu)

Periode: **28 September 2026 – 6 Desember 2026**
Diperbarui: **2 November 2026** (awal minggu 6)
Estimasi dalam jam-orang (ho). Kode tugas mengacu pada
`feature-breakdown-id.md`.

Dokumen ini menggantikan jadwal lama yang menganggap E4.1 selesai di Minggu 1.
Jadwal di bawah sudah disesuaikan dengan kondisi nyata: dataset belum diunduh,
PR #3 belum direview, dan integrasi belum bisa dimulai.

---

## 1. Ringkasan status

| Area | Kondisi per 2 November 2026 |
|---|---|
| Fondasi aplikasi (E1) | Selesai, PR #1 dan #4 |
| Aturan harmoni (E6.4) | Selesai, PR #2 |
| Dataset dan Model 1 | Selesai, PR #6 dan #7; akurasi test 94,34 persen |
| Penyimpanan (E2) | Selesai sebagian, PR #13; riwayat dan test DAO tersisa |
| Auth (E3) | Selesai, PR #8–#12 |
| Modul warna (E5) | Sebagian, PR #13; palet dan test tersisa |
| Model 3 (E6) | Sebagian; MLP data sintetis, metrik belum |
| Integrasi (E7) | Sebagian, PR #13; fallback dan latensi tersisa |
| Fitur aplikasi (E8) | Sebagian; Admin dan CRUD lengkap tersisa |
| QA (E9) | 39 test otomatis lulus; rencana uji formal belum |
| Dokumentasi (E10) | Logbook minggu 1–6 dan laporan Milestone 1 |

Jalur ML sudah tuntas sampai pelatihan dan evaluasi. Sisa pekerjaan ada pada
ekspor model sendiri, metrik Model 3, dan penyelesaian fitur.

---

## 2. Jadwal per minggu

| Minggu | Tanggal | Fokus | Tugas utama | Milestone | Status |
|---|---|---|---|---|---|
| 1 | 28 Sep – 4 Okt | Fondasi | E1 fondasi aplikasi, alur rute, state Riverpod, logbook | CP-1 Proposal (2 Okt) | Selesai |
| 2 | 5 – 11 Okt | Kamera dan aturan warna | E1 lanjutan (kamera), E6.4 aturan harmoni (PR #2) | — | Selesai |
| 3 | 12 – 18 Okt | Pipeline ML dan kualitas UI | PR #3 pipeline Model 1, perbaikan layout responsif, keputusan lisensi dataset | — | Selesai |
| 4 | 19 – 25 Okt | Laporan Milestone 1 | Penyusunan laporan Milestone 1, logbook minggu 1–8 | CP-2 Milestone 1 (24 Okt) | Selesai (laporan), jalur ML tertinggal |
| 5 | 26 Okt – 1 Nov | Dataset, latihan model, autentikasi | Dataset 33.667 gambar (PR #6); baseline 89,37 persen; YOLOv11n-cls 94,34 persen (PR #7); autentikasi Firebase (PR #8–#12) | — | Selesai |
| 6 | 2 – 8 Nov | Integrasi dan penyelesaian | SQLite dan TFLite (PR #13); riwayat rekomendasi, test DAO, fallback aturan, ekspor model, metrik Model 3, label, Admin, CRUD lemari, QA plan | — | Berjalan |
| 7 | 9 – 15 Nov | Penyempurnaan fitur | E8.3, E8.5, E7.6, perbaikan temuan | — | Rencana |
| 8 | 16 – 22 Nov | Uji fungsional dan laporan | E9.2–E9.5, E10.3, draf laporan | CP-3 Milestone 2 (27 Nov) | Rencana |
| 9 | 23 – 29 Nov | QA lanjutan | E9.6, E9.7, E10.4 | — | Rencana |
| 10 | 30 Nov – 6 Des | Freeze dan demo | E10.5, build rilis, demo | CP-4 Final (4 Des) | Rencana |

Catatan: CP-3 Milestone 2 tetap **27 Nov**. Model 1 sudah tersedia dari blok ML
2–4 November sehingga integrasi bisa mulai lebih awal. CP-4 tetap 4 Desember.

---

## 3. Jadwal per epic

| Epic | Tugas tersisa | Target minggu | Penanggung sementara |
|---|---|---|---|
| E2 Penyimpanan | E2.4, E2.6 | 6 | Bisma |
| E3 Autentikasi | Selesai | — | — |
| E4 Model 1 | E4.6 ekspor model sendiri | 6 | Bisma |
| E5 Modul warna | E5.3, E5.4 | 6 | Bisma |
| E6 Model 3 | E6.5 metrik AUC dan precision@3 | 6 | Bisma |
| E7 Integrasi | E7.5 fallback, E7.6 latensi | 6 | Bisma (fallback), Abim (latensi) |
| E8 Fitur aplikasi | E8.1, E8.6, E8.7 | 6 | Izza (E8.1, E8.6), Abim (E8.7) |
| E8 Fitur lanjutan | E8.3, E8.5 | 7 | Izza |
| E9 QA | E9.1–E9.7 | 6, 8–9 | Bisma dan seluruh tim |
| E10 Dokumentasi | E10.2–E10.5 | 6, 8–10 | Izza (laporan), Bisma (metode ML) |

Penanggung sementara hanya berlaku untuk minggu berjalan dan boleh ditukar.
Aturan tetap: maksimal 2 tugas aktif per orang.

### 3.1 Satu jalur integrasi

| Jalur | Branch | Isi |
|---|---|---|
| Semua pekerjaan | `dev` | Mobile, ML, skrip, dan artefak model |

Seluruh branch tugas dibuat dari `dev` dan PR diarahkan ke `dev`. `dev-ml` sudah
digabung ke `dev` dan dihapus pada 2 November 2026, sehingga tidak ada lagi
jalur terpisah. `main` hanya menerima penggabungan `dev` pada akhir milestone.

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
| ML dan mobile dipisah sampai 1 November | Integrasi bergeser | Mobile selesai 1 Nov, ML selesai 2 Nov, integrasi jalan minggu 6 |
| Ekspor TFLite model sendiri gagal di Windows | Artefak resmi belum ada | Ekspor lewat Colab atau Linux; sementara memakai aset PR #13 |
| Akurasi model di bawah 80 persen | Target laporan tidak tercapai | Siapkan baseline MobileNetV2 dan fine-tune; catat hasil apa adanya |
| Integrasi TFLite mepet | E7 dan E8.3 tidak selesai | Mulai E7.1 segera setelah artefak pertama ada, jangan menunggu model sempurna |
| Beban QA menumpuk di akhir | Bug tidak tertangani | E9.1 disusun minggu 5, uji fungsional bertahap sejak minggu 9 |
| Firebase belum dikonfigurasi | E3.1 dan E8.7 tertahan | Buat proyek Firebase dan `google-services.json` minggu 5 (jangan di-commit) |

---

## 7. Aturan pelaksanaan

1. Satu tugas = satu branch = satu PR; branch dari `dev`, PR ke `dev`. `main`
   hanya menerima penggabungan `dev` pada akhir milestone.
2. Maksimal 2 tugas aktif per orang.
3. Tugas yang tertahan prasyarat tidak diambil; pindah ke tugas independen.
4. Setiap Jumat: perbarui status di papan Notion dan logbook.
5. Setiap Minggu: rekap mingguan dan perbarui dokumen ini bila ada pergeseran.
6. Scope freeze pada 30 November: setelah itu hanya perbaikan bug, pengujian, dan
   laporan.

---

## 8. Prioritas eksekusi minggu 6

| Prioritas | Tugas | Alasan | Perkiraan |
|---|---|---|---|
| P0 | E2.4, E2.6 | Melengkapi penyimpanan dan menjaga lapisan data | 2–3 Nov |
| P0 | E7.5, rapikan UI auth | Aplikasi tetap berguna saat model gagal dan tidak menyesatkan pengguna | 4 Nov |
| P0 | E9.1 | Harus ada sebelum pengujian formal | 3 Nov |
| P1 | E4.6 ekspor TFLite | Artefak resmi untuk integrasi | 4–6 Nov |
| P1 | E6.5 metrik Model 3 | Bahan laporan ML | 6 Nov |
| P1 | E5.3, E5.4 | Melengkapi modul warna | 4–5 Nov |
| P1 | E8.6, E8.1, E8.7 | Menuntaskan fitur aplikasi | 2–5 Nov |
| P2 | Label 9 kelas, E7.6 latensi | Akurasi label dan performa | 3–5 Nov |
| P2 | Dokumentasi metode ML | Bukti laporan | 7 Nov |
| P3 | E8.3, E8.5, E9.2 ke atas, E10.2 ke atas | Menyusul setelah fitur stabil | Minggu 7–9 |

CP-3 Milestone 2 tetap **27 November** dan scope freeze 30 November.
