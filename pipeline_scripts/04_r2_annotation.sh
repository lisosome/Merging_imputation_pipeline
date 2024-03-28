#!/usr/bin/env bash
set -e


###########################################
#             JOB DEFINITION              #
###########################################

#$ -l h_vmem=4G
#$ -V
#$ -q fast
#$ -t 1-22
#$ -pe smp 5

###################
# ARRAY VARIABLES # 
###################
echo "JOB_ID: $JOB_ID"
echo "TASK_ID: $SGE_TASK_ID"

chr_list=$(echo "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22")
chr=$(echo ${chr_list} | cut -d " " -f$SGE_TASK_ID)


###################
#       JOB       # 
###################
out_dir=$1

wdir=${out_dir}/03.IMPUTED/VCF


if [ ! -d ${wdir} ];then
        mkdir -m 777 -p ${wdir}
fi

if [ ! -d ${wdir}/headers ];then
        mkdir -m 777 -p ${wdir}/headers
fi

echo "##INFO=<ID=R2,Number=.,Type=Float,Description=\"Imputation Info score calculated using qctool software after merging different batches\">" > ${wdir}/headers/${chr}.header
bcftools annotate --threads 5 -x INFO/R2 ${out_dir}/CALLRATE95/${chr}.vcf.gz | bcftools annotate --threads 3 -c CHROM,POS,-,REF,ALT,R2 -h ${wdir}/headers/${chr}.header -a ${out_dir}/CALLRATE95/${chr}.info.tab.gz -Oz -o ${wdir}/${chr}.vcf.gz &&
bcftools index --threads 5 -t ${wdir}/${chr}.vcf.gz

