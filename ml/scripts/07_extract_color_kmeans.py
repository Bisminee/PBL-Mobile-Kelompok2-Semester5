"""
Sera-Z — 03. Modul 2: Ekstraksi Warna Dominan Pakaian (K-Means Clustering)
Script CLI untuk mendeteksi warna dominan pakaian dan memetakan ke 14 palet warna Sera-Z.
"""

from pathlib import Path
import cv2
import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans

ROOT = Path(__file__).resolve().parents[2]
DATA_DIR = ROOT / "ml" / "data" / "processed" / "model1" / "test"
RUNS_DIR = ROOT / "ml" / "runs"
RUNS_DIR.mkdir(parents=True, exist_ok=True)

# Palet 14 Warna Standar Sera-Z (RGB)
PALETTE_RGB = {
    "black":  np.array([20, 20, 20]),
    "white":  np.array([245, 245, 245]),
    "gray":   np.array([128, 128, 128]),
    "navy":   np.array([20, 35, 75]),
    "blue":   np.array([30, 100, 200]),
    "denim":  np.array([70, 110, 150]),
    "brown":  np.array([110, 65, 35]),
    "beige":  np.array([220, 200, 170]),
    "cream":  np.array([245, 235, 210]),
    "green":  np.array([35, 130, 60]),
    "sage":   np.array([140, 165, 135]),
    "red":    np.array([200, 30, 30]),
    "maroon": np.array([115, 20, 35]),
    "yellow": np.array([240, 210, 40]),
    "pink":   np.array([230, 140, 170]),
    "orange": np.array([235, 115, 30]),
}


def preprocess_foreground(img_bgr, crop_ratio=0.8):
    h, w = img_bgr.shape[:2]
    ch, cw = int(h * crop_ratio), int(w * crop_ratio)
    y1, x1 = (h - ch) // 2, (w - cw) // 2
    cropped = img_bgr[y1:y1+ch, x1:x1+cw]

    rgb = cv2.cvtColor(cropped, cv2.COLOR_BGR2RGB)
    hsv = cv2.cvtColor(cropped, cv2.COLOR_BGR2HSV)

    # Filter latar putih/terang jika bukan warna baju asli
    v = hsv[:, :, 2]
    s = hsv[:, :, 1]
    bg_mask = (v > 240) & (s < 25)
    fg_pixels = rgb[~bg_mask]

    if len(fg_pixels) < 100:
        fg_pixels = rgb.reshape(-1, 3)

    return rgb, fg_pixels


def map_to_nearest_palette(rgb_color):
    min_dist = float("inf")
    closest_name = "gray"
    for name, p_rgb in PALETTE_RGB.items():
        dist = np.linalg.norm(rgb_color - p_rgb)
        if dist < min_dist:
            min_dist = dist
            closest_name = name
    return closest_name


def extract_dominant_colors(image_path, k=3):
    img_bgr = cv2.imread(str(image_path))
    if img_bgr is None:
        return None, None, None, None

    rgb_img, fg_pixels = preprocess_foreground(img_bgr)

    kmeans = KMeans(n_clusters=k, random_state=42, n_init="auto")
    kmeans.fit(fg_pixels)

    centers = kmeans.cluster_centers_.astype(int)
    _, counts = np.unique(kmeans.labels_, return_counts=True)
    percentages = counts / len(kmeans.labels_)

    sorted_indices = np.argsort(percentages)[::-1]
    sorted_centers = centers[sorted_indices]
    sorted_pcts = percentages[sorted_indices]

    color_names = [map_to_nearest_palette(c) for c in sorted_centers]
    return rgb_img, sorted_centers, sorted_pcts, color_names


def run_color_extraction_demo():
    print("=" * 65)
    print("SERA-Z ML PIPELINE: 03. EKSTRAKSI WARNA DOMINAN (K-MEANS)")
    print("=" * 65)

    sample_images = list(DATA_DIR.glob("*/*.jpg"))[:5] if DATA_DIR.exists() else []
    if not sample_images:
        print(f"[-] Tidak menemukan sampel gambar di: {DATA_DIR}")
        return

    print(f"[+] Menjalankan ekstraksi pada {len(sample_images)} sampel gambar...\n")

    fig, axes = plt.subplots(len(sample_images), 2, figsize=(8, 3 * len(sample_images)))
    if len(sample_images) == 1:
        axes = [axes]

    for i, img_p in enumerate(sample_images):
        rgb_img, centers, pcts, names = extract_dominant_colors(img_p, k=3)
        cat_name = img_p.parent.name.upper()

        print(f"[*] Gambar {i+1} [{cat_name}]:")
        for rank, (c_name, p) in enumerate(zip(names, pcts), 1):
            print(f"    - Warna {rank}: {c_name.upper()} ({p*100:.1f}%)")

        axes[i][0].imshow(rgb_img)
        axes[i][0].set_title(f"{cat_name}\nDominan: {names[0].upper()} ({pcts[0]*100:.1f}%)", fontsize=10)
        axes[i][0].axis("off")

        bar_matrix = np.zeros((50, 300, 3), dtype=np.uint8)
        start_x = 0
        for c, p in zip(centers, pcts):
            end_x = start_x + int(p * 300)
            bar_matrix[:, start_x:end_x] = c
            start_x = end_x

        axes[i][1].imshow(bar_matrix)
        axes[i][1].set_title(" | ".join([f"{n} ({p*100:.0f}%)" for n, p in zip(names, pcts)]), fontsize=9)
        axes[i][1].axis("off")

    plt.tight_layout()
    out_swatch = RUNS_DIR / "color_kmeans_sample.png"
    plt.savefig(out_swatch, dpi=150)
    plt.close()

    print(f"\n[+] Visualisasi swatch warna disimpan di: {out_swatch}")
    print("[OK] Modul 2 (K-Means Warna) Selesai!")


if __name__ == "__main__":
    run_color_extraction_demo()
