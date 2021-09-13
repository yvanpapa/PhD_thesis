#!/bin/bash
#SBATCH --job-name=maker_rnd2
#SBATCH --cpus-per-task=24
#SBATCH --mem=48G
#SBATCH --partition=parallel
#SBATCH --time=5-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/maker/TRIAL2_TARdn_V2P/round2/maker_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/maker/TRIAL2_TARdn_V2P/round2/maker_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

source activate genome_annotation
module load augustus/3.3.1
export PATH="/home/software/apps/augustus/3.3.1/bin:$PATH"
export PATH="/home/software/apps/augustus/3.3.1/scripts:$PATH"
#cp -r /home/software/apps/augustus/3.3.1/config /nfs/scratch/papayv/Tarakihi/TARdn/08_Assembly_stats/augustus/  #to do if folder doesnt exist
export AUGUSTUS_CONFIG_PATH="/nfs/scratch/papayv/Tarakihi/TARdn/08_Assembly_stats/augustus/config/"


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

dir=/nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/maker/TRIAL2_TARdn_V2P/round2/
threads=24

echo "start maker"
mpiexec -n $threads maker -base TARdn_V2P_rnd2 $dir/trial2_rnd2_maker_opts.ctl $dir/maker_bopts.ctl $dir/maker_exe.ctl
echo "done"
#do not put a path in base