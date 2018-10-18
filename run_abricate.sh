#!/bin/bash 

TAG=$1
WDIR=~/data/10k_genomes/4_merged_assembly/fasta

source activate resist 

## these five DBs are for resistance genes
## three others - EcOH, ecoli_vf, and vfdb - are for virulence factors and will be used separately

abricate -db card $WDIR/$TAG.fa > $TAG.abricate.tsv 
abricate -db resfinder $WDIR/$TAG.fa | grep -v COVERAGE_MAP >> $TAG.abricate.tsv
abricate -db plasmidfinder $WDIR/$TAG.fa | grep -v COVERAGE_MAP >> $TAG.abricate.tsv
abricate -db ncbi $WDIR/$TAG.fa | grep -v COVERAGE_MAP >> $TAG.abricate.tsv
abricate -db argannot $WDIR/$TAG.fa | grep -v COVERAGE_MAP >> $TAG.abricate.tsv
