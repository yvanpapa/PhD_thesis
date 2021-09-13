#!/bin/bash
#SBATCH --job-name=iso_cluster
#SBATCH --cpus-per-task=64
#SBATCH --mem=68G
#SBATCH --partition=parallel
#SBATCH --constraint="SSE41"
#SBATCH --time=1-1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/05_clustering/%j_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/05_clustering/%j_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#SMRTLink as installed on Raapoi does not support isoseq3: Error! Processor does not support the SSE4.1 CPU instruction set.
#FIX: specify --constraint="SSE41" in header

#Due to the nature of the algorithm, it can't be efficiently parallelized. It is advised to give this step as many cores as possible

module load SMRTLink/9.0.0.92188

bam_list=/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/04_merge/TARdn2_isoseq_all_tissues.flnc.fofn
dir=/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/05_clustering/
name=TARdn2_isoseq_all_tissues
threads=64

isoseq3 cluster --help
#just to check

echo "start clustering"
isoseq3 cluster $bam_list $dir/$name.clustered.bam --verbose --use-qvs --num-threads=$threads
echo "done"
