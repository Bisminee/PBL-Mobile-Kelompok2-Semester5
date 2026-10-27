"""
Sera-Z — E4.4: Latih model utama YOLOv11n-cls (transfer learning ImageNet).

Cara pakai:
  python ml/scripts/04_train_yolo11n.py
  python ml/scripts/04_train_yolo11n.py --epochs 60 --batch 16 --device cpu
  python ml/scripts/04_train_yolo11n.py --cls-pw 0.5     # jika versi mendukung

Prasyarat: 01_prepare_model1.py (+ opsional 02_balance_train.py) sudah jalan.
Output: ml/runs/model1_yolo11n/weights/best.pt + kurva/confusion matrix Ultralytics
"""
from __future__ import annotations

import argparse
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
M1 = ROOT / "ml" / "data" / "processed" / "model1"
RUNS = ROOT / "ml" / "runs"


def sanity_check() -> None:
    for split in ("train", "val"):
        d = M1 / split
        if not d.exists():
            raise SystemExit(f"Folder {d} tidak ada — jalankan 01_prepare_model1.py dulu.")
    train_cls = sorted(p.name for p in (M1 / "train").iterdir() if p.is_dir())
    val_cls = sorted(p.name for p in (M1 / "val").iterdir() if p.is_dir())
    if train_cls != val_cls:
        raise SystemExit(f"Kelas train != val:\n train={train_cls}\n val={val_cls}")
    n_train = sum(1 for _ in (M1 / "train").rglob("*.jpg"))
    n_val = sum(1 for _ in (M1 / "val").rglob("*.jpg"))
    print(f"Kelas ({len(train_cls)}): {train_cls}")
    print(f"Train: {n_train} gambar | Val: {n_val} gambar")


def main() -> None:
    ap = argparse.ArgumentParser(description="Latih YOLOv11n-cls untuk Model 1.")
    ap.add_argument("--model", default="yolo11n-cls.pt",
                    help="checkpoint awal (ImageNet). Proyek memakai yolo11n-cls.")
    ap.add_argument("--epochs", type=int, default=40)
    ap.add_argument("--imgsz", type=int, default=224)
    ap.add_argument("--batch", type=int, default=32, help="turunkan kalau OOM/RAM habis")
    ap.add_argument("--patience", type=int, default=8, help="early stopping")
    ap.add_argument("--device", default="", help="kosong=otomatis, 'cpu', atau '0' (GPU)")
    ap.add_argument("--name", default="model1_yolo11n")
    ap.add_argument("--cls-pw", type=float, default=None,
                    help="pembobotan kelas (0-1) bila versi Ultralytics mendukung")
    args = ap.parse_args()

    try:
        from ultralytics import YOLO
    except ImportError:
        raise SystemExit("Ultralytics belum terpasang: pip install ultralytics")

    sanity_check()
    RUNS.mkdir(parents=True, exist_ok=True)

    model = YOLO(args.model)          # ImageNet pretrained = transfer learning
    common = dict(
        data=str(M1),
        epochs=args.epochs,
        imgsz=args.imgsz,
        batch=args.batch,
        patience=args.patience,
        seed=42,                       # reproduksibel untuk laporan
        project=str(RUNS),
        name=args.name,
        exist_ok=True,
    )
    if args.device:
        common["device"] = args.device

    print(f"\nMulai latih: {args.model} | epochs={args.epochs} | imgsz={args.imgsz}\n")
    if args.cls_pw is not None:
        try:
            model.train(cls_pw=args.cls_pw, **common)
        except Exception as e:      # versi lama tidak mengenal cls_pw
            print(f"[!] cls_pw tidak didukung di versi ini ({e.__class__.__name__}). "
                  f"Lanjut tanpa cls_pw — andalkan 02_balance_train.py untuk imbalance.")
            model.train(**common)
    else:
        model.train(**common)

    best = RUNS / args.name / "weights" / "best.pt"
    print(f"\nSelesai. Checkpoint terbaik: {best}")
    print("Langkah berikutnya: python ml/scripts/05_eval_model1.py "
          f"--weights \"{best}\"")


if __name__ == "__main__":
    main()
