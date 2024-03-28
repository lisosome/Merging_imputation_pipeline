#!/usr/bin/env bash
set -e


###########################################
#             JOB DEFINITION              #
###########################################

#$ -l h_vmem=4G
#$ -V
#$ -q fast@apollo1.burlo.trieste.it,fast@apollo3.burlo.trieste.it
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

if [ ! -d ${out_dir}/CALLRATE95 ];then
        mkdir -m 777 -p ${out_dir}/CALLRATE95
fi

qctool=/home/nardone/software/qctool_v2.2.0/qctool
#qctool=/share/apps/bio/bin/qctool_v2.0.1

vcf=${out_dir}/CALLRATE95/${chr}.vcf.gz

qctool_out=${out_dir}/CALLRATE95/${chr}.info_stats

${qctool} -threads 5 -g ${vcf} -filetype vcf -vcf-genotype-field GP -snp-stats -osnp ${qctool_out} &&
echo -e "#CHROM\tPOS\tID\tREF\tALT\tR2" > ${out_dir}/CALLRATE95/${chr}.info.tab &&
grep ^NA ${qctool_out} | cut -f2-6,18 | awk 'BEGIN{FS=" ";OFS="\t"}{if($6=="NA") print $2,$3,$1,$4,$5,0;else print $2,$3,$1,$4,$5,sprintf("%.3f",$6)}' >> ${out_dir}/CALLRATE95/${chr}.info.tab && bgzip ${out_dir}/CALLRATE95/${chr}.info.tab &&
tabix -f -s 1 -b 2 -e 2 ${out_dir}/CALLRATE95/${chr}.info.tab.gz









