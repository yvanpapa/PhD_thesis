#!/bin/bash
#SBATCH --job-name=stats_fasta
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=5G
#SBATCH --partition=bigmem
#SBATCH --time=3-1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/08_Assembly_stats/job_out_stats_fasta
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/08_Assembly_stats/job_err_stats_fasta
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module purge #to avoid conflict with samtools and bwa
module load bbmap/38.31

assembly=/nfs/scratch/papayv/Tarakihi/TARdn/07_MASURCA/RUN_1/CA.mr.41.15.15.0.02/final.genome.scf.fasta

echo "computing stats"
time stats.sh in=$assembly
echo "stats computed"




