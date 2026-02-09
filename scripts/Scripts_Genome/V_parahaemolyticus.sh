#!/bin/bash
set -e

TOTAL=25
BLOQUE=10
SPECIES="Vibrio parahaemolyticus"
TAG="V_parahaemolyticus"

mkdir -p data/$TAG metadata/$TAG

for START in $(seq 1 $BLOQUE $TOTAL); do
    END=$((START + BLOQUE - 1))
    [ $END -gt $TOTAL ] && END=$TOTAL

    echo "=== $SPECIES: genomas $START a $END ==="

    METADATA_FILE="metadata/$TAG/parahaemolyticus_${START}_to_${END}.jsonl"
    ACCESSIONS_FILE="metadata/$TAG/parahaemolyticus_accessions_${START}_to_${END}.txt"
    ZIP_FILE="parahaemolyticus_${START}_to_${END}.zip"
    TMP_DIR="tmp_unzip_parahaemolyticus"

    mkdir -p "$TMP_DIR"

    datasets summary genome taxon "$SPECIES" --assembly-level complete --as-json-lines \
    | head -n $END | tail -n $BLOQUE > "$METADATA_FILE"

    jq -r '.accession' "$METADATA_FILE" > "$ACCESSIONS_FILE"

    datasets download genome accession --inputfile "$ACCESSIONS_FILE" --filename "$ZIP_FILE"

    unzip -q "$ZIP_FILE" -d "$TMP_DIR"
    find "$TMP_DIR" -type f -name "*.fna" -exec mv {} data/$TAG/ \;

    rm -rf "$TMP_DIR" "$ZIP_FILE"
done

echo "=== Listo: $TOTAL genomas de $SPECIES descargados ==="
