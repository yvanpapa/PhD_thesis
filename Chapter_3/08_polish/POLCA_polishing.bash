#!/bin/bash
#SBATCH --job-name=polca
#SBATCH --cpus-per-task=32
#SBATCH --mem=256G
#SBATCH --partition=bigmem
#SBATCH --time=9-1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/07_2_polish_test/POLCA/TARdn_V2/%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/07_2_polish_test/POLCA/TARdn_V2/%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#bwa uses a lot of memory, so to avoid core being dumped, request more memory in the header than specified in the command

#bwa manual here: http://bio-bwa.sourceforge.net/bwa.shtml
module purge #to avoid conflict with samtools
module load bwa-kit/0.7.15
module load masurca/3.4.1 

REF=/nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2/TARdn_assembly_V2.fasta
Illumina_dir=/nfs/scratch/papayv/Tarakihi/TARdn/07_MASURCA/seq_input

/home/software/apps/masurca/3.4.1/bin/polca.sh -a $REF -r "$Illumina_dir/TARdn_clean_illumina_R1.fastq $Illumina_dir/TARdn_clean_illumina_R2.fastq" -t 30 -m 8000000000



