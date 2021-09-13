#!/bin/bash
#SBATCH --job-name=filter_ns
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/14_isoseq_analyses/convert_and_filter/%j_filter_n.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/14_isoseq_analyses/convert_and_filter/%j_filter_n.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#### Discard if more than 70% of bases are hardmasked repeats ###

dir=/nfs/scratch/papayv/Tarakihi/TARdn/14_isoseq_analyses/convert_and_filter/
GFF=/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/07_collapse/TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P.gff
filter_labels=/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/09_filter_repeats/TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P.hardmasked.N_percent_70.filter_labels

#keep only the "PB" part of the labels and remove the "TRPT" part

cat $filter_labels | awk -F '\\|' '{print $1}' > $dir/repeat_transcripts_filter_labels


cp $GFF $dir/

#do the filtering
grep -v -f $dir/repeat_transcripts_filter_labels $GFF > $dir/TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P_filtered.gff
