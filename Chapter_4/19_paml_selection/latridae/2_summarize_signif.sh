#!/bin/bash
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=2G
#SBATCH --partition=quicktest
#SBATCH --time=10:00
#SBATCH --job-name=csummarize_lnL
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/24_paml_selection/selection_latridae/summarize_lnL_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/24_paml_selection/selection_latridae/summarize_lnL_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/24_paml_selection/selection_latridae/
list_sing_copy_ortho=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/1_2_proteomes/all_teleost/primary_transcripts/OrthoFinder/Results_Jun21/Orthogroups/Orthogroups_SingleCopyOrthologues.txt
readarray -t array < $list_sing_copy_ortho # there are 1480 single ortho, minus the few that could not be converted in dna
indir=$dir/orthogroups/

rm $dir/list_lnL.txt #just in case
for f in "${array[@]}" ; do
echo -n $f >> $dir/list_lnL.txt
echo -n " lnL1 " >> $dir/list_lnL.txt
echo -n  $(grep "lnL" $indir/$f/$f.alternative.mlc) >> $dir/list_lnL.txt
echo -n " lnL0 " >> $dir/list_lnL.txt
echo $(grep "lnL" $indir/$f/$f.null_model.mlc) >> $dir/list_lnL.txt
done

#Do th signif calculation as explained bellow with a simple excell spreadsheet

#We use echo -n to append results on the same line


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
