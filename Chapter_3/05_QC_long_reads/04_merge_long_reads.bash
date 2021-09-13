#!/bin/bash
#SBATCH --job-name=merge_nanopore_reads
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=5G
#SBATCH --partition=bigmem
#SBATCH --time=3-1:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/06_QC_longreads/job_out_merge_nanopore_reads
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/06_QC_longreads/job_err_merge_nanopore_reads
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz


reads1=/nfs/scratch/papayv/Tarakihi/TARdn/06_QC_longreads/nanopore_cell2_filtertrimmed.fastq.gz
reads2=/nfs/scratch/papayv/Tarakihi/TARdn/06_QC_longreads/nanopore_cell3_filtertrimmed.fastq.gz
output_dir=/nfs/scratch/papayv/Tarakihi/TARdn/06_QC_longreads

echo "starting merging"
time cat $reads1 $reads2 > $output_dir/nanopore_reads_filtertrimmed.fastq.gz
echo "starting QC Stats"
time NanoStat --fastq $output_dir/nanopore_reads_filtertrimmed.fastq.gz --name $output_dir/QC_summary_nanopore_reads_filtertrimmed.fastq.gz
echo "le hash elle aime"