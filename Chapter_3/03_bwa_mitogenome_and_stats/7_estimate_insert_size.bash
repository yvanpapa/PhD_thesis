#!/bin/bash
#SBATCH --job-name=insert_size
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=5G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/job_out_insert_size
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/job_err_insert_size
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module load java/jdk/1.8.0_121
module load picard/2.18.20
input=/nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/190604_v1/mitogenome_tardn.mapped.bam
outdir=/nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome

echo "start"
java -jar /nfs/home/papayv/bin/picard.jar CollectInsertSizeMetrics I=$input O=$outdir/TARdn.insert_size_metrics.txt H=$outdir/TARdn.insert_size_histogram.pdf
echo "done"

