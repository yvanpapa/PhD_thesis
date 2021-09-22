#!/bin/bash
#SBATCH --job-name=fastqc_multiqc2
#SBATCH --cpus-per-task=12
#SBATCH --mem=24G
#SBATCH --partition=bigmem
#SBATCH --time=5-12:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/popgen/04_fastqc2/lib6/job_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/popgen/04_fastqc2/lib6/job_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module load fastqc/0.11.7
module load multiqc/1.7

read_dir=/nfs/scratch/papayv/Tarakihi/popgen/03_trimming/lib6/results
output_dir=/nfs/scratch/papayv/Tarakihi/popgen/04_fastqc2/lib6/results
mkdir -p $output_dir/fastqc/

echo "Calculating quality metrics for samples in $read_dir"
  for f in $read_dir/*_paired.fq.gz ; do
    time fastqc $f -t 12 --noextract -o $output_dir/fastqc/
    echo "Done"
  done
#cpt=12, mem=48G: 5 - 8min / sample
#cpt=12, mem=24G: ~ 5min / paired file
  
#parameters:
#-t: --threads. Specifies the number of files which can be processed simultaneously.  Each thread will be allocated 250MB
#--noextract: Do not uncompress the output file after creating it
#-o: --outdir. Must already exist.
  
  
mkdir -p $output_dir/multiqc/
echo "creating multiqc report for fastq files in $output_dir"
time multiqc $output_dir/fastqc/ -o $output_dir/multiqc/

#cpt=12, mem=48G, total time (fastqc+multiqc): 1h20. Max mem used=5.45G
#cpt=12, mem=24G, total time (fastqc+multiqc): 1h27. Max mem used=5.53G