#!/bin/bash
#SBATCH --job-name=augustus
#SBATCH --cpus-per-task=6
#SBATCH --mem=24G
#SBATCH --partition=bigmem
#SBATCH --time=7-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/maker/TRIAL2_TARdn_V2P/TARdn_V2P_rnd1.maker.output/augustus/round1/augustus_rnd1_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/maker/TRIAL2_TARdn_V2P/TARdn_V2P_rnd1.maker.output/augustus/round1/augustus_rnd1_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz


#Script "inspired" by the following tutorial:
#https://gist.github.com/darencard/bb1001ac1532dd4225b030cf0cd61ce2

module load bedtools/2.27.1 
threads=12

gff=/nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/maker/TRIAL2_TARdn_V2P/TARdn_V2P_rnd1.maker.output/TARdn_V2P_rnd1.all.maker.noseq.gff
genome=/nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P/TARdn_assembly_V2_p_srn.fasta
name=TARdn_V2P_rnd1
dir=/nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/maker/TRIAL2_TARdn_V2P/TARdn_V2P_rnd1.maker.output/augustus/round1/

#excise the regions that contain mRNA annotations based on our initial MAKER run (with 1000bp on each side)
awk -v OFS="\t" '{ if ($3 == "mRNA") print $1, $4, $5 }' $gff | \
  awk -v OFS="\t" '{ if ($2 < 1000) print $1, "0", $3+1000; else print $1, $2-1000, $3+1000 }' | \
  bedtools getfasta -fi $genome -bed - -fo $dir/$name.all.maker.transcripts1000.fasta

#you will likely get warnings from BEDtools that certain coordinates could not be used to extract FASTA sequences
#This is okay, however, as we still end up with sequences from thousands of gene models and BUSCO will only be searching for a small subset of genes itself.

#### Train AUGUSTUS with BUSCO ####

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

time python $busco_scripts_path/run_BUSCO.py -i $dir/$name.all.maker.transcripts1000.fasta -o $name.maker -l $lineage \
  -m genome -c $threads --long -sp zebrafish -z --augustus_parameters='--progress=true'

# -l LINEAGE, we are using the actinopterygii set of conserved genes so BUSCO will try to identify those gene using BLAST and an initial HMM model for each that comes stocked within BUSCO
# -m MODE, --mode MODE  Specify which BUSCO analysis mode to run (genome / transcriptome / protein. We specify the -m genome option since we are giving BUSCO regions that include more than just transcripts.
# --long   Optimization Augustus self-training mode (Default: Off); adds considerably to the run time, but can improve results for some non-model organisms
#-sp 	The initial HMM model we'll use is the zebrafish one
#-z, --tarzip compress/tarball the results folders that contain many files











