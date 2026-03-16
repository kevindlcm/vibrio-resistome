#!/bin/bash

for sp in V_alginolyticus V_cholerae V_parahaemolyticus V_vulnificus
do
abricate --db card --minid 90 --mincov 90 quality/checkM/input/$sp/*.fna > analysis/resistome/${sp}_card.tsv
done
