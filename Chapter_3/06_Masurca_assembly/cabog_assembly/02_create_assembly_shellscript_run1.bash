#!/bin/bash
#SBATCH --job-name=create_shellscript
#SBATCH --cpus-per-task=6
#SBATCH --mem-per-cpu=8G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/07_MASURCA/RUN_1/job_out_create_shellscript
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/07_MASURCA/RUN_1/job_err_create_shellscript
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#Manual: https://github.com/alekseyzimin/masurca
#Other manual: https://isugenomics.github.io/bioinformatics-workbook/dataAnalysis/GenomeAssembly/Assemblers/MaSuRCA.html

#Hardware requirements:
#Mammalian genomes (up to 3Gb): 512Gb RAM, 32+ cores, 5Tb disk space: 30-40 days

echo "use the masurca script from the MaSuRCA bin directory to generate the assemble.sh shell script that executes the assembly"

time /home/software/apps/masurca/3.2.9/bin/masurca /nfs/scratch/papayv/Tarakihi/TARdn/07_MASURCA/RUN_1/sr_config_run1.txt

echo "shell script completed"



