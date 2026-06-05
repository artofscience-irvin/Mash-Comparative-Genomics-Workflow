#!/usr/bin/env bash
set -euo pipefail

# Extract GCF accessions from a Mash output table and download matching NCBI datasets.
# Usage: bash scripts/download_top_matches.sh results/query_vs_ecoli_chr_top20.tsv 20 gbff

MASH_RESULTS="${1:-}"
TOP_N="${2:-20}"
INCLUDE_TYPE="${3:-gbff}"

RESULTS_DIR="results"

[ -n "$MASH_RESULTS" ] || { echo "Usage: bash scripts/download_top_matches.sh results/query_vs_ecoli_chr_top20.tsv 20 gbff"; exit 1; }
[ -f "$MASH_RESULTS" ] || { echo "Missing Mash results file: $MASH_RESULTS"; exit 1; }

command -v datasets >/dev/null || { echo "NCBI Datasets CLI not found"; exit 1; }

mkdir -p "$RESULTS_DIR"

BASENAME=$(basename "$MASH_RESULTS" .tsv)
ACCESSION_FILE="$RESULTS_DIR/${BASENAME}_accessions.txt"
ZIP_FILE="$RESULTS_DIR/${BASENAME}_${INCLUDE_TYPE}.zip"

echo "Extracting accessions from: $MASH_RESULTS"
awk '{print $2}' "$MASH_RESULTS" \
| grep -oE 'GCF_[0-9]+\.[0-9]+' \
| sort -u \
| head -n "$TOP_N" \
> "$ACCESSION_FILE"

echo "Downloading $INCLUDE_TYPE files for top matches..."
datasets download genome accession \
    --inputfile "$ACCESSION_FILE" \
    --include "$INCLUDE_TYPE" \
    --filename "$ZIP_FILE"

echo "Accessions written to: $ACCESSION_FILE"
echo "Dataset written to: $ZIP_FILE"
