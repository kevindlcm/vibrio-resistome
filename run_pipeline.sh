#!/bin/bash

echo "Running quality control..."
bash scripts/run_quast_all.sh
bash scripts/run_checkm_all.sh

echo "Running resistome detection..."
bash scripts/run_amrfinder.sh
bash scripts/run_resfinder.sh

echo "Pipeline finished"
