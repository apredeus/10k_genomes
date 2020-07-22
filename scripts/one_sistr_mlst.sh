#!/bin/bash 

TAG=$1
FADIR=$2

#source activate sistr

sistr --use-full-cgmlst-db --qc -vv -a $TAG.allele.json -n $TAG.novel_alleles.fasta -p $TAG.cgmlst_profiles.csv -f tab -o $TAG.output.tab $FADIR/$TAG.fa &> $TAG.sistr.log 

mlst $FADIR/$TAG.fa > $TAG.mlst.out 
