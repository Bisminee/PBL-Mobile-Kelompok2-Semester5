"""
Sera-Z — E4.1/E4.2 (alternatif): Siapkan dataset Model 1 dari Hugging Face.

Mengubah dataset Hugging Face `ashraq/fashion-product-images-small` menjadi
struktur folder Ultralytics yang sama dengan 01_prepare_model1.py:

    <out>/
      train/<kelas>/*.jpg
      val/<kelas>/*.jpg
      test/<kelas>/*.jpg
      metadata.csv          # split,target,source,source_label,file,orig_id

Opsi --negatives menambahkan kelas ke-10 "other" berisi foto objek yang BUKAN
pakaian (laptop, meja, kursi, tangan, dinding). Kelas ini membuat model bisa
menjawab "ini bukan pakaian" alih-alih memaksa memilih kaos atau celana.

Contoh isi folder negatif:

    ml/data/raw/negatives/
      laptop_01.jpg
      meja_02.jpg
      tangan_03.jpg
      ... (bebas, tidak perlu subfolder)

Cara pakai:
  python ml/scripts/13_prepare_hf.py --dry-run
  python ml/scripts/13_prepare_hf.py --force
  python ml/scripts/13_prepare_hf.py --force --negatives ml/data/raw/negatives
  python ml/scripts/13_prepare_hf.py --limit 3000     # uji cepat sebelum run penuh
  python ml/scripts/13_prepare_hf.py --out ml/data/processed/model1_hf

Catatan: dataset HF ini adalah port dari Kaggle
`paramaggarwal/fashion-product-images-small`, isinya sama dengan sumber
`fashion_products` pada pipeline lama.
"""
from __future__ import annotations

import argparse
import hashlib
import io
import shutil
from pathlib import Path

import pandas as pd
from sklearn.model_selection import train_test_split
from tqdm import tqdm

ROOT = Path(__file__).resolve().parents[2]
LABEL_MAPS = ROOT / "ml" / "label_maps"
DEFAULT_OUT = ROOT / "ml" / "data" / "processed" / "model1"
DEFAULT_REPO = "ashraq/fashion-product-images-small"

SEED = 42
MIN_PER_CLASS = 5
GENDERS = ("Men", "Women", "Unisex")
SOURCE = "fashion_products_hf"
NEGATIVE_CLASS = "other"
IMG_EXT = {".jpg", ".jpeg", ".png", ".webp"}


def load_mapping(name: str) -> dict[str, str]:
    """Baca kamus label dari ml/label_maps/<name>.

    Dipisahkan dari fashion_products.csv agar pipeline lama (01_prepare_model1)
    tetap memakai pemetaan aslinya.
    """
    df = pd.read_csv(LABEL_MAPS / name)
    return dict(zip(df["source_label"].astype(str), df["target"].astype(str)))


def build_index(repo_id: str) -> pd.DataFrame:
    """Ambil kolom metadata saja, tanpa mendekode gambar (cepat & hemat RAM)."""
    from datasets import load_dataset

    print(f"Mengunduh metadata {repo_id} (parquet ~270 MB pada run pertama)...")
    ds = load_dataset(repo_id, split="train")
    meta = ds.select_columns(["id", "gender", "articleType"]).to_pandas()
    meta = meta.reset_index().rename(columns={"index": "row"})
    return meta


def filter_and_split(meta: pd.DataFrame, mapping: dict[str, str],
                     val_size: float, test_size: float,
                     limit: int | None) -> pd.DataFrame:
    """Filter label/gender, lalu split stratified per kelas."""
    df = meta[
        meta["articleType"].isin(mapping)
        & meta["gender"].isin(GENDERS)
    ].copy()
    df["target"] = df["articleType"].map(mapping)
    df["source_label"] = df["articleType"]
    df["source"] = SOURCE
    df["src_path"] = None

    counts = df.groupby("target")["target"].transform("size")
    dropped = int((counts < MIN_PER_CLASS).sum())
    df = df[counts >= MIN_PER_CLASS].copy()
    if dropped:
        print(f"[!] {dropped} baris dibuang (kelas < {MIN_PER_CLASS} sampel).")

    if limit is not None and len(df) > limit:
        df = df.groupby("target", group_keys=False).apply(
            lambda g: g.sample(n=max(1, int(round(limit * len(g) / len(df)))),
                              random_state=SEED))
        print(f"[i] --limit aktif: dipakai {len(df)} gambar.")

    df = df.sample(frac=1, random_state=SEED).reset_index(drop=True)

    train, tmp = train_test_split(
        df, test_size=val_size + test_size, stratify=df["target"],
        random_state=SEED)
    rel_val = val_size / (val_size + test_size)
    val, test = train_test_split(
        tmp, test_size=1 - rel_val, stratify=tmp["target"], random_state=SEED)

    return pd.concat([
        train.assign(split="train"),
        val.assign(split="val"),
        test.assign(split="test"),
    ], ignore_index=True)


