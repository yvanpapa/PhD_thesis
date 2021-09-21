#!/bin/bash
#SBATCH --job-name=trim_fastqc
#SBATCH --cpus-per-task=12
#SBATCH --mem=24G
#SBATCH --partition=parallel
#SBATCH --time=3-1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/1_trim_fastqc/%j_.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/1_trim_fastqc/%j_.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

##TO RUN: change only the lib ID and the sample numbers array
module load trimmomatic/20190304
##wesley@raapoi-master:~$ module show trimmomatic
##----------------------------------------------
##/home/software/vuwrc/modulefiles/trimmomatic/20190304:
##----------------------------------------------
##load("java/jdk/1.8.0_121")
##setenv("TM_HOME","/home/software/apps/trimmomatic/20190304/bin")
##wesley@raapoi-master:~$ java -jar $TM_HOME/trimmomatic.jar

read_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/0_merge/
output_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/1_trim_fastqc/

#create an array of all unique sample numbers !must change everytime depending on samples input! 
array=("003_BAR" "004_BM04" "005_BM05" "014_BT02" "018_KA01")

for f in "${array[@]}" ; do 
echo "Trimming sample $f"
  time java -jar $TM_HOME/trimmomatic.jar PE \
  -threads 12 -phred33 $read_dir/$f*R1.fastq.gz $read_dir/$f*R2.fastq.gz \
  $f.forward_paired.fq.gz $f.forward_unpaired.fq.gz \
  $f.reverse_paired.fq.gz $f.reverse_unpaired.fq.gz \
  ILLUMINACLIP:/nfs/scratch/papayv/Tarakihi/popgen/03_trimming/NexteraPE-PE.fa:2:30:10
  echo "sample $f trimmed"
#HEADCROP:10 
done

echo "fastqc"
module load fastqc/0.11.7
echo "Calculating quality metrics for samples in $read_dir"
  for f in $output_dir/*_paired.fq.gz ; do
    time fastqc $f -t 12 --noextract -o $output_dir/
    echo "Done"
  done

