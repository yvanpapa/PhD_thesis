#!/bin/bash
#SBATCH -a 1-1214
#SBATCH --job-name=filter_KTAR_out
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=2G
#SBATCH --partition=parallel
#SBATCH --time=3:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/noKTAR/%A_%a_filter_KTAR_out.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/noKTAR/%A_%a_AB_filter_KTAR_out.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

# -a 1-1214

module load vcftools/0.1.16 
module load bcftools/1.9
module load htslib/1.9 


scf=${SLURM_ARRAY_TASK_ID}
dir=/nfs/scratch/papayv/Tarakihi/popgen/13_filters/lib1_to_6_V2P/filter3/
outdir_AB=$dir/2_lib1_to_6_V2P.allele_imbalance/scaffolds/$scf/
dir_noKTAR=$dir/noKTAR/
outdir_noKTAR=$dir_noKTAR/scaffolds/$scf
mkdir -p $outdir_noKTAR
name=call_set_AGRFlib1_to_6_V2P.rn.QCmaf #change that to smth shorter maybe

echo "filter KTAR out of QCAB dataset"
vcftools 	--gzvcf $outdir_AB/$name.scf$scf.AB.vcf.gz --out $outdir_noKTAR/$name.scf$scf.AB.noKTAR \
			--remove $dir_noKTAR/KTAR_list.txt --recode-INFO-all --recode
			mv $outdir_noKTAR/$name.scf$scf.AB.noKTAR.recode.vcf $outdir_noKTAR/$name.scf$scf.AB.noKTAR.vcf
bcftools stats --depth 1,100,1 $outdir_noKTAR/$name.scf$scf.AB.noKTAR.vcf > $outdir_noKTAR/$name.scf$scf.AB.noKTAR.stats.txt

echo "remove monomorphic sites"
#remove every line that does contain 0/0 but does not contain 1/1, 1/0 or 0/1 
sed -e '/0\/0/{/1\/1\|1\/0\|0\/1/!d;}' $outdir_noKTAR/$name.scf$scf.AB.noKTAR.vcf > $outdir_noKTAR/$name.scf$scf.AB.noKTAR.nofixed.vcf
#remove every line that does contain 1/1 but does not contain 0/0, 1/0 or 0/1
sed -i -e '/1\/1/{/0\/0\|1\/0\|0\/1/!d;}' $outdir_noKTAR/$name.scf$scf.AB.noKTAR.nofixed.vcf
bcftools stats --depth 1,100,1 $outdir_noKTAR/$name.scf$scf.AB.noKTAR.nofixed.vcf > $outdir_noKTAR/$name.scf$scf.AB.noKTAR.nofixed.stats.txt

bgzip -f -i $outdir_noKTAR/$name.scf$scf.AB.noKTAR.vcf
bgzip -f -i $outdir_noKTAR/$name.scf$scf.AB.noKTAR.nofixed.vcf

