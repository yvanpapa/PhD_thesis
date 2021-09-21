#!/bin/bash
#SBATCH --job-name=concat
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --partition=parallel
#SBATCH --time=3-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/concat_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/concat_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module load seqkit/0.13.2
#Let's concatenate all our aligned, cleaned up fasta files in one big fasta alignement

dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/
indir=$dir/outputs_all_teleost_June21/3_4_mafft_gblocks/
rndir=$dir/outputs_all_teleost_June21/5_renamed/
mkdir -p $rndir
concatdir=$dir/outputs_all_teleost_June21/6_concatenated_alignement
mkdir -p $concatdir

#Let's create a list of file names
find $rndir/*.rn.fasta -print > $dir/list_rn_files

seqkit concat --infile-list $dir/list_rn_files > $concatdir/alignement.fasta

