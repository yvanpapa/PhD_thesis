#!/bin/bash
#SBATCH --job-name=markdup
#SBATCH --cpus-per-task=16
#SBATCH --mem=256G
#SBATCH --partition=bigmem
#SBATCH --time=8-06:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/10_snp_call_heteroz/2_markdup/%j_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/10_snp_call_heteroz/2_markdup/%j_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#module load picard/2.18.20

array=("TARdn")
read_dir=/nfs/scratch/papayv/Tarakihi/TARdn/10_snp_call_heteroz/1_bwa_alignement/bamfiles/
output_dir=/nfs/scratch/papayv/Tarakihi/TARdn/10_snp_call_heteroz/2_markdup/

for f in "${array[@]}" ; do
echo "marking sample $f"
time java -jar -XX:-UseGCOverheadLimit -Xmx250000m /home/software/apps/picard/2.18.20/picard.jar MarkDuplicates \
      I=$read_dir/aln_pe_$f.bam \
      O=$output_dir/aln_pe_$f.markdup.bam \
      M=$output_dir/aln_pe_$f.markdup.metrics.txt \
	  MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=100000 #ulimit -n=131072
done
#cpt=32, mem=512G ~40min/sample, maxMem=511.60G 
#cpt=16, mem=256G ~30min/sample, maxMem= 256.61G 

##############################################

echo "Index the BAM files."
module purge #to avoid conflict with samtools
module load samtools/1.9

for f in "${array[@]}" ; do
echo "indexing $f .bam"
time samtools index $output_dir/aln_pe_$f.markdup.bam
echo "$f BAM file indexed"
done
echo "all BAM files indexed"
#cpt=32, mem=512G 1-2 min/sample

###################################################

echo "computing stats"
module purge #to avoid conflict with samtools
module load samtools/1.9

for f in "${array[@]}" ; do
echo "computing stats $f.bam"
time samtools flagstat $output_dir/aln_pe_$f.markdup.bam > $output_dir/aln_pe_$f.markdup.stats.txt
echo "$f.bam stats computed"
done
echo "all BAM stats computed"
##cpt=32, mem=512 1-2min / sample

##########

module load bamtools/2.5.1 

echo "computing BAM stats"
for f in "${array[@]}" ; do
echo "computing stats $f.bam"
time bamtools stats -in $output_dir/aln_pe_$f.markdup.bam -insert > $output_dir/aln_pe_$f.markdup.bamstats.txt
echo "$f.bam stats computed"
done
echo "all BAM stats computed"

##########

mkdir -p $output_dir/bamfiles
mkdir -p $output_dir/stats
mkdir -p $output_dir/bamstats
mkdir -p $output_dir/metrics

mv $output_dir/*.bam $output_dir/bamfiles
mv $output_dir/*.bai $output_dir/bamfiles
mv $output_dir/*.stats.txt $output_dir/stats
mv $output_dir/*.bamstats.txt $output_dir/bamstats
mv $output_dir/*.metrics.txt $output_dir/metrics



