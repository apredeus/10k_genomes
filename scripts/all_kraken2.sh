#!/bin/bash 

#conda activate kraken2
## also need to have bracken installed in the same env - conda works 

WDIR=$1
DB=$2  ### download masked minikraken2 db; we used minikraken2_v2_8GB_201904_UPDATE
KMER=$3 ## database150mers.kmer_distrib - http://ccb.jhu.edu/software/kraken2/index.shtml?t=downloads
FQDIR=$WDIR/0_merged_fastq
LIST=sample.list

if [[ $# < 1 ]]
then
  >&2 echo "Usage: ./all_kraken2.sh <working dir>"
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
