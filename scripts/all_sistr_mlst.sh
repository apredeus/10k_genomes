#!/bin/bash 

#conda activate sistr
## also need to have bbduk installed in the same env

WDIR=$1
LIST=sample.list
FADIR=$WDIR/8_final_fasta

if [[ $# < 1 ]]
then
  >&2 echo "Usage: ./all_sistr_mlst.sh <working dir>"
  exit 1
fi

KK=`cat $LIST`

echo "["`date +%H:%M:%S`"] Started SISTR/MLST processing.."

for i in $KK
do
  while [ $(jobs | wc -l) -ge 64 ] ; do sleep 1; done
  ./one_sistr_mlst.sh $i $FADIR & 
done 
wait 

echo "["`date +%H:%M:%S`"] ALL DONE!"
