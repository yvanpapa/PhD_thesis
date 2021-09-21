#!/bin/bash
#SBATCH --job-name=orthofinder
#SBATCH --cpus-per-task=48
#SBATCH --mem=48G
#SBATCH --partition=parallel
#SBATCH --time=10-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/orthofinder_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/orthofinder_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#tutorial here: https://davidemms.github.io/orthofinder_tutorials/running-an-example-orthofinder-analysis.html

source activate orthofinder
orthofinder_bin=/nfs/scratch/papayv/bin/miniconda3/envs/orthofinder/bin/

dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/
indir=$dir/proteomes/all_teleost

#extract just the longest transcript variant per gene
for f in $indir/*fasta ; do python $orthofinder_bin/primary_transcript.py $f ; done

orthofinder -f $indir/primary_transcripts/