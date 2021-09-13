#!/bin/bash
#SBATCH --job-name=convert_gff
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/isoseq/%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/isoseq/%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

read_dir=/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/06_align_genome
gff_name=TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P_hardmask
out_dir=/nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/isoseq/



cat $read_dir/$gff_name.gff | \
  perl -ane '$id; if(!/^\#/){@F = split(/\t/, $_); chomp $F[-1];$id++; $F[-1] .= "\;ID=$id"; $_ = join("\t", @F)."\n"} print $_' \
  > $out_dir/$gff_name.reformat.gff3

