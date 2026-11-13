"""
Sera-Z — E10.2/E4.5: Uji model pada foto lapangan (foto asli, bukan katalog).

Struktur folder yang diharapkan:

    ml/data/raw/field/
      tshirt/      foto kaos dari HP
      shirt/       foto kemeja
      long_sleeve/ foto atasan lengan panjang
      hoodie/      foto hoodie (diharapkan terbaca outerwear)
      pants/       foto celana panjang (diharapkan terbaca long_pants)
      shoes/       foto sepatu
      ...
      other/       foto objek BUKAN pakaian (laptop, meja, tangan, dinding)

Nama folder = kelas yang benar menurut model 10 kelas:
  dress, long_pants, long_sleeve, other, outerwear, shirt, shoes, shorts,
  skirt, tshirt

Folder `other` dipakai untuk mengukur apakah model berhasil menolak objek
bukan pakaian. Foto pakaian yang salah ditolak juga dihitung.

Cara pakai:
  python ml/scripts/10_eval_field.py
  python ml/scripts/10_eval_field.py --weights ml/runs/model1_hf/weights/best.pt
  python ml/scripts/10_eval_field.py --reject-below 0.5

Output:
  ml/reports/field_test_report.txt
  ml/reports/field_test_summary.json
  ml/reports/field_test_confusion_matrix.png

Prasyarat: ultralytics, pillow, scikit-learn, matplotlib.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from PIL import Image
from sklearn.metrics import (ConfusionMatrixDisplay, accuracy_score,
                             classification_report, confusion_matrix)

ROOT = Path(__file__).resolve().parents[2]
REPORTS = ROOT / "ml" / "reports"
DEFAULT_WEIGHTS = ROOT / "ml" / "runs" / "model1_yolo11n" / "weights" / "best.pt"
DEFAULT_FIELD = ROOT / "ml" / "data" / "raw" / "field"

IMG_EXT = {".jpg", ".jpeg", ".png", ".webp"}
NOT_GARMENT = "other"
IMAGE_SIZE = 224


def preprocess(path: Path) -> np.ndarray | None:
    """Samakan dengan aplikasi: sisi pendek di-resize ke 224, lalu center crop.

    Ultralytics membaca array numpy sebagai BGR, jadi kanal dibalik di akhir.
    """
    try:
        im = Image.open(path).convert("RGB")
    except Exception:
        return None

    w, h = im.size
    skala = IMAGE_SIZE / min(w, h)
    im = im.resize((round(w * skala), round(h * skala)), Image.BILINEAR)

    kiri = (im.width - IMAGE_SIZE) // 2
    atas = (im.height - IMAGE_SIZE) // 2
    im = im.crop((kiri, atas, kiri + IMAGE_SIZE, atas + IMAGE_SIZE))

    arr = np.asarray(im, dtype=np.float32)
    return arr[:, :, ::-1]  # RGB -> BGR


def kumpulkan(folder: Path) -> pd.DataFrame:
    """Baca semua foto, ambil nama folder sebagai label benar."""
    baris = []
    for p in sorted(folder.rglob("*")):
        if p.suffix.lower() not in IMG_EXT:
            continue
        # Folder teratas di bawah `field/` adalah labelnya.
        rel = p.relative_to(folder)
        if len(rel.parts) < 2:
            continue
        baris.append({"path": p, "benar": rel.parts[0]})
    if not baris:
        raise SystemExit(
            f"Tidak ada foto di {folder}. Buat subfolder per kelas, "
            f"contoh: {folder / 'tshirt' / 'foto1.jpg'}")
    return pd.DataFrame(baris)


def main() -> None:
    ap = argparse.ArgumentParser(description="Uji model pada foto lapangan.")
    ap.add_argument("--weights", default=str(DEFAULT_WEIGHTS))
    ap.add_argument("--field", default=str(DEFAULT_FIELD))
    ap.add_argument("--reject-below", type=float, default=0.50,
                    help="confidence di bawah ini dianggap bukan pakaian")
    args = ap.parse_args()

    weights = Path(args.weights)
    field = Path(args.field)
    if not weights.exists():
        raise SystemExit(f"Weights tidak ditemukan: {weights}")

    try:
        from ultralytics import YOLO
    except ImportError:
        raise SystemExit("Ultralytics belum terpasang: pip install ultralytics")

    df = kumpulkan(field)
    print(f"{len(df)} foto dari {field}")
    print(df["benar"].value_counts().to_string())

    dikenal = {"dress", "long_pants", "long_sleeve", "outerwear", "shirt",
               "shoes", "shorts", "skirt", "tshirt", NOT_GARMENT}
    asing = sorted(set(df["benar"]) - dikenal)
    if asing:
        print(f"[!] Nama folder tidak dikenal model: {asing}. "
              f"Daftar yang benar: {sorted(dikenal)}")

    REPORTS.mkdir(parents=True, exist_ok=True)

    model = YOLO(str(weights))
    preds, confs, dilewati = [], [], 0

    for i, r in enumerate(df.itertuples(), start=1):
        arr = preprocess(r.path)
        if arr is None:
            dilewati += 1
            preds.append("(rusak)")
            confs.append(0.0)
            continue
        hasil = model.predict(arr, imgsz=IMAGE_SIZE, verbose=False)[0]
        idx = int(hasil.probs.top1)
        preds.append(hasil.names[idx])
        confs.append(float(hasil.probs.top1conf))
        if i % 10 == 0 or i == len(df):
            print(f"  {i}/{len(df)}", end="\r")
    print()

    if dilewati:
        print(f"[!] {dilewati} foto tidak bisa dibaca dan dilewati.")

    df["pred"] = preds
    df["conf"] = confs
    # Aturan yang sama dengan aplikasi: kelas "other" atau confidence rendah = ditolak.
    df["ditolak"] = (df["pred"] == NOT_GARMENT) | (df["conf"] < args.reject_below)
    df.to_csv(REPORTS / "field_test_per_image.csv", index=False)

    # --- Foto objek bukan pakaian -------------------------------------------
    neg = df[df["benar"] == NOT_GARMENT]
    if len(neg):
        benar_tolak = int(neg["ditolak"].sum())
        print(f"\nObjek bukan pakaian: {benar_tolak}/{len(neg)} berhasil ditolak "
              f"({benar_tolak / len(neg) * 100:.1f}%).")
    else:
        print("\n[!] Tidak ada folder 'other'. Penolakan objek tidak bisa diukur.")
        benar_tolak = 0

    # --- Foto pakaian --------------------------------------------------------
    pakaian = df[df["benar"] != NOT_GARMENT].copy()
    if pakaian.empty:
        raise SystemExit("Tidak ada foto pakaian. Isi minimal satu subfolder kelas.")

    # Akurasi dihitung hanya pada foto pakaian yang tidak ditolak.
    dipakai = pakaian[~pakaian["ditolak"]]
    acc = accuracy_score(dipakai["benar"], dipakai["pred"]) if len(dipakai) else 0.0
    salah_tolak = int(pakaian["ditolak"].sum())

    print(f"\nFoto pakaian: {len(pakaian)}")
    print(f"  salah ditolak : {salah_tolak} "
          f"({salah_tolak / len(pakaian) * 100:.1f}%)")
    print(f"  akurasi sisanya: {acc * 100:.2f}%")

    laporan = ""
    if len(dipakai):
        laporan = classification_report(dipakai["benar"], dipakai["pred"], digits=3)
        print("\n" + laporan)

        labels = sorted(set(dipakai["benar"]) | set(dipakai["pred"]))
        cm = confusion_matrix(dipakai["benar"], dipakai["pred"], labels=labels)
        fig, ax = plt.subplots(figsize=(9, 8))
        ConfusionMatrixDisplay(cm, display_labels=labels).plot(
            ax=ax, xticks_rotation=45, colorbar=False)
        fig.tight_layout()
        fig.savefig(REPORTS / "field_test_confusion_matrix.png", dpi=150)
        print("Confusion matrix: ml/reports/field_test_confusion_matrix.png")

    # --- Per kelas ------------------------------------------------------------
    print("\nPer kelas:")
    for kelas, g in pakaian.groupby("benar"):
        lulus = g[~g["ditolak"]]
        a = accuracy_score(lulus["benar"], lulus["pred"]) if len(lulus) else 0.0
        print(f"  {kelas:14s} n={len(g):3d}  ditolak={int(g['ditolak'].sum()):3d}  "
              f"akurasi={a * 100:5.1f}%")

    # --- Simpan ringkasan -----------------------------------------------------
    (REPORTS / "field_test_report.txt").write_text(
        f"weights: {weights}\n"
        f"foto: {len(df)}\n"
        f"bukan_pakaian_total: {len(neg)}\n"
        f"bukan_pakaian_ditolak: {benar_tolak}\n"
        f"pakaian_total: {len(pakaian)}\n"
        f"pakaian_salah_ditolak: {salah_tolak}\n"
        f"akurasi_pakaian: {acc:.4f}\n\n{laporan}",
        encoding="utf8")

    ringkas = {
        "weights": str(weights),
        "n_foto": int(len(df)),
        "n_bukan_pakaian": int(len(neg)),
        "bukan_pakaian_ditolak": benar_tolak,
        "n_pakaian": int(len(pakaian)),
        "pakaian_salah_ditolak": salah_tolak,
        "akurasi_pakaian": round(float(acc), 4),
        "reject_below": args.reject_below,
    }
    (REPORTS / "field_test_summary.json").write_text(
        json.dumps(ringkas, indent=2), encoding="utf8")
    print("\nRingkasan: ml/reports/field_test_summary.json")


if __name__ == "__main__":
    main()
