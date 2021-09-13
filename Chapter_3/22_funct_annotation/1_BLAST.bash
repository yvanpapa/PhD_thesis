#!/bin/bash
#SBATCH --job-name=blastp
#SBATCH --cpus-per-task=48
#SBATCH --mem=128G
#SBATCH --partition=bigmem
#SBATCH --time=10-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/12_funct_annotation/ncbi_blast/%j_blastp_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/12_funct_annotation/ncbi_blast/%j_blastp_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz
threads=48

module load ncbi/blast+/2.6.0

dir=/nfs/scratch/papayv/Tarakihi/TARdn/12_funct_annotation/ncbi_blast/
#cp /nfs/scratch2/data/BLAST_databases/nr/nr.gz $dir
db=$dir/nr.gz

#need to do only once per database
gunzip -c $db | makeblastdb -in - -dbtype prot -out $dir/nr.db -title nr
echo "database built"

proteins=/nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/3_rename_outputs/maker_renamed_outputs/TARdn_V2P_rnd2.all.maker.proteins.fasta

blastp -db $dir/nr/nr.db -query $proteins -num_threads $threads \
-evalue 1e-6 -max_hsps 1 -max_target_seqs 1 -outfmt 6 -out $dir/TARdn_V2P_rnd2.all.maker.proteins_blast_nr.out

echo "blast over"

