#!/bin/bash
#SBATCH --job-name=merge_outputs_BAR
#SBATCH --cpus-per-task=2
#SBATCH --mem=24G
#SBATCH --partition=parallel
#SBATCH --time=2-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BAR/maker/merge_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BAR/maker/merge_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#Needs at least 24G of memory!! even if vuw-job-report doesnt say so
#Takes more than an hour if there are a lot of scaffolds (like KTARdn)
#Barracouta took 4 hours per one gff file! Really depends of the number fo scffolds

source activate genome_annotation

read_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BAR/maker/BARdn_rnd1.maker.output/
index_log=$read_dir/BARdn_rnd1_master_datastore_index.log
name=BARdn_rnd1


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
