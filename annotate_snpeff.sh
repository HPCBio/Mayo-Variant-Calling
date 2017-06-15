#!/bin/bash
#PBS -l mem=10gb,nodes=1:ppn=1
#PBS -A Mayo_Workshop

# move to the work directory
cd $PBS_O_WORKDIR

# load the tool environment
module load gatk/2.5-2

# set some shortcuts...

export SNPEFF=/home/mirrors/gatk_bundle/mayo_workshop/snpEff_v3_3/snpEff.jar

export SNPEFF_CONFIG=/home/mirrors/gatk_bundle/mayo_workshop/snpEff.config

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
