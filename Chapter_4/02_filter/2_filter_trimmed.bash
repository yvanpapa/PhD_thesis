#!/bin/bash
#SBATCH --job-name=filter_trimmed
#SBATCH --cpus-per-task=6
#SBATCH --mem=8G
#SBATCH --partition=parallel
#SBATCH --time=3-1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/2_filter_trimmed/%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/2_filter_trimmed/%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

read_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/1_trim_fastqc/
output_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/2_filter_trimmed/
mkdir -p $output_dir
array=("003_BAR.forward_paired" "003_BAR.reverse_paired" "004_BM04.forward_paired" "004_BM04.reverse_paired" "005_BM05.forward_paired" "005_BM05.reverse_paired" "014_BT02.forward_paired" "014_BT02.reverse_paired" "018_KA01.forward_paired" "018_KA01.reverse_paired")


echo "filtering"
module load seqkit/0.13.2
for f in "${array[@]}" ; do 
echo "filtering $f for 150bp"
seqkit seq -m 150 $read_dir/$f.fq.gz > $output_dir/$f.filtered.fq
done

echo "compress"
  for f in $output_dir/*.filtered.fq ; do
time gzip -c $f > $f.gz
done

echo "fastqc"
module load fastqc/0.11.7
echo "Calculating quality metrics for samples in $read_dir"
  for f in $output_dir/*.filtered.fq.gz ; do
    time fastqc $f -t 12 --noextract -o $output_dir/
  done

echo "count the number of N bases just in case"
module load seqtk/1.3
  for f in $output_dir/*.filtered.fq.gz ; do
    time seqtk fqchk $f
  done

echo "ouai c'est pas faux"