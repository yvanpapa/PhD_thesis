#!/bin/bash
#SBATCH --job-name=bwa
#SBATCH --cpus-per-task=24
#SBATCH --mem-per-cpu=10G
#SBATCH --partition=bigmem
#SBATCH --time=9-6:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/10_snp_call_heteroz/1_bwa_alignement/%job_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/10_snp_call_heteroz/1_bwa_alignement/%job_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

REF=/nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P/TARdn_assembly_V2_p_srn.fasta
read_dir=/nfs/scratch/papayv/Tarakihi/TARdn/07_MASURCA/seq_input
output_dir=/nfs/scratch/papayv/Tarakihi/TARdn/10_snp_call_heteroz/1_bwa_alignement
R1=TARdn_clean_illumina_R1.fastq
R2=TARdn_clean_illumina_R2.fastq
output_name=TARdn

###########
#need to do only once per genome
echo "creating bwa index of reference genome"
module purge #to avoid conflict with samtools
module load bwa-kit/0.7.15
time bwa index $REF
echo "bwa index completed"

###########
#need to do only once per genome
echo "creating sam index of reference genome (.fai)"
module purge #to avoid conflict with samtools
module load samtools/1.9
time samtools faidx $REF
echo "sam index completed"

##########

echo "starting bwa alignment"
module purge #to avoid conflict with samtools module load bwa-kit/0.7.15
module load bwa-kit/0.7.15
time bwa mem -a -M -t 24 $REF $read_dir/$R1 $read_dir/$R2 > $output_dir/aln_pe_$output_name.sam
echo "sam alignment completed"
#cpt=32, mem=512 10-15min / sample

####parameters:
## -a	Output all found alignments for single-end or unpaired paired-end reads. These alignments will be flagged as secondary alignments.
## -M	Mark shorter split hits as secondary (for Picard compatibility).
## -t INT	Number of threads [1]

############

echo "Convert SAM to sorted BAM."
module purge #to avoid conflict with samtools
module load samtools/1.9
time  samtools sort -m 8000000000 -@ 22 $output_dir/aln_pe_$output_name.sam > $output_dir/aln_pe_$output_name.bam
echo "sample $f converted to BAM"

##cpt=32, mem=512 3-4min / sample 
####parameters:
#-m for m: always ask a a couple less threads than requested core, and a bit less memory, or might do core dump error
#-m INT Approximately the maximum required memory per thread, specified either in bytes or with a K, M, or G suffix. [768 MiB]-> always ask a bit less than allocated
#-@ INT Set number of sorting and compression threads. By default, operation is single-threaded.

############

echo "Index the BAM files."
time samtools index $output_dir/aln_pe_$output_name.bam
echo "BAM file indexed"
##cpt=32, mem=512 1-2min / sample

###########

echo "computing flag stats"
time samtools flagstat $output_dir/aln_pe_$output_name.bam > $output_dir/aln_pe_$output_name.stats.txt
echo "bam stats computed"
##cpt=32, mem=512 1-2min / sample

##########

module load bamtools/2.5.1 

echo "computing insert size BAM stats"
time bamtools stats -in $output_dir/aln_pe_$output_name.bam -insert > $output_dir/aln_pe_$output_name.bamstats.txt
echo "all BAM stats computed"
##cpt=32, mem=512 1-2min / sample

###parameters:
# -in <BAM filename>                the input BAM file [stdin]
# -insert                           summarize insert size data

mkdir -p $output_dir/samfiles
mkdir -p $output_dir/bamfiles
mkdir -p $output_dir/stats
mkdir -p $output_dir/bamstats

mv $output_dir/*.sam $output_dir/samfiles
mv $output_dir/*.bam $output_dir/bamfiles
mv $output_dir/*.bai $output_dir/bamfiles
mv $output_dir/*.stats.txt $output_dir/stats
mv $output_dir/*.bamstats.txt $output_dir/bamstats

############

##cpt=32, mem=512, bwa mem threads=30: total run time= ~11h. Max Mem Used: 451.18G!!
##cpt=16, mem=256G, bwa mwm threads=15: total run time= ~18h. Max Mem Used: 230.47G
