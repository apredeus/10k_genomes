#!/bin/bash 

TAG=$1
FQDIR=$2

bowtie2 -p 4 -x LT2 -1 $FQDIR/$TAG.R1.fastq.gz -2 $FQDIR/$TAG.R2.fastq.gz -S $TAG.sam &> $TAG.bowtie2.log 
samtools view -b $TAG.sam | samtools sort -@4 > $TAG.bam
picard MarkDuplicates I=$TAG.bam O=$TAG.mkdup.bam M=$TAG.mkdup.metrics &> $TAG.mkdup.log 
rm $TAG.sam
mv $TAG.mkdup.bam $TAG.bam
