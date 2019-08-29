#!/bin/bash 

TAG=$1
FQDIR=$2
ADAPTERS=$3

#source activate unicycler 

echo "["`date +%H:%M:%S`"] Sample $TAG: processing paired-end reads using Bbduk PE.."

bbduk.sh in1=$FQDIR/$TAG.R1.fastq.gz in2=$FQDIR/$TAG.R2.fastq.gz out1=$TAG.bbduk.R1.fastq out2=$TAG.bbduk.R2.fastq ref=$ADAPTERS ktrim=r k=23 mink=11 hdist=1 tpe tbo &> $TAG.bbduk.log

echo "["`date +%H:%M:%S`"] Sample $TAG: running Spades assembly using Unicycler.."

unicycler -t 1 -1 $TAG.bbduk.R1.fastq -2 $TAG.bbduk.R2.fastq -o $TAG.unicycler &> /dev/null 

rm $TAG.bbduk.R1.fastq $TAG.bbduk.R2.fastq

echo "["`date +%H:%M:%S`"] Sample $TAG: All done!"
