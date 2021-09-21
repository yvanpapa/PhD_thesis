#!/bin/bash
#SBATCH --job-name=BM_repeatmasker
#SBATCH --cpus-per-task=48
#SBATCH --mem=256G
#SBATCH --partition=bigmem
#SBATCH --time=6-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/9_repeat_masking/BM/%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/9_repeat_masking/BM/%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#! The job has failed twice on the parallel partition because of a c04n04 node failure. I wonder if it's because I need to request more memory than it seems
#I use 256G because I had another issue and still wonder if this is caused by lack of memory...

module load singularity/3.5.2
#need to do once only
#singularity pull docker://quay.io/biocontainers/repeatmasker:4.1.1--pl526_1
singdir=/nfs/scratch/papayv/Tarakihi/TARdn/09_Repeat/new_pipeline/V2P/
sing=$singdir/repeatmasker_4.1.1--pl526_1.sif

dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/9_repeat_masking/BM/
assembly_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/Genome_assemblies/BM
assembly=BMdn_assembly_V1_srn.fasta
repeat_library=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/9_repeat_masking/BM/BMdn_V1_repeat_lib_TARV2Pdb_and_denovo.fa
threads=64
#cp $assembly_dir/$assembly $dir maybe shouldnt do that

time echo "use RepeatMasker to get a masked sequence and a table of repeats famillies"
singularity exec $sing RepeatMasker -gff -xsmall -pa $threads -lib $repeat_library $assembly_dir/$assembly
echo "job finished"