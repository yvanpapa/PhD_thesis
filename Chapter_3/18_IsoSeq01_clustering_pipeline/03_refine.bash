#!/bin/bash
#SBATCH --job-name=iso_refine
#SBATCH --cpus-per-task=12
#SBATCH --mem=24G
#SBATCH --partition=parallel
#SBATCH --constraint="SSE41"
#SBATCH --time=3-1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/03_refine/%j_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/03_refine/%j_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#SMRTLink as installed on Raapoi does not support isoseq3: Error! Processor does not support the SSE4.1 CPU instruction set.
#FIX: specify --constraint="SSE41" in header

module load SMRTLink/9.0.0.92188


dir=/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/03_refine/
name=TARdn2_isoseq
threads=12

primers="/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/02_lima/primers.fasta"
bamfile1="/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/02_lima/TARdn2_isoseq.liver.demux.Clontech_5p--NEB_Clontech_3p.bam"
tissue1=liver
bamfile2="/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/02_lima/TARdn2_isoseq.white_muscle.demux.Clontech_5p--NEB_Clontech_3p.bam"
tissue2=white_muscle
bamfile3="/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/02_lima/TARdn2_isoseq.brain.demux.Clontech_5p--NEB_Clontech_3p.bam"
tissue3=brain
bamfile4="/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/02_lima/TARdn2_isoseq.spleen.demux.Clontech_5p--NEB_Clontech_3p.bam"
tissue4=spleen

#Full-length (FL) reads -> full-length non-concatemer (FLNC) reads
# Trim poly(A) tails + identify and remove concatemers

echo "bamfile 1"
isoseq3 refine --require-polya $bamfile1 $primers $dir/$name.$tissue1.flnc.bam --num-threads=$threads
# --require-polya            Require FL reads to have a poly(A) tail and remove it

echo "bamfile 2"
isoseq3 refine --require-polya $bamfile2 $primers $dir/$name.$tissue2.flnc.bam --num-threads=$threads
# --require-polya            Require FL reads to have a poly(A) tail and remove it

echo "bamfile 3"
isoseq3 refine --require-polya $bamfile3 $primers $dir/$name.$tissue3.flnc.bam --num-threads=$threads
# --require-polya            Require FL reads to have a poly(A) tail and remove it

echo "bamfile 4"
isoseq3 refine --require-polya $bamfile4 $primers $dir/$name.$tissue4.flnc.bam --num-threads=$threads
# --require-polya            Require FL reads to have a poly(A) tail and remove it

echo "done"

