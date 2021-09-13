#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=5G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/01_fastqc/job_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/01_fastqc/job_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz


module load fastqc/0.11.7

if [[ $# -eq 0 ]] ; then
  echo "Usage: fastqc.sh directory"
  exit 1
fi

read_dir=$1
output_dir=/nfs/scratch/papayv/Tarakihi/01_fastqc/results/
mkdir -p $output_dir

echo "Calculating quality metrics for samples in $directory_path"
  for f in $read_dir/*.fastq.gz ; do
    time fastqc $f -t 12 --noextract -o $output_dir
    echo "Done"
  done

mv job* $output_dir



