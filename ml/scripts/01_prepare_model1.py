"""
Sera-Z — E4.1/E4.2: Siapkan & gabungkan dataset Model 1.

Menggabungkan 3 dataset (semua lisensi bersih) menjadi satu struktur folder
Ultralytics:

    ml/data/processed/model1/
      train/<kelas>/*.jpg
      val/<kelas>/*.jpg
      test/<kelas>/*.jpg
      metadata.csv          # split,target,source,source_label,file,orig_path

Dataset:
  1. Clothing Dataset Full        (CC0)  -> ml/data/raw/clothing-full/
  2. Fashion Product Images Small (MIT)  -> ml/data/raw/fashion-products/
  3. Clothes Dataset Carousell    (MIT)  -> ml/data/raw/carousell/

Cara pakai:
  python ml/scripts/01_prepare_model1.py --dry-run   # cek tanpa menyalin
  python ml/scripts/01_prepare_model1.py             # jalankan penuh
  python ml/scripts/01_prepare_model1.py --force     # timpa hasil sebelumnya

Catatan:
  - Split 70/15/15 dilakukan PER DATASET (stratified per kelas, seed 42),
    baru digabung — supaya proporsi tiap sumber adil di tiap split.
  - Dedup md5 mencegah gambar identik muncul di train & test (kebocoran).
  - Struktur folder Carousell bisa berbeda-beda antar unduhan: script mencoba
    deteksi otomatis dari nama folder induk / awalan nama file. Kalau ada
    gambar yang tidak terpetakan, jumlahnya akan dilaporkan di akhir.
"""
from __future__ import annotations

import argparse
import hashlib
import shutil
from pathlib import Path

import pandas as pd
from PIL import Image
from sklearn.model_selection import train_test_split

# ------------------------------------------------------------------ konstanta
ROOT = Path(__file__).resolve().parents[2]          # root repo (PBL/)
RAW = ROOT / "ml" / "data" / "raw"
OUT = ROOT / "ml" / "data" / "processed" / "model1"
LABEL_MAPS = ROOT / "ml" / "label_maps"

SEED = 42
MIN_PER_CLASS = 5          # kelas dengan < 5 sampel per sumber dibuang
IMG_EXT = {".jpg", ".jpeg", ".png"}


# ------------------------------------------------------------------ utilitas
def load_map(name: str) -> dict[str, str]:
    """Baca tabel pemetaan label dari ml/label_maps/<name>.csv."""
    df = pd.read_csv(LABEL_MAPS / name)
    return dict(zip(df["source_label"].astype(str), df["target"]))


def is_valid_image(path: Path) -> bool:
    """True kalau file benar-benar gambar yang bisa dibuka."""
    try:
        Image.open(path).verify()
        return True
    except Exception:
        return False


def md5(path: Path) -> str:
    return hashlib.md5(path.read_bytes()).hexdigest()


def index_images(base: Path) -> dict[str, Path]:
    """Peta stem -> path (untuk mencari gambar yang tidak di lokasi standar)."""
    if not base.exists():
        return {}
    return {p.stem: p for p in base.rglob("*") if p.suffix.lower() in IMG_EXT}


def resolve(base: Path, stem: str, index: dict[str, Path],
            patterns: list[str]) -> Path | None:
    """Cari gambar: coba pola standar dulu, lalu fallback ke index."""
    for pat in patterns:
        p = base / pat.format(stem=stem)
        if p.exists():
            return p
    return index.get(stem)


# ------------------------------------------------------------------ kolektor
def collect_clothing_full(rows: list[dict], notes: list[str]) -> None:
    base = RAW / "clothing-full"
    csv = base / "images.csv"
    if not csv.exists():
        notes.append(f"[clothing-full] TIDAK DITEMUKAN: {csv} — lewati.")
        return

    mapping = load_map("clothing_full.csv")
    df = pd.read_csv(csv)
    df = df[df["label"].isin(mapping) & (~df["kids"].astype(bool))]

    index = index_images(base)
    ok = 0
    for _, r in df.iterrows():
        stem = str(r["image"])
        path = resolve(base, stem, index,
                       ["images/{stem}.jpg", "images/{stem}.jpeg",
                        "images-1024/{stem}.jpg", "images-512/{stem}.jpg"])
        if path is None:
            continue
        rows.append(dict(path=path, target=mapping[r["label"]],
                         source="clothing_full", source_label=r["label"],
                         uid=stem))
        ok += 1
    notes.append(f"[clothing-full] {ok} gambar siap diproses.")


def collect_fashion_products(rows: list[dict], notes: list[str]) -> None:
    base = RAW / "fashion-products"
    csv = base / "styles.csv"
    if not csv.exists():
        notes.append(f"[fashion-products] TIDAK DITEMUKAN: {csv} — lewati.")
        return

    mapping = load_map("fashion_products.csv")
    df = pd.read_csv(csv, on_bad_lines="skip")
    df = df[df["articleType"].isin(mapping)
            & df["gender"].isin(["Men", "Women", "Unisex"])]

    index = index_images(base / "images")
    ok = 0
    for _, r in df.iterrows():
        stem = str(r["id"])
        path = resolve(base / "images", stem, index, ["{stem}.jpg"])
        if path is None:
            continue
        rows.append(dict(path=path, target=mapping[r["articleType"]],
                         source="fashion_products",
                         source_label=r["articleType"], uid=stem))
        ok += 1
    notes.append(f"[fashion-products] {ok} gambar siap diproses.")


