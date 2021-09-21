#!/bin/bash
#SBATCH --job-name=BAR_rename_maker_outputs
#SBATCH --cpus-per-task=4
#SBATCH --mem=4G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BAR/4_rename_outputs/maker_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BAR/4_rename_outputs/maker_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

source activate genome_annotation

ID=BARdn
file_prefix=BARdn_rnd2.all.maker
dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BAR/4_rename_outputs/
indir=$dir/maker_raw_outputs/

mkdir -p $indir
outdir=$dir/maker_renamed_outputs
mkdir -p $outdir
cp /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BAR/maker/round2/BARdn_rnd2.maker.output/BARdn_rnd2.all.maker.noseq.gff $indir
cp /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BAR/maker/round2/BARdn_rnd2.maker.output/BARdn_rnd2.all.maker.gff $indir
cp /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BAR/maker/round2/BARdn_rnd2.maker.output/BARdn_rnd2.all.maker.proteins.fasta $indir
cp /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BAR/maker/round2/BARdn_rnd2.maker.output/BARdn_rnd2.all.maker.transcripts.fasta $indir
cp $indir/* $outdir


#script taken here: https://gist.github.com/darencard/bb1001ac1532dd4225b030cf0cd61ce2
# create naming table (there are additional options for naming beyond defaults)
maker_map_ids --prefix $ID --justify 5 $outdir/$file_prefix.gff > $dir/$file_prefix.name.map
# replace names in GFF files
map_gff_ids $dir/$file_prefix.name.map $outdir/$file_prefix.gff
map_gff_ids $dir/$file_prefix.name.map $outdir/$file_prefix.noseq.gff
# replace names in FASTA headers
map_fasta_ids $dir/$file_prefix.name.map $outdir/$file_prefix.transcripts.fasta
map_fasta_ids $dir/$file_prefix.name.map $outdir/$file_prefix.proteins.fasta

