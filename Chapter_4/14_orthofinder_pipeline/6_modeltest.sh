#!/bin/bash
#SBATCH --cpus-per-task=24
#SBATCH --mem-per-cpu=2G
#SBATCH --partition=parallel
#SBATCH --time=10-00:00:00
#SBATCH --job-name=modeltest
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/modeltest_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/modeltest_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module use /home/software/tools/eb_modulefiles/all/Core
module load foss/2020b
module load ModelTest-NG/0.1.7 

file=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/outputs_all_teleost_June21/6_concatenated_alignement/alignement.fasta
outdir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/outputs_all_teleost_June21/7_modeltest/
mkdir -p $outdir

modeltest-ng -d aa -i $file -o $outdir/models_report -p 24 -t ml


