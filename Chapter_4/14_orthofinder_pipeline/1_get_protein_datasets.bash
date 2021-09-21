#!/bin/bash
#SBATCH --job-name=get_prots_datasets
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/get_prots_datasets_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/get_prots_datasets_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz


#protein datasets:
dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/
mkdir -p $dir/proteomes/all/


cp /nfs/scratch/papayv/Tarakihi/TARdn/14_filter_gene_models/trial2_lightGFF/2_flag_filter_ORF/final_outputs_flagged/TARdn_V2P_rnd2.all.maker.proteins.blstfnc.lngthfiltrd.ORFflag.fasta \
$dir/proteomes/all/a_tarakihi.fasta
cp /nfs/scratch/papayv/Tarakihi/TARdn/Z_KTAR_pipeline/14_filter_gene_models/2_flag_filter_ORF/final_outputs_flagged/KTARdn_rnd2.all.maker.proteins.blstfnc.lngthfiltrd.ORFflag.fasta \
$dir/proteomes/all/b_ktar.fasta
cp /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/12_filter_gene_models/BAR/2_flag_filter_ORF/final_outputs_flagged/BARdn_rnd2.all.maker.proteins.blstfnc.lngthfiltrd.ORFflag.fasta \
$dir/proteomes/all/c_bar.fasta
cp /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/12_filter_gene_models/BM/2_flag_filter_ORF/final_outputs_flagged/BMdn_rnd2.all.maker.proteins.blstfnc.lngthfiltrd.ORFflag.fasta \
$dir/proteomes/all/d_bm.fasta
cp /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/12_filter_gene_models/BT/2_flag_filter_ORF/final_outputs_flagged/BTdn_rnd2.all.maker.proteins.blstfnc.lngthfiltrd.ORFflag.fasta \
$dir/proteomes/all/e_bt.fasta
cp /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/12_filter_gene_models/KA/2_flag_filter_ORF/final_outputs_flagged/KAdn_rnd2.all.maker.proteins.blstfnc.lngthfiltrd.ORFflag.fasta \
$dir/proteomes/all/f_ka.fasta


gunzip -cd /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/1_run_maker/homologous/danio_rerio/*.pep.all.fa.gz > $dir/proteomes/all/g_zebrafish.fasta
gunzip -cd /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/1_run_maker/homologous/gasterosteus_aculeatus/*.pep.all.fa.gz > $dir/proteomes/all/h_stickleback.fasta
gunzip -cd /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/1_run_maker/homologous/lepisosteus_oculatus/*.pep.all.fa.gz > $dir/proteomes/all/i_spotted_gar.fasta
gunzip -cd /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/1_run_maker/homologous/oreochromis_niloticus/*.pep.all.fa.gz > $dir/proteomes/all/j_nile_tilapia.fasta
gunzip -cd /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/1_run_maker/homologous/oryzias_latipes/*.pep.all.fa.gz > $dir/proteomes/all/k_medaka.fasta
gunzip -cd /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/1_run_maker/homologous/takifugu_rubripes/*.pep.all.fa.gz > $dir/proteomes/all/l_fugu.fasta
gunzip -cd /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/1_run_maker/homologous/tetraodon_nigroviridis/*.pep.all.fa.gz > $dir/proteomes/all/m_tetraodon.fasta
gunzip -cd /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/1_run_maker/homologous/xiphophorus_maculatus/*.pep.all.fa.gz > $dir/proteomes/all/n_platyfish.fasta
gunzip -cd /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_protein_families/download/latimeria_chalumnae/*.pep.all.fa.gz > $dir/proteomes/all/o_coelacanth.fasta

