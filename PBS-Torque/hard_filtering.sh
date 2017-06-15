#!/bin/bash
#PBS -l mem=10gb,nodes=1:ppn=4
#PBS -A Mayo_Workshop

# move to the work directory
cd $PBS_O_WORKDIR

# load the tool environment
module load gatk/2.5-2

# set some shortcuts...
# GATK path
export GATK=/home/apps/gatk/gatk-2.5-2/GenomeAnalysisTK.jar

# reference genome
export REFERENCE=/home/mirrors/gatk_bundle/2.5/b37/human_g1k_v37.fasta

# inputs (raw VCF)
export SNP_VCF_FILE=raw_snps.vcf
export INDEL_VCF_FILE=raw_indels.vcf

# outputs (VCF)
export SNP_VCF_FILE_OUT=hard_filtered_snps.vcf
export INDEL_VCF_FILE_OUT=hard_filtered_indels.vcf

# the actual GATK calls

# SNPs
java -jar $GATK -T VariantFiltration \
    -R $REFERENCE \
    --variant $SNP_VCF_FILE \
    --clusterSize 3 \
    --clusterWindowSize 10 \
    --filterExpression "QD < 2.0" \
    --filterName "QDFilter" \
    --filterExpression "MQ < 40.0" \
    --filterName "MQFilter" \
    --filterExpression "FS > 60.0" \
    --filterName "FSFilter" \
    --filterExpression "HaplotypeScore > 13.0" \
    --filterName "HaplotypeScoreFilter" \
    --filterExpression "MQRankSum < -12.5" \
    --filterName "MQRankSumFilter" \
    --filterExpression "ReadPosRankSum < -8.0" \
    --filterName "ReadPosRankSumFilter" \
    -o $SNP_VCF_FILE_OUT

# Indels
java -jar $GATK -T VariantFiltration \
    -R $REFERENCE \
    --variant $INDEL_VCF_FILE \
    --filterExpression "QD < 2.0" \
    --filterName "QDFilter" \
    --filterExpression "ReadPosRankSum < -20.0" \
    --filterName "ReadPosFilter" \
    --filterExpression "FS > 200.0" \
    --filterName "FSFilter" \
    -o $INDEL_VCF_FILE_OUT

