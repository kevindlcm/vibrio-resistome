#!/bin/bash

echo "Iniciando análisis de ensamblajes con QUAST..."

DATA_DIR="data/Genome_NCBI"
OUT_DIR="quality/quast"

mkdir -p $OUT_DIR

for sp in V_alginolyticus V_cholerae V_parahaemolyticus V_vulnificus
do
    echo "Procesando $sp..."
    mkdir -p $OUT_DIR/$sp
    
    quast \
        $DATA_DIR/$sp/*.fna \
        -o $OUT_DIR/$sp \
        --threads 4 \
        --silent
done

echo "QUAST finalizado correctamente."
