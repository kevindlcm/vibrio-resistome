#!/usr/bin/env python3

import pandas as pd
import sys
import re

if len(sys.argv) != 3:
    print("Uso: python filter_checkm.py input.tsv output.tsv")
    sys.exit(1)

input_file = sys.argv[1]
output_file = sys.argv[2]

rows = []

with open(input_file) as f:
    for line in f:
        # saltar INFO y separadores
        if line.startswith("[") or line.startswith("-") or line.strip() == "":
            continue
        rows.append(line.strip())

# dividir por múltiples espacios
data = [re.split(r"\s{2,}", r) for r in rows]

# primera fila = header
header = data[0]
data = data[1:]

df = pd.DataFrame(data, columns=header)

# limpiar nombres
df.columns = [c.strip() for c in df.columns]

# renombrar por seguridad
rename_map = {
    "Bin Id": "BinId",
    "Completeness": "Completeness",
    "Contamination": "Contamination"
}

for col in df.columns:
    if "Bin" in col:
        rename_map[col] = "BinId"
    if "Completeness" in col:
        rename_map[col] = "Completeness"
    if "Contamination" in col:
        rename_map[col] = "Contamination"

df = df.rename(columns=rename_map)

df = df[["BinId", "Completeness", "Contamination"]]

df["Completeness"] = pd.to_numeric(df["Completeness"])
df["Contamination"] = pd.to_numeric(df["Contamination"])

df["Status"] = df.apply(
    lambda r: "OK" if (r["Completeness"] >= 90 and r["Contamination"] <= 5) else "DESCARTAR",
    axis=1
)

df.to_csv(output_file, sep="\t", index=False)

ok = (df["Status"] == "OK").sum()
bad = (df["Status"] == "DESCARTAR").sum()

print("\n✅ Filtrado terminado")
print(f"Genomas OK: {ok}")
print(f"Genomas descartados: {bad}")
print(f"Archivo: {output_file}\n")

