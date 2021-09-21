#!/bin/bash
#SBATCH -a 0-3
#SBATCH --job-name=4fish_srn_stats_busco
#SBATCH --cpus-per-task=12
#SBATCH --mem=32G
#SBATCH --partition=parallel
#SBATCH --time=1-12:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/8_sort_rename_assembly_stats/job_%A_%a.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/8_sort_rename_assembly_stats/job_%A_%a.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

####SORT BY SIZE AND RENAME SCAFFOLDS####
module load seqkit/0.13.2
#manual: https://bioinf.shenwei.me/seqkit/usage/#sort

names=("BAR" "BM" "BT" "KA")
asm_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/Genome_assemblies/${names[${SLURM_ARRAY_TASK_ID}]}/
asm_name=${names[${SLURM_ARRAY_TASK_ID}]}dn_assembly_V1
assembly=$asm_dir/"$asm_name"_srn.fasta
stats_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/8_sort_rename_assembly_stats/
busco_output=busco_${names[${SLURM_ARRAY_TASK_ID}]}dn_V1_zebrafish
threads=12

#get the list of seq names
echo "${names[${SLURM_ARRAY_TASK_ID}]}"
touch $stats_dir/seqnames_${names[${SLURM_ARRAY_TASK_ID}]}
seqkit seq $asm_dir/$asm_name.fasta -n >> $stats_dir/seqnames_${names[${SLURM_ARRAY_TASK_ID}]}

#sort by size (longest to shortest, s=sorted)
time seqkit sort -l -r -2 $asm_dir/$asm_name.fasta > $asm_dir/"$asm_name"_s.fasta
#cpt=12, mem=32G. real	0m2.545s
# -l, --by-length by sequence length
# -r, --reverse reverse the result
#-2, --two-pass  two-pass mode read files twice to lower memory usage. (only for FASTA format)

#get the new list of seq names
echo "length ordered seq names"
seqkit seq $asm_dir/"$asm_name"_s.fasta -n >> $stats_dir/seqnames_${names[${SLURM_ARRAY_TASK_ID}]}

#rename by simple numbers (rn=renames)
time seqkit replace -p .+ -r "{nr}" $asm_dir/"$asm_name"_s.fasta \
> $asm_dir/"$asm_name"_srn.fasta
#cpt=12, mem=32G. real	0m4.087s

#echo "final list of names"
seqkit seq $asm_dir/"$asm_name"_srn.fasta -n >> $stats_dir/seqnames_${names[${SLURM_ARRAY_TASK_ID}]}


#### ASSEMBLY STATS ####

echo "compute read stats in tabular format"
time seqkit fx2tab $asm_dir/"$asm_name"_srn.fasta -l -B A -B T -B G -B C -B N -g -G -H -n > $stats_dir/$asm_name.tab 

module purge #to avoid conflict with samtools and bwa
module load bbmap/38.31
echo "computing bbmap stats"
time stats.sh in=$assembly
echo "stats computed"

echo "start busco stats"
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

time python $busco_scripts_path/run_BUSCO.py -i $assembly -o $busco_output -l $lineage -m genome -c $threads -sp zebrafish

#-i SEQUENCE_FILE
#-o OUTPUT_NAME: should not be a path. your ouptut should be created in the directory you started your analysis
#-l LINEAGE
#-m MODE
#-c --cpu



