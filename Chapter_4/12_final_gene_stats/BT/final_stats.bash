#!/bin/bash
#SBATCH --job-name=agat_stats_BT
#SBATCH --cpus-per-task=4
#SBATCH --mem=12G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/13_final_gene_stats/BT/stats_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/13_final_gene_stats/BT/stats_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz
threads=4

#Script obtained from https://gist.github.com/darencard/bb1001ac1532dd4225b030cf0cd61ce2
module load perl/CPAN/5.16
module load BioPerl/1.7.2 

gff=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/12_filter_gene_models/BT/2_flag_filter_ORF/final_outputs_flagged/BTdn_rnd2.mkr.noseq.blstfnc.iprscan.lngthfiltrd.ORFflag.genes_only.gff
perlscript="/nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/2_model_evaluations/AED_cdf_generator.pl"
dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/13_final_gene_stats/BT/
genome=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/Genome_assemblies/BT/BTdn_assembly_V1_srn.fasta


echo "Count the number of gene models and the gene lengths after each round."
cat $gff | awk '{ if ($3 == "gene") print $0 }' | awk '{ sum += ($5 - $4) } END { print NR, sum / NR }'

echo "Count the AED distribution after each round."
perl $perlscript -b 0.025 $gff

echo "How many genes have blast annotation"
cat $gff | awk -F'\t' '{ if ($3 == "gene") print $0 }' | awk -F'\t' '{ if ($9 ~ "Note=blastp") print $0 }' | wc -l

echo "How many genes have IPR annotation"
cat $gff | awk -F'\t' '{ if ($3 == "gene") print $0 }' | awk -F'\t' '{ if ($9 ~ "Dbxref") print $0 }' | wc -l
cat $gff | awk -F'\t' '{ if ($3 == "gene") print $0 }' | awk -F'\t' '{ if ($9 ~ "InterPro") print $0 }' | wc -l

echo "both blast and IPR"
cat $gff | awk -F'\t' '{ if ($3 == "gene") print $0 }' | awk -F'\t' '{ if ($9 ~ "Note=blastp" && $9 ~ "InterPro") print $0 }' | wc -l
echo "either blast or IPR"
cat $gff | awk -F'\t' '{ if ($3 == "gene") print $0 }' | awk -F'\t' '{ if ($9 ~ "Note=blastp" || $9 ~ "InterPro") print $0 }' | wc -l

module purge

source activate agat
agat_sp_statistics.pl --gff $gff --gs $genome -v
