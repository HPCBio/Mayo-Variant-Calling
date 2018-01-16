#!/bin/bash
#SBATCH -c 4
#SBATCH --mem 8000
#SBATCH -A Mayo_Workshop
#SBATCH -J SnpEff
#SBATCH -o SnpEff.%j.out
#SBATCH -e SnpEff.%j.err
#SBATCH -p classroom

# load the tool environment
module load GATK/3.7-Java-1.8.0_121

# set some shortcuts...
export BUNDLE_HOME=/home/mirror/gatkbundle
export SNPEFF=$BUNDLE_HOME/mayo_workshop/snpEff_latest/snpEff/snpEff.jar
export SNPEFF_CONFIG=$BUNDLE_HOME/mayo_workshop/snpEff_latest/snpEff/snpEff.config

# this is our input (VCF)
export SNP_VCF_FILE=hard_filtered_snps.vcf
export INDEL_VCF_FILE=hard_filtered_indels.vcf

# this is our output (VCF)
export SNP_VCF_FILE_OUT=hard_filtered_snps_annotated.vcf
export INDEL_VCF_FILE_OUT=hard_filtered_indels_annotated.vcf

# to speed this up, we limit the range
echo -e "20\t15000000\t30000000" > interval.bed

java -Xmx8g -jar $SNPEFF ann GRCh37.75 -geneId -o gatk -v $SNP_VCF_FILE -c $SNPEFF_CONFIG -filterInterval interval.bed > $SNP_VCF_FILE_OUT

mkdir snpeff_snp_results
mv snpEff* snpeff_snp_results

java -Xmx8g -jar $SNPEFF ann GRCh37.75 -geneId -o gatk -v $INDEL_VCF_FILE -c $SNPEFF_CONFIG -filterInterval interval.bed > $INDEL_VCF_FILE_OUT

mkdir snpeff_indel_results
mv snpEff* snpeff_indel_results

rm interval.bed
