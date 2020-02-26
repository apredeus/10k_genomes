#!/bin/bash 

## rotate a circular chromosome or a plasmid accordingly to a certain reference gene 
## imagine you want a reference gene trpA to start at 337 (1-based - GTF and blast output)
## and be on the positive strand; then run this progam as follows: 
## ./rotate_circular.sh A1636.chr.fa trpA.fa 337 + 


FA=$1
REF=$2
POS=$3
STRAND=$4

if [[ $# < 4 ]]
then
  >&2 echo "Usage: ./rotate_circular.sh <chr_fa> <ref_gene_fa> <desired_start> <desired_strand>"
  exit 1
fi

TAG=${FA%%.fa}
samtools faidx $FA 
NC=`cat $FA.fai | wc -l`
LEN1=`awk '{print $2}' $FA.fai`

if [[ $NC != 1 ]]
then 
  >&2 echo "ERROR: Input fasta contains more than 1 sequence!"
  exit 1
else 
  echo "Input file has 1 chromosome, length is $LEN1 bp."
fi 

makeblastdb -in $FA -dbtype nucl &> /dev/null
blastn -query $REF -db $FA -evalue 1 -task megablast -outfmt 6 > init.blast.out 

N=`wc -l init.blast.out | awk '{print $1}'`
if [[ $N != 1 ]]
then
  >&2 echo "ERROR: 0 or >1 blast result found for the provided gene!"
  exit 1
fi 

BEG=`awk -F "\t" '{print $9}'  init.blast.out`
END=`awk -F "\t" '{print $10}' init.blast.out`

## there could overall be 8 cases worth considering 
if (( $BEG > $END )) 
then
  if [[ $STRAND == "+" ]]
  then
    echo "Reference gene maps onto \"-\" strand, but required to map to \"+\"; generating revcomp!"
    revseq -sequence $FA -reverse -complement -outseq $TAG.revcomp.fa
    makeblastdb -in $TAG.revcomp.fa -dbtype nucl &> /dev/null
    blastn -query $REF -db $TAG.revcomp.fa -evalue 1 -task megablast -outfmt 6 > rev.blast.out

    RBEG=`awk -F "\t" '{print $9}'  rev.blast.out`
    REND=`awk -F "\t" '{print $10}' rev.blast.out`
    
    LEN=$((RBEG-POS)) 
    if (( $LEN > 0 )) 
    then 
      # case 1
      seqtk seq -l 0 $TAG.revcomp.fa > $TAG.unfolded.fa
      awk -v l=$LEN '{if (/^>/) {print $1} else {L=length($0); printf "%s%s\n",substr($0,l+1,L-l),substr($0,1,l)}}' $TAG.unfolded.fa | seqtk seq -l 80 - > $TAG.rotated.fa
    else 
      # case 2 
      seqtk seq -l 0 $TAG.revcomp.fa > $TAG.unfolded.fa
      awk -v l=$LEN '{if (/^>/) {print $1} else {L=length($0); printf "%s%s\n",substr($0,L+l+1,-l),substr($0,1,L+l)}}' $TAG.unfolded.fa | seqtk seq -l 80 - > $TAG.rotated.fa
    fi 
  else 
    echo "Reference gene maps onto \"-\" strand, is required to map to \"-\"; continuing!"
    LEN=$((END-POS))
    if (( $LEN > 0 )) 
    then 
      # case 3
      seqtk seq -l 0 $FA > $TAG.unfolded.fa
      awk -v l=$LEN '{if (/^>/) {print $1} else {L=length($0); printf "%s%s\n",substr($0,l+1,L-l),substr($0,1,l)}}' $TAG.unfolded.fa | seqtk seq -l 80 - > $TAG.rotated.fa
    else 
      # case 4 
      seqtk seq -l 0 $FA > $TAG.unfolded.fa
      awk -v l=$LEN '{if (/^>/) {print $1} else {L=length($0); printf "%s%s\n",substr($0,L+l+1,-l),substr($0,1,L+l)}}' $TAG.unfolded.fa | seqtk seq -l 80 - > $TAG.rotated.fa
    fi
  fi
else  ## $BEG < $END 
  if [[ $STRAND == "+" ]]
  then
    echo "Reference gene maps onto \"+\" strand, is required to map to \"+\"; continuing!"
    
    LEN=$((BEG-POS)) 
    if (( $LEN > 0 )) 
    then 
      # case 5
      seqtk seq -l 0 $FA > $TAG.unfolded.fa
      awk -v l=$LEN '{if (/^>/) {print $1} else {L=length($0); printf "%s%s\n",substr($0,l+1,L-l),substr($0,1,l)}}' $TAG.unfolded.fa | seqtk seq -l 80 - > $TAG.rotated.fa
    else 
      # case 6 
      seqtk seq -l 0 $FA > $TAG.unfolded.fa
      awk -v l=$LEN '{if (/^>/) {print $1} else {L=length($0); printf "%s%s\n",substr($0,L+l+1,-l),substr($0,1,L+l)}}' $TAG.unfolded.fa | seqtk seq -l 80 - > $TAG.rotated.fa
    fi 
  else 
    echo "Reference gene maps onto \"+\" strand, but is required to map to \"-\"; generating revcomp!"
    revseq -sequence $FA -reverse -complement -outseq $TAG.revcomp.fa
    makeblastdb -in $TAG.revcomp.fa -dbtype nucl &> /dev/null
    blastn -query $REF -db $TAG.revcomp.fa -evalue 1 -task megablast -outfmt 6 > rev.blast.out

    RBEG=`awk -F "\t" '{print $9}'  rev.blast.out`
    REND=`awk -F "\t" '{print $10}' rev.blast.out`
    ## REND is the smaller number, that's the one we need 
    LEN=$((REND-POS))
    if (( $LEN > 0 )) 
    then 
      # case 7
      seqtk seq -l 0 $TAG.revcomp.fa > $TAG.unfolded.fa
      awk -v l=$LEN '{if (/^>/) {print $1} else {L=length($0); printf "%s%s\n",substr($0,l+1,L-l),substr($0,1,l)}}' $TAG.unfolded.fa | seqtk seq -l 80 - > $TAG.rotated.fa
    else 
      # case 8 
      seqtk seq -l 0 $TAG.revcomp.fa > $TAG.unfolded.fa
      awk -v l=$LEN '{if (/^>/) {print $1} else {L=length($0); printf "%s%s\n",substr($0,L+l+1,-l),substr($0,1,L+l)}}' $TAG.unfolded.fa | seqtk seq -l 80 - > $TAG.rotated.fa
    fi 
  fi
fi 

## Now-we-check (see what I did there?!) 

makeblastdb -in $TAG.rotated.fa -dbtype nucl &> /dev/null
blastn -query $REF -db $TAG.rotated.fa -evalue 1 -task megablast -outfmt 6 > rot.blast.out

XBEG=`awk -F "\t" '{print $9}'   rot.blast.out`
XEND=`awk -F "\t" '{print $10}'  rot.blast.out`

samtools faidx $TAG.rotated.fa
LEN2=`awk '{print $2}' $TAG.rotated.fa.fai`
echo "Rotated sequence generated; length is $LEN2 bp."
echo "New coordinates after rotation: begin = $XBEG, end = $XEND"

## rm *.blast.out $TAG.*.nhr $TAG.*.nin $TAG.*.nsq
