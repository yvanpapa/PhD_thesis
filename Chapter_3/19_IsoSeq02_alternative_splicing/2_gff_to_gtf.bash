#!/bin/bash
#SBATCH --job-name=gff_to_gtf
#SBATCH --cpus-per-task=2
#SBATCH --mem=120G
#SBATCH --partition=bigmem
#SBATCH --time=1-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/14_isoseq_analyses/convert_and_filter/gff_to_gtf_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/14_isoseq_analyses/convert_and_filter/gff_to_gtf_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#need a lot of memory, get out of memory core dump when run on quicktest

source activate agat

gff=/nfs/scratch/papayv/Tarakihi/TARdn/14_isoseq_analyses/convert_and_filter/TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P_filtered.gff
dir=/nfs/scratch/papayv/Tarakihi/TARdn/14_isoseq_analyses/convert_and_filter/
name=TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P_filtered

agat_convert_sp_gff2gtf.pl --gff $gff -o $dir/$name.gtf

# or agat_convert_sp_gff2gtf.pl --gff $gff -o $dir/$name.gtf
