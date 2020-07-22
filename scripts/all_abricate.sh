#!/bin/bash 

#conda activate kraken2
## also need to have bracken installed in the same env - conda works 

WDIR=$1
LIST=sample.list
FADIR=$WDIR/8_final_fasta

if [[ $# < 1 ]]
then
  >&2 echo "Usage: ./all_abricate.sh <working dir>"
  exit 1
fi

KK=`cat $LIST`

echo "["`date +%H:%M:%S`"] Started Abricate processing.."

for i in $KK
do
  while [ $(jobs | wc -l) -ge 64 ] ; do sleep 5; done
  ./one_abricate.sh $i $FADIR &> $i.abricate.log &  
done 

wait 

echo "["`date +%H:%M:%S`"] ALL DONE!"
