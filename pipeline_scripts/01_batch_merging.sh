#!/usr/bin/env bash
set -e


###########################################
#             JOB DEFINITION              #
###########################################

#$ -l h_vmem=4G
#$ -V
#$ -q all.q
#$ -t 1-22


###################
# ARRAY VARIABLES # 
###################

echo "JOB_ID: $JOB_ID"
echo "TASK_ID: $SGE_TASK_ID"

chr_list=$(echo "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22")
chr=$(echo ${chr_list} | cut -d " " -f$SGE_TASK_ID)


vcf_dir=$1
out_dir=$2

if [ ! -d ${out_dir}/MERGED ];then
        mkdir -m 777 -p ${out_dir}/MERGED
fi


merge_arg=""
while read line;do  
vcf=$(find ${line} -type f -name "${chr}.vcf.gz")
merge_arg="${merge_arg} ${vcf}"
done < <(echo ${vcf_dir} | tr "," "\n")

echo "Vcfs: ${merge_arg}"


outvcf=${out_dir}/MERGED/${chr}.vcf.gz


bcftools merge -m none ${merge_arg} -Oz -o ${outvcf} && bcftools index -t ${outvcf} 













