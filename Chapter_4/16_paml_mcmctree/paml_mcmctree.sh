#!/bin/bash
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=2G
#SBATCH --partition=parallel
#SBATCH --time=1:00:00
#SBATCH --job-name=mcmctree
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/22_paml/mcmctree_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/22_paml/mcmctree_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz


source activate paml

dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/22_paml/
rundir1=$dir/teleosts_runs/run1/
mkdir -p $rundir1

align_fasta_file=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/outputs_all_teleost_June21/6_concatenated_alignement/alignement.fasta
#for tree, need to manually root the tree in Figtree, save it in NWK format and calibrate some node ages using info from timetree.org
#Dont forget: The first must have the number of species e.g. (7) and the number of trees e.g. (1)
#ALSO: no branch lengths
tree=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/22_paml/teleosts_runs/run1/all_teleosts_tree.nwk
#copy the mcmc.ctl file and change the parameters according to your analysis
mcmctree_ctl=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/22_paml/teleosts_runs/run1/mcmctree.ctl
aln=all_teleosts_aln.phy

#Convert fasta to PHYLIP
# You need to do that part only once per input file:
module load seqmagick/0.8.0
seqmagick convert --alphabet protein $align_fasta_file $rundir1/$aln
###
#### actually that's not enough: need to do some tweakings to the format manually (see aa example).

cd $rundir1
mcmctree mcmctree.ctl


#### Follow instrutions there: http://abacus.gene.ucl.ac.uk/software/MCMCtree.Tutorials.pdf Tutorial 4: Approximate likelihood with protein data
#### Use the appropriate model .dat file
#### then run:
mcmctree codeml tmp0001.ctl

####Follow instructions again: Rename file “rst2” as “in.BV”, edit mcmctree.ctl

mcmctree mcmctree.ctl
rundir2=$dir/teleosts_runs/run2/
mkdir -p $rundir2

cd $rundir2

cp $rundir1/* $rundir2/
rm SeedUsed
rm mcmc.txt
rm FigTree.tre
rm out.txt

mcmctree mcmctree.ctl



