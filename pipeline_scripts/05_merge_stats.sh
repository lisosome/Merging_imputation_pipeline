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


if [ ! -d ${wdir}/stats ];then
        mkdir -m 777 -p ${wdir}/stats
fi

bcftools stats ${wdir}/${chr}.vcf.gz >> ${wdir}/stats/${chr}.merge_stats 







