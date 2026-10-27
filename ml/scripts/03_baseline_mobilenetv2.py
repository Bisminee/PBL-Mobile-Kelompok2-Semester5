"""
Sera-Z — E4.3: Baseline MobileNetV2 (transfer learning, 2 fase).

Fungsi: model pembanding sederhana sebagai patokan akurasi — syarat E4.5
(laporan wajib membandingkan model utama vs baseline).

Cara pakai:
  python ml/scripts/03_baseline_mobilenetv2.py
  python ml/scripts/03_baseline_mobilenetv2.py --epochs1 5 --epochs2 10 --batch 32

Prasyarat: 01_prepare_model1.py sudah dijalankan (folder train/val ada).
Output:
  ml/runs/baseline_mobilenetv2.pt
  ml/reports/baseline_mobilenetv2_report.txt + _summary.json
"""
from __future__ import annotations

import argparse
import json
import random
from pathlib import Path

import numpy as np
import torch
from sklearn.metrics import accuracy_score, classification_report, f1_score
from torch import nn
from torch.utils.data import DataLoader
from torchvision import datasets, models, transforms

ROOT = Path(__file__).resolve().parents[2]
M1 = ROOT / "ml" / "data" / "processed" / "model1"
RUNS = ROOT / "ml" / "runs"
REPORTS = ROOT / "ml" / "reports"
SEED = 42


def seed_everything(seed: int = SEED) -> None:
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)


def build_loaders(imgsz: int, batch: int):
    train_tf = transforms.Compose([
        transforms.RandomResizedCrop(imgsz, scale=(0.7, 1.0)),
        transforms.RandomHorizontalFlip(),
        transforms.ColorJitter(0.2, 0.2, 0.2),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406],
                             std=[0.229, 0.224, 0.225]),
    ])
    val_tf = transforms.Compose([
        transforms.Resize(int(imgsz * 1.14)),
        transforms.CenterCrop(imgsz),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406],
                             std=[0.229, 0.224, 0.225]),
    ])
    train_ds = datasets.ImageFolder(M1 / "train", train_tf)
    val_ds = datasets.ImageFolder(M1 / "val", val_tf)
    assert train_ds.classes == val_ds.classes, "Urutan kelas train/val tidak sama!"
    print(f"Kelas ({len(train_ds.classes)}):", train_ds.classes)
    print(f"Train: {len(train_ds)} gambar | Val: {len(val_ds)} gambar")

    # num_workers=0 paling aman di Windows
    train_dl = DataLoader(train_ds, batch_size=batch, shuffle=True, num_workers=0)
    val_dl = DataLoader(val_ds, batch_size=batch, shuffle=False, num_workers=0)
    return train_dl, val_dl, train_ds.classes


def evaluate(model, loader, device):
    model.eval()
    ys, ps = [], []
    with torch.no_grad():
        for x, y in loader:
            out = model(x.to(device)).argmax(1).cpu().numpy()
            ys += y.numpy().tolist()
            ps += out.tolist()
    return (accuracy_score(ys, ps), f1_score(ys, ps, average="macro"), ys, ps)


def main() -> None:
    ap = argparse.ArgumentParser(description="Baseline MobileNetV2.")
    ap.add_argument("--epochs1", type=int, default=5, help="epoch fase head")
    ap.add_argument("--epochs2", type=int, default=10, help="epoch fase fine-tune")
    ap.add_argument("--batch", type=int, default=32)
    ap.add_argument("--imgsz", type=int, default=224)
    args = ap.parse_args()

    if not (M1 / "train").exists():
        raise SystemExit("Folder train/ belum ada — jalankan 01_prepare_model1.py dulu.")
    RUNS.mkdir(parents=True, exist_ok=True)
    REPORTS.mkdir(parents=True, exist_ok=True)

    seed_everything()
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print("Device:", device)

    train_dl, val_dl, classes = build_loaders(args.imgsz, args.batch)

    model = models.mobilenet_v2(weights=models.MobileNet_V2_Weights.IMAGENET1K_V2)
    model.classifier[1] = nn.Linear(model.last_channel, len(classes))
    model.to(device)

    criterion = nn.CrossEntropyLoss()
    ckpt_path = RUNS / "baseline_mobilenetv2.pt"
    best_acc = 0.0

    def fit(epochs: int, lr: float, params) -> None:
        nonlocal best_acc
        optimizer = torch.optim.Adam(params, lr=lr)
        for ep in range(1, epochs + 1):
            model.train()
            losses = []
            for x, y in train_dl:
                x, y = x.to(device), y.to(device)
                optimizer.zero_grad()
                loss = criterion(model(x), y)
                loss.backward()
                optimizer.step()
                losses.append(loss.item())
            acc, f1, _, _ = evaluate(model, val_dl, device)
            print(f"  epoch {ep:2d} | loss {np.mean(losses):.4f} | "
                  f"val acc {acc:.4f} | macro F1 {f1:.4f}")
            if acc > best_acc:
                best_acc = acc
                torch.save({"state_dict": model.state_dict(), "classes": classes,
                            "arch": "mobilenet_v2", "val_acc": acc}, ckpt_path)

    # Fase 1 — latih classifier head saja (backbone dibekukan)
    for p in model.features.parameters():
        p.requires_grad = False
    print("\nFase 1: latih head (backbone frozen)")
    fit(args.epochs1, 1e-3, model.classifier.parameters())

    # Fase 2 — buka blok terakhir untuk fine-tune
    for p in model.features[-2:].parameters():
        p.requires_grad = True
    print("\nFase 2: fine-tune blok akhir")
    fit(args.epochs2, 1e-4, filter(lambda p: p.requires_grad, model.parameters()))

    # Evaluasi final dari checkpoint terbaik
    ck = torch.load(ckpt_path, map_location=device, weights_only=False)
    model.load_state_dict(ck["state_dict"])
    acc, f1, ys, ps = evaluate(model, val_dl, device)
    print(f"\nBASELINE MobileNetV2 — val acc {acc:.4f} | macro F1 {f1:.4f}")
    print(f"Checkpoint: {ckpt_path}")

    (REPORTS / "baseline_mobilenetv2_report.txt").write_text(
        classification_report(ys, ps, target_names=classes, digits=3), encoding="utf8")
    (REPORTS / "baseline_mobilenetv2_summary.json").write_text(
        json.dumps({"val_acc": acc, "macro_f1": f1, "classes": classes}, indent=2),
        encoding="utf8")
    print("Laporan: ml/reports/baseline_mobilenetv2_*.{txt,json}")


if __name__ == "__main__":
    main()
