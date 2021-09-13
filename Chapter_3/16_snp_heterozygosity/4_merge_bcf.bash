#!/bin/bash
#SBATCH --job-name=bcf_merge
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --partition=parallel
#SBATCH --time=8-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/10_snp_call_heteroz/4_merge_bcf/job_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/10_snp_call_heteroz/4_merge_bcf/job_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

###/!\ DO NOT FORGET: YOU NEED THE FILE_LIST_***.TXT BUT ALSO THE SAMPLE_NAMES_***.TXT IF YOU WANT TO RENAME THE SAMPLES PROPERLY

module load bcftools/1.9 

output_dir=/nfs/scratch/papayv/Tarakihi/TARdn/10_snp_call_heteroz/4_merge_bcf/

echo "use bcftools concat to merge all the scaffold bcf files"
time bcftools concat -f  $output_dir/file_list.txt -Ob > $output_dir/call_set_TARdn.bcf
echo "in bird culture this is considered a dick move"
#cpt=16, mem=256G: 34min, MaxMem=0.22G

#parameters
#-f, --file-list FILE: Read file names from FILE, one file name per line.
#-Ob: output compressed bam file

echo "backing up the bcf file just in case"
mkdir -p $output_dir/backup
time cp $output_dir/call_set_TARdn.bcf $output_dir/backup/call_set_TARdn.bcf
#cpt=16, mem=256G: 0.5min, MaxMem=0.22G

echo "remove path in BAM names"
time bcftools reheader -s $output_dir/samples_names.txt \
$output_dir/call_set_TARdn.bcf > $output_dir/call_set_TARdn.rn.bcf

####Should I do this? Let's do a test and then maybe add to the pipeline?
###bcftools norm -f $REF $output_dir/call_set_AGRFlib1_to_4_noK.bcf > \
###$output_dir/call_set_AGRFlib1_to_4_noK.normed.bcf

echo "compute bcf file stats"
time bcftools stats $output_dir/call_set_TARdn.rn.bcf > \
$output_dir/call_set_TARdn.rn.bcf.stats
#cpt=16, mem=256G: 3min, MaxMem=0.22G

echo "create bcf index"
time bcftools index $output_dir/call_set_TARdn.rn.bcf
echo "on s'est couché encore plus tard"
#cpt=16, mem=256G: 3min, MaxMem=0.22G

#Also save as vcf
echo "convert bcf to vcf copy"
time bcftools view $output_dir/call_set_TARdn.rn.bcf -Ov > $output_dir/call_set_TARdn.rn.vcf
#echo "doodle-i-done"

