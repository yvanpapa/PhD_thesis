#!/bin/bash
#SBATCH --job-name=interproscan
#SBATCH --cpus-per-task=16
#SBATCH --mem=128G
#SBATCH --partition=bigmem
#SBATCH --time=10-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/12_funct_annotation/interproscan/interproscan_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/12_funct_annotation/interproscan/interproscan_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz
threads=14 #Ask for two threads less than the number of cpus

#https://interproscan-docs.readthedocs.io/en/latest/HowToRun.html
#!!!! There might be Perl erros. If this is the case, re-start a fresh Raapoi session
#module load perl/CPAN/5.16 # no need I think it is bundles in java module
module load java/jdk/15.0.2

perl -version

proteins=/nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/3_rename_outputs/maker_renamed_outputs/TARdn_V2P_rnd2.all.maker.proteins.fasta
interproscan_path=/nfs/scratch/papayv/bin/my_interproscan/interproscan-5.50-84.0/

$interproscan_path/interproscan.sh -appl pfam -dp -f TSV -goterms -iprlookup -pa -t p -cpu $threads \
 -i $proteins -o output.iprscan
