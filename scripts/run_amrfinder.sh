#!/bin/bash

THREADS=2

mkdir -p analysis/resistome/amrfinder

for sp in V_cholerae V_alginolyticus V_parahaemolyticus V_vulnificus
do
    echo "====================="
    echo "Procesando $sp"
    echo "====================="

    mkdir -p analysis/resistome/amrfinder/$sp

    for genome in quality/checkM/input/$sp/*.fna
    do
        base=$(basename $genome .fna)

        amrfinder \
            -n $genome \
            -o analysis/resistome/amrfinder/$sp/${base}_amrfinder.tsv \
            --threads $THREADS
    done

    # unir resultados por especie
    head -n 1 analysis/resistome/amrfinder/$sp/*_amrfinder.tsv > analysis/resistome/${sp}_amrfinder.tsv
    tail -n +2 -q analysis/resistome/amrfinder/$sp/*_amrfinder.tsv >> analysis/resistome/${sp}_amrfinder.tsv
done

# unir todo
head -n 1 analysis/resistome/V_cholerae_amrfinder.tsv > analysis/resistome/amrfinder_all_species.tsv
tail -n +2 -q analysis/resistome/V_*_amrfinder.tsv >> analysis/resistome/amrfinder_all_species.tsv

echo "✅ AMRFinder terminado"
