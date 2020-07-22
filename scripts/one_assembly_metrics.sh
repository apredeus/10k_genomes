#!/bin/bash 

## calculate all assembly stats in one go
## QC is only meaningful for Salmonella and needs to be customized for other species.

## Enterobase QC can be taken from here: https://enterobase.readthedocs.io/en/latest/pipelines/backend-pipeline-qaevaluation.html
## TAG=barcode

TAG=$1
WDIR=$2

KR_SP=`grep -v kraken_assigned_reads $WDIR/1_kraken2/bracken/$TAG.bracken.out | sort -t$'\t' -k7,7nr | head -n 1 | awk -F "\t" '{print $1}'`
KR_PT=`grep -v kraken_assigned_reads $WDIR/1_kraken2/bracken/$TAG.bracken.out | sort -t$'\t' -k7,7nr | head -n 1 | awk -F "\t" '{printf "%.2f\n",100*$7}'`
if [[ $KR_SP == "" || $KR_PT == "" ]] 
then
  KR_SP="NONE"
  KR_PT="NONE"
fi 

DUP_PT=`grep "Unknown Library" $WDIR/2_duplicates/metrics/$TAG.mkdup.metrics | awk -F "\t" '{printf "%.2f\n",100*$9}'`
DUP_LS=`grep "Unknown Library" $WDIR/2_duplicates/metrics/$TAG.mkdup.metrics | awk -F "\t" '{print $10}'`
if [[ $DUP_PT == "" || $DUP_LS == "" ]] 
then
  DUP_PT="NONE"
  DUP_LS="NONE"
fi

POOLS=`cut -f 2 $WDIR/3_coverage_etc/coverage/$TAG.coverage.out`
COV=`cut -f 3 $WDIR/3_coverage_etc/coverage/$TAG.coverage.out`
if [[ $POOLS == "" || $COV == "" ]] 
then
  POOLS="NONE"
  COV="NONE"
fi

TLEN=`grep TOTAL $WDIR/4_assembly/n50/$TAG.n50.out | awk '{print $2}'` 
NCTG=`grep CONTIGS $WDIR/4_assembly/n50/$TAG.n50.out | awk '{print $4}'` 
N50=`grep N50 $WDIR/4_assembly/n50/$TAG.n50.out | awk '{print $3}'` 
if [[ $TLEN == "" || $NCTG == "" || $N50 == "" ]] 
then
  TLEN="NONE"
  NCTG="NONE"
  N50="NONE"
fi 

TRIM=`grep "Total Removed" $WDIR/4_assembly/trim_logs/$TAG.bbduk.log | tr '[(%]' '\t' | cut -f 6`
if [[ $TRIM == "" ]] 
then 
  TRIM="NONE" 
fi

## now QC
QC="NO" 
ROUND=`echo $KR_PT | awk '{printf "%d\n",$1+0.5}'` ## rounded % dominant species, acc to Bracken
RESCPASS=`grep $TAG $WDIR/7_rescue/new_qc.tsv | cut -f 5`

if [[ $KR_SP == "Salmonella"* ]]
then
  if (( $TLEN >= 4000000 && $TLEN <= 5800000 && $N50 > 20000 && $NCTG < 600 && $ROUND > 70 ))
  then
    QC="YES"
  elif (( $TLEN >= 4000000 && $TLEN <= 5800000 && $N50 > 10000 && $NCTG < 2000 && $ROUND > 90 ))
  then
    QC="RESCUE"
  elif [[ $RESCPASS == "YES" ]]
  then
    QC="RESCUE"
  fi
fi

if [[ $KR_SP == "Shigella"* || $KR_SP == "Escherichia"* ]]
then
  if (( $TLEN >= 3700000 && $TLEN <= 6400000 && $N50 > 20000 && $NCTG < 800 && $ROUND > 70 ))
  then
    QC="YES"
  fi
fi

if [[ $KR_SP == "Staphylococcus"* ]]
then
  if (( $TLEN >= 2200000 && $TLEN <= 3300000 && $N50 > 20000 && $NCTG < 400 && $ROUND > 70 ))
  then
    QC="YES"
  fi
fi

echo -e "$TAG\t$POOLS\t$COV\t$DUP_PT\t$DUP_LS\t$TRIM\t$KR_SP\t$KR_PT\t$TLEN\t$NCTG\t$N50\t$QC" 
