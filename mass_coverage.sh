#!/bin/bash 

for i in *.R1.fastq.gz
do
  TAG=${i%%.R1.fastq.gz}
  simple_coverage.sh $TAG 4.8 &> $TAG.coverage.out & 
  while [ $(jobs | wc -l) -ge 150 ] ; do sleep 5; done
done 

wait 

