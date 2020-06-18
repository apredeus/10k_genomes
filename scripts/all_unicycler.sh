#!/bin/bash 

#conda activate unicycler
## also need to have bbduk installed in the same env

LIST=$1
FQDIR=/pub37/alexp/data/10k_genomes/V3_merged_analysis/0_merged_fastq
ADAPTERS=/pub37/alexp/bbmap/resources/adapters.fa

if [[ $# < 1 ]]
then
  >&2 echo "Usage: ./all_unicycler.sh <barcode_list>"
  exit 1
fi

KK=`cat $LIST`

echo "["`date +%H:%M:%S`"] Started bbduk/Unicycler processing.."

for i in $KK
do
  while [ $(jobs | wc -l) -ge 64 ] ; do sleep 5; done
  ./one_unicycler.sh $i $FQDIR $ADAPTERS & 
done 
wait 

echo "["`date +%H:%M:%S`"] ALL DONE!"
