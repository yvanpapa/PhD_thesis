#!/bin/bash
#SBATCH -a 1-30
#SBATCH --job-name=Calculate_LD
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=1G
#SBATCH --partition=parallel
#SBATCH --time=30:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/%A_%a_AB_calculate_LD.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/%A_%a_AB_calculate_LD.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

# -a 1-1214

module load vcftools/0.1.16 

scf=${SLURM_ARRAY_TASK_ID}
dir=/nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/
dir_AB=$dir/2_lib1_to_6_V2P.allele_imbalance/scaffolds/$scf/
name=call_set_AGRFlib1_to_6_V2P.rn.QCmaf #change that to smth shorter maybe
outdir=$dir/2_b_Calculate_LD/1_results
outdir_subset=$dir/2_b_Calculate_LD/2_subsets

mkdir -p $outdir
mkdir -p $outdir_subset

#Do only once
cat $outdir/$name.scf1.AB.geno.ld | head -1 > $dir/2_b_Calculate_LD/header

echo "Calculate LD"
vcftools 	--gzvcf $dir_AB/$name.scf$scf.AB.vcf.gz 	\
			--geno-r2 --ld-window-bp 50000 	\
			--out $outdir/$name.scf$scf.AB

Use the shuf function to shuffle data points and extract only the first 1 million

tail -n +2 $outdir/$name.scf$scf.AB.geno.ld | shuf -n 1000000 -o $outdir_subset/$name.scf$scf.AB.geno.ld.subset1M.tmp
cat $dir/2_b_Calculate_LD/header $outdir_subset/$name.scf$scf.AB.geno.ld.subset1M.tmp > $outdir_subset/$name.scf$scf.AB.geno.ld.subset1M
rm $outdir_subset/$name.scf$scf.AB.geno.ld.subset1M.tmp


