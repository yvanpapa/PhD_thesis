#!/bin/bash
#SBATCH --job-name=hicanu
#SBATCH --cpus-per-task=48
#SBATCH --mem=128G
#SBATCH --partition=bigmem
#SBATCH --time=7-1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn2/Hifi/2_hicanu/%j_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn2/Hifi/2_hicanu/%j_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#conda activate canu
#manual here: https://github.com/marbl/canu

dir=/nfs/scratch/papayv/Tarakihi/TARdn2/Hifi/2_hicanu/
out_name=TARdn2_hifi_canu_asm
hifi_reads=/nfs/scratch/papayv/Tarakihi/TARdn2/Hifi/1_bamtofastx/TARdn2_hifi.fastq.gz

time echo "starting assembly"

canu -p $out_name -d $dir genomeSize=600m maxThreads=48 -pacbio-hifi $hifi_reads

#"The contigs labeled by ‘suggestedBubbles=yes’ were removed from the primary assembly." Check that?

time echo "assembly complete"
