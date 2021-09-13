#!/bin/bash
#SBATCH --job-name=NanoFilter
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=5G
#SBATCH --partition=bigmem
#SBATCH --time=3-1:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/06_QC_longreads/job_filter_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/06_QC_longreads/job_filter_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz


module load nanopack/1.0.0 

Cell2=/nfs/scratch/papayv/Tarakihi/TARdn/nanopore_reads/2/20181204-NPL0480-P1-E3-H3/1-E3-H3/qc_report/fastq/20181204-NPL0480-P1-E3-H3.fastq.gz
Cell3=/nfs/scratch/papayv/Tarakihi/TARdn/nanopore_reads/3/20181204-NPL0480-P2-A9-D9/2-A9-D9/qc_report/fastq/20181204-NPL0480-P2-A9-D9.fastq.gz

sumCell2=/nfs/scratch/papayv/Tarakihi/TARdn/nanopore_reads/2/20181204-NPL0480-P1-E3-H3/1-E3-H3/qc_report/fastq/20181204-NPL0480-P1-E3-H3.sequencing_summary.txt.gz
sumCell3=/nfs/scratch/papayv/Tarakihi/TARdn/nanopore_reads/3/20181204-NPL0480-P2-A9-D9/2-A9-D9/qc_report/fastq/20181204-NPL0480-P2-A9-D9.sequencing_summary.txt.gz
output_dir=/nfs/scratch/papayv/Tarakihi/TARdn/06_QC_longreads


echo "starting filtering"
time gunzip -c $Cell2 | NanoFilt --logfile $output_dir/NanoFilt_logfile -q 7 -l 500 --headcrop 50 --summary $sumCell2 | gzip > $output_dir/nanopore_cell2_trimmed.fastq.gz
echo "done"