# Vibrio Resistome Pipeline – Command History

Este documento describe los comandos utilizados para la construcción del pipeline bioinformático aplicado al análisis del resistoma en especies del género Vibrio.

Proyecto de investigación:

*Estudio in silico de genes de resistencia antimicrobiana en especies del género Vibrio mediante herramientas genómicas y programación en Python*

---

# 1. Preparación del sistema

Actualización del sistema operativo:

sudo apt update && sudo apt upgrade -y

Instalación de herramientas básicas:

sudo apt install python3 python3-pip git curl -y

---

# 2. Instalación de Miniconda

Descarga de Miniconda:

curl -LO https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

Instalación:

bash Miniconda3-latest-Linux-x86_64.sh

Activación de conda:

source ~/.bashrc

Verificación:

conda --version

---

# 3. Creación del entorno de bioinformática

Creación del entorno:

conda create -n vibrio_env python=3.11 -y

Activación del entorno:

conda activate vibrio_env

---

# 4. Instalación de librerías de Python

pip install pandas biopython matplotlib seaborn scikit-learn plotly geopandas jupyterlab

---

# 5. Instalación de herramientas bioinformáticas

conda install -c bioconda abricate ncbi-amrfinderplus fastqc quast checkm-genome

Instalación de seqkit:

conda install -n base -c conda-forge mamba -y
mamba install -c bioconda seqkit -y

---

# 6. Creación de la estructura del proyecto

mkdir Bioinformatica
cd Bioinformatica

mkdir tesis_vibrio
cd tesis_vibrio

mkdir data
mkdir results
mkdir scripts
mkdir notebooks
mkdir metadata
mkdir quality

---

# 7. Descarga de genomas desde NCBI

Ejemplo de descarga de genomas de Vibrio:

datasets summary genome taxon "Vibrio cholerae" --assembly-level complete --as-json-lines

Extracción de accesiones:

jq -r '.accession'

Descarga de genomas mediante accesiones:

datasets download genome accession --inputfile ACCESSIONS.txt

Descompresión de archivos:

unzip -q V_cholerae.zip

Extracción de archivos .fna:

find data/V_cholerae/ -type f -name "*.fna" -exec mv {} data/V_cholerae/ \;

---

# 8. Evaluación preliminar de genomas (SeqKit)

seqkit stats data/Genome_NCBI/V_cholerae/*.fna > quality/seqkit/seqkit_stats_V_cholerae.tsv

seqkit stats data/Genome_NCBI/V_alginolyticus/*.fna > quality/seqkit/seqkit_stats_V_alginolyticus.tsv

seqkit stats data/Genome_NCBI/V_parahaemolyticus/*.fna > quality/seqkit/seqkit_stats_V_parahaemolyticus.tsv

seqkit stats data/Genome_NCBI/V_vulnificus/*.fna > quality/seqkit/seqkit_stats_V_vulnificus.tsv

---

# 9. Evaluación estructural de ensamblaje (QUAST)

quast.py data/Genome_NCBI/V_cholerae/*.fna -o quality/quast/Vibrios/V_cholerae

quast.py data/Genome_NCBI/V_alginolyticus/*.fna -o quality/quast/Vibrios/V_alginolyticus

quast.py data/Genome_NCBI/V_parahaemolyticus/*.fna -o quality/quast/Vibrios/V_parahaemolyticus

quast.py data/Genome_NCBI/V_vulnificus/*.fna -o quality/quast/Vibrios/V_vulnificus

Criterios evaluados:

- número de contigs
- tamaño del contig mayor
- N50
- L50
- contenido GC

---

# 10. Evaluación de calidad genómica (CheckM)

checkm taxonomy_wf domain Bacteria -x fna quality/checkM/input/V_cholerae quality/checkM/output/V_cholerae

checkm taxonomy_wf domain Bacteria -x fna quality/checkM/input/V_alginolyticus quality/checkM/output/V_alginolyticus

checkm taxonomy_wf domain Bacteria -x fna quality/checkM/input/V_parahaemolyticus quality/checkM/output/V_parahaemolyticus

checkm taxonomy_wf domain Bacteria -x fna quality/checkM/input/V_vulnificus quality/checkM/output/V_vulnificus

Extracción de métricas:

checkm qa Bacteria.ms quality/checkM/output/V_cholerae -o 2

Criterios de filtrado:

- Completitud ≥ 90%
- Contaminación ≤ 5%

---

# 11. Detección de genes de resistencia antimicrobiana

## CARD (Abricate)

for sp in V_alginolyticus V_cholerae V_parahaemolyticus V_vulnificus
do
abricate --db card --minid 90 --mincov 90 quality/checkM/input/$sp/*.fna > analysis/resistome/${sp}_card.tsv
done

---

## AMRFinderPlus

amrfinder -n genome.fna -o results.tsv

---

## ResFinder

run_resfinder.py -ifa genome.fna -o output_directory

---

# 12. Integración de resultados del resistoma

Unión de resultados por especie:

head -n 1 analysis/resistome/V_cholerae_amrfinder.tsv > analysis/resistome/amrfinder_all_species.tsv

tail -n +2 -q analysis/resistome/V_*_amrfinder.tsv >> analysis/resistome/amrfinder_all_species.tsv

Archivo final del resistoma:

resistoma_global.tsv

---

# 13. Análisis en Python

Los análisis se realizaron en notebooks:

01_build_resistome_dataset.ipynb

02_resistome_descriptivo.ipynb

03_multivariado_resistoma.ipynb

04_metadatos_integracion.ipynb

05_estadistica_inferencial.ipynb

---

# 14. Análisis estadístico

Pruebas aplicadas:

Chi-cuadrado (χ²) → asociación entre especies y clases de resistencia

Shapiro-Wilk → prueba de normalidad

Kruskal-Wallis → comparación de diversidad genética entre especies

Significancia estadística:

p < 0.05

---

# 15. Visualización de resultados

Figuras generadas:

- Heatmap del resistoma
- PCA del resistoma
- clustering jerárquico
- gráficos de abundancia
- tablas de genes únicos

---

# 16. Control de versiones

Inicialización del repositorio:

git init

git add .

git commit -m "Initial commit - Vibrio resistome pipeline"

Conexión con GitHub:

git remote add origin https://github.com/kevindlcm/vibrio-resistome.git

git branch -M main

git push -u origin main
