#!/bin/bash
#SBATCH --job-name=model_evaluations_BM
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/3_model_evaluations/model_evaluations_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/3_model_evaluations/model_evaluations_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#Script obtained from https://gist.github.com/darencard/bb1001ac1532dd4225b030cf0cd61ce2
module load perl/CPAN/5.16
module load BioPerl/1.7.2 

round1_gff="/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/maker/BMdn_rnd1.maker.output/BMdn_rnd1.all.maker.noseq.gff"
round2_gff="/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/maker/round2/BMdn_rnd2.maker.output/BMdn_rnd2.all.maker.noseq.gff"
perlscript="/nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/2_model_evaluations/AED_cdf_generator.pl"
dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/3_model_evaluations/

echo "Count the number of gene models and the gene lengths after each round."
echo "round1"
cat $round1_gff | awk '{ if ($3 == "gene") print $0 }' | awk '{ sum += ($5 - $4) } END { print NR, sum / NR }'
echo "round2"
cat $round2_gff | awk '{ if ($3 == "gene") print $0 }' | awk '{ sum += ($5 - $4) } END { print NR, sum / NR }'


echo "Count the AED distribution after each round."
echo "round1"
perl $perlscript -b 0.025 $round1_gff
echo "round2"
perl $perlscript -b 0.025 $round2_gff

#Do this for preparing inputs for the next script
cp /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/maker/BMdn_rnd1.maker.output/BMdn_rnd1.all.maker.proteins.fasta $dir/BMdn_round1.all.maker.proteins.fasta
cp /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/maker/BMdn_rnd1.maker.output/BMdn_rnd1.all.maker.transcripts.fasta $dir/BMdn_round1.all.maker.transcripts.fasta

cp /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/maker/round2/BMdn_rnd2.maker.output/BMdn_rnd2.all.maker.proteins.fasta $dir/BMdn_round2.all.maker.proteins.fasta
cp /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/maker/round2/BMdn_rnd2.maker.output/BMdn_rnd2.all.maker.transcripts.fasta $dir/BMdn_round2.all.maker.transcripts.fasta

