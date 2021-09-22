#!/bin/bash
#SBATCH --job-name=Calculate_stats
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=2G
#SBATCH --partition=parallel
#SBATCH --time=6-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/%j_AB_calculate_stats.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/%j_AB_calculate_stats.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

# -a 1-1214

module load vcftools/0.1.16

dir=/nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/
name=call_set_AGRFlib1_to_6_V2P.rn.QCmaf #change that to smth shorter maybe
dir_AB=$dir/2_lib1_to_6_V2P.allele_imbalance/$scf/
outdir_AB=$dir_AB/stats
mkdir -p $outdir_AB
dir_neutral=$dir/4_lib1_to_6_V2P.neutral/
outdir_neutral=$dir_neutral/stats
mkdir -p $outdir_neutral

#Need to do the output functions one by one apparently, or "Error: Only one output function may be called."
echo "Calculate stats QC dataset"
vcftools 	--gzvcf $dir_AB/$name.AB.vcf.gz \
			--het   \
			--out $outdir_AB/$name.AB
			
vcftools 	--gzvcf $dir_AB/$name.AB.vcf.gz \
			--depth \
			--out $outdir_AB/$name.AB
			
vcftools 	--gzvcf $dir_AB/$name.AB.vcf.gz \
			--site-depth \
			--out $outdir_AB/$name.AB
			
vcftools 	--gzvcf $dir_AB/$name.AB.vcf.gz \
			--site-mean-depth \
			--out $outdir_AB/$name.AB
			
vcftools 	--gzvcf $dir_AB/$name.AB.vcf.gz \
			--missing-indv \
			--out $outdir_AB/$name.AB
			
vcftools 	--gzvcf $dir_AB/$name.AB.vcf.gz \
			--singletons \
			--out $outdir_AB/$name.AB
			
echo "Calculate stats 242 scf neutral dataset (+KTAR and small pops. Those should be removed bc not true neutral)"			
vcftools 	--gzvcf $dir_neutral/$name.AB.neutral.hwe_thin.pruned.242.vcf.gz \
			--het   \
			--out $outdir_neutral/$name.AB.neutral.hwe_thin.pruned.242
			
vcftools 	--gzvcf $dir_neutral/$name.AB.neutral.hwe_thin.pruned.242.vcf.gz \
			--depth \
			--out $outdir_neutral/$name.AB.neutral.hwe_thin.pruned.242
			
vcftools 	--gzvcf $dir_neutral/$name.AB.neutral.hwe_thin.pruned.242.vcf.gz \
			--site-depth \
			--out $outdir_neutral/$name.AB.neutral.hwe_thin.pruned.242
			
vcftools 	--gzvcf $dir_neutral/$name.AB.neutral.hwe_thin.pruned.242.vcf.gz \
			--site-mean-depth \
			--out $outdir_neutral/$name.AB.neutral.hwe_thin.pruned.242
			
vcftools 	--gzvcf $dir_neutral/$name.AB.neutral.hwe_thin.pruned.242.vcf.gz \
			--missing-indv \
			--out $outdir_neutral/$name.AB.neutral.hwe_thin.pruned.242
			
vcftools 	--gzvcf $dir_neutral/$name.AB.neutral.hwe_thin.pruned.242.vcf.gz \
			--singletons \
			--out $outdir_neutral/$name.AB.neutral.hwe_thin.pruned.242

#het Calculates a measure of heterozygosity on a per-individual basis. 
#Specfically, the inbreeding coefficient, F, is estimated for each individual using a method of moments.
#--depth Generates a file containing the mean depth per individual.
#--site-depth Generates a file containing the depth per site summed across all individuals. 
#--site-mean-depth Generates a file containing the mean depth per site averaged across all individuals
#--missing-indv Generates a file reporting the missingness on a per-individual basis. 
#This option will generate a file detailing the location of singletons, and the individual they occur in.
#The file reports both true singletons, and private doubletons (i.e. SNPs where the minor allele only occurs in a single individual 
#and that individual is homozygotic for that allele)
