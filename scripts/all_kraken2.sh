#!/bin/bash 

#conda activate kraken2
## also need to have bracken installed in the same env - conda works 

LIST=$1
DB=/pub37/alexp/reference/Kraken2/minikraken2_v2_8GB_201904_UPDATE
KMER=/pub37/alexp/reference/Kraken2/database150mers.kmer_distrib
FQDIR=/pub37/alexp/data/10k_genomes/V3_merged_analysis/0_merged_fastq

if [[ $# < 1 ]]
then
  >&2 echo "Usage: ./all_kraken2.sh <barcode_list>"
  exit 1
fi

KK=`cat $LIST`

echo "["`date +%H:%M:%S`"] Started Kraken2/Bracken processing.."

for i in $KK
do
  while [ $(jobs | wc -l) -ge 64 ] ; do sleep 5; done
  ./one_kraken2.sh $i $FQDIR $DB $KMER &> $i.kraken2.log &  
done 
wait 

echo "["`date +%H:%M:%S`"] ALL DONE!"
