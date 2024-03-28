## Introduction

Simple pipeline based on SGE jobs dependency system on Apollo HPC cluster at Burlo Garofolo. It involves six steps:
- **01_batch_merging.sh**: BCFTools merge command to merge vcf from different batches;
- **02_callrate_filter.sh**: BCFTools fill-tags annotation and callrate 95% filtering;
- **03_qctools_stats.sh**: QCtool's R2 calculation and tsv files creation for subsequent annotation;
- **04_r2_annotation.sh**: R2 INFO tag update with R2 from QCtool using BCFTools;
- **05_merge_stats.sh**: BCFTools stats of merged VCFs;
- **06_tabs_n_bimbam.sh**: Tsv files with imputed/genotyped SNPs and BIMBAM format files creation.

## Usage

`Merging_pipeline.sh /path/to/vcf/from/first/batch,/path/to/vcf/from/second/batch /path/to/output/folder`

VCF files must be named as `${chromosome}.vcf.gz`. e.g.: 22.vcf.gz

## Description

Every step will be submitted by the wrapper script (Merging_pipeline.sh) as a job array. Each task of the array is a process that analyse each autosomal chromosome. The dependency system revolves around the -hold_jid flag of qsub. Doing so, step two will start after completion of the 22 tasks of step one, and the same will do step three with step two and so on.

