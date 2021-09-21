#!/bin/bash
#SBATCH --job-name=BM_iprscan_annot
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --partition=quicktest
#SBATCH --time=30:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/11_funct_annotation/BM/4_annotation_interproscan/iprscan_annot_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/11_funct_annotation/BM/4_annotation_interproscan/iprscan_annot_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

source activate genome_annotation

indir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/11_funct_annotation/BM/3_annotation/functannot_output_protID/
dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/11_funct_annotation/BM/4_annotation_interproscan/
iprdir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/11_funct_annotation/BM/2_interproscan
name1=BMdn_rnd2.all.maker.noseq.blastfunc_annotated
name2=BMdn_rnd2.all.maker.blastfunc_annotated
outdir=$dir/final_outputs
ID=BM
mkdir -p $outdir

gff1=$indir/$name1.gff
gff2=$indir/$name2.gff
iprscan_file=$iprdir/output.iprscan

echo "annotate protein domains gff1"
ipr_update_gff $gff1 $iprscan_file > $outdir/$name1.iprscan.gff
iprscan2gff3 $iprscan_file $outdir/$name1.iprscan.gff > $outdir/BMdn_rnd2.visible_iprscan_domains.gff

echo "annotate protein domains gff2"
ipr_update_gff $gff2 $iprscan_file > $outdir/$name2.iprscan.gff

#This is for the next steps
mkdir -p /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/12_filter_gene_models/
mkdir -p /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/12_filter_gene_models/$ID
mkdir -p /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/12_filter_gene_models/$ID/1_filterlength
mkdir -p /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/12_filter_gene_models/$ID/2_flag_filter_ORF
mkdir -p /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/13_final_gene_stats/
mkdir -p /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/13_final_gene_stats/$ID
