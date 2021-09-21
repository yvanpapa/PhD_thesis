#!/bin/bash
#SBATCH --job-name=gblocks
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --partition=parallel
#SBATCH --time=1-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/mafft_alignement_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/mafft_alignement_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

source activate gblocks
#Gblocks will remove the poorly aligned positions and divergent regions in the alignements

dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/
al_fa_dir=$dir/outputs_all_teleost_June21/3_4_mafft_gblocks/


for f in $al_fa_dir/*.al.fa ; do
echo "gblocks $f"
Gblocks $f -t=p
done

#-t=	Type Of Sequence
#(Protein, DNA, Codons)	p, d, c

## Check that the number of files is correct
ls *.fa | wc -l
#1481
ls *.fa-gb | wc -l

#OG0009342.fa alignement is empty, so gblock did not work on this one
#-> 1480 gb alignements