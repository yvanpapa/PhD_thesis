#!/bin/bash
#SBATCH --job-name=iso_align_genome
#SBATCH --cpus-per-task=24
#SBATCH --mem=32G
#SBATCH --partition=parallel
#SBATCH --constraint="SSE41"
#SBATCH --time=30:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/06_align_genome/%j_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/06_align_genome/%j_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#SMRTLink as installed on Raapoi does not support isoseq3: Error! Processor does not support the SSE4.1 CPU instruction set.
#FIX: specify --constraint="SSE41" in header

module load SMRTLink/9.0.0.92188

rna_bamfile="/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/05_clustering/TARdn2_isoseq_all_tissues.clustered.hq.bam"
#unmasked genome because we will mask the repeats after
genome="/nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P/TARdn_assembly_V2_p_srn.fasta"
name=TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P
threads=24

#just to check
pbmm2 --help 
echo "align iso reads to genome"
pbmm2 align $rna_bamfile $genome $name.sorted.bam --preset ISOSEQ --sort -j $threads
#--sort		sort BAM output
#-j			threads

#echo "done"