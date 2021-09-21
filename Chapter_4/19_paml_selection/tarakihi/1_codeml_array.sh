#!/bin/bash
#SBATCH -a 0-1480
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=2G
#SBATCH --partition=parallel
#SBATCH --time=3:00:00
#SBATCH --job-name=codeml_array
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/24_paml_selection/ppl1_cds_array_tarakihi/job_files/codeml_tar_array_%A_%a.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/24_paml_selection/ppl1_cds_array_tarakihi/job_files/codeml_tar_array_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/24_paml_selection/ppl1_cds_array_tarakihi/

#Get the list of files we are going to work on
list_sing_copy_ortho=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/1_2_proteomes/all_teleost/primary_transcripts/OrthoFinder/Results_Jun21/Orthogroups/Orthogroups_SingleCopyOrthologues.txt
readarray -t array < $list_sing_copy_ortho # there are 1480 single ortho, minus the few that could not be converted in dna
workdir=$dir/orthogroups/"${array[${SLURM_ARRAY_TASK_ID}]}"
mkdir -p $workdir

#paml does not recognize wild cards so we have to move to the directory and give the full path
cd  $workdir

#Get the tree
cp "/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/24_paml_selection/ppl1_cds/codeml_tree_tarakihi.nwk" $workdir/

#Get the alignement and convert it to relaxed phylip
#convert to relaxed phylip
aln_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/CDS/2_convert_dna_outputs/
module load seqmagick/0.8.0
cp $aln_dir/"${array[${SLURM_ARRAY_TASK_ID}]}".cds.al.fa-gb $workdir/"${array[${SLURM_ARRAY_TASK_ID}]}".cds.al.gb.fa
#Also all seq names must be the same as in the tree
#emove all the numbers in the fasta ID so that all seqs from same species have the same ID
module load seqkit/0.13.2
cat $workdir/"${array[${SLURM_ARRAY_TASK_ID}]}".cds.al.gb.fa | seqkit replace -p "[^a-zA-Z]" > $workdir/"${array[${SLURM_ARRAY_TASK_ID}]}".cds.al.gb.rn.fa

seqmagick convert --alphabet dna  $workdir/"${array[${SLURM_ARRAY_TASK_ID}]}".cds.al.gb.rn.fa $workdir/"${array[${SLURM_ARRAY_TASK_ID}]}".cds.al.gb.rn.phyx
#some of them will be empty, it's okay
#Need to add an I at the end of first line to tell paml it's an interleaved phylip file
sed -i '1s/.*/ &  I/' $workdir/"${array[${SLURM_ARRAY_TASK_ID}]}".cds.al.gb.rn.phyx
#
 
#Get the two ctl files
cp /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/24_paml_selection/ppl1_cds/alternative.ctl $workdir/
sed -i 's/all_teleost_ppl1.cds.phy/'"${array[${SLURM_ARRAY_TASK_ID}]}".cds.al.gb.rn.phyx'/g' $workdir/alternative.ctl
sed -i 's/all_teleost_ppl1.alternative.mlc/'"${array[${SLURM_ARRAY_TASK_ID}]}".alternative.mlc'/g' $workdir/alternative.ctl

cp /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/24_paml_selection/ppl1_cds/null_model.ctl $workdir/
sed -i 's/all_teleost_ppl1.cds.phy/'"${array[${SLURM_ARRAY_TASK_ID}]}".cds.al.gb.rn.phyx'/g' $workdir/null_model.ctl
sed -i 's/all_teleost_ppl1.null.mlc/'"${array[${SLURM_ARRAY_TASK_ID}]}".null_model.mlc'/g' $workdir/null_model.ctl

source activate paml
codeml ./alternative.ctl
codeml ./null_model.ctl
#
##Two output files are produced: TF105351.Eut.3.53876.mlc (alternative model) and TF105351.Eut.3.53876.fixed.mlc (null model).
##We retieve the likelihood values lnL1 and lnL0 from TF105351.Eut.3.53876.mlc and TF105351.Eut.3.53876.fixed.mlc files, respectively:
#
##lnL(ntime: 41  np: 46):  -4707.209701      +0.000000 (lnL1)
##lnL(ntime: 41  np: 45):  -4710.222255      +0.000000 (lnL0)
#
##We can construct the LRT:
##-->
##ΔLRT = 2×(lnL1 - lnL0) =2*(-4707.209701-(-4710.222255)) = 6.025108
##The degree of freedom is 1 (np1 - np0 = 46 - 45)
#
##more explanations on LRT here https://evomics.org/resources/likelihood-ratio-test/
##and how to use chi-square table here https://www.statology.org/how-to-read-chi-square-distribution-table/
##The LRT is actually a test of goodness of fit
#
##If the test value is greater than the critical value (= the table value),
##we reject the null hypothesis. If not, we can't reject it.
#
##So: For LRT=6.025, DF=1, and P=0.05, the critical value (cval) is 3.841
##6.025 > 3.841 > significant!
##However it's not significant for 0.01: cval=6.635
#
##In the TF105351.Eut.3.53876.mlc, we can retrieve sites under positive selection
##at the following line:
##Positive sites for foreground lineages Prob(w>1):
##   36 K 0.971*
#  159 C 0.993**




