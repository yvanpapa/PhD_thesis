#!/bin/bash
#SBATCH --job-name=create_shellscript
#SBATCH --cpus-per-task=6
#SBATCH --mem-per-cpu=8G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/07_MASURCA/RUN2_V3_4_1/job_out_create_shellscript_2_4
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/07_MASURCA/RUN2_V3_4_1/job_err_create_shellscript_2_4
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#Partition: bigmem
#This partition is primarily useful for jobs that require very large shared memory (generally greater than 125 GB). These are known as memory-bound jobs.
#Maximum CPU available per task: 48
#Maximum memory available per task: 1 TB (Note: maximum CPU for 1 TB is 40)
#Maximum Runtime: 10 days

#Manual: https://github.com/alekseyzimin/masurca
#Other manual: https://isugenomics.github.io/bioinformatics-workbook/dataAnalysis/GenomeAssembly/Assemblers/MaSuRCA.html

#Hardware requirements:
#Mammalian genomes (up to 3Gb): 512Gb RAM, 32+ cores, 5Tb disk space: 30-40 days

echo "use the masurca script from the MaSuRCA bin directory to generate the assemble.sh shell script that executes the assembly"

time /home/software/apps/masurca/3.4.1/bin/masurca /nfs/scratch/papayv/Tarakihi/TARdn/07_MASURCA/RUN2_V3_4_1/sr_config_run2_4.txt


echo "shell script completed"



