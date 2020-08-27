# 10k Salmonella Genomes Project 

Efficient data processing for [10k Salmonella genomes](https://10k-salmonella-genomes.com/) project.

## Reference 

Perez-Sepulveda BM, Heavens D, Pulford CV, Predeus AV *et al.*, [An accessible, efficient and global approach for the large-scale sequencing of bacterial genomes](https://www.biorxiv.org/content/10.1101/2020.07.22.200840v1), *bioRxiv* **2020**.

## Data description

The project had the goal of genome sequencing invasive non-typhoid Salmonella on a large scale. While most (~7000) of the isolates were *Salmonella enterica*, collaborators also provided *Shigella* (~2000 isolates), *Staphylococcus aureus* (~400 isolates), as well as some other species.  

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
* Automated annotation using [Prokka](https://github.com/tseemann/prokka) (*Salmonella* only);
* Final quality control based on [Enterobase criteria](https://enterobase.readthedocs.io/en/latest/pipelines/backend-pipeline-qaevaluation.html) (with modifications - see below).

## Directory structure 

Choose a working directory (`$WDIR` variable in scripts) with plenty of space. Within, create the following sub-directories: 

* 0\_merged\_fastq
* 1\_kraken2  
* 2\_duplicates  
* 3\_coverage\_etc  
* 4\_assembly  
* 5\_sistr  
* 6\_MLST  
* 7\_rescue  
* 8\_final\_fasta
* 9\_prokka

## Dependency installation

You can install all tools used by this pipeline with Bioconda. Following commands should help you install exact same versions of packages we have used in the paper: 

```bash
conda create -n 10k_salmonella
source activate 10k_salmonella
conda install kraken2=2.0.8_beta
conda install unicycler=0.4.7
conda install sistr_cmd=1.0.2
conda install mlst=2.11 
conda install bracken=1.0.0
conda install bowtie2=2.3.5
conda install samtools=1.9
conda install picard=2.21.1
conda install prokka=1.13.7
conda install abricate=1.0.1
```
Also, you would need to download and install [BBtools](https://sourceforge.net/projects/bbmap/) v38.07.

There's pretty good chance everything will work fine with other tool versions; known exceptions are `samtools` (version < 1), and old versions of `sistr_cmd` (different number of fields in the output file). 

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
    * or, passes Enterobase criteria if assembly is run on a subset of reads identified as *Salmonella* by Kraken2 (for impure samples); 
* If assembly does not satisfy any of the above criteria, it is classified as **FAIL**.


<p align="center"><img src="https://github.com/apredeus/10k_genomes/blob/master/img/10k_genomes_qc_V3.png"></p>

## Notes on adapter trimming 

Using the Nextera protocol makes it difficult to control insert size, often resulting in adapter sequences being present in the final reads. We have compared several strategies of adapter trimming, including Trimmomatic palindromic mode and bbduk. Bbduk trimming resulted in the highest assembly contiguity and the fastest processing time.  

<p align="center"><img src="https://github.com/apredeus/10k_genomes/blob/master/img/n50.png"></p>
