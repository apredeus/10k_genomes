#!/bin/bash 

TAG=$1
FADIR=$2

samtools faidx $FADIR/$TAG.fa 

cat $FADIR/$TAG.fa.fai | cut -f 2 | perl -ne '{chomp; push @ctg,$_; $tot+=$_} END{$nc=scalar(@ctg); foreach(sort{$b<=>$a}@ctg) {$sum+=$_; $L=$_; if($sum>=$tot*0.5){print "TOTAL: $tot\nNUMBER OF CONTIGS: $nc\nN50 : $L\n"; exit}}}'
