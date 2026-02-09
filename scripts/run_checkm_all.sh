#!/bin/bash
set -e

THREADS=2

SPECIES=(
V_alginolyticus
V_parahaemolyticus
V_vulnificus
)

for SP in "${SPECIES[@]}"; do
    echo "==============================="
    echo "Procesando $SP"
    echo "==============================="

    INPUT="quality/checkM/input/$SP"
    OUTPUT="quality/checkM/output/$SP"

    mkdir -p "$OUTPUT"

    echo "→ CheckM taxonomy_wf"
    checkm taxonomy_wf domain Bacteria -x fna -t $THREADS "$INPUT" "$OUTPUT"

    echo "→ CheckM QA summary"
    checkm qa "$OUTPUT/Bacteria.ms" "$OUTPUT" -o 2 > "$OUTPUT/${SP}_checkm_summary.tsv"

    echo "→ Filtrado calidad"
    python scripts/filter_checkm.py \
        "$OUTPUT/${SP}_checkm_summary.tsv" \
        "$OUTPUT/${SP}_filtered.tsv"

    echo "✓ $SP terminado"
    echo
done

echo "🎉 Todas las especies completadas"
