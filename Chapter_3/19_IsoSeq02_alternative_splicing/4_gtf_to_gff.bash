#!/bin/bash
#SBATCH --job-name=gtf_to_gff
#SBATCH --cpus-per-task=2
#SBATCH --mem=120G
#SBATCH --partition=bigmem
#SBATCH --time=6-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/14_isoseq_analyses/suppa/gtf_to_gff_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/14_isoseq_analyses/suppa/gtf_to_gff_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#need a lot of memory, get out of memory core dump when run on quicktest

source activate agat

dir=/nfs/scratch/papayv/Tarakihi/TARdn/14_isoseq_analyses/suppa/
array=("A3" "A5" "AF" "AL" "MX" "RI" "SE")

for f in "${array[@]}"; do

agat_convert_sp_gxf2gxf.pl -g $dir/AS_events.out_${f}_strict.gtf -o $dir/AS_events.out_${f}_strict.gff

done

# or agat_convert_sp_gff2gtf.pl --gff $gff -o $dir/$name.gtf
