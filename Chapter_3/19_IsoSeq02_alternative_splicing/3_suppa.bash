#!/bin/bash
#SBATCH --job-name=suppa
#SBATCH --cpus-per-task=24
#SBATCH --mem=48G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/14_isoseq_analyses/suppa/suppa_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/14_isoseq_analyses/suppa/suppa_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz
threads=24

source activate suppa

dir=/nfs/scratch/papayv/Tarakihi/TARdn/14_isoseq_analyses/suppa/
gtf=/nfs/scratch/papayv/Tarakihi/TARdn/14_isoseq_analyses/convert_and_filter/TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P_filtered.gtf

#https://github.com/comprna/SUPPA#psi-calculation-for-transcripts-and-events

suppa.py generateEvents -i $gtf -o $dir/AS_events.out -f ioe -e SE SS MX RI FL

#-e | --event-type: (only used for local AS events) space separated list of events to generate from the following list:
#SE: Skipping exon (SE)
#SS: Alternative 5' (A5) or 3' (A3) splice sites (generates both)
#MX: Mutually Exclusive (MX) exons
#RI: Retained intron (RI)
#FL: Alternative First (AF) and Last (AL) exons (generates both)

#
# I dont think it can use threads
