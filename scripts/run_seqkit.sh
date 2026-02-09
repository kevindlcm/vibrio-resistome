#!/bin/bash
set -e

echo "Iniciando análisis con SeqKit..."

BASE_DATA="data/Genome_NCBI"
OUT_DIR="quality/seqkit"

mkdir -p "$OUT_DIR"

for sp in V_alginolyticus V_cholerae V_parahaemolyticus V_vulnificus; do
    echo "Procesando $sp"
    seqkit stats "$BASE_DATA/$sp"/*.fna > "$OUT_DIR/seqkit_stats_$sp.tsv"
done

echo "SeqKit finalizado correctamente."
