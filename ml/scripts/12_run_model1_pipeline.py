"""
Sera-Z — Jalankan seluruh pipeline Model 1 dengan satu perintah.

Urutan yang dijalankan:
  1. Unduh foto objek bukan pakaian dari COCO 2017 (kelas "other").
  2. Siapkan dataset 10 kelas (9 pakaian + other).
  3. Latih YOLOv11n-cls.
  4. Evaluasi pada test set katalog.
  5. Evaluasi pada foto lapangan, bila folder foto lapangan ada.
  6. Ekspor TFLite int8 (otomatis dilewati di Windows).

Cara pakai:
  python ml/scripts/12_run_model1_pipeline.py --device 0
  python ml/scripts/12_run_model1_pipeline.py --device 0 --epochs 40
  python ml/scripts/12_run_model1_pipeline.py --device 0 --finetune
  python ml/scripts/12_run_model1_pipeline.py --device 0 --count-negatives 1200

Fine-tune (latih ulang dari model sebelumnya, bukan dari ImageNet):
  python ml/scripts/12_run_model1_pipeline.py --device 0 --finetune --epochs 10

Melewati tahap tertentu:
  --skip-negatives   pakai folder negatif yang sudah ada
  --skip-prepare     pakai dataset yang sudah disiapkan
  --skip-train       hanya evaluasi/ekspor
  --skip-export      jangan ekspor TFLite

Prasyarat: pip install -r ml/requirements.txt
"""
from __future__ import annotations

import argparse
import importlib.util
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SCRIPTS = ROOT / "ml" / "scripts"
NEGATIVES = ROOT / "ml" / "data" / "raw" / "negatives"
M1 = ROOT / "ml" / "data" / "processed" / "model1"
FIELD = ROOT / "ml" / "data" / "raw" / "field"
RUNS = ROOT / "ml" / "runs"
EXPORTED = ROOT / "assets" / "models"

# modul yang diimpor -> nama paket pip
DEPENDENSI = {
    "datasets": "datasets",
    "PIL": "pillow",
    "tqdm": "tqdm",
    "pandas": "pandas",
    "sklearn": "scikit-learn",
    "matplotlib": "matplotlib",
    "ultralytics": "ultralytics",
}


def cek_dependensi() -> None:
    """Berhenti dengan pesan jelas bila paket Python belum terpasang."""
    kurang = [
        paket for modul, paket in DEPENDENSI.items()
        if importlib.util.find_spec(modul) is None
    ]
    if not kurang:
        return
    print("Dependensi belum terpasang: " + ", ".join(kurang))
    print("\nJalankan perintah ini dulu:")
    print(f"  {sys.executable} -m pip install " + " ".join(kurang))
    raise SystemExit(1)


def cek_perangkat(device: str) -> str:
    """Turunkan ke CPU bila GPU diminta tetapi CUDA tidak tersedia."""
    if not device or device == "cpu":
        return device or "cpu"
    try:
        import torch
    except ImportError:
        print("[!] PyTorch belum terpasang; memakai CPU.")
        return "cpu"
    if not torch.cuda.is_available():
        print(
            "[!] --device 0 diminta, tetapi CUDA tidak tersedia di komputer ini. "
            "Latihan memakai CPU dan akan lambat (berjam-jam). Untuk hasil cepat, "
            "jalankan di Google Colab dengan GPU T4."
        )
        return "cpu"
    return device


def jalankan(nama: str, argumen: list[str]) -> None:
    """Jalankan satu script pipeline dan hentikan bila gagal."""
    perintah = [sys.executable, str(SCRIPTS / nama), *argumen]
    print("\n" + "=" * 70)
    print("Menjalankan:", " ".join(perintah[1:]))
    print("=" * 70 + "\n")
    subprocess.run(perintah, cwd=ROOT, check=True)


def jumlah_foto(folder: Path, pola: str = "*") -> int:
    if not folder.exists():
        return 0
    return sum(1 for p in folder.rglob(pola) if p.is_file())


