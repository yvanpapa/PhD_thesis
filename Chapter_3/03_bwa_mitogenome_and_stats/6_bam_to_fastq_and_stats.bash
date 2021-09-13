#!/bin/bash
#SBATCH --job-name=bam_to_fastq
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=5G
#SBATCH --partition=bigmem
#SBATCH --time=3-1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/bam_to_fastq_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/bam_to_fastq_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module purge #to avoid conflict bwa and samtools
module load samtools/1.9 
module load bedtools/2.27.1
module load seqkit/0.10.1

filename=/nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/mitogenome_tardn.unmapped

echo "sort the BAM file by query name (required for bamtofastq paired-end)"
time samtools sort  -o $filename.sorted.bam -n $filename.bam
#-o is required for samtools ouput now. -n means sort by seq name

echo "start bam to fastq conversion"
time bedtools bamtofastq -i $filename.sorted.bam -fq $filename.end1.fq -fq2 $filename.end2.fq

echo "bonus: compute basic stats for all fq files so far"

echo "raw illumina reads 1"
time seqkit stat /nfs/scratch/papayv/Tarakihi/TARdn/illumina_reads/Rawdata/1/1_R1.fq.gz
echo "raw illumina reads 2"
time seqkit stat /nfs/scratch/papayv/Tarakihi/TARdn/illumina_reads/Rawdata/1/1_R2.fq.gz
echo "sequencing-filtered illumina reads 1"
time seqkit stat /nfs/scratch/papayv/Tarakihi/TARdn/illumina_reads/Cleandata/1/1_R1.fq.gz
echo "sequencing-filtered illumina reads 2"
time seqkit stat /nfs/scratch/papayv/Tarakihi/TARdn/illumina_reads/Cleandata/1/1_R2.fq.gz
echo "Kraken-classified reads 1"
time seqkit stat /nfs/scratch/papayv/Tarakihi/TARdn/03_Kraken/cseqs_1.fq
echo "Kraken-classified reads 2"
time seqkit stat /nfs/scratch/papayv/Tarakihi/TARdn/03_Kraken/cseqs_2.fq
echo "Kraken-unclassified reads 1"
time seqkit stat /nfs/scratch/papayv/Tarakihi/TARdn/03_Kraken/useqs_1.fq
echo "Kraken-unclassified reads 2"
time seqkit stat /nfs/scratch/papayv/Tarakihi/TARdn/03_Kraken/useqs_2.fq
echo "clean reads without mitogenome 1"
time seqkit stat $filename.end1.fq
echo "clean reads without mitogenome 2"
time seqkit stat $filename.end2.fq
echo "long reads cell 2"
time seqkit stat /nfs/scratch/papayv/Tarakihi/TARdn/nanopore_reads/2/20181204-NPL0480-P1-E3-H3/1-E3-H3/qc_report/fastq/20181204-NPL0480-P1-E3-H3.fastq.gz
echo "long reads cell 3"
time seqkit stat /nfs/scratch/papayv/Tarakihi/TARdn/nanopore_reads/3/20181204-NPL0480-P2-A9-D9/2-A9-D9/qc_report/fastq/20181204-NPL0480-P2-A9-D9.fastq.gz

echo "Nice, now we got fastq files of paired-end reads filtered for conta (Kraken) AND mitogenome (bwa+samtools)"

#There should be 366082674 reads total, 366082674 paired in sequencing, 183,040,997 R1 and 183,041,677 R2
#If results are weird, try java -jar /home/software/apps/picard/2.18.20/picard.jar SamToFastq
#I did not use picard first because the way they include non primary alignments is "not comprehensive"