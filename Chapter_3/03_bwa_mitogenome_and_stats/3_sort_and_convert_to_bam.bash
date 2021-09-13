#!/bin/bash
#SBATCH --job-name=sort_and_convert-to_bam
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=5G
#SBATCH --partition=bigmem
#SBATCH --time=3-12:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/sort_and_convert-to_bam_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/sort_and_convert-to_bam_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module purge #to avoid conflict with samtools
module load samtools/1.9

samfile=/nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/mitogenome_tardn.sam

echo "Convert SAM to sorted BAM."
time  samtools sort $samfile > mitogenome_tardn.bam

echo "Index the BAM file."
time samtools index /nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/mitogenome_tardn.bam



