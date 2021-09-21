#!/bin/bash
#SBATCH --job-name=busco_gene_models_BM
#SBATCH --cpus-per-task=32
#SBATCH --mem=120G
#SBATCH --partition=bigmem
#SBATCH --time=1-10:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/3_model_evaluations/busco_genemodels_job_%A_%a.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/3_model_evaluations/busco_genemodels_job_%A_%a.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#Script "inspired" by the following tutorial:
#https://gist.github.com/darencard/bb1001ac1532dd4225b030cf0cd61ce2

module load bedtools/2.27.1 
threads=32

genome=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/Genome_assemblies/BM/BMdn_assembly_V1_srn.fasta
dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/3_model_evaluations/
name=BM

#### Run BUSCO ####
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

echo "proteins round1"
time python $busco_scripts_path/run_BUSCO.py -i $dir/BMdn_round1.all.maker.proteins.fasta -o busco_prots_round1 -l $lineage \
  -m proteins -c $threads -sp King_Tarakihi -z --augustus_parameters='--progress=true'
  
echo "transcripts round1"
time python $busco_scripts_path/run_BUSCO.py -i $dir/BMdn_round1.all.maker.transcripts.fasta -o busco_mrna_round1 -l $lineage \
  -m transcriptome -c $threads -sp King_Tarakihi -z --augustus_parameters='--progress=true'
  
  echo "proteins round2"
time python $busco_scripts_path/run_BUSCO.py -i $dir/BMdn_round2.all.maker.proteins.fasta -o busco_prots_round2 -l $lineage \
  -m proteins -c $threads -sp King_Tarakihi -z --augustus_parameters='--progress=true'
  
echo "transcripts round2"
time python $busco_scripts_path/run_BUSCO.py -i $dir/BMdn_round2.all.maker.transcripts.fasta -o busco_mrna_round2 -l $lineage \
  -m transcriptome -c $threads -sp King_Tarakihi -z --augustus_parameters='--progress=true'
  
#echo "round 2"
#time python $busco_scripts_path/run_BUSCO.py -i $dir/$name.dedup_maker_transcripts.round2.fasta -o busco_on_round2 -l $lineage \
 # -m transcriptome -c $threads -sp Tarakihi -z --augustus_parameters='--progress=true'
#echo "round 3"
#time python $busco_scripts_path/run_BUSCO.py -i $dir/$name.dedup_maker_transcripts.round3.fasta -o busco_on_round3 -l $lineage \
 # -m transcriptome -c $threads -sp Tarakihi -z --augustus_parameters='--progress=true'

# -l LINEAGE, we are using the actinopterygii set of conserved genes so BUSCO will try to identify those gene using BLAST and an initial HMM model for each that comes stocked within BUSCO
# -m MODE, --mode MODE  Specify which BUSCO analysis mode to run (genome / transcriptome / protein. We specify the -m genome option since we are giving BUSCO regions that include more than just transcripts.
# --long   Optimization Augustus self-training mode (Default: Off); adds considerably to the run time, but can improve results for some non-model organisms
#-sp 	The initial HMM model we'll use is the zebrafish one
#-z, --tarzip compress/tarball the results folders that contain many files
