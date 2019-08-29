#!/bin/bash 

TAG=$1
FADIR=$2

## these five DBs are for resistance genes
## three others - EcOH, ecoli_vf, and vfdb - are for virulence factors and will be used separately

abricate -db card $FADIR/$TAG.fa > $TAG.abricate.tsv 
abricate -db resfinder $FADIR/$TAG.fa | grep -v COVERAGE_MAP >> $TAG.abricate.tsv
abricate -db plasmidfinder $FADIR/$TAG.fa | grep -v COVERAGE_MAP >> $TAG.abricate.tsv
abricate -db ncbi $FADIR/$TAG.fa | grep -v COVERAGE_MAP >> $TAG.abricate.tsv
abricate -db argannot $FADIR/$TAG.fa | grep -v COVERAGE_MAP >> $TAG.abricate.tsv
