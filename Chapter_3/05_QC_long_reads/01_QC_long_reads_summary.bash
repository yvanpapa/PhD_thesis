#!/bin/bash
#SBATCH --job-name=NanosumStat
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=5G
#SBATCH --partition=bigmem
#SBATCH --time=3-1:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/06_QC_longreads/job_out_sum
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/06_QC_longreads/job_err_sum
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz


module load nanopack/1.0.0 

sumCell2=/nfs/scratch/papayv/Tarakihi/TARdn/nanopore_reads/2/20181204-NPL0480-P1-E3-H3/1-E3-H3/qc_report/fastq/20181204-NPL0480-P1-E3-H3.sequencing_summary.txt.gz
sumCell3=/nfs/scratch/papayv/Tarakihi/TARdn/nanopore_reads/3/20181204-NPL0480-P2-A9-D9/2-A9-D9/qc_report/fastq/20181204-NPL0480-P2-A9-D9.sequencing_summary.txt.gz
output_dir=/nfs/scratch/papayv/Tarakihi/TARdn/06_QC_longreads


echo "producing QC stats of long reads 1"
time NanoStat --summary $sumCell2 --name $output_dir/sumQC_summary_Cell2
echo "done. producing QC stats of long reads 2"
time NanoStat --summary $sumCell3 --name $output_dir/sumQC_summary_Cell3
echo "done"


