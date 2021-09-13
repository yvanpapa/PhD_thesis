#!/bin/bash
#SBATCH --job-name=repeat_transcripts
#SBATCH --cpus-per-task=48
#SBATCH --mem=128G
#SBATCH --partition=bigmem
#SBATCH --time=1-12:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/10_caract_repeat_transcripts/%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/10_caract_repeat_transcripts/%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz


#filter /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/08_Repeatmasker/TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P.fasta.out
#to keep only the sequences in /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/09_filter_repeats/TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P.softmasked.reponly.fasta

touch list_RE_transcripts
grep '>' /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/09_filter_repeats/TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P.softmasked.reponly.fasta > list_RE_transcripts
cp /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/08_Repeatmasker/TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P.fasta.out .

sed -i 's/TRPT/trpt/g' list_RE_transcripts
sed -i 's/>//g' list_RE_transcripts
grep -f list_RE_transcripts TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P.fasta.out > RE_transcripts_characterized
