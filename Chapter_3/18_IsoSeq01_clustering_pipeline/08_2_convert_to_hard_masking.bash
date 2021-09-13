#!/bin/bash
#SBATCH --job-name=iso_hard_masking
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/08_Repeatmasker/%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/08_Repeatmasker/%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#https://unix.stackexchange.com/questions/529530/replacing-all-characters-in-text-file-with-specific-character
dir=/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/08_Repeatmasker/

sed 's/trpt/TRPT/g' $dir/TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P.softmasked.fasta > \
$dir/TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P.relabelled.fasta

sed 's/[a-z]/N/g' $dir/TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P.relabelled.fasta > \
$dir/TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P.hardmasked.fasta

rm $dir/TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P.relabelled.fasta

echo "hard masking complete"