def load_negatives(folder: Path, val_size: float,
                   test_size: float) -> pd.DataFrame:
    """Kumpulkan foto objek bukan pakaian sebagai kelas 'other'."""
    files = sorted(p for p in folder.rglob("*") if p.suffix.lower() in IMG_EXT)
    if not files:
        raise SystemExit(f"Tidak ada gambar di {folder}. Isi dulu folder negatif.")

    df = pd.DataFrame({
        "row": None,
        "id": [p.stem for p in files],
        "target": NEGATIVE_CLASS,
        "source_label": NEGATIVE_CLASS,
        "source": "negatives",
        "src_path": [str(p) for p in files],
    }).sample(frac=1, random_state=SEED).reset_index(drop=True)

    # Foto negatif biasanya sedikit, jadi cukup dibagi acak tanpa stratify.
    train, tmp = train_test_split(
        df, test_size=val_size + test_size, random_state=SEED)
    rel_val = val_size / (val_size + test_size)
    val, test = train_test_split(
        tmp, test_size=1 - rel_val, random_state=SEED)

    print(f"[negatives] {len(files)} foto bukan pakaian ditambahkan sebagai "
          f"kelas '{NEGATIVE_CLASS}'.")

    return pd.concat([
        train.assign(split="train"),
        val.assign(split="val"),
        test.assign(split="test"),
    ], ignore_index=True)


def image_bytes(ds, r) -> tuple[bytes, str] | None:
    """Ambil byte JPEG untuk satu baris dataset (HF atau folder negatif)."""
    if isinstance(r.src_path, str) and r.src_path:
        path = Path(r.src_path)
        try:
            return path.read_bytes(), path.suffix.lower() or ".jpg"
        except Exception:
            return None

    try:
        image = ds[int(r.row)]["image"]
    except Exception:
        return None

    buf = io.BytesIO()
    image.convert("RGB").save(buf, format="JPEG", quality=95)
    return buf.getvalue(), ".jpg"


def save_split(ds, df: pd.DataFrame, out: Path,
               seen_hashes: set[str]) -> list[dict]:
    """Simpan gambar per split, dedup md5, kembalikan baris metadata."""
    rows: list[dict] = []
    skipped_dup = 0
    for r in tqdm(df.itertuples(), total=len(df), desc="menyimpan gambar"):
        hasil = image_bytes(ds, r)
        if hasil is None:
            continue
        data, ext = hasil

        digest = hashlib.md5(data).hexdigest()
        if digest in seen_hashes:
            skipped_dup += 1
            continue
        seen_hashes.add(digest)

        fname = f"{r.source}_{r.id}{ext}"
        dst = out / r.split / r.target / fname
        dst.parent.mkdir(parents=True, exist_ok=True)
        dst.write_bytes(data)

        rows.append(dict(split=r.split, target=r.target, source=r.source,
                         source_label=r.source_label,
                         file=f"{r.split}/{r.target}/{fname}",
                         orig_id=str(r.id)))

    if skipped_dup:
        print(f"[dedup] {skipped_dup} gambar identik dibuang.")
    return rows


def main() -> None:
    ap = argparse.ArgumentParser(
        description="Siapkan dataset Model 1 dari Hugging Face.")
    ap.add_argument("--repo-id", default=DEFAULT_REPO)
    ap.add_argument("--out", default=str(DEFAULT_OUT),
                    help="folder hasil (default: ml/data/processed/model1)")
    ap.add_argument("--negatives", default=None,
                    help="folder foto objek bukan pakaian (kelas 'other')")
    ap.add_argument("--label-map", default="fashion_products_v3.csv",
                    help="kamus label di ml/label_maps/ (default: versi 10 kelas "
                         "dengan long_sleeve)")
    ap.add_argument("--val", type=float, default=0.15)
    ap.add_argument("--test", type=float, default=0.15)
    ap.add_argument("--limit", type=int, default=None,
                    help="batasi jumlah gambar pakaian untuk uji cepat")
    ap.add_argument("--force", action="store_true",
                    help="hapus folder hasil sebelum menulis")
    ap.add_argument("--dry-run", action="store_true",
                    help="hanya laporkan rencana, tidak menyimpan gambar")
    args = ap.parse_args()

    if args.val <= 0 or args.test <= 0 or args.val + args.test >= 1:
        raise SystemExit("--val dan --test harus > 0 dan totalnya < 1.")

    out = Path(args.out)
    if out.exists() and not args.dry_run:
        if args.force:
            shutil.rmtree(out)
        else:
            raise SystemExit(f"{out} sudah ada. Pakai --force untuk menimpa.")

    mapping = load_mapping(args.label_map)
    meta = build_index(args.repo_id)
    print(f"Total baris dataset: {len(meta)}")

    df = filter_and_split(meta, mapping, args.val, args.test, args.limit)

    if args.negatives:
        neg = load_negatives(Path(args.negatives), args.val, args.test)
        neg["source"] = "negatives"
        df = pd.concat([df, neg], ignore_index=True)
        if len(neg) < 200:
            print("[!] Foto negatif < 200. Tambah lagi agar kelas 'other' kuat.")
    else:
        print("[i] Tanpa --negatives: model hanya bisa memilih jenis pakaian, "
              "tidak bisa menolak objek lain.")

    print("\n--- Jumlah per split x kelas ---")
    print(df.groupby(["split", "target"]).size().unstack(fill_value=0).to_string())

    if args.dry_run:
        print("\nDry-run selesai. Tidak ada file yang disimpan.")
        return

    from datasets import load_dataset
    ds = load_dataset(args.repo_id, split="train")

    rows: list[dict] = []
    seen: set[str] = set()
    for split in ("train", "val", "test"):
        part = df[df["split"] == split]
        print(f"\n[{split}] {len(part)} gambar")
        rows += save_split(ds, part, out, seen)

    pd.DataFrame(rows).to_csv(out / "metadata.csv", index=False)
    print(f"\nmetadata.csv ditulis: {out / 'metadata.csv'}")
    print(f"Total gambar tersimpan: {len(rows)}")
    print("\nLangkah berikutnya:")
    print(f"  python ml/scripts/04_train_yolo11n.py --data \"{out}\" --name model1_hf")


if __name__ == "__main__":
    main()
