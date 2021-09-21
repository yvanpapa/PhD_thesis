#!/bin/bash
#SBATCH --job-name=remove_unpair_fastq
#SBATCH --cpus-per-task=4
#SBATCH --mem=24G
#SBATCH --partition=parallel
#SBATCH --time=2-6:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/5_remove_unpaired_final_fastq/%j_rm_unpair.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/5_remove_unpaired_final_fastq/%j_rm_unpair.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#### keep only paired reads and do a final FastQC

source activate fastq-pair

read_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/4_quality_filter/seqs_filtered_adpt_N_qual/
dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/5_remove_unpaired_final_fastq/
array=("003_BAR" "004_BM04" "005_BM05" "014_BT02" "018_KA01")

for f in "${array[@]}" ; do 

##need to unzip because fastq_pair does not work on zipped files
#gzip -cd $read_dir/$f.forward.fq.gz > $dir/$f.forward.fq
#gzip -cd $read_dir/$f.reverse.fq.gz > $dir/$f.reverse.fq

#need to ask for more than 16G for this step
fastq_pair -t 85000000 $dir/$f.forward.fq $dir/$f.reverse.fq
#-t 
#The optimal table size is basically somewhere around the number of sequences in your fastq files. 
#You can quickly find out how many sequences there are in your fastq file:

echo "compressing"

gzip -c $dir/$f.forward.fq.paired.fq > $dir/$f.forward.paired.fq.gz
gzip -c $dir/$f.reverse.fq.paired.fq > $dir/$f.reverse.paired.fq.gz
gzip -c $dir/$f.forward.fq.single.fq > $dir/$f.forward.single.fq.gz
gzip -c $dir/$f.reverse.fq.single.fq > $dir/$f.reverse.single.fq.gz

#rm $dir/$f.*.fq

echo "done"

echo "fastqc"
module load fastqc/0.11.7
echo "Calculating quality metrics for samples in $dir"
  for f in $dir/*paired.fq.gz ; do
    time fastqc $f -t 4 --noextract -o $dir/
    echo "Done"
  done

done




