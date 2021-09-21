#!/bin/bash
#SBATCH --job-name=maker_BM
#SBATCH --cpus-per-task=24
#SBATCH --mem=48G
#SBATCH --partition=parallel
#SBATCH --time=4-11:30:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/maker/maker_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/maker/maker_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz
threads=48 #I think the threads dont use the full cpus so it's ok to ask more...

source activate genome_annotation
#module load perl/CPAN/5.16
#module load BioPerl/1.7.2
#module load MAKER/2.31.10

#When using module load, I get the error: 
#--------------------------------------------------------------------------
#There are not enough slots available in the system to satisfy the 22 slots
#that were requested by the application:
#  maker

#Either request fewer slots for your application, or make more slots available
#for use.
#--------------------------------------------------------------------------


export LIBDIR=/nfs/scratch/papayv/Tarakihi/TARdn/09_Repeat/new_pipeline/V2P/Libraries/libs/Libraries
export REPEATMASKER_MATRICES_DIR=/nfs/scratch/papayv/bin/miniconda3/envs/genome_annotation/share/RepeatMasker/Matrices #not sure if still necessary

dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/maker/

echo "start maker"
mpiexec -n $threads maker -base BMdn_rnd1 $dir/bm_rnd1_maker_opts.ctl $dir/maker_bopts.ctl $dir/maker_exe.ctl
echo "done"
#do not put a path in base


