#!/bin/bash
#SBATCH --job-name=BAR_srn_stats_busco
#SBATCH --cpus-per-task=12
#SBATCH --mem=32G
#SBATCH --partition=parallel
#SBATCH --time=1-12:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/8_sort_rename_assembly_stats/job_%A_%a.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/8_sort_rename_assembly_stats/job_%A_%a.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

source activate busco

stats_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/8_sort_rename_assembly_stats/
asm_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/Genome_assemblies/BAR/
asm_name=BARdn_assembly_V1
assembly=$asm_dir/"$asm_name"_srn.fasta
#lineage=/nfs/scratch/papayv/Tarakihi/TARdn/08_Assembly_stats/actinopterygii_odb9/actinopterygii_odb9/
lineage=actinopterygii_odb10
busco_output=busco_BARdn_V1_zebrafish2
species=zebrafish
threads=12

busco -i $assembly -l $lineage -o $busco_output -m genome --augustus_species $species -c $threads -f 


#-i SEQUENCE_FILE
#-o OUTPUT_NAME: should not be a path. your ouptut should be created in the directory you started your analysis
#-l LINEAGE
#-m MODE
#-c --cpu
#-f, --force           Force rewriting of existing files. Must be used when output files with the provided name already exist.
