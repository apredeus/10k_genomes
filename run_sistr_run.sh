#!/bin/bash 

FA=$1
TAG=${FA%%.fa} 

source activate sistr

sistr --use-full-cgmlst-db --qc -vv -a $TAG.allele.json -n $TAG.novel_alleles.fasta -p $TAG.cgmlst_profiles.csv -f tab -o $TAG.output.tab $FA &> $TAG.sistr.log 
mlst $FA > $TAG.mlst.out 
