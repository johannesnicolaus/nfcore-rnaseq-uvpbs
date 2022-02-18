# nfcore-rnaseq-uvpbs
nfcore RNA-seq pipeline template for IPR UV-PBS

Written by Johannes Nicolaus Wibisana for the Laboratory for Cell Systems IPR

This template repository can be used for the analysis of bulk-RNA-seq data, including steps from QC, trimming, alignment, up to the quantification of transcripts.

More info of the pipeline is available on:
https://nf-co.re/rnaseq/3.5

# Prerequisites
Nextflow must be installed, preferably using conda:
```shell
$ conda install nextflow
```

To install miniconda:
https://docs.conda.io/en/latest/miniconda.html

To download this repository to your local directory:
```shell
$ git clone https://github.com/johannesnicolaus/nfcore-rnaseq-uvpbs.git
```

# Usage

## To prepare your data for analysis
- Place all the `fastq.gz` files inside the `raw_data` directory.
- Edit `samplesheet_rna.csv` within the `work` directory to include the following information at each column:
   1. `sample`: replicate can be separated by using the suffix `_1`, `_2`, etc. The same sample sequenced more than once should have identical sample names.<br> (Check https://nf-co.re/rnaseq/usage for sample naming)
   2. `fastq_1`: Read 1 (R1) containing fastq file
   3. `fastq_2`: Read 2 (R2) containing fastq file, leave blank if single-end read only
   4. strandedness. Sample strand-specificity: `unstranded`, `forward`, `reverse`.

### More details about the sample sheet
Please refer to https://nf-co.re/rnaseq/usage for details on sample sheet usage.

Strandedness is required for accurate QC. As the parameter `--salmon_quant_libtype A` is specified, downstream analyses will not be affected even though the wrong strandedness is specified.

## Running the pipeline
To run the pipeline, navigate to the `work` directory and execute:
```shell
$ qsub run.sh
```

To check progress:
```shell
$ qstat
```

# Description of parameters

## UV-PBS server parameters used in script

- `#PBS -q MEDIUM` <br>
Specifies the queue where the job is run: <br>
  - LARGE: 64 threads max
  - MEDIUM: 8 threads max
  - SMALL: 1 thread max

- `#PBS -l select=1:ncpus=8:mem=256gb` <br>
Specifies the number of node (1), the number of CPUs (8) which is restricted by the type of queue used and the memory allocated for the job (256gb)

- `#PBS -N JOB_NAME`<br>
Specifies the name of the job.

- `#PBS -m e` <br>
Sends email when job is terminated.

- `#PBS -e ${PBS_O_WORKDIR}` `#PBS -o ${PBS_O_WORKDIR}`<br>
Sets the error and output log directory to the same directory as the `run.sh` script.

- `#PBS -M YOUR_EMAIL@EMAIL.com` <br>
Email for which the job status is sent to.

## Default nf-core/rnaseq parameters in the template script

For detailed usage and parameters, please visit:
https://nf-co.re/rnaseq/dev/usage


- `-r 3.5`<br>
Specifies the version of the nf-core pipeline to ensure reproducibility, it is set to the newest (as of to 2022/2/17): `3.5` here.

- `-profile singularity`<br>
Specifies where the software required for the pipeline are downloaded from. As UV-PBS supports singularity, we will be using singularity.

- `--input samplesheet_rna.csv`<br>
Specifies the sample sheet containing sample info.

- `--genome GRCh38`<br>
Uses the default GRCh38 from AWS igenomes. Use GRCm38 for mouse. The genome keys are available here:
https://support.illumina.com/sequencing/sequencing_software/igenome.html

- `--save_reference`<br>
Option to save the indexed STAR reference files within the results directory.

- `--salmon_quant_libtype A`<br>
Automatically infers strandedness for quantification of transcripts using Salmon.

- `--max_cpus 8`<br>
Uses max CPU of 8, this depends on the queue where the job is run.

- `--max_memory 256.GB`<br>
Uses max memory of 256 GB, this also depends on the parameters set on the `#PBS` headers.


## Results
Results will be available in the `results` directory, in which the quality check results are within the multiqc directory and the quantified transcripts are within the `star_salmon` directory.

To read counts to R, use the package `tximport`. Details are in the following page:
https://nf-co.re/rnaseq/dev/output#pseudo-alignment-and-quantification

Additionally, indexed reference file will be available in the `results` directory.


# Notes
## Specifying previously built index file
Use the parameter `--star_index` and specify the STAR reference directory (should be in results directory after the first run).

## Specifying cache for singularity images
To prevent nf-core from downloading singularity containers on every run, add the following line to `~/.bash_profile`:

```shell
 export NXF_SINGULARITY_CACHEDIR="/user1/tanpaku/okada/YOUR_USERNAME/SINGULARITY_DIRECTORY"   
```

Where `SINGULARITY_DIRECTORY` is the directory where the images are stored.

## To resume job 
If somehow the job was aborted due to errors or any other problem, it is possible to continue from the last succesful checkpoint by addint the following parameter: <br>
`-resume`



For further questions contact Nico at: <br>
nico@protein.osaka-u.ac.jp <br>
johannes.nicolaus@gmail.com
