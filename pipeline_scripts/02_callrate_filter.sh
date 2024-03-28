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


vcf_dir=$1
out_dir=$2

if [ ! -d ${out_dir}/CALLRATE95 ];then
        mkdir -m 777 -p ${out_dir}/CALLRATE95
fi

bcftools_bin=/share/apps/bio/bin/bcftools

vcf=${vcf_dir}/${chr}.vcf.gz

${bcftools_bin} +fill-tags ${vcf} -- -t all,F_MISSING | bcftools view --threads 5 -e "F_MISSING>=0.05"| bcftools view -e "HWE <= 0.000001" -O z -o ${out_dir}/CALLRATE95/${chr}.vcf.gz && bcftools index -t ${out_dir}/CALLRATE95/${chr}.vcf.gz
