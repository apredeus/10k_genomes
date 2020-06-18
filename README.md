# 10k Salmonella Genomes Project 

Efficient data processing for 10k Salmonella genomes project

## Data description

The project had the goal of genome sequencing invasive non-typhod Salmonella on a large scale. While most (~7000) of the isolates were *Salmonella enterica*, collaborators also provided *Shigella* (~2000 isolates), *Staphylococcus aureus* (~400 isolates), as well as some other species.  

Data in the project were generated using a modified Nextera library preparation approach (the LITE protocol) and 2x150 bp Illumina sequencing on HiSeq 4000. Details will be published soon (Perez-Sepulveda et al 2020). 

Median sequencing depth was 30x; high-identity, low coverage samples were re-sequenced in an additional round of sequencing. Sequencing was done at [Earlham Institute](https://www.earlham.ac.uk/).

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

All scripts used here were dedicated to the execution of one task for one sample (e.g. *one_unicycler.sh*) had a parallel wrapper (*all_unicycler.sh* for this example). The number of parallel jobs should be adjusted according to the system that you are running these scripts on. 

## Assembly quality control 

All assemblies were classified according to the following scheme: 

* If an assembly has passed slightly modified Enterobase criteria for the appropriate species, it was classified as **PASS**; These criteria for *Salmonella enterica* are: 

  | Metrics                            | Criteria             |
  |------------------------------------|----------------------|
  | Assembly length                    | 4.0-5.8Mb            |
  | N50 value                          | >20kb                |
  | Number of contigs                  | <600                 | 
  | Read assignment by Kraken2+Bracken | >70% correct species | 

* Alternatively, if an assembly satisfied one of the two conditions listed below, it was classified as **RESCUE**: 
    * Passes relaxed Enterobase criteria: 4Mb < (length) < 5.8Mb, species 90%+, N50 > 10kb, n_contigs < 2,000; 
    * Or, passes Enterobase criteria if assembly is run on a subset of reads identified as *Salmonella* by Kraken2 (for impure samples); 
* If assembly does not satisfy any of the above criteria, it is classified as **FAIL**.

<p align="center"><img src="https://github.com/apredeus/10k_genomes/blob/master/img/10k_genomes_qc_V3.png"></p>

## Notes on adapter trimming 

Using the Nextera protocol makes it difficult to control insert size, often resulting in adapter sequences being present in the final reads. We have compared several strategies of adapter trimming, including Trimmomatic palindromic mode and bbduk. Bbduk trimming resulted in the highest assembly contiguity and the fastest processing time.  

<p align="center"><img src="https://github.com/apredeus/10k_genomes/blob/master/img/n50.png"></p>

## Circular replicon rotation 

In order to compare circular replicons (plasmids etc), one needs to make sure they start at the same position. Included script named **rotate_circular.sh** uses the position of a reference gene to rotate the circular chromosomes and plasmids. 
