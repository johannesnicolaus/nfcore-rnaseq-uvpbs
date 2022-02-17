#!/bin/sh

#PBS -q MEDIUM
#PBS -l select=1:ncpus=8:mem=256gb
#PBS -N JOB_NAME
#PBS -m e
#PBS -e ${PBS_O_WORKDIR}/logs
#PBS -o ${PBS_O_WORKDIR}/logs
#PBS -M YOUR_EMAIL@EMAIL.com

cd ${PBS_O_WORKDIR}

source $HOME/apps/anaconda3/bin/activate

# for more info on settings: https://nf-co.re/rnaseq/3.5
nextflow run nf-core/rnaseq \
    -r 3.5 \
    -profile singularity \
    --input samplesheet_rna.csv \
    --genome GRCh38 \
    --save_reference \
    --salmon_quant_libtype A \
    --max_cpus 8 \
    --max_memory 256.GB