def collect_carousell(rows: list[dict], notes: list[str]) -> None:
    base = RAW / "carousell"
    if not base.exists():
        notes.append(f"[carousell] TIDAK DITEMUKAN: {base} — lewati.")
        return

    mapping = load_map("carousell.csv")
    imgs = [p for p in base.rglob("*") if p.suffix.lower() in IMG_EXT]
    ok, skipped = 0, 0
    for p in imgs:
        # Coba: (a) nama folder induk, (b) awalan nama file sebelum '_'/'-'
        label = p.parent.name if p.parent.name in mapping else None
        if label is None:
            for sep in ("_", "-"):
                head = p.stem.split(sep)[0]
                if head in mapping:
                    label = head
                    break
        if label is None:
            skipped += 1
            continue
        rows.append(dict(path=p, target=mapping[label], source="carousell",
                         source_label=label, uid=p.stem))
        ok += 1
    notes.append(f"[carousell] {ok} gambar terpetakan, {skipped} dilewati "
                 f"(periksa struktur folder bila angka 'dilewati' besar!).")


# ------------------------------------------------------------------ split
def split_per_source(df: pd.DataFrame) -> pd.DataFrame:
    """Split 70/15/15 per sumber, stratified per kelas."""
    parts: list[pd.DataFrame] = []
    for src, g in df.groupby("source"):
        # buang kelas yang terlalu kecil agar stratify tidak error
        counts = g.groupby("target")["target"].transform("size")
        g = g[counts >= MIN_PER_CLASS].copy()
        if g.empty:
            continue
        train, tmp = train_test_split(g, test_size=0.30,
                                      stratify=g["target"], random_state=SEED)
        val, test = train_test_split(tmp, test_size=0.50,
                                     stratify=tmp["target"], random_state=SEED)
        parts += [train.assign(split="train"),
                  val.assign(split="val"),
                  test.assign(split="test")]
    return pd.concat(parts, ignore_index=True)


# ------------------------------------------------------------------ utama
def main() -> None:
    ap = argparse.ArgumentParser(description="Gabungkan dataset Model 1.")
    ap.add_argument("--dry-run", action="store_true",
                    help="hanya laporkan, tidak menyalin file")
    ap.add_argument("--force", action="store_true",
                    help="hapus hasil sebelumnya di processed/model1/")
    args = ap.parse_args()

    if OUT.exists() and not args.dry_run:
        if args.force:
            shutil.rmtree(OUT)
        else:
            raise SystemExit(
                f"{OUT} sudah ada. Jalankan dengan --force untuk menimpa, "
                f"atau hapus folder itu dulu. (--dry-run aman.)")

    # 1. Kumpulkan dari 3 dataset
    rows: list[dict] = []
    notes: list[str] = []
    collect_clothing_full(rows, notes)
    collect_fashion_products(rows, notes)
    collect_carousell(rows, notes)

    df = pd.DataFrame(rows)
    if df.empty:
        raise SystemExit("Tidak ada data. Pastikan dataset sudah diunduh ke ml/data/raw/.\n"
                         + "\n".join(notes))

    # 2. Validasi gambar + dedup md5
    print("Validasi gambar...")
    df = df[df["path"].map(lambda p: Path(p).exists() and is_valid_image(Path(p)))]
    df["md5"] = df["path"].map(lambda p: md5(Path(p)))
    n_before = len(df)
    df = df.drop_duplicates("md5").drop(columns="md5").reset_index(drop=True)
    notes.append(f"[dedup] {n_before} → {len(df)} gambar "
                 f"({n_before - len(df)} duplikat dibuang).")

    # 3. Split per sumber + gabung
    df = split_per_source(df)

    # 4. Simpan ke struktur folder Ultralytics
    if args.dry_run:
        print("\n=== DRY-RUN (tidak menyalin) ===")
    else:
        for _, r in df.iterrows():
            split_dir = OUT / r["split"] / r["target"]
            split_dir.mkdir(parents=True, exist_ok=True)
            dst = split_dir / f"{r['source']}_{r['uid']}{Path(r['path']).suffix}"
            shutil.copy2(r["path"], dst)
        df["file"] = df.apply(
            lambda r: f"{r['split']}/{r['target']}/{r['source']}_{r['uid']}"
                      f"{Path(r['path']).suffix}", axis=1)
        df["orig_path"] = df["path"].astype(str)
        df.drop(columns=["path"]).to_csv(OUT / "metadata.csv", index=False)
        print(f"metadata.csv ditulis: {OUT / 'metadata.csv'}")

    # 5. Laporan kewarasan
    print("\n--- Catatan ---")
    for n in notes:
        print(" ", n)

    print("\n--- Jumlah per split x kelas ---")
    print(df.groupby(["split", "target"]).size().unstack(fill_value=0).to_string())

    train = df[df["split"] == "train"]
    if not train.empty:
        print("\n--- Proporsi sumber di TRAIN ---")
        prop = train["source"].value_counts(normalize=True).round(3)
        print(prop.to_string())
        if prop.max() > 0.60:
            print("\n[!] Satu sumber > 60% train. Pertimbangkan "
                  "'python ml/scripts/02_balance_train.py --cap-source <sumber>:0.6'")

    print("\nSelesai." if not args.dry_run else
          "\nDry-run selesai. Jalankan tanpa --dry-run untuk menyalin.")


if __name__ == "__main__":
    main()
