#!/bin/bash 

WDIR=$1
LIST=sample.list
FADIR=$WDIR/8_final_fasta

if [[ $# < 1 ]]
then
  >&2 echo "Usage: ./all_n50.sh <working dir>"
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
