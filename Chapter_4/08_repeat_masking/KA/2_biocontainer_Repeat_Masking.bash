#!/bin/bash
#SBATCH --job-name=KA_repeatmasker
#SBATCH --cpus-per-task=48
#SBATCH --mem=256G
#SBATCH --partition=bigmem
#SBATCH --time=6-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/9_repeat_masking/KA/%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/9_repeat_masking/KA/%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz
threads=48

module load singularity/3.5.2
#need to do once only
#singularity pull docker://quay.io/biocontainers/repeatmasker:4.1.1--pl526_1
singdir=/nfs/scratch/papayv/Tarakihi/TARdn/09_Repeat/new_pipeline/V2P/
sing=$singdir/repeatmasker_4.1.1--pl526_1.sif

dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/9_repeat_masking/KA/
assembly_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/Genome_assemblies/KA
assembly=KAdn_assembly_V1_srn.fasta
repeat_library=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/9_repeat_masking/KA/KAdn_V1_repeat_lib_TARV2Pdb_and_denovo.fa
#cp $assembly_dir/$assembly $dir maybe shouldnt do that

time echo "use RepeatMasker to get a masked sequence and a table of repeats famillies"
singularity exec $sing RepeatMasker -gff -xsmall -pa $threads -lib $repeat_library $assembly_dir/$assembly
echo "job finished"