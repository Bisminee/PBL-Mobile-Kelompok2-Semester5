"""
Sera-Z - Hitung data aksesoris untuk ml/reports/accessory-dataset.md.

Script ini hanya membaca berkas lokal dan tidak mengubah dataset. Angka di
dokumen riset aksesoris berasal dari keluaran script ini, sehingga bisa diulang.

Yang dihitung:

1. Fashion Product Images (Small): baris styles.csv dengan
   masterCategory == Accessories, gender Men/Women/Unisex, dan berkas gambar
   ada. Baris dibaca dengan memisah pada 9 koma pertama, karena sebagian
   productDisplayName memuat koma. Parser CSV ketat (misalnya pandas dengan
   on_bad_lines="skip" di 01_prepare_model1.py) membuang baris itu; jumlahnya
   ikut dilaporkan.
2. Clothing Dataset Full: label Hat, kids == False, dan berkas gambar ada.
3. Jumlah per kelas usulan (pemetaan articleType di CLASS_MAP).
4. Opsional, Open Images V7: jumlah gambar unik per kelas pada berkas anotasi
   bbox validasi dan uji, bila --openimages-dir diberikan. Berkas yang dicari:
   oidv7-class-descriptions-boxable.csv, validation-annotations-bbox.csv,
   test-annotations-bbox.csv (unduh dari storage.googleapis.com/openimages).

Pemakaian:
    python ml/scripts/count_accessory_dataset.py
    python ml/scripts/count_accessory_dataset.py --openimages-dir D:/openimages
"""

import argparse
import csv
import json
from collections import Counter, defaultdict
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
RAW = ROOT / "ml" / "data" / "raw"
REPORT_PATH = ROOT / "ml" / "reports" / "accessory_counts.json"

ADULT = {"Men", "Women", "Unisex"}
STYLES_FIELDS = 10

# Kelas usulan -> articleType Fashion Product Images.
CLASS_MAP = {
    "bag": [
        "Handbags", "Backpacks", "Clutches", "Duffel Bag", "Laptop Bag",
        "Messenger Bag", "Mobile Pouch", "Rucksacks", "Waist Pouch", "Wallets",
    ],
    "watch": ["Watches"],
    "eyewear": ["Sunglasses"],
    "belt": ["Belts"],
    "hat": ["Caps", "Hat"],
}
# Tambahan dari Clothing Dataset Full per kelas usulan.
CLOTHING_FULL_MAP = {"hat": ["Hat"]}

OPENIMAGES_CLASSES = [
    "Handbag", "Backpack", "Belt", "Glasses", "Sunglasses", "Hat", "Sun hat",
    "Fedora", "Cowboy hat", "Watch", "Necklace", "Scarf", "Tie", "Glove",
    "Fashion accessory", "Briefcase",
]


def display_path(path):
    path = Path(path).resolve()
    try:
        return path.relative_to(ROOT).as_posix()
    except ValueError:
        return str(path)


def image_ids(folder):
    return {p.stem for p in Path(folder).iterdir() if p.is_file()}


def count_fashion_products(base):
    images = image_ids(base / "images")
    rows, extra_comma = [], 0
    with open(base / "styles.csv", encoding="utf-8") as f:
        next(f)
        for line in f:
            line = line.rstrip("\r\n")
            if not line:
                continue
            if line.count(",") > STYLES_FIELDS - 1:
                extra_comma += 1
            rows.append(line.split(",", STYLES_FIELDS - 1))

    acc = [r for r in rows if r[2] == "Accessories"]
    adult = [r for r in acc if r[1] in ADULT]
    kept = [r for r in adult if r[0] in images]
    kept_extra_comma = sum(1 for r in kept if "," in r[9])

    return kept, {
        "styles_rows": len(rows),
        "rows_with_extra_comma": extra_comma,
        "accessories_all_gender": len(acc),
        "accessories_adult": len(adult),
        "accessories_adult_with_image": len(kept),
        "accessories_dropped_by_strict_csv": kept_extra_comma,
        "accessories_seen_by_01_prepare": len(kept) - kept_extra_comma,
        "by_subcategory": dict(Counter(r[3] for r in kept).most_common()),
        "by_article_type": dict(Counter(r[4] for r in kept).most_common()),
    }


