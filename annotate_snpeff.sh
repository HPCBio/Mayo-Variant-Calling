#!/bin/bash
#SBATCH -c 1
#SBATCH --mem 8000
#SBATCH -A Mayo_Workshop
#SBATCH -J SnpEff

# load the tool environment
module load GATK/3.7-Java-1.8.0_121

# set some shortcuts...
export BUNDLE_HOME=/home/mirror/gatkbundle
export SNPEFF=$BUNDLE_HOME/mayo_workshop/snpEff_v3_3/snpEff.jar
export SNPEFF_CONFIG=$BUNDLE_HOME/mayo_workshop/snpEff.config

# this is our input (VCF)
export SNP_VCF_FILE=hard_filtered_snps.vcf
export INDEL_VCF_FILE=hard_filtered_indels.vcf

# this is our output (VCF)
export SNP_VCF_FILE_OUT=hard_filtered_snps_annotated.vcf
export INDEL_VCF_FILE_OUT=hard_filtered_indels_annotated.vcf

java -Xmx2g -jar $SNPEFF GRCh37.69 -geneId -o gatk -v $SNP_VCF_FILE -c $SNPEFF_CONFIG > $SNP_VCF_FILE_OUT

mkdir snpeff_snp_results
mv snpEff* snpeff_snp_results

java -Xmx2g -jar $SNPEFF GRCh37.69 -geneId -o gatk -v $INDEL_VCF_FILE -c $SNPEFF_CONFIG > $INDEL_VCF_FILE_OUT

mkdir snpeff_indel_results
mv snpEff* snpeff_indel_results
