#!/bin/bash
#SBATCH --job-name=assembly_stats
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/13_figure_stats/assembly_stats_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/13_figure_stats/assembly_stats_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#You need to rename your assembly file without underscores, or the html file wont work!!

dir=/nfs/scratch/papayv/Tarakihi/TARdn/13_figure_stats/

module load singularity/3.5.2
#does not work with the newer versions

singularity build $dir/yvan_assemblystats.simg shub://kiwiepic/assembly-stats:17.02
assembly=/nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P/TARdn_assembly_V2_p_srn.fasta
cp $assembly .

cp TARdn_assembly_V2_p_srn.fasta Tarakihi.fasta

singularity exec yvan_assemblystats.simg create-stats TarakihiHiFi.fasta TarakihiV1.fasta TarakihiV2.fasta TarakihiV2P.fasta > assembly-stats.html