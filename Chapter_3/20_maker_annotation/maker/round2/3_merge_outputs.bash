#!/bin/bash
#SBATCH --job-name=merge_outputs
#SBATCH --cpus-per-task=4
#SBATCH --mem=24G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/maker/TRIAL2_TARdn_V2P/round2/merge_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/maker/TRIAL2_TARdn_V2P/round2/merge_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

source activate genome_annotation

read_dir=/nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/maker/TRIAL2_TARdn_V2P/round2/TARdn_V2P_rnd2.maker.output/
index_log=$read_dir/TARdn_V2P_rnd2_master_datastore_index.log
name=TARdn_V2P_rnd2


#We conclude by assembling together the GFF and FASTA outputs
echo "start merging"
gff3_merge -s -d $index_log > $read_dir/$name.all.maker.gff
# -s Use STDOUT for output
# -d The location of the MAKER datastore index log file.

fasta_merge -d $index_log

# GFF w/o the sequences
gff3_merge -n -s -d $index_log > $read_dir/$name.all.maker.noseq.gff
#-n Do not print fasta sequence in footer
echo "merging done"
