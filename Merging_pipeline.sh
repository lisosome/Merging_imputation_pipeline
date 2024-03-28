#!/usr/bin/env bash
set -e

###########################################
#                VARIABLES                #
###########################################

vcf_dir=$1 # Comma separated list of directory in which are stored the imputed batches to merge
outdir=$2
logdir=${outdir}/Logs

pipedir=$(dirname $0)

scriptdir=/home/nardone/script/pipeline_merging/pipeline_scripts

if [ ! -d ${logdir} ];then
        mkdir -m 777 -p ${logdir}
fi

###########################################
#           STEP1: VCF MERGING            #
###########################################

job1=$(qsub -N merge_vcf -o ${logdir}/merge_vcf.log -e ${logdir}/merge_vcf.err ${scriptdir}/01_batch_merging.sh ${vcf_dir} ${outdir})

merge_vcf=$(echo "${job1}" | grep -oE '[0-9]+\.[0-9]+')

echo "JOB ID VCF merging: ${merge_vcf}"

###########################################
#        STEP2: CALLRATE FILTERING        #
###########################################

callrate=$(qsub -N callrate_filtering -hold_jid merge_vcf -o ${logdir}/callrate_filtering.log -e ${logdir}/callrate_filtering.err ${scriptdir}/02_callrate_filter.sh ${outdir}/MERGED ${outdir})
echo "JOB ID callrate filtering: ${callrate}"

#-hold_jid ${merge_vcf}

###########################################
#          STEP3: QCTOOLS STATS           #
###########################################

qctool=$(qsub -N qctool_stats -hold_jid callrate_filtering -o ${logdir}/qctool_stats.log -e ${logdir}/qctool_stats.err ${scriptdir}/03_qctools_stats.sh ${outdir})
echo "JOB ID qctool stats: ${qctool}"

###########################################
#          STEP4: R2 ANNOTATION           #
###########################################

r2=$(qsub -N r2_annotation -hold_jid qctool_stats -o ${logdir}/r2_annotation.log -e ${logdir}/r2_annotation.err ${scriptdir}/04_r2_annotation.sh ${outdir})
echo "JOB ID R2 annotation: ${r2}"

###########################################
#          STEP5: MERGE STATS             #
###########################################

merge_stats=$(qsub -N merge_stats -hold_jid r2_annotation -o ${logdir}/merge_stats.log -e ${logdir}/merge_stats.err ${scriptdir}/05_merge_stats.sh ${outdir})
echo "JOB ID merge stats: ${merge_stats}"

###########################################
#         STEP6: TABS & BIMBAMS           #
###########################################

bim=$(qsub -N tabsNbimbams -hold_jid merge_stats -o ${logdir}/tabsNbimbams.log -e ${logdir}/tabsNbimbams.err ${scriptdir}/06_tabs_n_bimbam.sh ${outdir})
echo "JOB ID tabs & bimbams: ${bim}"
