#!/bin/bash
#SBATCH --job-name=stats_fasta
#SBATCH --cpus-per-task=12
#SBATCH --mem=32G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/08_Assembly_stats/RUN2/job_out_stats_fasta
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/08_Assembly_stats/RUN2/job_err_stats_fasta
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module purge #to avoid conflict with samtools and bwa
module load bbmap/38.31

assembly=/nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2/TARdn_assembly_V2_srn.fasta

echo "computing stats"
time stats.sh in=$assembly
echo "stats computed"




