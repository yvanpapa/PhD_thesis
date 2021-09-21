#!/bin/bash
#SBATCH --job-name=gblocks
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/CDS/gblock_ppl1_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/CDS/gblock_ppl1_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

source activate gblocks
#Gblocks will remove the poorly aligned positions and divergent regions in the alignements

dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/CDS/
indir=$dir/2_convert_dna_outputs
mkdir -p $outdir

#don't forget to delete manually the few empty fasta files in convert_dna_outputs first

for f in $indir/*.al.fa ; do
echo "gblocks $f"
Gblocks $f -t=c
done

#-t=	Type Of Sequence
#(Protein, DNA, Codons)	p, d, c