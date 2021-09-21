#!/bin/bash
#SBATCH --job-name=hard_masking_KA
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/9_repeat_masking/KA/%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/9_repeat_masking/KA/%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#https://unix.stackexchange.com/questions/529530/replacing-all-characters-in-text-file-with-specific-character
assembly_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/Genome_assemblies/KA

mv $assembly_dir/KAdn_assembly_V1_srn.fasta.masked $assembly_dir/KAdn_assembly_V1_srn_repsoftmask.fasta

sed 's/[a-z]/N/g' $assembly_dir/KAdn_assembly_V1_srn_repsoftmask.fasta > $assembly_dir/KAdn_assembly_V1_srn_rephardmask.fasta

echo "hard masking complete"