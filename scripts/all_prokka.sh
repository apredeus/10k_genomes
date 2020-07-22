#!/bin/bash 

WDIR=$1
LIST=sample.list
FAA=Salmonella_proteins.faa
FADIR=$WDIR/8_final_fasta

KK=`cat $LIST`

echo "["`date +%H:%M:%S`"] Started Prokka processing.."

for i in $KK
do
  while [ $(jobs | wc -l) -ge 16 ] ; do sleep 10; done
  echo "Prokka: processing sample $i"
  ./one_prokka.sh $i $FADIR $FAA &> /dev/null &  
done 
wait 

echo "["`date +%H:%M:%S`"] ALL DONE!"
