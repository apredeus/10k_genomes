#!/bin/bash 

TAG=$1
FQDIR=$2
DB=$3
KMER=$4

echo "["`date +%H:%M:%S`"] Sample $TAG: running Kraken2.."
kraken2 --gzip-compressed --db $DB --output $TAG.kraken.out --report $TAG.report.out --paired $FQDIR/$TAG.R1.fastq.gz $FQDIR/$TAG.R2.fastq.gz

echo "["`date +%H:%M:%S`"] Sample $TAG: running Bracken.."
est_abundance.py -i $TAG.report.out -k $KMER -o $TAG.bracken.out
