#!/bin/bash
#SBATCH --job-name=BAR_blastp
#SBATCH --cpus-per-task=48
#SBATCH --mem=48G
#SBATCH --partition=parallel
#SBATCH --time=10-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/11_funct_annotation/BAR/1_ncbi_blast/%j_blastp_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/11_funct_annotation/BAR/1_ncbi_blast/%j_blastp_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz
threads=48

module load ncbi/blast+/2.6.0

dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/11_funct_annotation/BAR/1_ncbi_blast/
#cp /nfs/scratch2/data/BLAST_databases/nr/nr.gz $dir
#db=$dir/nr.gz

##need to do only once per database
#gunzip -c $db | makeblastdb -in - -dbtype prot -out $dir/nr.db -title nr
#echo "database built"

db=/nfs/scratch/papayv/Tarakihi/TARdn/12_funct_annotation/ncbi_blast/nr/nr.db
proteins=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BAR/4_rename_outputs/maker_renamed_outputs/BARdn_rnd2.all.maker.proteins.fasta


blastp -db $db -query $proteins -num_threads $threads \
-evalue 1e-6 -max_hsps 1 -max_target_seqs 1 -outfmt 6 -out $dir/BARdn_rnd2.all.maker.proteins_blast_nr.out

echo "blast over"
