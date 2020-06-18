#!/bin/bash 

LIST=$1
FQDIR=/pub37/alexp/data/10k_genomes/V3_merged_analysis/0_merged_fastq

if [[ $# < 1 ]]
then
  >&2 echo "Usage: ./all_mkdup.sh <barcode_list>"
  exit 1
fi

KK=`cat $LIST`
echo "["`date +%H:%M:%S`"] Started Picard MarkDuplicates processing.."

for i in $KK 
do
  while [ $(jobs | wc -l) -ge 16 ] ; do sleep 10; done 
  ./one_mkdup.sh $i $FQDIR & 
done 
wait 

echo "["`date +%H:%M:%S`"] ALL DONE!"
