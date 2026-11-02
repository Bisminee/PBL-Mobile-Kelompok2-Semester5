"""
Sera-Z — E4.4 (bagian data): Penyeimbang kelas & sumber untuk TRAIN.

Val/test TIDAK PERNAH disentuh di sini — evaluasi harus dari data asli.

Default  : hanya LAPORAN + RENCANA (aman dicek dulu).
--apply  : eksekusi. Dua aksi (bisa salah satu/bkeduanya):
  1) Oversample kelas minoritas: duplikasi file TRAIN sampai ~`--target-frac`
     dari kelas terbesar (file duplikat diberi suffix _dupN).
  2) --cap-source NAMA:FRAKSI  (mis. fashion_products:0.6): batasi proporsi
     satu sumber di train; kelebihannya DIPINDAHKAN (bukan dihapus) ke
     ml/data/processed/model1/_excluded/<kelas>/ supaya bisa dikembalikan.

Cara pakai:
  python ml/scripts/02_balance_train.py
  python ml/scripts/02_balance_train.py --apply
  python ml/scripts/02_balance_train.py --apply --cap-source fashion_products:0.6
"""
from __future__ import annotations

import argparse
import shutil
from pathlib import Path

import pandas as pd

ROOT = Path(__file__).resolve().parents[2]
M1 = ROOT / "ml" / "data" / "processed" / "model1"
TRAIN = M1 / "train"
EXCL = M1 / "_excluded"
META = M1 / "metadata.csv"


def load_train() -> pd.DataFrame:
    if not META.exists():
        raise SystemExit("metadata.csv belum ada — jalankan 01_prepare_model1.py dulu.")
    df = pd.read_csv(META)
    df = df[df["split"] == "train"].copy()
    df["abs"] = df["file"].map(lambda f: M1 / f)
    df = df[df["abs"].map(Path.exists)]
    if df.empty:
        raise SystemExit("Tidak ada file train yang ditemukan. Jalankan ulang 01_.")
    return df


def overview(df: pd.DataFrame, label: str) -> None:
    print(f"--- {label} ---")
    print(df.groupby("target").size().sort_values(ascending=False).to_string())
    print("proporsi sumber:", df["source"].value_counts(normalize=True).round(3).to_dict())


def plan_oversample(df: pd.DataFrame, frac: float) -> tuple[int, dict[str, int]]:
    counts = df.groupby("target").size()
    biggest = int(counts.max())
    target = max(1, int(frac * biggest))
    plan = {c: target - int(n) for c, n in counts.items() if int(n) < target}
    return target, plan


def apply_oversample(df: pd.DataFrame, plan: dict[str, int]) -> None:
    for cls, need in plan.items():
        files = df.loc[df["target"] == cls, "abs"].tolist()
        for i in range(need):
            src: Path = files[i % len(files)]
            dst = src.with_name(f"{src.stem}_dup{i}{src.suffix}")
            shutil.copy2(src, dst)
        print(f"  oversample {cls:12s}: +{need} file")


def apply_cap(df: pd.DataFrame, spec: str) -> None:
    try:
        source, frac_s = spec.rsplit(":", 1)
        frac = float(frac_s)
    except ValueError:
        raise SystemExit(f"--cap-source format salah: '{spec}' (contoh: fashion_products:0.6)")

    total = len(df)
    keep_n = int(frac * total)
    rows = df[df["source"] == source]
    if len(rows) <= keep_n:
        print(f"  cap {source}: {len(rows)} file ≤ batas {keep_n} — tidak ada yang dipindah.")
        return
    to_move = rows.sample(n=len(rows) - keep_n, random_state=42)
    for _, r in to_move.iterrows():
        src: Path = r["abs"]
        dst = EXCL / str(r["target"]) / src.name
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.move(str(src), str(dst))
    print(f"  cap {source}: {len(to_move)} file dipindah ke {EXCL} "
          f"(kembalikan manual bila perlu)")


def final_counts() -> pd.Series:
    files = [p for p in TRAIN.rglob("*") if p.suffix.lower() in {".jpg", ".jpeg", ".png"}]
    classes = [p.parent.name for p in files]
    return pd.Series(classes).value_counts().sort_values(ascending=False)


def main() -> None:
    ap = argparse.ArgumentParser(description="Seimbangkan TRAIN Model 1.")
    ap.add_argument("--apply", action="store_true",
                    help="eksekusi (default hanya laporan)")
    ap.add_argument("--target-frac", type=float, default=0.5,
                    help="target kelas minoritas = frac x kelas terbesar (default 0.5)")
    ap.add_argument("--cap-source", action="append", default=[],
                    metavar="NAMA:FRAKSI",
                    help="batasi proporsi sumber di train, boleh diulang")
    args = ap.parse_args()

    df = load_train()
    overview(df, "TRAIN sekarang")

    target, plan = plan_oversample(df, args.target_frac)
    print(f"\nRencana oversample: target ~ {target} file/kelas")
    print("  kelas yang ditambah:", plan if plan else "(tidak ada, sudah seimbang)")

    if args.cap_source:
        print("Rencana cap sumber:")
        for spec in args.cap_source:
            print("  ", spec)

    if not args.apply:
        print("\nLaporan saja. Jalankan lagi dengan --apply untuk eksekusi.")
        return

    print("\nEksekusi...")
    if plan:
        apply_oversample(df, plan)
    for spec in args.cap_source:
        apply_cap(df, spec)

    print("\n--- Jumlah file TRAIN setelah eksekusi ---")
    print(final_counts().to_string())
    print("\nTips: latih ulang model (04_train_yolo11n.py). "
          "Cek juga proporsi sumber bila memakai --cap-source.")


if __name__ == "__main__":
    main()
