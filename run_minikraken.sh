#!/bin/bash 

DB=/pub37/alexp/reference/Kraken/minikraken_20171101_8GB_dustmasked
## we have 150 bp reads, so Braken's author advised using 75mers 
KMER=/pub37/alexp/reference/Kraken/minikraken_8GB_75mers_distrib.txt
FQDIR=/pub37/alexp/data/10k_genomes/0_merged_fastq
LIST=$1

KK=`cat $LIST`

echo "["`date +%H:%M:%S`"] Kraken with Minikraken DB 8Gb started; using 2x64 CPU cores at a time."
echo; echo "=============================================================================="; echo

for i in $KK
do
  while [ $(jobs | wc -l) -ge 64 ] ; do sleep 5; done
  R1=$FQDIR/$i.R1.fastq.gz
  R2=$FQDIR/$i.R2.fastq.gz
  kraken -db $DB --threads 2 --gzip-compressed --fastq-input --output $i.kraken.out --paired $R1 $R2 & 
done 
wait 

echo "["`date +%H:%M:%S`"] Converting all Kraken outputs into Kraken Reports."
echo; echo "=============================================================================="; echo

for i in $KK
do
  while [ $(jobs | wc -l) -ge 128 ] ; do sleep 5; done
  kraken-report -db $DB $i.kraken.out > $i.report.out & 
done 
wait 

echo "["`date +%H:%M:%S`"] Using Bracken to obtain species-level assignment."
echo; echo "=============================================================================="; echo

## now Braken species-level report
for i in $KK
do 
  while [ $(jobs | wc -l) -ge 128 ] ; do sleep 5; done
  python ~/miniconda2/bin/est_abundance.py -i $i.report.out -k $KMER -o $i.braken.out  & 
done 
wait 

echo; echo "=============================================================================="; echo
echo "["`date +%H:%M:%S`"] ALL DONE!"
