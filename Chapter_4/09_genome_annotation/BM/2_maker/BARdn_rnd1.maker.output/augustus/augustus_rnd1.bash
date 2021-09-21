#!/bin/bash
#SBATCH --job-name=augustus_BM
#SBATCH --cpus-per-task=8
#SBATCH --mem=128G
#SBATCH --partition=bigmem
#SBATCH --time=1-12:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/maker/BMdn_rnd1.maker.output/augustus/augustus_rnd1_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/maker/BMdn_rnd1.maker.output/augustus/augustus_rnd1_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz
threads=8
#I havent found a way to ask for more than 8 cpus to augustus as implemented in BUSCO

#Script "inspired" by the following tutorial:
#https://gist.github.com/darencard/bb1001ac1532dd4225b030cf0cd61ce2

module load bedtools/2.27.1 

gff=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/maker/BMdn_rnd1.maker.output/BMdn_rnd1.all.maker.noseq.gff
genome=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/Genome_assemblies/BM/BMdn_assembly_V1_srn.fasta
name=BMdn_rnd1
dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/maker/BMdn_rnd1.maker.output/augustus/

#excise the regions that contain mRNA annotations based on our initial MAKER run (with 1000bp on each side)
awk -v OFS="\t" '{ if ($3 == "mRNA") print $1, $4, $5 }' $gff | \
  awk -v OFS="\t" '{ if ($2 < 1000) print $1, "0", $3+1000; else print $1, $2-1000, $3+1000 }' | \
  bedtools getfasta -fi $genome -bed - -fo $dir/$name.all.maker.transcripts1000.fasta

#you will likely get warnings from BEDtools that certain coordinates could not be used to extract FASTA sequences
#This is okay, however, as we still end up with sequences from thousands of gene models and BUSCO will only be searching for a small subset of genes itself.

module load singularity/3.5.2
singdir=/nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/1_run_maker/maker/TRIAL2_TARdn_V2P/round2/TARdn_V2P_rnd2.maker.output/augustus/round2_parallel_trial/
sing=$singdir/busco_v5.0.0_cv1.sif
#singularity exec $sing cp -r /augustus/config .
export AUGUSTUS_CONFIG_PATH="/nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/1_run_maker/maker/TRIAL2_TARdn_V2P/round2/TARdn_V2P_rnd2.maker.output/augustus/round2_parallel_trial/config/"
export BLASTDB_LMDB_MAP_SIZE=1000000 #https://www.biostars.org/p/413294/

lineage=actinopterygii_odb10
sp=zebrafish 

singularity exec $sing busco -i $dir/$name.all.maker.transcripts1000.fasta -l $lineage -o $name -m genome --augustus \
--augustus_species $sp --long -c $threads --augustus_parameters='--progress=true' -r

# -f, --force           Force rewriting of existing files. Must be used when output files with the provided name already exist.
# -r, --restart         Continue a run that had already partially completed.

