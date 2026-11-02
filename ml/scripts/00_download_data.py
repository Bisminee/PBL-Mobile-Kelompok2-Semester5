"""
Sera-Z — 00: Unduh Otomatis 3 Dataset Mentah (Kaggle).

Dataset yang diunduh:
  1. Clothing Dataset Full (CC0)            -> ml/data/raw/clothing-full/
  2. Fashion Product Images Small (MIT)     -> ml/data/raw/fashion-products/
  3. Clothes Dataset Carousell (MIT)        -> ml/data/raw/carousell/

Cara pakai:
  python ml/scripts/00_download_data.py
"""
from __future__ import annotations

import os
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
RAW = ROOT / "ml" / "data" / "raw"

DATASETS = [
    {
        "name": "clothing-full",
        "kaggle_slug": "agrigorev/clothing-dataset-full",
        "check_file": "images.csv",
    },
    {
        "name": "fashion-products",
        "kaggle_slug": "paramaggarwal/fashion-product-images-small",
        "check_file": "styles.csv",
    },
    {
        "name": "carousell",
        "kaggle_slug": "ryanbadai/clothes-dataset",
        "check_file": None,
    },
]


def create_junction(src: Path, dst: Path) -> bool:
    """Buat Windows directory junction bila di OS Windows."""
    if os.name == "nt":
        try:
            cmd = f'cmd /c mklink /J "{dst}" "{src}"'
            res = subprocess.run(cmd, capture_output=True, text=True, shell=True)
            return res.returncode == 0
        except Exception:
            return False
    return False


def download_with_kagglehub(target_folder: Path, slug: str, name: str) -> bool:
    try:
        import kagglehub
    except ImportError:
        print("[!] Library kagglehub belum terpasang. Install via: pip install kagglehub")
        return False

    print(f"\n[*] Mengunduh {name} ({slug}) via kagglehub...")
    try:
        cached_path = Path(kagglehub.dataset_download(slug))
        print(f"    Selesai diunduh ke cache: {cached_path}")

        # Sambungkan ke folder raw via junction atau copy
        if target_folder.exists():
            return True

        if create_junction(cached_path, target_folder):
            print(f"    Berhasil membuat link junction -> {target_folder}")
            return True

        print(f"    Menyalin file ke {target_folder}...")
        shutil.copytree(cached_path, target_folder, dirs_exist_ok=True)
        return True
    except Exception as e:
        print(f"[!] Gagal mengunduh via kagglehub: {e}")
        return False


def download_with_kaggle_cli(target_folder: Path, slug: str, name: str) -> bool:
    target_folder.mkdir(parents=True, exist_ok=True)
    print(f"\n[*] Mengunduh {name} ({slug}) via Kaggle CLI...")
    cmd = [
        "kaggle", "datasets", "download",
        "-d", slug,
        "-p", str(target_folder),
        "--unzip"
    ]
    try:
        res = subprocess.run(cmd, capture_output=True, text=True)
        if res.returncode == 0:
            print(f"    Berhasil diunduh dan diekstrak ke: {target_folder}")
            return True
        else:
            print(f"[!] Kaggle CLI error: {res.stderr.strip()}")
            return False
    except FileNotFoundError:
        print("[!] Command 'kaggle' tidak ditemukan di sistem.")
        return False


def main() -> None:
    RAW.mkdir(parents=True, exist_ok=True)
    print(f"Lokasi penyimpanan dataset mentah: {RAW}")

    all_ok = True
    for ds in DATASETS:
        name = ds["name"]
        slug = ds["kaggle_slug"]
        check_file = ds["check_file"]
        target = RAW / name

        # Periksa apakah sudah ada dan valid
        if target.exists():
            if check_file is None or (target / check_file).exists():
                print(f"[OK] {name} sudah tersedia di {target}")
                continue

        # Coba unduh via kagglehub dulu
        success = download_with_kagglehub(target, slug, name)
        if not success:
            # Fallback ke Kaggle CLI
            success = download_with_kaggle_cli(target, slug, name)

        if not success:
            all_ok = False
            print(f"[PERINGATAN] Gagal mengunduh {name}.")
            print(f"Silakan unduh manual dari: https://www.kaggle.com/datasets/{slug}")
            print(f"Lalu ekstrak ke: {target}")

    if all_ok:
        print("\nSemua dataset mentah siap!")
        print("Langkah selanjutnya: python ml/scripts/01_prepare_model1.py")
    else:
        print("\nAda dataset yang belum lengkap. Periksa pesan di atas.")


if __name__ == "__main__":
    main()
