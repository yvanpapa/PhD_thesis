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

#Once we have corrected the p-values with fdr and got the list of fdr-significant orthogroups, let's check if they all have significant amino-acid substitutions:
dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/24_paml_selection/selection_latridae/
list_fdr_signif_ortho=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/24_paml_selection/selection_latridae/fdr_signif_orthogroups_latridae.txt
#do not forget to delete all the "\r" first in fdr_signif_etc.txt 
readarray -t array < $list_fdr_signif_ortho
indir=$dir/orthogroups/

rm $dir/list_aa_bayesproba_.txt
for f in "${array[@]}" ; do
echo $f >> $dir/list_aa_bayesproba_.txt
sed -n '/Bayes Empirical Bayes (BEB)/,/The grid/p' $indir/$f/$f.alternative.mlc >> $dir/list_aa_bayesproba_.txt
done

#manually remove all the non-significant orthogroups in fdr_signif_orthogroups_latridae.txt > final_selected_orthogroups.txt

###Now get the functions of the genes:
module load seqkit/0.13.2
fastadir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/CDS/1_convert_dna_inputs/
list_selected_ortho=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/24_paml_selection/selection_latridae/final_selected_orthogroups_latridae.txt
readarray -t array < $list_selected_ortho

rm $dir/adapted_genes_functions_latridae.txt
for f in "${array[@]}" ; do
echo $f >> $dir/adapted_genes_functions_latridae.txt
seqkit seq --name $fastadir/$f.fullname.fa >> $dir/adapted_genes_functions_latridae.txt
done

#get only the gene names:
cat $dir/adapted_genes_functions_latridae.txt | grep ENSDAR | grep -o -P '(?<=gene_symbol:).*(?= description)' > $dir/gene_names_latridae.txt
cat $dir/adapted_genes_functions_latridae.txt | grep ENSDAR | grep -o -P '(?<=description:).*(?= \[Source)' > $dir/prot_names_latridae.txt
cat $dir/adapted_genes_functions_latridae.txt | grep ENSDAR | grep -o -P '(?<=\Source:).*(?=\])' > $dir/sources_latridae.txt

