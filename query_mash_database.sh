#!/usr/bin/env bash
set -euo pipefail

# Sketch a query genome and compare it against the E. coli chromosome Mash database.
# Usage: bash scripts/query_mash_database.sh path/to/query_genome.fna query_name [top_n]

QUERY_FASTA="${1:-}"
QUERY_NAME="${2:-query}"
TOP_N="${3:-20}"

DB_DIR="db"
RESULTS_DIR="results"

[ -n "$QUERY_FASTA" ] || { echo "Usage: bash scripts/query_mash_database.sh path/to/query_genome.fna query_name [top_n]"; exit 1; }
[ -f "$QUERY_FASTA" ] || { echo "Missing query FASTA: $QUERY_FASTA"; exit 1; }
[ -f "$DB_DIR/ecoli_chr_db.msh" ] || { echo "Missing Mash database: $DB_DIR/ecoli_chr_db.msh"; exit 1; }

mkdir -p "$DB_DIR" "$RESULTS_DIR"

command -v mash >/dev/null || { echo "mash not found"; exit 1; }

QUERY_SKETCH="$DB_DIR/${QUERY_NAME}_chr"
OUTFILE="$RESULTS_DIR/${QUERY_NAME}_vs_ecoli_chr_top${TOP_N}.tsv"

echo "Sketching query genome: $QUERY_FASTA"
mash sketch -k 21 -s 5000 -o "$QUERY_SKETCH" "$QUERY_FASTA"

echo "Comparing query genome against chromosome database..."
mash dist "${QUERY_SKETCH}.msh" "$DB_DIR/ecoli_chr_db.msh" \
| sort -gk3 \
| head -n "$TOP_N" \
> "$OUTFILE"

echo "Top $TOP_N matches written to: $OUTFILE"
