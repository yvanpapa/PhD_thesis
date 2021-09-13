#!/bin/bash
#SBATCH --job-name=produce_stats_bam_file
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=5G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/produce_stats_bam_file_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/produce_stats_bam_file_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module purge #to avoid conflict with samtools and bwa
module load samtools/1.9

bamfile=/nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/mitogenome_tardn

echo "computing stats"
time samtools flagstat $bamfile.bam > $bamfile.stats.txt
echo "stats computed"




