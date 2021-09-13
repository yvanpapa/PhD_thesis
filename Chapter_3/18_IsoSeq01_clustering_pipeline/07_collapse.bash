#!/bin/bash
#SBATCH --job-name=iso_collapse
#SBATCH --cpus-per-task=24
#SBATCH --mem=32G
#SBATCH --partition=parallel
#SBATCH --constraint="SSE41"
#SBATCH --time=30:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/07_collapse//%j_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/07_collapse//%j_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#SMRTLink as installed on Raapoi does not support isoseq3: Error! Processor does not support the SSE4.1 CPU instruction set.
#FIX: specify --constraint="SSE41" in header

module load SMRTLink/9.0.0.92188

read_dir=/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/06_align_genome/
name=TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P
threads=24


isoseq3 collapse --help 
echo "collapse trancripts based on genomic mapping"
isoseq3 collapse $read_dir/$name.sorted.bam $name.gff --num-threads $threads

#echo "done"