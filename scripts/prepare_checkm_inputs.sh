#!/bin/bash

BASE=quality/checkM/input
SRC=data/Genome_NCBI
SUM=quality/quast/summary

for sp in V_cholerae V_alginolyticus V_parahaemolyticus V_vulnificus
do
  echo "Procesando $sp"
  mkdir -p $BASE/$sp

  awk '$NF=="OK"{print $1}' $SUM/${sp}_quast_final_table.tsv | while read acc
  do
    cp $SRC/$sp/${acc}.fna $BASE/$sp/
  done

  echo "  Copiados $(ls $BASE/$sp | wc -l) genomas OK"
done
