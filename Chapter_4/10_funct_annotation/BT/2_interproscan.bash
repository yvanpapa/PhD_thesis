#!/bin/bash
#SBATCH --job-name=BT_interproscan
#SBATCH --cpus-per-task=24
#SBATCH --mem=32G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/11_funct_annotation/BT/2_interproscan/interproscan_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/11_funct_annotation/BT/2_interproscan/interproscan_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz
threads=22 #Ask for two threads less than the number of cpus

#https://interproscan-docs.readthedocs.io/en/latest/HowToRun.html
#!!!! There might be Perl erros. If this is the case, re-start a fresh Raapoi session
#module load perl/CPAN/5.16 # no need I think it is bundles in java module
module load java/jdk/15.0.2

perl -version

proteins=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BT/4_rename_outputs/maker_renamed_outputs/BTdn_rnd2.all.maker.proteins.fasta
interproscan_path=/nfs/scratch/papayv/bin/my_interproscan/interproscan-5.50-84.0/

$interproscan_path/interproscan.sh -appl pfam -dp -f TSV -goterms -iprlookup -pa -t p -cpu $threads \
 -i $proteins -o output.iprscan
