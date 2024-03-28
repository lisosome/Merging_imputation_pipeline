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

vcfbase=${out_dir}/03.IMPUTED/VCF

stats_dir=${out_dir}/04.STATS

bimbamdir=${out_dir}/03.IMPUTED/BIMBAM


for fol in ${stats_dir} ${bimbamdir};do
    if [ ! -d ${wdir}/stats ];then
        mkdir -m 777 -p ${fol}
    fi
done

bcftools query -H -f"%CHROM\t%POS\t%ID\t%REF\t%ALT\t%AF\t%INFO/R2\t%INFO/IMP\n" ${vcfbase}/${chr}.vcf.gz | awk 'BEGIN{FS="\t";OFS="\t"}{if($8==".") print $1,$2,$3,$4,$5,$6,$7,0;else print $0}' | gzip -c > ${stats_dir}/${chr}.info_stats.gz &&
bcftools query -f'%ID,%REF,%ALT[,%DS]\n' ${vcfbase}/${chr}.vcf.gz | gzip --best -c > ${bimbamdir}/${chr}.bimbam.gz &&
bcftools query -f'%ID,%POS,%CHROM\n' ${vcfbase}/${chr}.vcf.gz -o  ${bimbamdir}/${chr}.pos










