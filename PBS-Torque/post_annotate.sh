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

# this is our input (raw VCF)
export SNP_VCF_FILE_ORIG=hard_filtered_snps.vcf
export SNP_VCF_FILE_SNPEFF=hard_filtered_snps_annotated.vcf

export INDEL_VCF_FILE_ORIG=hard_filtered_indels.vcf
export INDEL_VCF_FILE_SNPEFF=hard_filtered_indels_annotated.vcf

# this is our output (VCF)
export SNP_VCF_FILE_OUT=hard_filtered_snps_final.vcf
export INDEL_VCF_FILE_OUT=hard_filtered_indels_final.vcf

# the actual GATK calls

# SNPs
java -jar $GATK -T VariantAnnotator \
    -R $REFERENCE \
    -A SnpEff \
    --variant $SNP_VCF_FILE_ORIG \
    --snpEffFile $SNP_VCF_FILE_SNPEFF \
    -nt $PBS_NUM_PPN \
    -o $SNP_VCF_FILE_OUT

# Indels
java -jar $GATK -T VariantAnnotator \
    -R $REFERENCE \
    -A SnpEff \
    --variant $INDEL_VCF_FILE_ORIG \
    --snpEffFile $INDEL_VCF_FILE_SNPEFF \
    -nt $PBS_NUM_PPN \
    -o $INDEL_VCF_FILE_OUT
