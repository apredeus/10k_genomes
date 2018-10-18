#!/bin/bash 

TAG=$1
SIZE=$2

if [[ $# != 2 ]]
then
  echo "ERROR: Please provide common tag for archived Illumina reads (TAG.R1.fastq.gz, TAG.R2.fastq.gz), and estimated genome size in Mb!"
  exit 1
fi

KK1=`zcat $TAG.R1.fastq.gz | awk '{if (NR%4==2) sl+=length($1)} END {print sl, NR/4, sl*4/NR}'`
N1=`echo $KK1 | awk '{print $2}'`
L1=`echo $KK1 | awk '{print $3}'`


COV=`echo $KK1 | awk -v v=$SIZE '{print $1/(v*500000)}'`

echo "Sample $TAG length $L1 coverage $COV"
