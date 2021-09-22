#!/bin/bash
#SBATCH -a 1-30
#SBATCH --job-name=Calculate_LD
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=1G
#SBATCH --partition=parallel
#SBATCH --time=30:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/noKTAR/%A_%a_AB_calculate_LD.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/noKTAR/%A_%a_AB_calculate_LD.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

# -a 1-1214

module load vcftools/0.1.16 

scf=${SLURM_ARRAY_TASK_ID}

name=call_set_AGRFlib1_to_6_V2P.rn.QCmaf #change that to smth shorter maybe
dir_noKTAR=/nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/noKTAR/
outdir_noKTAR=$dir_noKTAR/scaffolds/$scf
outdir_LD=$dir_noKTAR/2_b_Calculate_LD/1_results
outdir_LD_subset=$dir_noKTAR/2_b_Calculate_LD/2_subsets
mkdir -p $outdir_LD
mkdir -p $outdir_LD_subset


####Do only once
####cat $outdir/$name.scf1.AB.geno.ld | head -1 > $dir/2_b_Calculate_LD/header

echo "Calculate LD"
vcftools 	--gzvcf $outdir_noKTAR/$name.scf$scf.AB.noKTAR.nofixed.vcf.gz 	\
			--geno-r2 --ld-window-bp 50000 	\
			--out $outdir_LD/$name.scf$scf.AB.noKTAR.nofixed

###Use the shuf function to shuffle data points and extract only the first 1 million

tail -n +2 $outdir_LD/$name.scf$scf.AB.noKTAR.nofixed.geno.ld | shuf -n 1000000 -o $outdir_LD_subset/$name.scf$scf.AB.noKTAR.nofixed.geno.ld.subset1M.tmp
cat $dir_noKTAR/header $outdir_LD_subset/$name.scf$scf.AB.noKTAR.nofixed.geno.ld.subset1M.tmp > $outdir_LD_subset/$name.scf$scf.AB.noKTAR.nofixed.geno.ld.subset1M
rm $outdir_LD_subset/$name.scf$scf.AB.noKTAR.nofixed.geno.ld.subset1M.tmp

###module load R/3.6.0
###module load R/CRAN/3.6
###module load plink/1.90
###module load bcftools/1.9
###module load htslib/1.9 
####htslib for bgzip and tabix


