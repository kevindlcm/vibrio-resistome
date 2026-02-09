#!/bin/bash

THREADS=4

for sp in V_cholerae V_alginolyticus V_parahaemolyticus V_vulnificus
do
    echo "Procesando $sp"

    mkdir -p analysis/resistome/resfinder/$sp

    for genome in quality/checkM/input/$sp/*.fna
    do
        base=$(basename $genome .fna)

        run_resfinder.py \
            -ifa $genome \
            -o analysis/resistome/resfinder/$sp/$base \
            -db_res databases/resfinder \
            -acq \
            -t 0.9 \
            -l 0.9 \
            -k $THREADS
    done
done

echo "✅ ResFinder terminado"
