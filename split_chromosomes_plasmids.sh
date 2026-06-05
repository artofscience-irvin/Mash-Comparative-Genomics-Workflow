#!/usr/bin/env bash
set -euo pipefail

# Split RefSeq genomic FASTA files into chromosome and plasmid FASTA files.
# Plasmids are identified by the word "plasmid" in the FASTA header.

INPUT_DIR="ecoli_refseq_complete"
CHR_DIR="split/chromosomes"
PLASMID_DIR="split/plasmids"

[ -d "$INPUT_DIR" ] || { echo "Missing input directory: $INPUT_DIR"; exit 1; }

mkdir -p "$CHR_DIR" "$PLASMID_DIR"

for f in "$INPUT_DIR"/*.fna.gz; do
    [ -f "$f" ] || continue

    base=$(basename "$f" .fna.gz)
    echo "Splitting $base"

    gunzip -c "$f" | awk \
        -v chr="$CHR_DIR/${base}.chrom.fna" \
        -v pl="$PLASMID_DIR/${base}.plasmid.fna" '
        BEGIN { out = chr }
        /^>/ {
            h = tolower($0)
            if (h ~ /plasmid/) out = pl
            else out = chr
        }
        { print >> out }
        '
done

find "$PLASMID_DIR" -type f -size 0 -delete

echo "Splitting complete."
echo "Chromosomes: $CHR_DIR"
echo "Plasmids: $PLASMID_DIR"
