#!/bin/bash
#SBATCH -n 4
#SBATCH --mem 32g
#SBATCH -A Mayo_Workshop
#SBATCH -J UnifiedGenotyper
#SBATCH -o UnifiedGenotyper.%j.out
#SBATCH -e UnifiedGenotyper.%j.err
#SBATCH -p classroom

# load the tools (GATK)
module load GATK/3.8-1-0-Java-1.8.0_152

# reference genome
export BUNDLE_HOME=/home/classroom/hpcbio
export REFERENCE=$BUNDLE_HOME/mayo_workshop/2019/human_g1k_v37.fasta

# this is our input (BAM)
export BAM_FILE=$BUNDLE_HOME/mayo_workshop/NA12878.HiSeq.WGS.bwa.cleaned.recal.b37.20_arm1.bam

# our outputs (VCF)
export SNP_VCF_FILE=raw_snps.vcf
export INDEL_VCF_FILE=raw_indels.vcf

# this is our dbsnp source
export DBSNP=$BUNDLE_HOME/mayo_workshop/2019/dbsnp_138.b37.vcf.gz

# the actual GATK calls

# SNPs
gatk -T UnifiedGenotyper \
    -I $BAM_FILE \
    -R $REFERENCE \
    -glm SNP \
    --dbsnp $DBSNP \
    -out_mode EMIT_VARIANTS_ONLY \
    -L 20:15000000-30000000 \
    -stand_call_conf 30  \
    --num_threads $SLURM_NPROCS \
    -A Coverage \
    -A HaplotypeScore \
    --disable_auto_index_creation_and_locking_when_reading_rods \
    -o $SNP_VCF_FILE

# Indels
gatk -T UnifiedGenotyper \
    -I $BAM_FILE \
    -R $REFERENCE \
    -glm INDEL \
    --dbsnp $DBSNP \
    -out_mode EMIT_VARIANTS_ONLY \
    -L 20:15000000-30000000 \
    -stand_call_conf 30  \
    --num_threads $SLURM_NPROCS \
    -A Coverage \
    -A HaplotypeScore \
    --disable_auto_index_creation_and_locking_when_reading_rods \
    -o $INDEL_VCF_FILE
