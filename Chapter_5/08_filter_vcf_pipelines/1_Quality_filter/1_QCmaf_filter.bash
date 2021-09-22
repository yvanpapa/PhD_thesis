#!/bin/bash
#SBATCH --job-name=vcft_filter
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --partition=parallel
#SBATCH --time=3-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/%j_filter_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/%j_filter_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module load bcftools/1.9
module load vcftools/0.1.16 
module load htslib/1.9

read_dir=/nfs/scratch/papayv/Tarakihi/popgen/12_bcf_merge/lib1_to_6_TARdn_V2P/
dir=/nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/
outdir=$dir/1_lib1_to_6_V2P.QCmaf/
mkdir -p $dir
name=call_set_AGRFlib1_to_6_V2P


QC="--minDP 3 --max-alleles 2 --min-alleles 2 --minQ 600 --max-missing 0.95 --min-meanDP 8 --max-meanDP 25"
# --remove-indels --bed $bed
maf="--maf 0.01"
neutral="--hwe 0.05 --thin 1500"

# to include only bi-allelic sites use:--min-alleles 2 --max-alleles 2
#--minQ <float> Includes only sites with Quality value above this threshold.
#--max-missing Exclude sites on the basis of the proportion of missing data 
#(defined to be between 0 and 1
#where 0 allows sites that are completely missing and 1 indicates no missing data allowed).
#min-meanDP Includes only sites with mean depth values (over all included individuals) 
#greater than or equal to the "--min-meanDP" value and less than or equal to the "--max-meanDP" value.
#includes only genotypes greater than or equal to the "--minDP" value 

###

echo "vcftools QCmaf filtering"
time vcftools --bcf $read_dir/$name.rn.bcf --out $outdir/$name.rn.QCmaf \
$QC $maf --recode-INFO-all --recode-bcf

mv $outdir/$name.rn.QCmaf.recode.bcf $outdir/$name.rn.QCmaf.bcf

echo "computing stats"
bcftools stats --depth 1,100,1 $outdir/$name.rn.QCmaf.bcf > $outdir/$name.rn.QCmaf.bcf.stats

echo "create bcf index"
time bcftools index $outdir/$name.rn.QCmaf.bcf

### Convert everything in vcf

echo "convert bcf to vcf and stats"
time bcftools view $outdir/$name.rn.QCmaf.bcf -Ov >  $outdir/$name.rn.QCmaf.vcf

echo "done"



