#!/bin/bash 

LIST=$1
FADIR=/pub37/alexp/data/10k_genomes/V3_merged_analysis/8_fasta_to_send/fasta

if [[ $# < 1 ]]
then
  >&2 echo "Usage: ./all_n50.sh <barcode_list>"
  exit 1
fi

KK=`cat $LIST`
echo "["`date +%H:%M:%S`"] Started N50/n_contig/assembly length calculation.."

for i in $KK 
do
  while [ $(jobs | wc -l) -ge 64 ] ; do sleep 5; done 
  ./one_n50.sh $i $FADIR > $i.n50.out & 
done 
wait 

echo "["`date +%H:%M:%S`"] ALL DONE!"
