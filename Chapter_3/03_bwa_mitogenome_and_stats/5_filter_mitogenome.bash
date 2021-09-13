#!/bin/bash
#SBATCH --job-name=filter_mitogenome
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=5G
#SBATCH --partition=bigmem
#SBATCH --time=3-1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/filter_mitogenome_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/filter_mitogenome_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module purge #to avoid conflict with samtools and bwa
module load samtools/1.9

bamfile=/nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/mitogenome_tardn

echo "counting reads unmapped to mitogenome"
time samtools view -c -f 4 $bamfile.bam

echo "keep only reads that did not map mitogenome"
time samtools view -b -f 4 $bamfile.bam > $bamfile.unmapped.bam
time samtools index $bamfile.unmapped.bam #create index
time samtools flagstat $bamfile.unmapped.bam > $bamfile.unmapped.bam.stats.txt

echo "counting reads mapped to mitogenome"
time samtools view -c -F 4 $bamfile.bam

echo "keep only reads that mapped mitogenome"
time samtools view -b -F 4 $bamfile.bam > $bamfile.mapped.bam
time samtools index $bamfile.mapped.bam #create index
time samtools flagstat $bamfile.mapped.bam > $bamfile.mapped.bam.stats.txt

echo "done"