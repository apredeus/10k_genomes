#!/bin/bash 

#conda activate unicycler
## also need to have bbduk installed in the same env

WDIR=$1
ADAPTERS=$2   ## look in bbmap installation - e.g. ~/bbmap/resources/adapters.fa
LIST=sample.list
FQDIR=$WDIR/0_merged_fastq

if [[ $# < 1 ]]
then
  >&2 echo "Usage: ./all_unicycler.sh <working dir>"
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
