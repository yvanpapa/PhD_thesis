#!/bin/bash
#SBATCH --job-name=hard_masking
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --partition=parallel
#SBATCH --time=2-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/09_Repeat/new_pipeline/V2P/3_Dfam_TETools_3d_run/%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/09_Repeat/new_pipeline/V2P/3_Dfam_TETools_3d_run/%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#https://unix.stackexchange.com/questions/529530/replacing-all-characters-in-text-file-with-specific-character
assembly_dir=/nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P/20201221_REPEAT_dfam_rb_run3

sed 's/[a-z]/N/g' $assembly_dir/TARdn_assembly_V2_p_srn_repsoftmask.fasta > $assembly_dir/TARdn_assembly_V2_p_srn_rephardmask.fasta

echo "hard masking complete"