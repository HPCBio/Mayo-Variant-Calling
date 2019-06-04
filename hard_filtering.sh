#!/bin/bash
#SBATCH -n 1
#SBATCH --mem 8000
#SBATCH -A Mayo_Workshop
#SBATCH -J GATK-Filtering
#SBATCH -o GATK-Filtering.%j.out
#SBATCH -e GATK-Filtering.%j.err
#SBATCH -p classroom

# load the tool environment
module load GATK/3.8-1-0-Java-1.8.0_152

# set some shortcuts...
# reference genome
export BUNDLE_HOME=/home/mirror/gatkbundle
export REFERENCE=$BUNDLE_HOME/mayo_workshop/2019/human_g1k_v37.fasta

# inputs (raw VCF)
export SNP_VCF_FILE=raw_snps.vcf
export INDEL_VCF_FILE=raw_indels.vcf

# outputs (VCF)
export SNP_VCF_FILE_OUT=hard_filtered_snps.vcf
export INDEL_VCF_FILE_OUT=hard_filtered_indels.vcf

# the actual GATK calls

# SNPs
gatk -T VariantFiltration \
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
gatk -T VariantFiltration \
    -R $REFERENCE \
    --variant $INDEL_VCF_FILE \
    --filterExpression "QD < 2.0" \
    --filterName "QDFilter" \
    --filterExpression "ReadPosRankSum < -20.0" \
    --filterName "ReadPosFilter" \
    --filterExpression "FS > 200.0" \
    --filterName "FSFilter" \
    -o $INDEL_VCF_FILE_OUT
