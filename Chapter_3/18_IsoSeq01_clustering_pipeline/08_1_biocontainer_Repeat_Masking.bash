#!/bin/bash
#SBATCH --job-name=iso_repeatmasker
#SBATCH --cpus-per-task=42
#SBATCH --mem=128G
#SBATCH --partition=bigmem
#SBATCH --time=7-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/08_Repeatmasker/%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/08_Repeatmasker/%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#! The job has failed twice on the parallel partition because of a c04n04 node failure. I wonder if it's because I need to request more memory than it seems
#I manually replaces "trancript" in IDs by "trpt", maybe automatize that later

#!!! Need to convert seq IDs in fasta file to less than 50 characters

##another thing: there might be perl conflicts with other modules, so might be worth clearing the environment before starting job

module load singularity/3.5.2
#need to do once only
#singularity pull docker://quay.io/biocontainers/repeatmasker:4.1.1--pl526_1
singdir=/nfs/scratch/papayv/Tarakihi/TARdn/09_Repeat/new_pipeline/V2P/
sing=$singdir/repeatmasker_4.1.1--pl526_1.sif

dir=/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/08_Repeatmasker
assembly_dir=/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/07_collapse/
assembly=TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P.fasta
repeat_library=/nfs/scratch/papayv/Tarakihi/TARdn/09_Repeat/new_pipeline/V2P/3_Dfam_TETools_3d_run/TARdn_V2P_repeat_lib_actinodb_ad_and_denovo.fa
threads=42

#cp $assembly_dir/$assembly $dir

time echo "use RepeatMasker to get a masked sequence and a table of repeats famillies"
singularity exec $sing RepeatMasker -gff -xsmall -pa $threads -lib $repeat_library $dir/$assembly
echo "job finished"
