#!/bin/bash
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=2G
#SBATCH --partition=quicktest
#SBATCH --time=10:00
#SBATCH --job-name=csummarize_lnL
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/24_paml_selection/ppl1_cds_array_tarakihi/summarize_lnL_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/24_paml_selection/ppl1_cds_array_tarakihi/summarize_lnL_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/24_paml_selection/ppl1_cds_array_tarakihi/
list_tar_only=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/24_paml_selection/ppl1_cds_array_tarakihi/orthogroups_only_tarakihi.txt
readarray -t array < $list_tar_only # there are 1480 single ortho, minus the few that could not be converted in dna


fastadir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/1_2_proteomes/all_teleost/primary_transcripts/OrthoFinder/Results_Jun21/Orthogroup_Sequences/
list_selected_ortho=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/24_paml_selection/ppl1_cds_array_tarakihi/final_selected_orthogroups.txt
readarray -t array < $list_selected_ortho

rm $dir/taronly_ortho_functions.txt
for f in "${array[@]}" ; do
echo $f >> $dir/taronly_ortho_functions.txt
seqkit seq --name $fastadir/$f.fa >> $dir/taronly_ortho_functions.txt
done

#get only the gene names:
cat $dir/adapted_genes_functions.txt | grep ENSDAR | grep -o -P '(?<=gene_symbol:).*(?= description)' > $dir/gene_names.txt
cat $dir/adapted_genes_functions.txt | grep ENSDAR | grep -o -P '(?<=description:).*(?= \[Source)' > $dir/prot_names.txt
cat $dir/adapted_genes_functions.txt | grep ENSDAR | grep -o -P '(?<=\Source:).*(?=\])' > $dir/sources.txt

