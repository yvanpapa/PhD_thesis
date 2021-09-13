#!/bin/bash
#SBATCH --job-name=index_mitogenome_TARdn
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=5G
#SBATCH --partition=bigmem
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/index_job_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/index_job_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz


module load bwa-kit/0.7.15

echo "creating index for reference genome"

time bwa index /nfs/scratch/papayv/Tarakihi/TARdn/mitogenome_tardn/mitogenome_tardn190515.fasta

echo "index completed"



