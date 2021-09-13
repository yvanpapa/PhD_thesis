#!/bin/bash
#SBATCH --job-name=bamtofastx
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --partition=parallel
#SBATCH --time=1-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn2/Hifi/1_bamtofastx/%j_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn2/Hifi/1_bamtofastx/%j_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module load SMRTLink/9.0.0.92188
module load seqkit/0.10.1
module load samtools/1.10 

dir=/nfs/scratch/papayv/Tarakihi/TARdn2/Hifi/1_bamtofastx/
bamfile=/nfs/scratch/papayv/Tarakihi/raw_data/TARdn/TARdn2_hifi_reads/bc1001_BAK8A_OA/ccs.bam
name=TARdn2_hifi

echo "convert to fasta"
bam2fasta -o $dir/$name $bamfile
echo "compute stats"
seqkit stat $dir/$name.fasta.gz

echo "convert to fastq"
bam2fastq -o $dir/$name $bamfile
echo "compute stats"
seqkit stat $dir/$name.fastq.gz

echo "decompress fastq and fasta"
gzip -cd $dir/$name.fasta.gz > $dir/$name.fasta
gzip -cd $dir/$name.fastq.gz > $dir/$name.fastq

echo "index fastq file"
samtools fqidx $dir/$name.fastq

#dont think it's necessary but if curious:
echo "fastqc"
mkdir -p $dir/fastqc
module load fastqc/0.11.7
  for f in $dir/*.fastq.gz ; do
    time fastqc $f -t 4 --noextract -o $dir/fastqc/
    echo "Done"
  done


