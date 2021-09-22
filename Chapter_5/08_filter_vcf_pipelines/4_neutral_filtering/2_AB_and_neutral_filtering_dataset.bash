#!/bin/bash
#SBATCH -a 1001-1214
#SBATCH --job-name=AB_and_neutral_filtering
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=2G
#SBATCH --partition=parallel
#SBATCH --time=2:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/4_lib1_to_6_V2P.neutral/jobs_reports/%A_%a_AB_and_neutral_filtering.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/4_lib1_to_6_V2P.neutral/jobs_reports/%A_%a_AB_and_neutral_filtering.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

# -a 1-1214

module load vcftools/0.1.16 
module load R/3.6.0
module load R/CRAN/3.6
module load plink/1.90
module load bcftools/1.9
module load htslib/1.9 
#htslib for bgzip and tabix

scf=${SLURM_ARRAY_TASK_ID}
name=call_set_AGRFlib1_to_6_V2P.rn.QCmaf #change that to smth shorter maybe
dir=/nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/
vcf_QCmaf=/nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/1_lib1_to_6_V2P.QCmaf/call_set_AGRFlib1_to_6_V2P.rn.QCmaf.vcf
QCmaf_scf_dir=/nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/1_lib1_to_6_V2P.QCmaf/scaffolds/$scf
outdir_AB=$dir/2_lib1_to_6_V2P.allele_imbalance/scaffolds/$scf/
R_script=/nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/allelelic_imbalance_2.0.R
outdir_pruned=$dir/3_lib1_to_6_V2P.pruned/scaffolds/$scf/
outdir_neutral=$dir/4_lib1_to_6_V2P.neutral/scaffolds/$scf/
mkdir -p $QCmaf_scf_dir
mkdir -p $outdir_AB
mkdir -p $outdir_pruned
mkdir -p $outdir_neutral

echo "split QCmaf into scaffolds"
vcftools 	--vcf $vcf_QCmaf --out $QCmaf_scf_dir/$name.scf$scf		\
			--recode-INFO-all --recode \
			--chr $scf
mv $QCmaf_scf_dir/$name.scf$scf.recode.vcf $QCmaf_scf_dir/$name.scf$scf.vcf

bcftools stats --depth 1,100,1 $QCmaf_scf_dir/$name.scf$scf.vcf > $QCmaf_scf_dir/$name.scf$scf.stats.txt

## allelic imbalance  ##
echo "Select output from VCF (genotypes)"
vcftools 	--vcf $QCmaf_scf_dir/$name.scf$scf.vcf 	\
			--extract-FORMAT-info GT 	\
			--out $outdir_AB/$name.scf$scf 
echo "Select output from VCF (allelic depth)"
vcftools 	--vcf $QCmaf_scf_dir/$name.scf$scf.vcf 	\
			--extract-FORMAT-info AD 	\
			--out $outdir_AB/$name.scf$scf

echo "run binomial test to filter sites with allelic imbalance"
Rscript 	$R_script $outdir_AB/$name.scf$scf.GT.FORMAT $outdir_AB/$name.scf$scf.AD.FORMAT $outdir_AB/$name.scf$scf.AB
rm $outdir_AB/$name.scf$scf.GT.FORMAT
rm $outdir_AB/$name.scf$scf.AD.FORMAT
awk '$6<=0.05 {print}' $outdir_AB/$name.scf$scf.AB.tsv | cut -f 1,2 > $outdir_AB/$name.scf$scf.AB_exclude.list
rm $outdir_AB/$name.scf$scf.AB.tsv

echo "filter sites for allelic imbalance - AB"
vcftools 	--vcf $QCmaf_scf_dir/$name.scf$scf.vcf --out $outdir_AB/$name.scf$scf.AB \
			--exclude-positions $outdir_AB/$name.scf$scf.AB_exclude.list \
			--recode-INFO-all --recode
mv $outdir_AB/$name.scf$scf.AB.recode.vcf $outdir_AB/$name.scf$scf.AB.vcf
bcftools stats --depth 1,100,1 $outdir_AB/$name.scf$scf.AB.vcf > $outdir_AB/$name.scf$scf.AB.stats.txt
bgzip -f -i $outdir_AB/$name.scf$scf.AB.vcf 
#-f 	overwrite files without asking
tabix -p vcf $outdir_AB/$name.scf$scf.AB.vcf.gz

##remove potentially adaptive outliers detected by outflank 
echo "remove potentially adaptive outliers detected by outflank"
vcftools 	--gzvcf $outdir_AB/$name.scf$scf.AB.vcf.gz --out $outdir_neutral/$name.scf$scf.AB.neutral \
			--exclude-positions $dir/4_lib1_to_6_V2P.neutral/1_list_outliers.txt \
			--recode-INFO-all --recodeLD
mv $outdir_neutral/$name.scf$scf.AB.neutral.recode.vcf $outdir_neutral/$name.scf$scf.AB.neutral.vcf
bcftools stats --depth 1,100,1 $outdir_neutral/$name.scf$scf.AB.neutral.vcf > $outdir_neutral/$name.scf$scf.AB.neutral.stats.txt
bgzip -f -i $outdir_neutral/$name.scf$scf.AB.neutral.vcf
tabix -p vcf $outdir_neutral/$name.scf$scf.AB.neutral.vcf.gz


#HWE + pruning

echo "trim 1500 bp and filter for HWE"
echo "convert to tmp HWE filtered"
vcftools 	--gzvcf $outdir_neutral/$name.scf$scf.AB.neutral.vcf.gz --out $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin \
			--hwe 0.05 --maf 0.01 --thin 1500  --recode-INFO-all --recode
mv $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin.recode.vcf $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin.vcf
bcftools stats --depth 1,100,1 $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin.vcf > $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin.stats.txt
bgzip -f -i $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin.vcf

echo "convert vcf to tped file"
vcftools 	--gzvcf $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin.vcf.gz --out $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin --plink-tped
#sed -i 's/^0\tLG\([0-9]*\)/\1\t\1/g' $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin.tped 

echo "prune file for pairwise Linkage Desequilibrium"
plink 	--tped $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin.tped --tfam $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin.tfam 				\
		--indep-pairwise 50 5 0.2 --out $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin --allow-extra-chr #--chr-set 24 no-xy no-mt
sed 's/^\([0-9]*\):/\1\t/g' $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin.prune.in > $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin.prune.in.list

echo "fitler retained SNPs"
vcftools 	--gzvcf $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin.vcf.gz --out $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin.pruned 		\
			--positions $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin.prune.in.list --recode-INFO-all --recode
			
mv $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin.pruned.recode.vcf $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin.pruned.vcf
bcftools stats --depth 1,100,1 $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin.pruned.vcf > $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin.pruned.stats.txt
bgzip -f -i $outdir_neutral/$name.scf$scf.AB.neutral.hwe_thin.pruned.vcf 

