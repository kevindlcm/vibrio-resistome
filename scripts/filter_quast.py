#!/usr/bin/env python3

import os
import pandas as pd

# Rutas
QUAST_DIR = "../quality/quast/Vibrios"
OUTPUT_DIR = "../quality/quast/summary"

os.makedirs(OUTPUT_DIR, exist_ok=True)

# Criterios por especie (GC %)
GC_RANGES = {
    "V_alginolyticus": (44.0, 46.0),
    "V_cholerae": (47.0, 48.5),
    "V_parahaemolyticus": (45.0, 46.0),
    "V_vulnificus": (46.0, 47.0)
}

for species in GC_RANGES:
    input_file = os.path.join(QUAST_DIR, species, "transposed_report.tsv")
    output_file = os.path.join(OUTPUT_DIR, f"{species}_quast_filtered.tsv")

    df = pd.read_csv(input_file, sep="\t")

    # Renombrar columnas clave para facilidad
    df = df.rename(columns={
        "# contigs": "contigs",
        "Largest contig": "largest_contig",
        "Total length": "total_length",
        "GC (%)": "gc",
        "N50": "n50",
        "L50": "l50"
    })

    gc_min, gc_max = GC_RANGES[species]

    status = []

    for _, row in df.iterrows():
        if (
            row["contigs"] <= 200 and
            row["largest_contig"] >= 500000 and
            row["n50"] >= 100000 and
            row["l50"] <= 10 and
            gc_min <= row["gc"] <= gc_max
        ):
            status.append("OK")
        else:
            status.append("REVISAR")

    df["Status"] = status

    df.to_csv(output_file, sep="\t", index=False)

    print(f"[OK] {species}: archivo generado → {output_file}")

print("\nFiltrado QUAST finalizado correctamente.")
