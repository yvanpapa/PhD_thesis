#!/bin/bash
#SBATCH --job-name=iso_primer_demux
#SBATCH --cpus-per-task=12
#SBATCH --mem=12G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/02_lima/%j_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/02_lima/%j_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module load SMRTLink/9.0.0.92188

dir=/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/02_lima/
name=TARdn2_isoseq
threads=12

bamfile1=/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/01_ccs/TARdn2_isoseq.liver.ccs.bam
tissue1=liver
bamfile2=/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/01_ccs/TARdn2_isoseq.white_muscle.ccs.bam
tissue2=white_muscle
bamfile3=/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/01_ccs/TARdn2_isoseq.brain.ccs.bam
tissue3=brain
bamfile4=/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/01_ccs/TARdn2_isoseq.spleen.ccs.bam
tissue4=spleen

#follow the pipeline here: https://github.com/PacificBiosciences/IsoSeq_SA3nUP/wiki/Tutorial:-Installing-and-Running-Iso-Seq-3-using-Conda
#and here: https://github.com/PacificBiosciences/IsoSeq/blob/master/isoseq-clustering.md

#1
#Primer removal and demultiplexing 
#CCS Reads -> Full-length reads
# for the primer file, I just copied the one given on the tutorial because it is supposed to be universal
echo "start bamfile 1"
lima $bamfile1 $dir/primers.fasta $dir/$name.$tissue1.demux.bam --isoseq --dump-clips --peek-guess --num-threads $threads   
# --isoseq	Activate specialized IsoSeq mode.
#--dump-clips show the clipped primers
#--peek-guess:	Try to infer the used barcodes subset, by peeking at the first 50,000 ZMWs, whitelisting barcode pairs with more than 10 counts and mean score = 45.

echo "start bamfile 2"
lima $bamfile2 $dir/primers.fasta $dir/$name.$tissue2.demux.bam --isoseq --dump-clips --peek-guess --num-threads $threads   

echo "start bamfile 3"
lima $bamfile3 $dir/primers.fasta $dir/$name.$tissue3.demux.bam --isoseq --dump-clips --peek-guess --num-threads $threads   

echo "start bamfile 4"
lima $bamfile4 $dir/primers.fasta $dir/$name.$tissue4.demux.bam --isoseq --dump-clips --peek-guess --num-threads $threads




