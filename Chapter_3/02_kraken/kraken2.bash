#!/bin/bash
#SBATCH --job-name=kraken2
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=5G
#SBATCH --partition=bigmem
#SBATCH --time=3-12:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/03_Kraken/job_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/03_Kraken/job_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz


module load kraken/2.0.7-beta

echo "Usage: kraken2.sh R1 R2"

DB=$1
R1=$2
R2=$3
#/nfs/scratch/papayv/Tarakihi/TARdn/03_Kraken/MiniKraken2_v2_8GB_database
#/nfs/scratch/papayv/Tarakihi/TARdn/illumina_reads/Cleandata/1/1_R1.fq.gz
#/nfs/scratch/papayv/Tarakihi/TARdn/illumina_reads/Cleandata/1/1_R2.fq.gz

echo "Started screening for vector and contaminants in provided database"
time kraken2 --db $DB --paired --fastq-input --gzip-compressed --unclassified-out useqs#.fq --classified-out cseqs#.fq --report kraken_report $R1 $R2
echo "Done"



