#!/bin/bash
#SBATCH -c 4
#SBATCH --mem 8000
#SBATCH -A Mayo_Workshop
#SBATCH -J VariantAnnotator
#SBATCH -o VariantAnnotator.%j.out
#SBATCH -e VariantAnnotator.%j.err
#SBATCH -p classroom

# load the tools (GATK)
module load GATK/3.7-Java-1.8.0_121

# reference genome
export BUNDLE_HOME=/home/mirror/gatkbundle
export REFERENCE=$BUNDLE_HOME/2.5/b37/human_g1k_v37.fasta

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
java -jar $EBROOTGATK/GenomeAnalysisTK.jar -T VariantAnnotator \
    -R $REFERENCE \
    -A SnpEff \
    --variant $SNP_VCF_FILE_ORIG \
    --snpEffFile $SNP_VCF_FILE_SNPEFF \
    -L 20:15000000-30000000 \
    -nt $SLURM_CPUS_PER_TASK \
    -o $SNP_VCF_FILE_OUT

# Indels
java -jar $EBROOTGATK/GenomeAnalysisTK.jar -T VariantAnnotator \
    -R $REFERENCE \
    -A SnpEff \
    --variant $INDEL_VCF_FILE_ORIG \
    --snpEffFile $INDEL_VCF_FILE_SNPEFF \
    -L 20:15000000-30000000 \
    -nt $SLURM_CPUS_PER_TASK \
    -o $INDEL_VCF_FILE_OUT
