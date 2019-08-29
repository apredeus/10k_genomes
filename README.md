# 10k Salmonella Genomes Project 

Efficient data processing for 10k Salmonella genomes project

## Data description

The project had a goal of invasive non-typhodial Salmonella genome sequencing on a high scale. While most (~ 7000) of the isolates were *Salmonella enterica*, data from collaborators also contained *Shigella* (~ 2000 isolates), *Staphylococcus aureus* (~ 400 isolates), as well as some other species.  

Data in the project were generated using Nextera library preparation and 2x150 bp Illumina sequencing on HiSeq 4000. Median sequencing depth was 30x; high-identity, low coverage samples were re-sequenced in an additional round of sequencing. Sequencing was done at [Earlham Institute](https://www.earlham.ac.uk/).

## Main steps of data processing

* Coverage estimation; 
* Bacterial species-level abundance estimation with [Kraken2](https://ccb.jhu.edu/software/kraken2/) (using [8Gb MiniKraken DB](ftp://ftp.ccb.jhu.edu/pub/data/kraken2_dbs/minikraken2_v2_8GB_201904_UPDATE.tgz)) and [Bracken](https://ccb.jhu.edu/software/bracken/); 
* Trimming of Nextera adapters using [bbduk](https://jgi.doe.gov/data-and-tools/bbtools/bb-tools-user-guide/bbduk-guide/); 
* Assembly with [Unicycler](https://github.com/rrwick/Unicycler); 
* Assembly quality evaluation: calculation of N50, assembly length, and number of contigs; 
* Alignment and PCR/optical duplicate estimation using [Picard MarkDuplicates](https://broadinstitute.github.io/picard/command-line-overview.html#MarkDuplicates); 
* MLST prediction using [mlst](https://github.com/tseemann/mlst); 
* Serovar prediction using [SISTR](https://github.com/peterk87/sistr_cmd) (*Salmonella* only); 
* Resistance and virulence gene profiling using [abricate](https://github.com/tseemann/abricate); 
* Final quality control based on [Enterobase criteria](https://enterobase.readthedocs.io/en/latest/pipelines/backend-pipeline-qaevaluation.html) (with modifications - see below).

## Parallel execution

All scripts used here dedicated to execution of one task for one sample (e.g. *one_unicycler.sh*) have a parallel wrapper (*all_unicycler.sh* for this example). Adjust the number of parallel jobs according to the system that you are running this on. 

## Assembly quality control 

All assemblies were classified according to the following scheme: 

* If an assembly has passed Enterobase criteria for the appropriate species, it was classified as **PASS**; 
* If an assembly has satisfied one of the two conditions listed below, it was classified as **RESCUE**: 
    * passes relaxed Enterobase criteria: 4M < (length) < 5.8M, species 90%+, N50 > 10,000, n_contigs < 2,000; 
    * or, passes Enterobase criteria if assembly is ran on a subset of reads identified as *Salmonella* by Kraken2 (for impure samples); 
* If assembly does not satisfy any of the above criteria, it is classified as **FAIL**. 

## Notes on adapter trimming 

Using Nextera protocol makes it harder to control insert size, often resulting in adapter being present in the final reads. We have compared several strategies of adapter trimming, including Trimmomatic palindromic mode and bbduk. Bbduk has shown the highest contiguity and fastest processing time.  

## Circular replicon rotation 

In order to compare circular replicons (plasmids etc), one needs to make sure they start at the same position. Included script named **rotate_circular.sh** uses the position of a reference gene in order to rotate the circular chromosomes and plasmids. 
