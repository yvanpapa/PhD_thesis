#!/bin/bash
#SBATCH --job-name=NanoStat
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=5G
#SBATCH --partition=bigmem
#SBATCH --time=3-1:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/06_QC_longreads/job_out_QC_summary_nanopore_cell2_filtertrimmed
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/06_QC_longreads/job_err_QC_summary_nanopore_cell2_filtertrimmed
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz


module load nanopack/1.0.0 

#Cell2=/nfs/scratch/papayv/Tarakihi/TARdn/nanopore_reads/2/20181204-NPL0480-P1-E3-H3/1-E3-H3/qc_report/fastq/20181204-NPL0480-P1-E3-H3.fastq.gz
#Cell3=/nfs/scratch/papayv/Tarakihi/TARdn/nanopore_reads/3/20181204-NPL0480-P2-A9-D9/2-A9-D9/qc_report/fastq/20181204-NPL0480-P2-A9-D9.fastq.gz
output_dir=/nfs/scratch/papayv/Tarakihi/TARdn/06_QC_longreads

filtered_nanopore=/nfs/scratch/papayv/Tarakihi/TARdn/06_QC_longreads/nanopore_reads_filtertrimmed.fastq.gz


echo "producing QC stats of long reads"
time NanoStat --fastq $filtered_nanopore --name $output_dir/QC_summary_nanopore_reads_filtertrimmed
#echo "done. producing QC stats of long reads 2"
#time NanoStat --fastq $Cell3 --name $output_dir/QC_summary_Cell3
echo "ça fait plaisir"


