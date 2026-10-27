"""
Sera-Z — E4.6: Ekspor model terbaik ke TFLite int8 → assets/models/.

Cara pakai:
  python ml/scripts/06_export_tflite.py
  python ml/scripts/06_export_tflite.py --weights ml/runs/model1_yolo11n/weights/best.pt

Output: assets/models/model1_yolo11n_v1.tflite  (target ≤ ~20 MB, E7.6)
Prasyarat: 04_train_yolo11n.py sudah selesai (best.pt ada).
"""
from __future__ import annotations

import argparse
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
M1 = ROOT / "ml" / "data" / "processed" / "model1"
ASSETS = ROOT / "assets" / "models"
DEFAULT_WEIGHTS = ROOT / "ml" / "runs" / "model1_yolo11n" / "weights" / "best.pt"


def main() -> None:
    ap = argparse.ArgumentParser(description="Ekspor Model 1 ke TFLite int8.")
    ap.add_argument("--weights", default=str(DEFAULT_WEIGHTS))
    ap.add_argument("--imgsz", type=int, default=224)
    ap.add_argument("--out-name", default="model1_yolo11n_v1.tflite")
    args = ap.parse_args()

    weights = Path(args.weights)
    if not weights.exists():
        raise SystemExit(f"Weights tidak ditemukan: {weights}")

    try:
        from ultralytics import YOLO
    except ImportError:
        raise SystemExit("Ultralytics belum terpasang: pip install ultralytics")

    model = YOLO(str(weights))

    # int8 butuh data kalibrasi; nama format bisa "tflite" (umum) / "litert" (baru)
    exported = None
    for fmt in ("tflite", "litert"):
        try:
            exported = model.export(format=fmt, int8=True, imgsz=args.imgsz,
                                    data=str(M1))
            print(f"Export sukses (format={fmt}) -> {exported}")
            break
        except Exception as e:
            print(f"[!] format='{fmt}' gagal: {e.__class__.__name__}: {e}")

    if exported is None:
        raise SystemExit("Export gagal. Baca error di atas "
                         "(biasanya perlu 'pip install tensorflow onnx onnxslim onnxruntime').")

    # Cari file .tflite hasil export
    src = Path(str(exported)) if isinstance(exported, (str, Path)) else None
    if src is None or not Path(src).exists():
        candidates = sorted(weights.parent.glob("*.tflite"),
                            key=lambda p: p.stat().st_mtime, reverse=True)
        if not candidates:
            raise SystemExit("File .tflite tidak ditemukan di folder weights.")
        src = candidates[0]

    ASSETS.mkdir(parents=True, exist_ok=True)
    dst = ASSETS / args.out_name
    shutil.copy2(src, dst)
    mb = dst.stat().st_size / 1_000_000
    print(f"\nDisalin: {src.name} -> {dst} ({mb:.1f} MB)")
    if mb > 20:
        print("[!] > 20 MB. Pertimbangkan imgsz lebih kecil / model lebih ringan (E7.6).")

    # Verifikasi cepat (kalau tensorflow ada)
    try:
        import tensorflow as tf
        it = tf.lite.Interpreter(model_path=str(dst))
        it.allocate_tensors()
        inp = it.get_input_details()[0]
        out = it.get_output_details()[0]
        print(f"Verifikasi OK. Input {inp['shape']} {inp['dtype']} | "
              f"Output {out['shape']} {out['dtype']} (9 kelas)")
    except Exception as e:
        print(f"(Verifikasi TF dilewati: {e})")

    print("\nSerahkan ke E7.1 bersama model card: input 224x224 RGB, "
          "output urutan 9 kelas (urut abjad folder), metrik dari 05_eval.")


if __name__ == "__main__":
    main()
