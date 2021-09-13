#!/bin/bash
#SBATCH --job-name=hifiasm
#SBATCH --cpus-per-task=48
#SBATCH --mem=128G
#SBATCH --partition=bigmem
#SBATCH --time=7-1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn2/Hifi/2_hifiasm/%j_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn2/Hifi/2_hifiasm/%j_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#conda activate hifiasm
#manual here: https://github.com/chhylp123/hifiasm

dir=/nfs/scratch/papayv/Tarakihi/TARdn2/Hifi/2_hifiasm/
out_name=TARdn2_hifi_hifiasm_asm
hifi_reads=/nfs/scratch/papayv/Tarakihi/TARdn2/Hifi/1_bamtofastx/TARdn2_hifi.fastq.gz

time echo "starting assembly"

hifiasm -o $dir/$out_name -t 48 $hifi_reads

time echo "assembly complete"

awk '/^S/{print ">"$2;print $3}' $dir/$out_name.p_ctg.gfa > $dir/$out_name.p_ctg.fa  # get primary contigs in FASTA

time echo "fasta conversion complete"

