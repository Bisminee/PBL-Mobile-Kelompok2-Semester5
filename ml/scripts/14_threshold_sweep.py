"""
Sera-Z — Validasi ambang confidence untuk penolakan objek bukan pakaian.

Menjalankan model pada test set, lalu menghitung untuk beberapa ambang:
  - akurasi pada foto pakaian yang diterima,
  - persentase foto pakaian yang salah ditolak,
  - persentase objek `other` yang berhasil ditolak.

Cara pakai:
  python ml/scripts/14_threshold_sweep.py
  python ml/scripts/14_threshold_sweep.py --weights ml/runs/model1_hf_v2/weights/best.pt
  python ml/scripts/14_threshold_sweep.py --data ml/data/processed/model1

Output:
  ml/reports/model1_v2_threshold_sweep.csv
  tabel ringkas di terminal

Prasyarat: ultralytics, pandas, tqdm. Dataset test harus punya metadata.csv.
"""
from __future__ import annotations

import argparse
from pathlib import Path

import pandas as pd
from tqdm import tqdm

ROOT = Path(__file__).resolve().parents[2]
M1 = ROOT / "ml" / "data" / "processed" / "model1"
REPORTS = ROOT / "ml" / "reports"
DEFAULT_WEIGHTS = ROOT / "ml" / "runs" / "model1_hf_v2" / "weights" / "best.pt"
NOT_GARMENT = "other"


def main() -> None:
    ap = argparse.ArgumentParser(
        description="Sapuan ambang confidence untuk kelas other.")
    ap.add_argument("--data", default=str(M1))
    ap.add_argument("--weights", default=str(DEFAULT_WEIGHTS))
    ap.add_argument("--out", default=str(REPORTS / "model1_v2_threshold_sweep.csv"))
    ap.add_argument("--chunk", type=int, default=64)
    args = ap.parse_args()

    data = Path(args.data)
    weights = Path(args.weights)
    if not (data / "metadata.csv").exists():
        raise SystemExit(f"metadata.csv tidak ada di {data}")
    if not weights.exists():
        raise SystemExit(f"Weights tidak ditemukan: {weights}")

    try:
        from ultralytics import YOLO
    except ImportError:
        raise SystemExit("Ultralytics belum terpasang: pip install ultralytics")

    meta = pd.read_csv(data / "metadata.csv")
    test = meta[meta["split"] == "test"].copy()
    test["abs"] = test["file"].map(lambda f: data / f)
    test = test[test["abs"].map(Path.exists)].reset_index(drop=True)
    if test.empty:
        raise SystemExit("Test set kosong.")

    model = YOLO(str(weights))
    preds: list[str] = []
    confs: list[float] = []

    for i in range(0, len(test), args.chunk):
        batch = [str(p) for p in test["abs"].iloc[i:i + args.chunk]]
        hasil = model.predict(batch, imgsz=224, verbose=False)
        for r in hasil:
            preds.append(r.names[int(r.probs.top1)])
            confs.append(float(r.probs.top1conf))
        print(f"  {min(i + args.chunk, len(test))}/{len(test)}", end="\r")
    print()

    test["pred"] = preds
    test["conf"] = confs

    pakaian = test[test["target"] != NOT_GARMENT]
    negatif = test[test["target"] == NOT_GARMENT]

    baris = []
    for ambang in [round(0.30 + 0.05 * i, 2) for i in range(13)]:
        if pakaian.empty:
            continue
        diterima = pakaian[
            (pakaian["pred"] != NOT_GARMENT) & (pakaian["conf"] >= ambang)
        ]
        akurasi = (
            (diterima["pred"] == diterima["target"]).mean()
            if not diterima.empty else 0.0
        )
        salah_tolak = 1 - len(diterima) / len(pakaian)
        tolak_benar = (
            ((negatif["pred"] == NOT_GARMENT) | (negatif["conf"] < ambang)).mean()
            if not negatif.empty else 0.0
        )
        baris.append({
            "threshold": ambang,
            "pakaian_diterima": len(diterima),
            "akurasi_pakaian": round(float(akurasi), 4),
            "pakaian_salah_ditolak": round(float(salah_tolak), 4),
            "bukan_pakaian_ditolak": round(float(tolak_benar), 4),
        })

    tabel = pd.DataFrame(baris)
    REPORTS.mkdir(parents=True, exist_ok=True)
    tabel.to_csv(args.out, index=False)
    print(tabel.to_string(index=False))

    # Ambang rekomendasi: penolakan other minimal 95 persen dan pakaian salah
    # ditolak maksimal 10 persen. Kalau tidak ada, ambil penolakan other tertinggi.
    layak = tabel[
        (tabel["bukan_pakaian_ditolak"] >= 0.95)
        & (tabel["pakaian_salah_ditolak"] <= 0.10)
    ]
    if not layak.empty:
        pilih = layak.iloc[0]
    else:
        pilih = tabel.sort_values("bukan_pakaian_ditolak", ascending=False).iloc[0]

    print(
        f"\nAmbang rekomendasi: {pilih['threshold']:.2f} "
        f"(other ditolak {pilih['bukan_pakaian_ditolak'] * 100:.1f} persen, "
        f"pakaian salah ditolak {pilih['pakaian_salah_ditolak'] * 100:.1f} persen, "
        f"akurasi pakaian {pilih['akurasi_pakaian'] * 100:.2f} persen)"
    )
    print(f"CSV: {args.out}")


if __name__ == "__main__":
    main()
