#!/bin/bash
#SBATCH --job-name=AB_and_neutral_filtering
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=2G
#SBATCH --partition=quicktest
#SBATCH --time=2:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/5_adaptive_datasets/%j_adaptive_filtering.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/5_adaptive_datasets/%j_adaptive_filtering.err
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

qval=0_05
He=0_1
filter=noTAS_WAI_CC_UWCSI_TBGB_HB
indir=/nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/2_lib1_to_6_V2P.allele_imbalance/
name=call_set_AGRFlib1_to_6_V2P.rn.QCmaf.AB
dir=/nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/5_adaptive_datasets/
outdir=$dir/q_${qval}_He_${He}_${filter}/
list_snps=$dir/list_selected_outliers_q_${qval}_He_${He}_${filter}.txt
mkdir -p $outdir


echo "keep adaptive SNPs"
vcftools 	--gzvcf $indir/$name.vcf.gz --out $outdir/$name.adapt_q_${qval}_He_${He}_${filter} 		\
			--positions $list_snps --recode-INFO-all --recode
			
mv $outdir/$name.adapt_q_${qval}_He_${He}_${filter}.recode.vcf $outdir/$name.adapt_q_${qval}_He_${He}_${filter}.vcf
bcftools stats --depth 1,100,1 $outdir/$name.adapt_q_${qval}_He_${He}_${filter}.vcf > $outdir/$name.adapt_q_${qval}_He_${He}_${filter}.stats.txt
bgzip -f -i $outdir/$name.adapt_q_${qval}_He_${He}_${filter}.vcf 


