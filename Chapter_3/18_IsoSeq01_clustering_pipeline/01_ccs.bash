#!/bin/bash
#SBATCH --job-name=iso_ccs_demultiplex
#SBATCH --cpus-per-task=64
#SBATCH --mem=68G
#SBATCH --partition=parallel
#SBATCH --time=10-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/01_ccs/%j_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/01_ccs/%j_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module load SMRTLink/9.0.0.92188

dir=/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/01_ccs/
name=TARdn2_isoseq

bamfile1=/nfs/scratch/papayv/Tarakihi/raw_data/TARdn/TARdn2_isoseq_reads/BGI_2020/TAR_isoseq/101_Tarakihi_Liver1A/HKYR20084210_A.bam
tissue1=liver
bamfile2=/nfs/scratch/papayv/Tarakihi/raw_data/TARdn/TARdn2_isoseq_reads/BGI_2020/TAR_isoseq/102_Tarakihi_White_MuscleA/HKYR20084211_A.bam
tissue2=white_muscle
bamfile3=/nfs/scratch/papayv/Tarakihi/raw_data/TARdn/TARdn2_isoseq_reads/BGI_2020/TAR_isoseq/103_Tarakihi_BrainA/HKYR20084212_A.bam
tissue3=brain
bamfile4=/nfs/scratch/papayv/Tarakihi/raw_data/TARdn/TARdn2_isoseq_reads/BGI_2020/TAR_isoseq/104_Tarakihi_SpleenA/HKYR20084213_A.bam
tissue4=spleen

# /!\ CAREFUL: ccs_report.txt is overwritten after each tissue. Need to find a way around this

#follow the pipeline here: https://github.com/PacificBiosciences/IsoSeq_SA3nUP/wiki/Tutorial:-Installing-and-Running-Iso-Seq-3-using-Conda
#and here: https://github.com/PacificBiosciences/IsoSeq/blob/master/isoseq-clustering.md

#1
echo "start bamfile 1"
#Generate consensus (Step 1 - Circular Consensus Sequence calling)
#PacBIO BAM submreads -> CCS reads
#Each sequencing run is processed by ccs to generate one representative circular consensus sequence (CCS) for each ZMW
ccs $bamfile1 $dir/$name.$tissue1.ccs.bam --min-rq 0.9 --num-threads 64
#parameters as recommanded by pacbio pipeline

echo "start bamfile 2"
ccs $bamfile2 $dir/$name.$tissue2.ccs.bam --min-rq 0.9 --num-threads 64

echo "start bamfile 3"
ccs $bamfile3 $dir/$name.$tissue3.ccs.bam --min-rq 0.9 --num-threads 64

echo "start bamfile 4"
ccs $bamfile4 $dir/$name.$tissue4.ccs.bam --min-rq 0.9 --num-threads 64




