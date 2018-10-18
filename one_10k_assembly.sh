#!/bin/bash 

BC=$1

source activate unicycler 

FQDIR=/scratch/alexp/0_merged_fastq
R1=$FQDIR/$BC.R1.fastq.gz
R2=$FQDIR/$BC.R2.fastq.gz

NEXTERA=/pub37/alexp/miniconda2/share/trimmomatic-0.38-1/adapters/NexteraPE-PE.fa

echo "["`date +%H:%M:%S`"] Sample $BC: processing paired-end reads using Trimmomatic PE."

trimmomatic PE -threads 4 $R1 $R2 -baseout $BC ILLUMINACLIP:$NEXTERA:2:30:10 &> $BC.trim.log 

mv ${BC}_1P $BC.R1.fastq
mv ${BC}_2P $BC.R2.fastq
cat ${BC}_1U ${BC}_2U > $BC.U.fastq

echo "["`date +%H:%M:%S`"] Sample $BC: running Spades assembly using Unicycler."

unicycler -t 4 -1 $BC.R1.fastq -2 $BC.R2.fastq -s $BC.U.fastq --verbosity 2 -o ${BC}_unicycler &> /dev/null 

rm ${BC}_1U ${BC}_2U $BC.R1.fastq $BC.R2.fastq $BC.U.fastq

echo "["`date +%H:%M:%S`"] Sample $BC: All done!"
