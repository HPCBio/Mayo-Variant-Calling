#!/bin/bash
#SBATCH -n 4
#SBATCH --mem 12000
#SBATCH -A Mayo_Workshop
#SBATCH -J HaplotypeCaller
#SBATCH -o HaplotypeCaller.%j.out
#SBATCH -e HaplotypeCaller.%j.err
#SBATCH -p classroom

# load the tools (GATK)
module load GATK/4.0.9.0-IGB-gcc-4.9.4-Java-1.8.0_152-Python-3.6.1

# reference genome
export BUNDLE_HOME=/home/mirror/gatkbundle
export REFERENCE=$BUNDLE_HOME/mayo_workshop/2019/human_g1k_v37.fasta

# this is our input (BAM)
export BAM_FILE=$BUNDLE_HOME/mayo_workshop/NA12878.HiSeq.WGS.bwa.cleaned.recal.b37.20_arm1.bam

# our outputs (VCF)
export VCF_FILE=raw_variants.hc.vcf

# this is our dbsnp source
export DBSNP=$BUNDLE_HOME/mayo_workshop/2019/dbsnp_138.b37.vcf.gz

# Joint calls
gatk --java-options "-Xmx8g" HaplotypeCaller \
    -I $BAM_FILE \
    -R $REFERENCE \
    --dbsnp $DBSNP \
    --native-pair-hmm-threads $SLURM_NPROCS \
    -L 20:15000000-30000000 \
    -A Coverage \
    -O $VCF_FILE
