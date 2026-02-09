import pandas as pd
import shutil
from pathlib import Path

BASE = Path("../")
QUAST_SUMMARY = BASE / "quality/quast/summary"
GENOMES = BASE / "data/Genome_NCBI"
CHECKM_INPUT = BASE / "quality/checkM/input"

species = {
    "V_cholerae": "V_cholerae_quast_final_table.tsv",
    "V_alginolyticus": "V_alginolyticus_quast_final_table.tsv",
    "V_parahaemolyticus": "V_parahaemolyticus_quast_final_table.tsv",
    "V_vulnificus": "V_vulnificus_quast_final_table.tsv",
}

for sp, table in species.items():
    df = pd.read_csv(QUAST_SUMMARY / table, sep="\t")
    ok = df[df["Status"] == "OK"]["Assembly"]

    outdir = CHECKM_INPUT / sp
    outdir.mkdir(parents=True, exist_ok=True)

    for acc in ok:
        src = GENOMES / sp / f"{acc}.fna"
        dst = outdir / f"{acc}.fna"
        shutil.copy(src, dst)

    print(f"{sp}: {len(ok)} genomas OK copiados")
