#!/bin/bash 

KK=`cat All_merged.list`

for i in $KK
do
  while [ $(jobs | wc -l) -ge 48 ] ; do sleep 5; done
  ./one_10k_assembly.sh $i & 
done 

wait 
