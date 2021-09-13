#!/bin/bash
#SBATCH --job-name=iprscan_annot
#SBATCH --cpus-per-task=12
#SBATCH --mem=24G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/12_funct_annotation/2_interproscan/iprscan_annot_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/12_funct_annotation/2_interproscan/iprscan_annot_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

source activate genome_annotation

indir=/nfs/scratch/papayv/Tarakihi/TARdn/12_funct_annotation/1_ncbi_blast/2_trial3_custom/functannot_output_protID/
dir=/nfs/scratch/papayv/Tarakihi/TARdn/12_funct_annotation/2_interproscan/
name1=TARdn_V2P_rnd2.all.maker.noseq.blastfunc_annotated
name2=TARdn_V2P_rnd2.all.maker.blastfunc_annotated

gff1=$indir/$name1.gff
gff2=$indir/$name2.gff
iprscan_file=$dir/output.iprscan

echo "annotate protein domains gff1"
ipr_update_gff $gff1 $iprscan_file > $dir/$name1.iprscan.gff
iprscan2gff3 $iprscan_file $dir/$name1.iprscan.gff > $dir/TARdn_V2P_rnd2.visible_iprscan_domains.gff

echo "annotate protein domains gff2"
ipr_update_gff $gff2 $iprscan_file > $dir/$name2.iprscan.gff



