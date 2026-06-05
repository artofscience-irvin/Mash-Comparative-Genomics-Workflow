# Mash Comparative Genomics Workflow

A Bash workflow for building bacterial RefSeq reference datasets, separating chromosomal and plasmid FASTA records, constructing Mash sketch databases, and identifying nearest genomic neighbors for comparative genomics.

## Overview

This repository provides modular shell scripts for comparing bacterial query genomes against a local RefSeq-derived *Escherichia coli* genome database using Mash.

The workflow can be used to:

1. Download complete RefSeq *E. coli* genome assemblies.
2. Separate chromosome and plasmid sequences using FASTA header annotations.
3. Build Mash sketch databases for chromosomes and plasmids.
4. Sketch a query genome.
5. Compare the query genome against the reference database.
6. Extract accession numbers from top Mash matches.
7. Download GenBank or FASTA files for the closest matches.

## Requirements

- Bash
- NCBI Entrez Direct
- NCBI Datasets CLI
- Mash
- wget
- awk
- grep
- sort
- gzip/gunzip

## Recommended Directory Structure

```text
mash-comparative-genomics/
├── scripts/
│   ├── download_refseq_ecoli.sh
│   ├── split_chromosomes_plasmids.sh
│   ├── build_mash_databases.sh
│   ├── query_mash_database.sh
│   └── download_top_matches.sh
├── ecoli_refseq_complete/
├── split/
│   ├── chromosomes/
│   └── plasmids/
├── db/
└── results/
```

## Script 1: Download complete RefSeq E. coli genomes

```bash
bash scripts/download_refseq_ecoli.sh
```

This script queries the NCBI Assembly database for complete, latest RefSeq *Escherichia coli* genomes and downloads the genomic FASTA files.

## Script 2: Split chromosomes and plasmids

```bash
bash scripts/split_chromosomes_plasmids.sh
```

This script separates FASTA records into chromosome and plasmid files based on whether the FASTA header contains the word `plasmid`.

## Script 3: Build Mash databases

```bash
bash scripts/build_mash_databases.sh
```

This script creates Mash sketch databases from the chromosome and plasmid FASTA files.

## Script 4: Query Mash database

```bash
bash scripts/query_mash_database.sh path/to/query_genome.fna query_name
```

Example:

```bash
bash scripts/query_mash_database.sh data/EL361_chromosome.fasta EL361
```

This creates a Mash sketch for the query genome and compares it against the chromosome database.

## Script 5: Download top matches

```bash
bash scripts/download_top_matches.sh results/EL361_vs_ecoli_chr_top20.tsv 20 gbff
```

The third argument controls the file type downloaded by NCBI Datasets.

Common options:

```text
genome  = genomic FASTA files
gbff    = GenBank flat files
protein = protein FASTA files
cds     = coding sequence FASTA files
```

## Output

Example Mash output file:

```text
results/EL361_vs_ecoli_chr_top20.tsv
```

Example accession list:

```text
results/EL361_top20_accessions.txt
```

Example downloaded dataset:

```text
results/EL361_top20_gbff.zip
```

## Applications

- Comparative genomics
- Nearest-neighbor genome identification
- Reference database construction
- Plasmid and chromosome similarity screening
- Selection of genomes for downstream phylogenomics

## Author

Irvin Rivera  
PhD Candidate, Molecular Microbiology and Immunology  
University of Texas at San Antonio
