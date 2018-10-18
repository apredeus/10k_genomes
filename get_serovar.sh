#!/bin/bash 

KK=`cat All_merged.list`

for i in $KK 
do
  if [[ -s output/$i.output.tab ]]
  then
    QC=`awk -F "\t" '{if (NR>1) print $11}' output/$i.output.tab | sed "s/://g" | awk '{print $1}'`
    S1=`awk -F "\t" '{if (NR>1) print $13}' output/$i.output.tab`
    S2=`awk -F "\t" '{if (NR>1) print $14}' output/$i.output.tab`
    S3=`awk -F "\t" '{if (NR>1) print $15}' output/$i.output.tab`
    echo -e "$i\t$S1\t$S2\t$S3\t$QC"
  else 
    echo -e "$i\tNONE\tNONE\tNONE\tNONE"
  fi
done
