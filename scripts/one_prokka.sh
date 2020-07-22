#!/bin/bash 

#conda activate prokka 

TAG=$1
FADIR=$2
FAA=$3

prokka --cpus 32 --outdir $TAG --prefix $TAG --locustag $TAG --proteins $FAA --rawproduct $FADIR/$TAG.fa
