#!/bin/bash
#SBATCH --job-name=index_bamfiles
#SBATCH --cpus-per-task=4
#SBATCH --mem=4G
#SBATCH --partition=parallel
#SBATCH --time=12:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/00_index_bamfiles/%j_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/00_index_bamfiles/%j_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module load SMRTLink/9.0.0.92188

bamfile1=/nfs/scratch/papayv/Tarakihi/raw_data/TARdn/TARdn2_isoseq_reads/BGI_2020/TAR_isoseq/101_Tarakihi_Liver1A/HKYR20084210_A.bam
bamfile2=/nfs/scratch/papayv/Tarakihi/raw_data/TARdn/TARdn2_isoseq_reads/BGI_2020/TAR_isoseq/102_Tarakihi_White_MuscleA/HKYR20084211_A.bam
bamfile3=/nfs/scratch/papayv/Tarakihi/raw_data/TARdn/TARdn2_isoseq_reads/BGI_2020/TAR_isoseq/103_Tarakihi_BrainA/HKYR20084212_A.bam
bamfile4=/nfs/scratch/papayv/Tarakihi/raw_data/TARdn/TARdn2_isoseq_reads/BGI_2020/TAR_isoseq/104_Tarakihi_SpleenA/HKYR20084213_A.bam

### 1 ###
echo "create index 1"
#pbindex $bamfile1

### 2 ###
echo "create index 2"
pbindex $bamfile2

### 3 ###
echo "create index 3"
pbindex $bamfile3

### 4 ###
echo "create index 4"
pbindex $bamfile4

echo "all done"