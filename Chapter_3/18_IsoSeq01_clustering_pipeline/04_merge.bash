#!/bin/bash
#SBATCH --job-name=iso_merge
#SBATCH --cpus-per-task=12
#SBATCH --mem=12G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/04_merge/%j_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/04_merge/%j_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz


dir=/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/04_merge/
name=TARdn2_isoseq_all_tissues

bamfile1="/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/03_refine/TARdn2_isoseq.liver.flnc.bam"
bamfile2="/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/03_refine/TARdn2_isoseq.white_muscle.flnc.bam"
bamfile3="/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/03_refine/TARdn2_isoseq.spleen.flnc.bam"
bamfile4="/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/03_refine/TARdn2_isoseq.brain.flnc.bam"

ls $bamfile1 $bamfile2 $bamfile3 $bamfile4 > $name.flnc.fofn
#fofn = file of file names

#!!! The order of files is now alphabetic