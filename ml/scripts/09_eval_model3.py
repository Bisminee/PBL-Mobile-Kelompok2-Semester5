"""
Sera-Z - 09. Evaluasi Model 3 (E6.5): ROC-AUC dan precision@3.

Script ini memakai ulang dataset sintetis, fitur, dan arsitektur MLP dari
08_train_model3_mlp.py, melatih ulang dengan seed tetap, lalu menghitung:

- ROC-AUC, akurasi, precision, recall, dan F1 pada split uji;
- precision@3: untuk setiap atasan (jenis + warna) di split uji, kandidat
  bawahan diurutkan menurut skor model, lalu dihitung proporsi pasangan
  berlabel cocok di tiga teratas.

Pembanding: Random Forest, Logistic Regression, aturan harmoni saja (fitur
color_harmony_score), dan urutan acak.

Script ini tidak menulis ke assets/models. Hasil disimpan di
ml/reports/model3_metrics.json.

Pemakaian:
    python ml/scripts/09_eval_model3.py
    python ml/scripts/09_eval_model3.py --epochs 35 --seed 42 --k 3
"""

import os

os.environ.setdefault("TF_ENABLE_ONEDNN_OPTS", "0")
os.environ.setdefault("TF_CPP_MIN_LOG_LEVEL", "2")

import argparse
import importlib.util
import json
from collections import defaultdict
from datetime import date
from pathlib import Path

import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import (
    accuracy_score,
    f1_score,
    precision_score,
    recall_score,
    roc_auc_score,
)

ROOT = Path(__file__).resolve().parents[2]
SCRIPT_08 = Path(__file__).resolve().parent / "08_train_model3_mlp.py"
REPORT_PATH = ROOT / "ml" / "reports" / "model3_metrics.json"

# Posisi kolom pada vektor 20 fitur (lihat extract_features di script 08).
TOP_CAT_COLS = slice(0, 4)
TOP_HSV_COLS = slice(9, 12)
HARMONY_COL = 18


def load_script_08():
    """Muat 08_train_model3_mlp.py sebagai modul (nama berkas diawali angka)."""
    spec = importlib.util.spec_from_file_location("train_model3", SCRIPT_08)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def classification_metrics(y_true, y_score, threshold=0.5):
    y_pred = (y_score >= threshold).astype(int)
    return {
        "roc_auc": round(float(roc_auc_score(y_true, y_score)), 4),
        "accuracy": round(float(accuracy_score(y_true, y_pred)), 4),
        "precision": round(float(precision_score(y_true, y_pred, zero_division=0)), 4),
        "recall": round(float(recall_score(y_true, y_pred, zero_division=0)), 4),
        "f1": round(float(f1_score(y_true, y_pred, zero_division=0)), 4),
    }


def group_by_top(X):
    """Kelompokkan indeks baris menurut identitas atasan (jenis + warna)."""
    groups = defaultdict(list)
    for i, row in enumerate(X):
        key = tuple(np.round(row[TOP_CAT_COLS], 4)) + tuple(np.round(row[TOP_HSV_COLS], 4))
        groups[key].append(i)
    return groups


def precision_at_k(groups, y_true, y_score, k, rng=None):
    """Rata-rata precision@k per atasan.

    Kelompok dengan kandidat kurang dari k, atau yang labelnya seragam (semua
    cocok atau semua tidak cocok), dilewati karena urutan apa pun memberi nilai
    yang sama.
    Nilai seri dipecah acak bila rng diberikan; tanpa rng, urutan stabil.
    """
    values = []
    for idx in groups.values():
        idx = np.asarray(idx)
        labels = y_true[idx]
        if len(idx) < k or labels.sum() == 0 or labels.all():
            continue
        scores = y_score[idx]
        if rng is not None:
            tiebreak = rng.random(len(idx))
            order = np.lexsort((tiebreak, -scores))
        else:
            order = np.argsort(-scores, kind="stable")
        values.append(labels[order[:k]].mean())
    return float(np.mean(values)), len(values)


def reference_precision_at_k(groups, y_true, k):
    """Precision@k acuan: harapan urutan acak dan batas atas urutan ideal.

    Acak = proporsi positif per kelompok. Ideal = min(jumlah positif, k) / k,
    karena kelompok dengan positif kurang dari k tidak bisa mencapai 1,0.
    """
    random_vals, ideal_vals = [], []
    for idx in groups.values():
        labels = y_true[np.asarray(idx)]
        if len(idx) < k or labels.sum() == 0 or labels.all():
            continue
        random_vals.append(labels.mean())
        ideal_vals.append(min(int(labels.sum()), k) / k)
    return float(np.mean(random_vals)), float(np.mean(ideal_vals))


