#!/bin/bash 

LIST=$1
KK=`cat $LIST`
COUNT=1

for i in $KK
do
  >&2 echo "Processing sample # $COUNT, barcode $i.." 
  ./one_assembly_metrics.sh $i
  COUNT=$((COUNT+1)) 
done 
