#!/bin/bash
#SBATCH -a 0-3
#SBATCH --job-name=bwa_mitogenome_array
#SBATCH --cpus-per-task=8
#SBATCH --mem=128G
#SBATCH --partition=bigmem
#SBATCH --time=12:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/4b_bwa_mitogenome/%j_job_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/4b_bwa_mitogenome/%j_job_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module load bwa-kit/0.7.15

refdir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/4_mitogenome_geneious/
readsdir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/3_kraken/
dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/4b_bwa_mitogenome/
names=("003_BAR" "005_BM05" "014_BT02" "018_KA01")
REF=$refdir/${names[${SLURM_ARRAY_TASK_ID}]}.mitogenome.fasta
R1=$readsdir/${names[${SLURM_ARRAY_TASK_ID}]}.useqs_1.fq.gz
R2=$readsdir/${names[${SLURM_ARRAY_TASK_ID}]}.useqs_2.fq.gz
bamfile=$dir/${names[${SLURM_ARRAY_TASK_ID}]}.mitogenome
unmapped=$bamfile.unmapped
mapped=$bamfile.mapped


threads=6
mem=20000000000


#### INDEXING REF ####
##need to do only once per genome
echo "creating sam index of reference genome (.fai)"
module load samtools/1.9
time samtools faidx $REF
echo "sam index completed"

echo "creating bwa index of reference genome"
module purge #to avoid conflict with samtools
module load bwa-kit/0.7.15
time bwa index $REF
echo "bwa index completed"
########

#### BAM ALIGNEMENT ####
echo "starting alignment"
module purge #to avoid conflict with samtools
module load bwa-kit/0.7.15
time bwa mem -a -M -t $threads $REF $R1 $R2 > $bamfile.sam
echo "sam alignment completed"
## -a	Output all found alignments for single-end or unpaired paired-end reads. These alignments will be flagged as secondary alignments.
## -M	Mark shorter split hits as secondary (for Picard compatibility).
## -t INT	Number of threads [1]
echo "alignment completed"

echo "Convert SAM to sorted BAM."
module purge #to avoid conflict with bwa-kit
module load samtools/1.9
time  samtools sort -m $mem -@ $threads $bamfile.sam > $bamfile.bam
echo "sample $f converted to BAM"
##cpt=32, mem=512 3-4min / sample 
####parameters:
#-m for m: always ask a a couple less threads than requested core, and a bit less memory, or might do core dump error
#-m INT Approximately the maximum required memory per thread, specified either in bytes or with a K, M, or G suffix. [768 MiB]-> always ask a bit less than allocated
#-@ INT Set number of sorting and compression threads. By default, operation is single-threaded.

echo "Index the BAM files."
time samtools index $bamfile.bam
echo "BAM file indexed"

echo "computing flag stats"
time samtools flagstat $bamfile.bam > $bamfile.stats.txt
echo "bam stats computed"

module load bamtools/2.5.1 
echo "computing insert size BAM stats"
time bamtools stats -in $bamfile.bam -insert > $bamfile.bamstats.txt
echo "all BAM stats computed"
########

#### MITOCHONDRIA FILTERING ####
echo "starting mitochondria filtering"
module purge #to avoid conflict with samtools and bwa
module load samtools/1.9

echo "counting reads unmapped to mitogenome"
time samtools view -c -f 4 $bamfile.bam
#-c Instead of printing the alignments, only count them and print the total number. All filter options, such as -f, -F, and -q, are taken into account.
echo "keep only reads that did not map mitogenome"
time samtools view -b -f 4 -@ $threads $bamfile.bam > $unmapped.bam
time samtools index $unmapped.bam #create index
time samtools flagstat $unmapped.bam > $unmapped.bam.stats.txt

echo "counting reads mapped to mitogenome"
time samtools view -c -F 4 $bamfile.bam
echo "keep only reads that mapped mitogenome"
time samtools view -b -F 4 -@ $threads $bamfile.bam > $mapped.bam
time samtools index $mapped.bam #create index
time samtools flagstat $mapped.bam > $mapped.bam.stats.txt
########

##### CONVERSION TO FASTQ ####
module purge #to avoid conflict bwa and samtools
module load samtools/1.9 
module load bedtools/2.27.1
module load seqkit/0.10.1
echo "convert nuclear bam to fastq"
echo "sort the BAM file by query name (required for bamtofastq paired-end)"
time samtools sort -m $mem -@ $threads -n $unmapped.bam -o $unmapped.sorted.bam
#-o is required for samtools ouput now. -n means sort by seq name
echo "start bam to fastq conversion"
time bedtools bamtofastq -i $unmapped.sorted.bam -fq $unmapped.end1.fq -fq2 $unmapped.end2.fq

echo "convert mitochondrial bam to fastq"
echo "sort the BAM file by query name (required for bamtofastq paired-end)"
time samtools sort -m $mem -@ $threads -n $mapped.bam -o $mapped.sorted.bam 
#-o is required for samtools ouput now. -n means sort by seq name
echo "start bam to fastq conversion"
time bedtools bamtofastq -i $mapped.sorted.bam -fq $mapped.end1.fq -fq2 $mapped.end2.fq

echo "sorting files"
mkdir -p $dir/bamfiles
mkdir -p $dir/stats
mkdir -p $dir/bamstats

rm $dir/${names[${SLURM_ARRAY_TASK_ID}]}.*.sam
mv $dir/${names[${SLURM_ARRAY_TASK_ID}]}.*.bam $dir/bamfiles/
mv $dir/${names[${SLURM_ARRAY_TASK_ID}]}.*.bai $dir/bamfiles
mv $dir/${names[${SLURM_ARRAY_TASK_ID}]}.*.stats.txt $dir/stats/
mv $dir/${names[${SLURM_ARRAY_TASK_ID}]}.*.bamstats.txt $dir/bamstats/
