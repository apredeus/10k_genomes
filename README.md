# 10k Salmonella Genomes Project 

Misc scripts for efficient processing of 10k Salmonella genomes

## Main steps of data processing

* Coverage estimation; 
* Bacterial species-level abundance estimation with Kraken (dustmasked 8Gb MiniKraken DB) and Bracken; 
* Palindromic trimming with Trimmomatic (Nextera adapters); 
* Assembly with Unicycler; 
* Assembly quality evaluation using QUAST with prophage- and plasmid-free reference genome; 
* MLST prediction using Torsen Seemann's [mlst](https://github.com/tseemann/mlst); 
* Serovar prediction using [SISTR](https://github.com/peterk87/sistr_cmd); 
* Resistance and virulence gene profiling using [abricate](https://github.com/tseemann/abricate); 
* (TODO) antibiotic resistance prediction using RGI/Ariba; 
* (TODO) find and compare all contigs Unicycler reports as circular; 
* (TODO) alignment and evaluation of duplicates as determinants of assembly quality.

## Circular replicon rotation 

In order to compare circular replicons, one needs to make sure they start at the same position. This, however, is quite tricky. Included script named **rotate_circular.sh** uses the position of a reference gene in order to rotate the circular chromosomes and plasmids. 

For *Salmonella enterica*, I am using thrA gene (see fasta in **/data**). The gene is expected to start at position 337 of (+) strand. 
