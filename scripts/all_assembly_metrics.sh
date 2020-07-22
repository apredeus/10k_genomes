#!/bin/bash 

WDIR=$1
LIST=sample.list

KK=`cat $LIST`
COUNT=1

for i in $KK
do
  >&2 echo "Processing sample # $COUNT, barcode $i.." 
  ./one_assembly_metrics.sh $i $WDIR
  COUNT=$((COUNT+1)) 
done 
