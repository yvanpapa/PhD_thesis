#!/bin/bash
#SBATCH --job-name=minimap_haplotigs
#SBATCH --cpus-per-task=8
#SBATCH --mem=34G
#SBATCH --partition=parallel
#SBATCH --time=9-1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/7C_Haplotigs_removal/3_V1/%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/7C_Haplotigs_removal/3_V1/%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

### inputs###

assembly=/nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V1/TARdn_assembly_V1_srn.fasta
long_reads=/nfs/scratch/papayv/Tarakihi/TARdn/07_MASURCA/seq_input/TARdn_filtered_nanopore.fa
dir=/nfs/scratch/papayv/Tarakihi/TARdn/7C_Haplotigs_removal/3_V1
name=V2P_mapped_haplotigs_V1

####

module load  minimap2/2.16
module load samtools/1.9

####

##need to do only once per genome
#echo "creating sam index of reference genome"
#time samtools faidx $assembly
#echo "sam index completed"

echo #map reads back to assembly
minimap2 -t 8 -ax map-ont $assembly $long_reads --secondary=no > $dir/$name.sam

samtools sort -m 4000000000 -@ 8 $dir/$name.sam > $dir/$name.bam
#!! -m=maximum memory PER THREAD!

samtools index $dir/$name.bam

#parameters 
#-x STR       preset (always applied before other options; see minimap2.1 for details) []
#- map-pb/map-ont: PacBio/Nanopore vs reference mapping
#-N INT       retain at most INT secondary alignments [5]
#-a           output in the SAM format (PAF by default)
#!! -m=maximum memory PER THREAD!

echo "run first step of haplotig purge: coverage plot"
source /nfs/scratch/papayv/bin/miniconda3/etc/profile.d/conda.sh
conda activate purge_haplotigs_env

## manual #https://bitbucket.org/mroachawri/purge_haplotigs/src/master/

purge_haplotigs  hist  -b $dir/$name.bam  -g $assembly  -t 8
