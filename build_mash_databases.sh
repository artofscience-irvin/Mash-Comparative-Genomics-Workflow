#!/usr/bin/env bash
set -euo pipefail

# Build Mash sketch databases for chromosome and plasmid FASTA files.

CHR_DIR="split/chromosomes"
PLASMID_DIR="split/plasmids"
DB_DIR="db"

mkdir -p "$DB_DIR"

command -v mash >/dev/null || { echo "mash not found"; exit 1; }

[ -d "$CHR_DIR" ] || { echo "Missing chromosome directory: $CHR_DIR"; exit 1; }
[ -d "$PLASMID_DIR" ] || { echo "Missing plasmid directory: $PLASMID_DIR"; exit 1; }

echo "Building chromosome Mash database..."
mash sketch -k 21 -s 5000 -o "$DB_DIR/ecoli_chr_db" "$CHR_DIR"/*.fna

echo "Building plasmid Mash database..."
mash sketch -k 21 -s 1000 -o "$DB_DIR/ecoli_plasmid_db" "$PLASMID_DIR"/*.fna

echo "Mash databases created:"
echo "$DB_DIR/ecoli_chr_db.msh"
echo "$DB_DIR/ecoli_plasmid_db.msh"
