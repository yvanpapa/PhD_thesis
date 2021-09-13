#!/bin/bash
#SBATCH --job-name=rename_maker_outputs
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/3_rename_outputs/maker_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/3_rename_outputs/maker_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

source activate genome_annotation

ID=TARdn
file_prefix=TARdn_V2P_rnd2.all.maker
dir=/nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/3_rename_outputs/
indir=/nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/3_rename_outputs/maker_raw_outputs/

cp -r $indir $dir/maker_renamed_outputs
outdir=$dir/maker_renamed_outputs

#script taken here: https://gist.github.com/darencard/bb1001ac1532dd4225b030cf0cd61ce2
# create naming table (there are additional options for naming beyond defaults)
maker_map_ids --prefix $ID --justify 5 $outdir/$file_prefix.gff > $dir/$file_prefix.name.map
# replace names in GFF files
map_gff_ids $dir/$file_prefix.name.map $outdir/$file_prefix.gff
map_gff_ids $dir/$file_prefix.name.map $outdir/$file_prefix.noseq.gff
# replace names in FASTA headers
map_fasta_ids $dir/$file_prefix.name.map $outdir/$file_prefix.transcripts.fasta
map_fasta_ids $dir/$file_prefix.name.map $outdir/$file_prefix.proteins.fasta

