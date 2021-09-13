#!/bin/bash
#SBATCH --job-name=CTL_files
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/maker/TRIAL2_TARdn_V2P/ctl_files_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/maker/TRIAL2_TARdn_V2P/ctl_files_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz


#MAKER TUTORIAL HERE: http://weatherby.genetics.utah.edu/MAKER/wiki/index.php/MAKER_Tutorial_for_WGS_Assembly_and_Annotation_Winter_School_2018

module load perl/CPAN/5.16
module load BioPerl/1.7.2
module load MAKER/2.31.10

#create a set of generic configuration files in the current working directory :
maker -CTL

#maker_exe.ctl - contains the path information for the underlying executables.
