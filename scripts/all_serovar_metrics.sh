#!/bin/bash

WDIR=$1
LIST=sample.list
KK=`cat $LIST`

for i in $KK
do
  QC="NONE"
  SRV="NONE"
  MLST="NONE" 

  if [[ -s $WDIR/5_sistr/output/$i.output.tab ]]
  then
    ## only use cgMLST serovar, sort it out later if needed 
    QC=`awk -F "\t" '{if (NR>1) print $12}' $WDIR/5_sistr/output/$i.output.tab | sed "s/://g" | awk '{print $1}'`
    SRV=`awk -F "\t" '{if (NR>1) print $16}' $WDIR/5_sistr/output/$i.output.tab`
    if [[ $SRV == "-:-:-" || $QC == "FAIL" ]]
    then 
      SRV="NONE"
    fi
  fi

  if [[ -s $WDIR/6_MLST/$i.mlst.out ]]
  then 
    MLST=`cut -f 3 $WDIR/6_MLST/$i.mlst.out`
    if [[ $MLST == "-" ]]
    then
      MLST="NONE"
    fi
  fi

  echo -e "$i\t$QC\t$SRV\t$MLST"
done
