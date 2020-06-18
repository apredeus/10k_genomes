#!/bin/bash 

TAG=$1
FQDIR=$2
SIZE=4800000 ## change if needed 

R1=$FQDIR/$TAG.R1.fastq.gz 

## calculate number of independent sequencing runs if sample was sequenced more than once
KK=`zcat $R1 | grep "^@" | awk -F ":" '{print $1}' | sort | uniq -c`
a=( $KK )
N=${#a[@]}
N2=$((N/2)) 
OUT="$N2(${a[0]}"

for j in `seq 2 2 $((N-2))`
do 
  OUT=$OUT"/${a[$j]}"
done 

OUT=$OUT")"

## calculate approximate coverage using size $SIZE
COV=`zcat $R1 | awk -v v=$SIZE '{if (NR%4==2) sl+=length($1)} END {printf "%.1f\n",sl*2/v}'`

echo -e "$TAG\t$OUT\t$COV"
