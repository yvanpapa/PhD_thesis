#!/bin/bash
#SBATCH --job-name=bam_align_mitogenome_TARdn
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=5G
#SBATCH --partition=bigmem
#SBATCH --time=3-12:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/bam_align_job_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/bam_align_job_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module purge #to avoid conflict with samtools
module load bwa-kit/0.7.15

REF=/nfs/scratch/papayv/Tarakihi/TARdn/mitogenome_tardn/mitogenome_tardn190515.fasta
R1=/nfs/scratch/papayv/Tarakihi/TARdn/03_Kraken/useqs_1.fq
R2=/nfs/scratch/papayv/Tarakihi/TARdn/03_Kraken/useqs_2.fq

echo "starting alignment"

time bwa mem $REF $R1 $R2 > mitogenome_tardn.sam

echo "alignment completed"



