#!/bin/bash
#SBATCH --job-name=convert_headers
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/homologous/%j_convert.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/homologous/%j_convert.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

dir=/nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/homologous/

array=("danio_rerio" "gasterosteus_aculeatus" "lepisosteus_oculatus" "oreochromis_niloticus" "oryzias_latipes" "takifugu_rubripes" "tetraodon_nigroviridis" "xiphophorus_maculatus")

for f in "${array[@]}" ; do 

zcat $dir/$f/*.all.fa.gz | sed "s/ pep.*/|$f/" > $dir/$f/$f.all.shortheaders.fa

gzip -c $dir/$f/$f.all.shortheaders.fa > $dir/$f/$f.all.shortheaders.fa.gz

done

