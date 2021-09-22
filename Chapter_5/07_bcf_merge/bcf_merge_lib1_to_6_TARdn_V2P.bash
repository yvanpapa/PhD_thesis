#!/bin/bash
#SBATCH --job-name=bcf_merge
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --partition=parallel
#SBATCH --time=1-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/popgen/12_bcf_merge/lib1_to_6_TARdn_V2P/job_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/popgen/12_bcf_merge/lib1_to_6_TARdn_V2P/job_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

###/!\ DO NOT FORGET: YOU NEED THE FILE_LIST_***.TXT BUT ALSO THE SAMPLE_NAMES_***.TXT IF YOU WANT TO RENAME THE SAMPLES PROPERLY

module load bcftools/1.9 

output_dir=/nfs/scratch/papayv/Tarakihi/popgen/12_bcf_merge/lib1_to_6_TARdn_V2P/
files_list=file_list_lib1_to_6_V2P.txt
sample_names=samples_names_lib1_to_6_V2P.txt
name=call_set_AGRFlib1_to_6_V2P

echo "use bcftools concat to merge all the scaffold bcf files"
time bcftools concat -f  $output_dir/$files_list -Ob > $output_dir/$name.bcf
echo "in bird culture this is considered a dick move"
#cpt=16, mem=256G: 34min, MaxMem=0.22G

#parameters
#-f, --file-list FILE: Read file names from FILE, one file name per line.
#-Ob: output compressed bam file

echo "backing up the bcf file just in case"
mkdir -p $output_dir/backup
time cp $output_dir/$name.bcf $output_dir/backup/$name.bcf
#cpt=16, mem=256G: 0.5min, MaxMem=0.22G

echo "remove path in BAM names"
time bcftools reheader -s $output_dir/$sample_names \
$output_dir/$name.bcf > $output_dir/$name.rn.bcf

echo "compute bcf file stats"
time bcftools stats $output_dir/$name.rn.bcf > \
$output_dir/$name.rn.bcf.stats
#cpt=16, mem=256G: 3min, MaxMem=0.22G

echo "create bcf index"
time bcftools index $output_dir/$name.rn.bcf
#cpt=16, mem=256G: 3min, MaxMem=0.22G

#Also save as vcf
#echo "convert bcf to vcf copy"
#time bcftools view $output_dir/$name.rn.bcf -Ov > $output_dir/$name.rn.vcf

