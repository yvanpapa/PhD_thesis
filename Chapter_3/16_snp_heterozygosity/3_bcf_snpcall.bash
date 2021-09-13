#!/bin/bash
#SBATCH -a 1-1214
#SBATCH --job-name=bcf_snp
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2G
#SBATCH --partition=parallel
#SBATCH --time=10-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/10_snp_call_heteroz/3_bcf_snpcall/job_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/10_snp_call_heteroz/3_bcf_snpcall/job_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module load bcftools/1.9 

output_dir=/nfs/scratch/papayv/Tarakihi/TARdn/10_snp_call_heteroz/3_bcf_snpcall
REF=/nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P/TARdn_assembly_V2_p_srn.fasta
samples_list=$output_dir/samples_list.txt
output_name=TARdn

#Pour le Yvan du futur: pas oublier pourquoi je refais un variant calling sans les indels et en incluant que les variants cette fois.
#C'est à cause de l'erreur dump bizarre quand j'essaie de filtrer le bcf

time bcftools mpileup -C50 -q10 --incl-flags 2 -f $REF --regions ${SLURM_ARRAY_TASK_ID} \
-b $samples_list -a "AD,DP,SP" -Ou | \
bcftools call -m -Ob -f "GQ,GP" --variants-only --skip-variants indels \
> $output_dir/call_set.$output_name.${SLURM_ARRAY_TASK_ID}.bcf

#mpileup step only: a=1-2696, cpt=1, mpc=2G, samples=27: MaxMem 0.15G. Time=18h
#mpileup + call: a 1-2696, cpt=1, mpc=2G, samples=34: MaxMem 0.15G. Time=7h!


#PARAMETERS:
#-C: The recommended value for BWA is 50. Coefficient for downgrading mapping quality for reads containing excessive mismatches
#-q: Minimum mapping quality for an alignment to be used
#--incl-flags 2 = keep only reads mapped in proper pair
#-b: List of input alignment files, one file per line
#-Ou ouput uncompressed BCF (Ou) or compressed BCD (Ob). Use the -Ou option when piping between bcftools subcommands to speed up performance by removing unnecessary compression and conversions
#-a: annotate. AD* .. Allelic depth. DP* .. Number of high-quality bases. SP* .. Phred-scaled strand bias P-value

#-m: multiallelic-caller
#-Ob: Output compressed BCF (b)
#-f: comma-separated list of FORMAT fields to output for each sample. Currently GQ and GP fields are supported
#--threads Number of output compression threads to use in addition to main thread. Only used when --output-type is b or z. 

##############################################

#/!\ optionnal parameters used by Tom in mpileup: -a 	"AD,DP,SP"	

#This will add the column FORMAT in the VCF, which is sample-level information 
#AD: unfiltered allele depth
#DP: filtered depth, at the sample level
#SP: Phred-scaled strand bias P-value

#PL (the only one included by default): "Normalized" Phred-scaled likelihoods of the possible genotypes

#/!\ optionnal parameters used by Tom in call: -f "GQ,GP"
#-f: comma-separated list of FORMAT fields to output for each sample. Equivalent of -a for call
#GQ : Quality of the assigned genotype
#GP: the phred-scaled genotype posterior probabilities

#Very good reading: https://gatkforums.broadinstitute.org/gatk/discussion/1268/what-is-a-vcf-and-how-should-i-interpret-it