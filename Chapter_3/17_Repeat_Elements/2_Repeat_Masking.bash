#!/bin/bash
#SBATCH --job-name=repeatmasker
#SBATCH --cpus-per-task=32
#SBATCH --mem=128G
#SBATCH --partition=bigmem
#SBATCH --time=8-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/09_Repeat/new_pipeline/V2P/3_Dfam_TETools_3d_run/%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/09_Repeat/new_pipeline/V2P/3_Dfam_TETools_3d_run/%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module load RepeatMasker/4.0.8

dir=/nfs/scratch/papayv/Tarakihi/TARdn/09_Repeat/new_pipeline/V2P/3_Dfam_TETools_3d_run/
assembly_dir=/nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P
assembly=TARdn_assembly_V2_p_srn.fasta
out_dir=$assembly_dir/20201214_repeat_dfam_rb_run3_soft

time echo "use RepeatMasker to get a masked sequence and a table of repeats famillies"
RepeatMasker -gff -xsmall -pa 32 -lib $dir/TARdn_V2P_repeat_lib_actinodb_ad_and_denovo.fa $assembly_dir/$assembly
echo "job finished"

#move output files
mkdir -p $out_dir
mv assembly_dir/*.masked $out_dir/
mv assembly_dir/*.tbl $out_dir/
mv assembly_dir/*.cat.gz $out_dir/
mv assembly_dir/*.out* $out_dir/

