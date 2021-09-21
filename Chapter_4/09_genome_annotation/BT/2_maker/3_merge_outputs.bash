#!/bin/bash
#SBATCH --job-name=merge_outputs_BT
#SBATCH --cpus-per-task=2
#SBATCH --mem=96G
#SBATCH --partition=bigmem
#SBATCH --time=6:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BT/maker/merge_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BT/maker/merge_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#Needs at least 24G of memory!! even if vuw-job-report doesnt say so
#Takes more than an hour if there are a lot of scaffolds (like KTARdn)

source activate genome_annotation

read_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BT/maker/BTdn_rnd1.maker.output/
index_log=$read_dir/BTdn_rnd1_master_datastore_index.log
name=BTdn_rnd1


##We conclude by assembling together the GFF and FASTA outputs
echo "start merging"
gff3_merge -s -d $index_log > $read_dir/$name.all.maker.gff
# -s Use STDOUT for output
# -d The location of the MAKER datastore index log file.

echo "merging noseq"
# GFF w/o the sequences
gff3_merge -n -s -d $index_log > $read_dir/$name.all.maker.noseq.gff
#-n Do not print fasta sequence in footer


cd $read_dir

echo "merging fasta"
fasta_merge -d $index_log
echo "merging done"
