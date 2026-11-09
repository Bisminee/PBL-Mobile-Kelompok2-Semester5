"""
Sera-Z — Unduh otomatis foto objek BUKAN pakaian untuk kelas "other".

Sumber: COCO 2017 lewat Hugging Face `detection-datasets/coco`.
Isinya foto sehari-hari: laptop, meja, kursi, orang, botol, TV, buku, dapur,
dan ruangan. Cocok menjadi contoh "ini bukan pakaian" saat kamera diarahkan
sembarangan.

Lisensi: anotasi COCO CC BY 4.0; gambar berasal dari Flickr dengan lisensi
Creative Commons. Aman untuk keperluan akademik, cantumkan sumbernya di
laporan.

Cara pakai:
  python ml/scripts/11_download_negatives.py                 # 800 foto
  python ml/scripts/11_download_negatives.py --count 500
  python ml/scripts/11_download_negatives.py --out ml/data/raw/negatives
  python ml/scripts/11_download_negatives.py --no-prefer-indoor

Hasil: file .jpg di ml/data/raw/negatives/, siap dipakai oleh:
  python ml/scripts/09_prepare_hf.py --negatives ml/data/raw/negatives

Prasyarat: pip install datasets pillow tqdm
"""
from __future__ import annotations

import argparse
from pathlib import Path

from tqdm import tqdm

ROOT = Path(__file__).resolve().parents[2]
DEFAULT_OUT = ROOT / "ml" / "data" / "raw" / "negatives"
DEFAULT_DATASET = "detection-datasets/coco"

# Kategori COCO yang sering muncul saat kamera diarahkan sembarangan.
# Dipakai agar foto yang diambil benar-benar relevan, bukan pemandangan acak.
KATEGORI_DALAM_RUANG = {
    "person",
    "laptop",
    "keyboard",
    "mouse",
    "tv",
    "cell phone",
    "remote",
    "book",
    "clock",
    "vase",
    "potted plant",
    "chair",
    "couch",
    "bed",
    "dining table",
    "bottle",
    "wine glass",
    "cup",
    "bowl",
    "microwave",
    "oven",
    "toaster",
    "sink",
    "refrigerator",
}


def nama_kategori(ds, row) -> set[str]:
    """Ambil nama kategori COCO untuk satu baris (ClassLabel bisa berupa int)."""
    names = ds.features["objects"].feature["category"].names
    raw = row.get("objects", {}).get("category", [])
    return {names[c] if isinstance(c, int) else c for c in raw}


def main() -> None:
    ap = argparse.ArgumentParser(
        description="Unduh foto objek bukan pakaian dari COCO 2017.")
    ap.add_argument("--dataset", default=DEFAULT_DATASET)
    ap.add_argument("--count", type=int, default=800,
                    help="jumlah foto yang disimpan (default 800)")
    ap.add_argument("--out", default=str(DEFAULT_OUT))
    ap.add_argument("--prefer-indoor", dest="prefer_indoor",
                    action="store_true", default=True,
                    help="utamakan foto yang memuat benda/ruangan (default)")
    ap.add_argument("--no-prefer-indoor", dest="prefer_indoor",
                    action="store_false",
                    help="terima semua foto COCO")
    ap.add_argument("--exclude-person-only", dest="exclude_person_only",
                    action="store_true", default=True,
                    help="buang foto yang hanya berisi orang (default)")
    ap.add_argument("--include-person-only", dest="exclude_person_only",
                    action="store_false")
    ap.add_argument("--max-size", type=int, default=640,
                    help="sisi terpanjang gambar setelah disimpan")
    args = ap.parse_args()

    if args.count < 1:
        raise SystemExit("--count harus lebih dari 0.")

    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)

    # Cegah menimpa hasil sebelumnya tanpa disadari.
    sudah = list(out.glob("coco_*.jpg"))
    if len(sudah) >= args.count:
        print(f"{out} sudah berisi {len(sudah)} foto COCO. "
              f"Tidak ada yang diunduh. Hapus dulu bila ingin mengulang.")
        return

    try:
        from datasets import load_dataset
    except ImportError:
        raise SystemExit("Library datasets belum terpasang: pip install datasets")

    print(f"Memuat {args.dataset} (streaming, tidak mengunduh seluruh dataset)...")
    ds = load_dataset(args.dataset, split="train", streaming=True)

    disimpan = 0
    dilewati = 0
    for row in tqdm(ds, total=args.count, desc="mengunduh"):
        kategori = nama_kategori(ds, row)

        if args.exclude_person_only and kategori == {"person"}:
            dilewati += 1
            continue
        if args.prefer_indoor and not (kategori & KATEGORI_DALAM_RUANG):
            dilewati += 1
            continue

        gambar = row["image"]
        if gambar is None or min(gambar.width, gambar.height) < 200:
            dilewati += 1
            continue

        # Perkecil agar folder negatif tidak membengkak.
        if max(gambar.size) > args.max_size:
            rasio = args.max_size / max(gambar.size)
            gambar = gambar.resize(
                (round(gambar.width * rasio), round(gambar.height * rasio)))

        path = out / f"coco_{row['image_id']}.jpg"
        if path.exists():
            continue  # sudah pernah diunduh
        gambar.convert("RGB").save(path, format="JPEG", quality=90)
        disimpan += 1

        if disimpan >= args.count:
            break

    print(f"\nSelesai: {disimpan} foto disimpan di {out}")
    if dilewati:
        print(f"{dilewati} foto dilewati (tidak sesuai filter).")
    print("\nLanjutkan dengan:")
    print(f"  python ml/scripts/09_prepare_hf.py --force --negatives \"{out}\"")


if __name__ == "__main__":
    main()
