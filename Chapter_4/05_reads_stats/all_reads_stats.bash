#!/bin/bash
#SBATCH -a 0-3
#SBATCH --job-name=stats
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=1G
#SBATCH --partition=parallel
#SBATCH --time=2-12:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/5_stats/job_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/5_stats/job_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module load seqkit/0.10.1
names=("003_BAR" "005_BM05" "014_BT02" "018_KA01")
dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/5_stats/

echo "bonus: compute basic stats for all fq files so far"

touch $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt

echo "raw illumina reads 1" >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt
time seqkit stat /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/0_merge/${names[${SLURM_ARRAY_TASK_ID}]}.6x_R1.fastq.gz >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt

echo "raw illumina reads 2" >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt
time seqkit stat /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/0_merge/${names[${SLURM_ARRAY_TASK_ID}]}.6x_R2.fastq.gz >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt

echo "filtered illumina reads 1" >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt
time seqkit stat /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/5_remove_unpaired_final_fastq/paired/${names[${SLURM_ARRAY_TASK_ID}]}.forward.paired.fq.gz >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt
echo "filtered illumina reads 2" >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt
time seqkit stat /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/5_remove_unpaired_final_fastq/paired/${names[${SLURM_ARRAY_TASK_ID}]}.reverse.paired.fq.gz >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt

echo "Kraken-classified reads 1" >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt
time seqkit stat /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/3_kraken/${names[${SLURM_ARRAY_TASK_ID}]}.cseqs_1.fq.gz >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt
echo "Kraken-classified reads 2" >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt
time seqkit stat /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/3_kraken/${names[${SLURM_ARRAY_TASK_ID}]}.cseqs_2.fq.gz >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt

echo "Kraken-unclassified reads 1" >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt
time seqkit stat /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/3_kraken/${names[${SLURM_ARRAY_TASK_ID}]}.useqs_1.fq.gz >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt
echo "Kraken-unclassified reads 2" >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt
time seqkit stat /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/3_kraken/${names[${SLURM_ARRAY_TASK_ID}]}.useqs_2.fq.gz >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt

echo "compressing R1" >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt
gzip -c /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/4b_bwa_mitogenome/${names[${SLURM_ARRAY_TASK_ID}]}.mitogenome.unmapped.end1.fq > /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/4b_bwa_mitogenome/${names[${SLURM_ARRAY_TASK_ID}]}.mitogenome.unmapped.end1.fq.gz
echo "compressing R2" >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt
gzip -c /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/4b_bwa_mitogenome/${names[${SLURM_ARRAY_TASK_ID}]}.mitogenome.unmapped.end2.fq > /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/4b_bwa_mitogenome/${names[${SLURM_ARRAY_TASK_ID}]}.mitogenome.unmapped.end2.fq.gz

echo "clean reads without mitogenome 1" >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt
time seqkit stat /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/4b_bwa_mitogenome/${names[${SLURM_ARRAY_TASK_ID}]}.mitogenome.unmapped.end1.fq >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt
echo "clean reads without mitogenome 2" >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt
time seqkit stat /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/4b_bwa_mitogenome/${names[${SLURM_ARRAY_TASK_ID}]}.mitogenome.unmapped.end2.fq >> $dir/${names[${SLURM_ARRAY_TASK_ID}]}.txt

echo "Nice, now we got fastq files of paired-end reads filtered for conta (Kraken) AND mitogenome (bwa+samtools)"

#There should be 366082674 reads total, 366082674 paired in sequencing, 183,040,997 R1 and 183,041,677 R2
#If results are weird, try java -jar /home/software/apps/picard/2.18.20/picard.jar SamToFastq
#I did not use picard first because the way they include non primary alignments is "not comprehensive"