#!/bin/bash
#SBATCH --job-name=stats_busco
#SBATCH --cpus-per-task=6
#SBATCH --mem=24G
#SBATCH --partition=parallel
#SBATCH --time=3-1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn2/Hifi/3_assembly_stats/1_hifiasm/%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn2/Hifi/3_assembly_stats/1_hifiasm/%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#compute general stats
module purge #to avoid conflict with samtools and bwa
module load bbmap/38.31

assembly=/nfs/scratch/papayv/Tarakihi/TARdn2/Hifi/2_hifiasm/TARdn2_hifi_hifiasm_asm.p_ctg.fa

echo "computing stats"
time stats.sh in=$assembly
echo "stats computed"

module load busco/3.0.2
module load augustus/3.3.1
module load ncbi/blast+/2.7.1
module load hmmer/3.2.1
module load R/CRAN/3.6
 

busco_scripts_path=/nfs/scratch/cadadm/src/busco/busco/scripts
lineage=/nfs/scratch/papayv/Tarakihi/TARdn/08_Assembly_stats/actinopterygii_odb9/actinopterygii_odb9/


export BUSCO_CONFIG_FILE="/nfs/scratch/papayv/Tarakihi/TARdn/08_Assembly_stats/config.ini"
export PATH="/home/software/apps/augustus/3.3.1/bin:$PATH"
export PATH="/home/software/apps/augustus/3.3.1/scripts:$PATH"
#cp -r /home/software/apps/augustus/3.3.1/config /nfs/scratch/papayv/Tarakihi/TARdn/08_Assembly_stats/augustus/  #to do if folder doesnt exist
export AUGUSTUS_CONFIG_PATH="/nfs/scratch/papayv/Tarakihi/TARdn/08_Assembly_stats/augustus/config/"

#manual: https://busco.ezlab.org/


#BUSCO was used to locate the presence or absence of the Actinopterygii- specific set of 4584 single-copy orthologs (OrthoDB v9). 
#To assess the completeness of the assembly we used BUSCO v3 (16) with the Actinopterygii ortholog dataset. 

#The Bench- marking Universal Single-Copy Orthologs v.3.0.2 (BUSCO, RRID: SCR 015008)[29] programwith default settings 
#(e-value 0.01)was used to screen the Renilla genome assemblies for 978 orthologs from the Metazoan data set as a method 
#to evaluate the com- pleteness of each assembly. 
#BUSCO used BLAST v.2.2.31 [23]and HMMER v.3.1.b2 (HMMER, RRID:SCR 005305)[30] in its pipeline.

time python $busco_scripts_path/run_BUSCO.py -i $assembly -o busco_TARdn2_V1_zebrafish -l $lineage -m genome -c 6 -sp zebrafish

#-i SEQUENCE_FILE
#-o OUTPUT_NAME
#-l LINEAGE
#-m MODE
#-c --cpu