def count_clothing_full(base):
    images = image_ids(base / "images_original")
    with open(base / "images.csv", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))
    kept = [r for r in rows if r["kids"] == "False" and r["image"] in images]
    return kept, dict(Counter(r["label"] for r in kept).most_common())


def proposed_classes(fp_rows, cf_rows):
    fp_types = Counter(r[4] for r in fp_rows)
    cf_labels = Counter(r["label"] for r in cf_rows)
    result = {}
    for name, types in CLASS_MAP.items():
        fp = sum(fp_types[t] for t in types)
        cf = sum(cf_labels[t] for t in CLOTHING_FULL_MAP.get(name, []))
        result[name] = {
            "fashion_products": fp,
            "clothing_full": cf,
            "total": fp + cf,
            "article_types": types,
        }
    return result


def count_openimages(folder):
    folder = Path(folder)
    with open(folder / "oidv7-class-descriptions-boxable.csv", encoding="utf-8") as f:
        name_to_mid = {row[1]: row[0] for row in csv.reader(f)}
    missing = [c for c in OPENIMAGES_CLASSES if c not in name_to_mid]
    wanted = {name_to_mid[c]: c for c in OPENIMAGES_CLASSES if c in name_to_mid}

    counts = {}
    for split in ("validation", "test"):
        path = folder / f"{split}-annotations-bbox.csv"
        if not path.exists():
            continue
        seen = defaultdict(set)
        with open(path, encoding="utf-8") as f:
            for row in csv.DictReader(f):
                cls = wanted.get(row["LabelName"])
                if cls:
                    seen[cls].add(row["ImageID"])
        counts[split] = {c: len(seen[c]) for c in OPENIMAGES_CLASSES if c in name_to_mid}

    return {
        "class_ids": {c: name_to_mid[c] for c in OPENIMAGES_CLASSES if c in name_to_mid},
        "missing_classes": missing,
        "images_per_split": counts,
    }


def main():
    parser = argparse.ArgumentParser(description="Hitung data aksesoris")
    parser.add_argument("--raw", type=Path, default=RAW)
    parser.add_argument("--openimages-dir", type=Path, default=None)
    parser.add_argument("--out", type=Path, default=REPORT_PATH)
    args = parser.parse_args()

    fp_rows, fp = count_fashion_products(args.raw / "fashion-products")
    cf_rows, cf = count_clothing_full(args.raw / "clothing-full")
    hats = [r for r in cf_rows if r["label"] == "Hat"]

    summary = {
        "generated": date.today().isoformat(),
        "script": "ml/scripts/count_accessory_dataset.py",
        "fashion_product_images": fp,
        "clothing_full": {"hat_adult_with_image": len(hats)},
        "proposed_classes": proposed_classes(fp_rows, hats),
    }
    if args.openimages_dir:
        summary["open_images_v7"] = count_openimages(args.openimages_dir)

    args.out = args.out.resolve()
    args.out.parent.mkdir(parents=True, exist_ok=True)
    with open(args.out, "w", encoding="utf-8") as f:
        json.dump(summary, f, indent=2, ensure_ascii=False)
        f.write("\n")

    print(f"Fashion Product Images, aksesoris dewasa dengan gambar: {fp['accessories_adult_with_image']}")
    print(f"  dibuang parser CSV ketat (koma di nama produk): {fp['accessories_dropped_by_strict_csv']}")
    print(f"Clothing Dataset Full, Hat dewasa: {len(hats)}")
    print("Kelas usulan:")
    for name, c in summary["proposed_classes"].items():
        print(f"  {name:<8}{c['total']:>6}  (FPI {c['fashion_products']}, CF {c['clothing_full']})")
    if "open_images_v7" in summary:
        oi = summary["open_images_v7"]
        if oi["missing_classes"]:
            print(f"Kelas Open Images tidak ditemukan: {oi['missing_classes']}")
        for split, counts in oi["images_per_split"].items():
            print(f"Open Images {split}: {counts}")
    print(f"Hasil disimpan di: {display_path(args.out)}")


if __name__ == "__main__":
    main()
