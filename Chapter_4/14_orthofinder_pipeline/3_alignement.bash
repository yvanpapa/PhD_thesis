#!/bin/bash
#SBATCH --job-name=mafft_alignement
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --partition=parallel
#SBATCH --time=1-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/gblocks_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/gblocks_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

source activate mafft

dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/
al_fa_dir=$dir/outputs_all_teleost_June21/3_4_mafft_gblocks/
mkdir -p $outdir

#Let's align all the unique orthologues fasta files

#All the orthogroups sequences are here:
orthodir=$dir/proteomes/all_teleost/primary_transcripts/OrthoFinder/Results_Jun21/Orthogroup_Sequences/

#The list of the single copy orthologues is here:
list_sing_copy_ortho=$dir/proteomes/all_teleost/primary_transcripts/OrthoFinder/Results_Jun21/Orthogroups/Orthogroups_SingleCopyOrthologues.txt

#Create an array from that list
readarray -t array < $list_sing_copy_ortho

for f in "${array[@]}" ; do
echo "align orthogroup $f"
mafft --auto $orthodir/$f.fa > $outdir/$f.al.fa
done
