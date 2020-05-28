#!/bin/bash
#SBATCH -n 2
#SBATCH --mem 16g
#SBATCH -A Mayo_Workshop
#SBATCH -J SnpEff
#SBATCH -o SnpEff.%j.out
#SBATCH -e SnpEff.%j.err
#SBATCH -p classroom

# load the tool environment
module load GATK/3.8-1-0-Java-1.8.0_152
module load snpEff/4.3t-Java-1.8.0_152

# set some shortcuts...
export BUNDLE_HOME=/home/classroom/hpcbio
export REFERENCE=$BUNDLE_HOME/mayo_workshop/2019/human_g1k_v37.fasta

export SNPEFF_CONFIG=$BUNDLE_HOME/mayo_workshop/2019/snpEff.config

# this is our input (VCF)
export SNP_VCF_FILE=hard_filtered_snps.vcf
export INDEL_VCF_FILE=hard_filtered_indels.vcf

# this is our output (VCF)
export SNP_VCF_FILE_OUT=hard_filtered_snps_annotated.vcf
export INDEL_VCF_FILE_OUT=hard_filtered_indels_annotated.vcf

# to speed this up, we limit the range
echo -e "20\t15000000\t30000000" > interval.bed

snpEff ann GRCh37.75 \
    -c $SNPEFF_CONFIG \
    -geneId -o gatk -v $SNP_VCF_FILE \
    -filterInterval \
    interval.bed > $SNP_VCF_FILE_OUT

mkdir snpeff_snp_results
mv snpEff* snpeff_snp_results

snpEff ann GRCh37.75 \
    -c $SNPEFF_CONFIG \
    -geneId -o gatk -v $INDEL_VCF_FILE \
    -filterInterval \
    interval.bed > $INDEL_VCF_FILE_OUT

mkdir snpeff_indel_results
mv snpEff* snpeff_indel_results

rm interval.bed
