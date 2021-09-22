#!/bin/bash
#SBATCH --job-name=fastqc_multiqc
#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --partition=parallel
#SBATCH --time=6-12:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/popgen/02_multiqc/lib6/job_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/popgen/02_multiqc/lib6/job_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz


module load fastqc/0.11.7
module load multiqc/1.7


read_dir=/nfs/scratch/papayv/Tarakihi/raw_data/popgen/lib6
output_dir=/nfs/scratch/papayv/Tarakihi/popgen/02_multiqc/lib6/results/
mkdir -p $output_dir/fastqc/

echo "Calculating quality metrics for samples in $read_dir"
  for f in $read_dir/*.fastq.gz ; do
    time fastqc $f -t 12 --noextract -o $output_dir/fastqc/
    echo "Done"
  done
#cpt=12, mem=48G: 5 - 8min / sample
  
#parameters:
#-t: --threads. Specifies the number of files which can be processed simultaneously.  Each thread will be allocated 250MB
#--noextract: Do not uncompress the output file after creating it
#-o: --outdir. Must already exist.
  
  
mkdir -p $output_dir/multiqc/
echo "creating multiqc report for fastq files in $output_dir"
multiqc $output_dir -o $output_dir/multiqc/

#cpt=12, mem=48G, total time (fastqc+multiqc): 1h20. Max mem used=5.45G