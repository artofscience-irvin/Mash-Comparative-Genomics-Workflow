#!/usr/bin/env bash
set -euo pipefail

# Download complete RefSeq Escherichia coli genome FASTA files.

OUTDIR="ecoli_refseq_complete"
FTP_LIST="ecoli_ftp_paths.txt"

mkdir -p "$OUTDIR"

command -v esearch >/dev/null || { echo "Entrez Direct esearch not found"; exit 1; }
command -v esummary >/dev/null || { echo "Entrez Direct esummary not found"; exit 1; }
command -v xtract >/dev/null || { echo "Entrez Direct xtract not found"; exit 1; }
command -v wget >/dev/null || { echo "wget not found"; exit 1; }

echo "Retrieving RefSeq FTP paths from NCBI Assembly..."

esearch -db assembly -query \
'Escherichia coli[Organism] AND "latest refseq"[filter] AND "complete genome"[filter]' \
| esummary \
| xtract -pattern DocumentSummary -element FtpPath_RefSeq \
| grep "^ftp" > "$FTP_LIST"

COUNT=$(wc -l < "$FTP_LIST")
echo "Found $COUNT assemblies."

while read -r ftp; do
    [ -n "$ftp" ] || continue
    base=$(basename "$ftp")
    url="${ftp}/${base}_genomic.fna.gz"

    echo "Downloading $base"
    wget -q -P "$OUTDIR" "$url"
done < "$FTP_LIST"

echo "Download complete. FASTA files are in: $OUTDIR"