def main():
    parser = argparse.ArgumentParser(description="Evaluasi Model 3 (E6.5)")
    parser.add_argument("--epochs", type=int, default=35)
    parser.add_argument("--seed", type=int, default=42)
    parser.add_argument("--k", type=int, default=3)
    parser.add_argument("--out", type=Path, default=REPORT_PATH)
    args = parser.parse_args()

    m08 = load_script_08()
    tf = m08.tf
    tf.keras.utils.set_random_seed(args.seed)
    tf.config.experimental.enable_op_determinism()

    print("=" * 65)
    print("SERA-Z ML PIPELINE: 09. EVALUASI MODEL 3 (E6.5)")
    print("=" * 65)

    X_train, X_test, y_train, y_test = m08.build_dataset(seed=args.seed)
    y_test_int = y_test.astype(int)
    print(f"[+] Dataset sintetis: {len(X_train)} latih, {len(X_test)} uji, {X_train.shape[1]} fitur")

    print("[*] Melatih ulang MLP Keras...")
    mlp = m08.build_keras_mlp(input_dim=X_train.shape[1])
    mlp.fit(X_train, y_train, epochs=args.epochs, batch_size=64, verbose=0)
    score_mlp = mlp.predict(X_test, verbose=0).ravel()

    print("[*] Melatih pembanding Random Forest dan Logistic Regression...")
    rf = RandomForestClassifier(n_estimators=100, random_state=args.seed)
    rf.fit(X_train, y_train)
    score_rf = rf.predict_proba(X_test)[:, 1]

    lr = LogisticRegression(max_iter=500, random_state=args.seed)
    lr.fit(X_train, y_train)
    score_lr = lr.predict_proba(X_test)[:, 1]

    score_rule = X_test[:, HARMONY_COL]

    scores = {
        "mlp_keras": score_mlp,
        "random_forest": score_rf,
        "logistic_regression": score_lr,
        "rule_harmony_only": score_rule,
    }

    groups = group_by_top(X_test)
    k = args.k
    rng = np.random.default_rng(args.seed)

    models = {}
    for name, s in scores.items():
        metrics = classification_metrics(y_test_int, s)
        p_at_k, n_groups = precision_at_k(groups, y_test_int, s, k, rng=rng)
        metrics[f"precision_at_{k}"] = round(p_at_k, 4)
        models[name] = metrics

    p_random, p_ideal = reference_precision_at_k(groups, y_test_int, k)
    _, n_groups = precision_at_k(groups, y_test_int, score_mlp, k)
    group_sizes = [len(v) for v in groups.values()]

    summary = {
        "task": "E6.5 evaluasi Model 3",
        "generated": date.today().isoformat(),
        "script": "ml/scripts/09_eval_model3.py",
        "data": {
            "type": "sintetis",
            "source": "build_dataset() pada ml/scripts/08_train_model3_mlp.py",
            "seed": args.seed,
            "n_train": int(len(X_train)),
            "n_test": int(len(X_test)),
            "positive_rate_test": round(float(y_test.mean()), 4),
            "n_features": int(X_train.shape[1]),
        },
        "training": {"epochs": args.epochs, "batch_size": 64},
        "precision_at_k_setup": {
            "k": k,
            "query": "satu atasan unik (jenis + warna) di split uji",
            "candidates": "semua pasangan uji dengan atasan tersebut",
            "relevant": "label 1 (pasangan cocok) dari generator sintetis",
            "query_filter": "minimal k kandidat serta memuat pasangan cocok dan tidak cocok",
            "n_queries_evaluated": n_groups,
            "n_queries_total": len(groups),
            "candidates_per_query_min": int(min(group_sizes)),
            "candidates_per_query_median": float(np.median(group_sizes)),
            "candidates_per_query_max": int(max(group_sizes)),
            "tie_break": "acak dengan seed yang sama",
        },
        "models": models,
        "reference": {
            f"random_precision_at_{k}": round(p_random, 4),
            f"ideal_precision_at_{k}": round(p_ideal, 4),
            "note": "ideal adalah batas atas; banyak atasan punya kurang dari "
            f"{k} pasangan cocok di split uji",
        },
        "target": {"roc_auc_min": 0.75},
        "meets_target": models["mlp_keras"]["roc_auc"] >= 0.75,
        "limitations": [
            "Data latih dan uji sintetis. Label dibangkitkan dari aturan harmoni "
            "warna yang juga menjadi salah satu fitur, sehingga AUC tinggi "
            "menunjukkan model meniru aturan, bukan bukti generalisasi ke "
            "penilaian manusia.",
            "Tidak ada data pasangan outfit nyata atau penilaian pengguna; "
            "precision@3 dihitung terhadap label sintetis yang sama.",
            "Kategori dan palet pada script 08 (4 atasan, 5 bawahan, 16 warna) "
            "belum sama dengan 9 kelas Model 1 dan 14 warna aplikasi.",
            "Validasi nyata perlu data pasangan berlabel manusia, misalnya dari "
            "riwayat rekomendasi atau survei pengguna.",
        ],
    }

    args.out.parent.mkdir(parents=True, exist_ok=True)
    with open(args.out, "w", encoding="utf-8") as f:
        json.dump(summary, f, indent=2, ensure_ascii=False)
        f.write("\n")

    print(f"\n{'Model':<22}{'AUC':>8}{'Akurasi':>10}{'F1':>8}{f'P@{k}':>8}")
    for name, m in models.items():
        print(f"{name:<22}{m['roc_auc']:>8.4f}{m['accuracy']:>10.4f}{m['f1']:>8.4f}{m[f'precision_at_{k}']:>8.4f}")
    print(f"{'acak (harapan)':<22}{'':>8}{'':>10}{'':>8}{p_random:>8.4f}")
    print(f"{'ideal (batas atas)':<22}{'':>8}{'':>10}{'':>8}{p_ideal:>8.4f}")
    print(f"\n[+] Kueri precision@{k}: {n_groups} dari {len(groups)} atasan")
    print(f"[+] Hasil disimpan di: {args.out.relative_to(ROOT)}")
    print("[!] Catatan: data sintetis, bukan validasi nyata.")


if __name__ == "__main__":
    main()
