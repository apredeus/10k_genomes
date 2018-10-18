#!/bin/bash 

KK=`cat All_merged.list`

for i in $KK
do
  while [ $(jobs | wc -l) -ge 64 ] ; do sleep 5; done
  ./run_abricate.sh $i &> $i.abr.log &  
done 

wait 
