#!/bin/bash
#PBS -l mem=10gb,nodes=1:ppn=4
#PBS -A Mayo_Workshop

# move to the work directory, where you submitted the job
cd $PBS_O_WORKDIR

# load the tools (GATK)
module load gatk/2.5-2

# set some shortcuts...
# GATK path
export GATK=/home/apps/gatk/gatk-2.5-2/GenomeAnalysisTK.jar

# reference genome
export REFERENCE=/home/mirrors/gatk_bundle/2.5/b37/human_g1k_v37.fasta

# this is our input (BAM)
export BAM_FILE=/home/mirrors/gatk_bundle/mayo_workshop/NA12878.HiSeq.WGS.bwa.cleaned.recal.b37.20_arm1.bam

# our outputs (VCF)
export SNP_VCF_FILE=raw_snps.vcf
export INDEL_VCF_FILE=raw_indels.vcf

# this is our dbsnp source
export DBSNP=/home/mirrors/gatk_bundle/mayo_workshop/resources/dbsnp_137.b37.vcf

# the actual GATK calls

# SNPs
java -jar $GATK -T UnifiedGenotyper \
    -I $BAM_FILE \
    -R $REFERENCE \
    -glm SNP \
    --dbsnp $DBSNP \
    -out_mode EMIT_VARIANTS_ONLY \
    -L 20 \
    -stand_emit_conf 10 \
    -stand_call_conf 30  \
    -nt $PBS_NUM_PPN \
    -A Coverage \
    -A HaplotypeScore \
    -A InbreedingCoeff \
    -o $SNP_VCF_FILE

# Indels
java -jar $GATK -T UnifiedGenotyper \
    -I $BAM_FILE \
    -R $REFERENCE \
    -glm INDEL \
    --dbsnp $DBSNP \
    -out_mode EMIT_VARIANTS_ONLY \
    -L 20 \
    -stand_emit_conf 10 \
    -stand_call_conf 30  \
    -nt $PBS_NUM_PPN \
    -A Coverage \
    -A HaplotypeScore \
    -A InbreedingCoeff \
    -o $INDEL_VCF_FILE