def main() -> None:
    ap = argparse.ArgumentParser(
        description="Pipeline Model 1 Sera-Z dari unduh data sampai TFLite.")
    ap.add_argument("--device", default="", help="'0' untuk GPU, 'cpu' untuk CPU")
    ap.add_argument("--epochs", type=int, default=30)
    ap.add_argument("--batch", type=int, default=64)
    ap.add_argument("--imgsz", type=int, default=224)
    ap.add_argument("--workers", type=int, default=8)
    ap.add_argument("--name", default="model1_hf_v2")
    ap.add_argument("--count-negatives", type=int, default=800)
    ap.add_argument("--finetune", action="store_true",
                    help="latih ulang dari best.pt, bukan dari ImageNet")
    ap.add_argument("--lr0", type=float, default=None,
                    help="learning rate awal; otomatis 0.001 bila --finetune")
    ap.add_argument("--skip-negatives", action="store_true")
    ap.add_argument("--skip-prepare", action="store_true")
    ap.add_argument("--skip-train", action="store_true")
    ap.add_argument("--skip-export", action="store_true")
    args = ap.parse_args()

    cek_dependensi()
    args.device = cek_perangkat(args.device)

    # ---------------------------------------------------------------- 1. data
    if not args.skip_negatives:
        ada = jumlah_foto(NEGATIVES, "*.jpg")
        if ada >= 100:
            print(f"[negatives] {ada} foto sudah ada, unduh dilewati.")
        else:
            jalankan("11_download_negatives.py",
                     ["--count", str(args.count_negatives)])

    # ------------------------------------------------------------- 2. prepare
    if not args.skip_prepare:
        argumen = ["--force"]
        if jumlah_foto(NEGATIVES, "*.jpg") >= 100:
            argumen += ["--negatives", str(NEGATIVES)]
        else:
            print("[prepare] Folder negatif kosong: dataset akan 9 kelas. "
                  "Hapus baris 'other' dari assets/models/labels.txt.")
        jalankan("09_prepare_hf.py", argumen)

    if not M1.exists():
        raise SystemExit(f"Dataset tidak ada: {M1}. Jalankan tanpa --skip-prepare.")

    # --------------------------------------------------------------- 3. latih
    weights = None
    if not args.skip_train:
        if args.finetune:
            kandidat = sorted(
                RUNS.glob("*/weights/best.pt"),
                key=lambda p: p.stat().st_mtime,
                reverse=True,
            )
            if not kandidat:
                raise SystemExit(
                    "--finetune butuh best.pt dari latihan sebelumnya, "
                    "tetapi tidak ada di ml/runs/.")
            weights = kandidat[0]
            print(f"[finetune] Mulai dari: {weights}")
        else:
            weights = Path("yolo11n-cls.pt")

        lr0 = args.lr0
        if lr0 is None and args.finetune:
            lr0 = 0.001

        jalankan("04_train_yolo11n.py", [
            "--data", str(M1),
            "--model", str(weights),
            "--epochs", str(args.epochs),
            "--batch", str(args.batch),
            "--imgsz", str(args.imgsz),
            "--workers", str(args.workers),
            "--name", args.name,
            *(["--device", args.device] if args.device else []),
            *(["--lr0", str(lr0)] if lr0 is not None else []),
        ])

    best = RUNS / args.name / "weights" / "best.pt"
    if not best.exists():
        kandidat = sorted(
            RUNS.glob("*/weights/best.pt"),
            key=lambda p: p.stat().st_mtime,
            reverse=True,
        )
        if not kandidat:
            raise SystemExit("best.pt tidak ditemukan. Latihan gagal?")
        best = kandidat[0]
        print(f"[i] Memakai model terbaru: {best}")

    # ---------------------------------------------------------------- 4. eval
    jalankan("05_eval_model1.py",
             ["--data", str(M1), "--weights", str(best)])

    # -------------------------------------------------------- 5. foto lapangan
    if jumlah_foto(FIELD, "*.jpg") >= 20:
        jalankan("10_eval_field.py", ["--weights", str(best)])
    else:
        print("\n[i] Foto lapangan belum ada (minimal 20). Tahap 5 dilewati.")

    # -------------------------------------------------------------- 6. ekspor
    if args.skip_export:
        return

    if sys.platform.startswith("win"):
        print(
            "\n[!] Ekspor TFLite dilewati: Ultralytics tidak mendukungnya di "
            "Windows. Jalankan 06_export_tflite.py di Colab atau Linux.\n"
            f"    Model siap diekspor: {best}"
        )
        return

    jalankan("06_export_tflite.py", [
        "--data", str(M1),
        "--weights", str(best),
        "--out-name", "model1_yolo11n_v2.tflite",
    ])
    print(f"\nTFLite ada di: {EXPORTED / 'model1_yolo11n_v2.tflite'}")
    print("Salin ke assets/models/yolo11n_cls.tflite, lalu build ulang aplikasi.")


if __name__ == "__main__":
    main()
