"""
Sera-Z — E4.5: Evaluasi Model 1 pada test set.

Yang dihasilkan (target E4.5 laporan):
  - Top-1 / Top-5 (dari model.val Ultralytics, bila tersedia)
  - Accuracy, macro F1, classification report per kelas
  - Confusion matrix (PNG)
  - Akurasi PER SUMBER dataset (clothing_full / fashion_products / carousell)
  - Daftar pasangan kelas yang paling sering tertukar

Cara pakai:
  python ml/scripts/05_eval_model1.py                          # pakai weights default
  python ml/scripts/05_eval_model1.py --weights path/best.pt

Output: ml/reports/model1_test_*  (di-commit sebagai bukti evaluasi)
Prasyarat: 01_ sudah jalan; 04_ (atau 03_) sudah selesai.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pandas as pd
from sklearn.metrics import (ConfusionMatrixDisplay, accuracy_score,
                             classification_report, confusion_matrix, f1_score)

ROOT = Path(__file__).resolve().parents[2]
M1 = ROOT / "ml" / "data" / "processed" / "model1"
REPORTS = ROOT / "ml" / "reports"
DEFAULT_WEIGHTS = ROOT / "ml" / "runs" / "model1_yolo11n" / "weights" / "best.pt"


def predict_files(model, files: list[Path], chunk: int = 64):
    """Jalankan prediksi per batch kecil; kembalikan (nama_pred, confidence)."""
    names, confs = [], []
    for i in range(0, len(files), chunk):
        batch = [str(p) for p in files[i:i + chunk]]
        results = model.predict(batch, verbose=False)
        for r in results:
            names.append(r.names[int(r.probs.top1)])
            confs.append(float(r.probs.top1conf))
        print(f"  {min(i + chunk, len(files))}/{len(files)}", end="\r")
    print()
    return names, confs


def main() -> None:
    ap = argparse.ArgumentParser(description="Evaluasi Model 1 pada test set.")
    ap.add_argument("--weights", default=str(DEFAULT_WEIGHTS))
    args = ap.parse_args()

    weights = Path(args.weights)
    if not weights.exists():
        raise SystemExit(f"Weights tidak ditemukan: {weights}\n"
                         f"Latih dulu (04_train_yolo11n.py) atau isi --weights.")
    if not (M1 / "metadata.csv").exists():
        raise SystemExit("metadata.csv tidak ada — jalankan 01_prepare_model1.py dulu.")

    try:
        from ultralytics import YOLO
    except ImportError:
        raise SystemExit("Ultralytics belum terpasang: pip install ultralytics")

    REPORTS.mkdir(parents=True, exist_ok=True)
    model = YOLO(str(weights))

    # --- Top-1/Top-5 resmi dari Ultralytics (kalau didukung) ------------------
    try:
        metrics = model.val(data=str(M1), split="test")
        print(f"Ultralytics val: top1={metrics.top1:.4f} top5={metrics.top5:.4f}")
    except Exception as e:
        print(f"(Lewati model.val: {e})")

    # --- Prediksi lengkap pada test set ---------------------------------------
    meta = pd.read_csv(M1 / "metadata.csv")
    test = meta[meta["split"] == "test"].copy()
    test["abs"] = test["file"].map(lambda f: M1 / f)
    test = test[test["abs"].map(Path.exists)].reset_index(drop=True)
    if test.empty:
        raise SystemExit("Test set kosong — periksa metadata.csv (split='test').")

    print(f"Prediksi {len(test)} gambar test...")
    preds, confs = predict_files(model, test["abs"].tolist())
    test["pred"] = preds
    test["conf"] = confs

    labels = sorted(test["target"].unique())
    acc = accuracy_score(test["target"], test["pred"])
    f1 = f1_score(test["target"], test["pred"], average="macro")
    report = classification_report(test["target"], test["pred"], digits=3)
    print(f"\nTEST — accuracy {acc:.4f} | macro F1 {f1:.4f}\n")
    print(report)

    # --- Simpan laporan --------------------------------------------------------
    (REPORTS / "model1_test_report.txt").write_text(
        f"weights: {weights}\naccuracy: {acc:.4f}\nmacro_f1: {f1:.4f}\n\n{report}",
        encoding="utf8")

    cm = confusion_matrix(test["target"], test["pred"], labels=labels)
    disp = ConfusionMatrixDisplay(cm, display_labels=labels)
    fig, ax = plt.subplots(figsize=(10, 9))
    disp.plot(ax=ax, xticks_rotation=45, colorbar=False)
    fig.tight_layout()
    fig.savefig(REPORTS / "model1_test_confusion_matrix.png", dpi=150)
    print("Confusion matrix: ml/reports/model1_test_confusion_matrix.png")

    # --- Per sumber -------------------------------------------------------------
    per_rows = []
    for src, g in test.groupby("source"):
        per_rows.append({"source": src, "n": len(g),
                         "accuracy": accuracy_score(g["target"], g["pred"]),
                         "macro_f1": f1_score(g["target"], g["pred"], average="macro")})
    per_source = pd.DataFrame(per_rows).set_index("source").round(4)
    per_source.to_csv(REPORTS / "model1_test_per_source.csv")
    print("\nAkurasi per sumber:\n", per_source.to_string(), sep="")

    # --- Pasangan kelas paling sering tertukar ---------------------------------
    pairs = []
    for i, a in enumerate(labels):
        for j, b in enumerate(labels):
            if i != j and cm[i, j] > 0:
                pairs.append((cm[i, j], a, b))
    pairs.sort(reverse=True)
    print("\nTop kekeliruan (benar -> diprediksi):")
    for n, a, b in pairs[:5]:
        print(f"  {a:12s} -> {b:12s} : {n}")

    summary = {
        "weights": str(weights),
        "n_test": int(len(test)),
        "accuracy": round(float(acc), 4),
        "macro_f1": round(float(f1), 4),
        "per_source": per_source.reset_index().to_dict(orient="records"),
        "top_confusions": [{"count": int(n), "true": a, "pred": b}
                           for n, a, b in pairs[:5]],
    }
    (REPORTS / "model1_test_summary.json").write_text(
        json.dumps(summary, indent=2), encoding="utf8")
    print("\nRingkasan: ml/reports/model1_test_summary.json")


if __name__ == "__main__":
    main()
