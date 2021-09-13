#!/bin/bash
#SBATCH --job-name=jellyfish
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=5G
#SBATCH --partition=bigmem
#SBATCH --time=3-1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/05_jellyfish/jellyfish_merged_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/05_jellyfish/jellyfish_merged_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module load jellyfish/2.2.10
#http://www.genome.umd.edu/docs/JellyfishUserGuide.pdf

filename=/nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/mitogenome_tardn.unmapped


filename=mitogenome_tardn.unmapped
input_path=/nfs/scratch/papayv/Tarakihi/TARdn/04_bwa_mitogenome/
output_path=/nfs/scratch/papayv/Tarakihi/TARdn/05_jellyfish/

echo "concatenate R1 and R2 in one fq file"
cat $input_path$filename.end1.fq $input_path$filename.end2.fq > $output_path$filename.catR1R2.fq

echo "Count R1R2 21-mers using jellyfish:"
time jellyfish count -C -m 21 -s 5000000000 -t 12 $output_path$filename.catR1R2.fq -o $output_path$filename.catR1R2.21mer_counts.jf

echo "Export R1R2 21-mers count histogram"
time jellyfish histo -t 12 $output_path$filename.catR1R2.21mer_counts.jf > $output_path$filename.catR1R2.21mer_counts.histo

echo "done"