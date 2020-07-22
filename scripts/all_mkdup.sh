#!/bin/bash 

WDIR=$1
LIST=sample.list
FQDIR=$WDIR/0_merged_fastq

if [[ $# < 1 ]]
then
  >&2 echo "Usage: ./all_mkdup.sh <working dir>"
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
