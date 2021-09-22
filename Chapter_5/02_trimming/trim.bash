#!/bin/bash
#SBATCH --job-name=trim
#SBATCH --cpus-per-task=24
#SBATCH --mem-per-cpu=6G
#SBATCH --partition=bigmem
#SBATCH --time=8-1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/popgen/03_trimming/lib6/job_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/popgen/03_trimming/lib6/job_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#TO RUN: change only the lib ID and the sample numbers array
module load trimmomatic/20190304
#wesley@raapoi-master:~$ module show trimmomatic
#----------------------------------------------
#/home/software/vuwrc/modulefiles/trimmomatic/20190304:
#----------------------------------------------
#load("java/jdk/1.8.0_121")
#setenv("TM_HOME","/home/software/apps/trimmomatic/20190304/bin")
#wesley@raapoi-master:~$ java -jar $TM_HOME/trimmomatic.jar

read_dir=/nfs/scratch/papayv/Tarakihi/raw_data/popgen/lib6

output_dir=/nfs/scratch/papayv/Tarakihi/popgen/03_trimming/lib6/results
mkdir -p $output_dir

#create an array of all unique sample numbers !must change everytime depending on samples input! 
array=("022_HB17022" "1608_GB19_004" "1623_GB19_019" "1624_GB19_020" "1652_TBGB_060" "1700_TBGB_108" "1775_WCSI_101" "1777_WCSI_103" "1779_WCSI_105" "1809_UWCNI_075" "1810_UWCNI_076" "1840_EC_069" "1875_TARA_001" "1877_TARA_003" "1898_AU_004" "1914_AU_020" "1915_AU_021" "1917_AU_023" "1925_CHCH_056" "1926_CHCH_057" "1927_CHCH_058" "1929_CHCH_060" "1930_CHCH_061" "1931_CHCH_062" "1932_CHCH_063" "1933_CHCH_064" "1934_CHCH_065" "1935_CHCH_066" "1936_CHCH_067" "1937_CHCH_068" "1938_CHCH_069" "1939_CHCH_070" "1941_CHCH_072" "1942_CHCH_073" "1965_WGTN20_001" "1967_WGTN20_003" "1969_WGTN20_005" "1970_WGTN20_006" "1973_WGTN20_009" "1977_WGTN20_013" "1978_WGTN20_014" "1979_WGTN20_015" "1982_WGTN20_018" "1983_WGTN20_019" "1984_WGTN20_020" "1985_WGTN20_0021" "1986_WGTN20_022" "318_KTAR018" "330_KTAR030_2x" "335_KTAR035" "339_KTAR039_2x" "395_CHAT055" "WEL19_004_BM04_3x" "WEL19_005_BM05_3x" "WEL19_014_BT02_3x" "WEL19_018_KA01_3x" "WEL20_001_TAR01_1_2x" "WEL20_001_TAR01_2_2x" "WEL20_003_BAR_2_3x" "WEL20_004_BC_2_3x" "WEL20_005_MAC_1_3x")

for f in "${array[@]}" ; do 
echo "Trimming sample $f"
  time java -jar $TM_HOME/trimmomatic.jar PE \
  -threads 12 -phred33 $read_dir/$f*R1.fastq.gz $read_dir/$f*R2.fastq.gz \
  $f.forward_paired.fq.gz $f.forward_unpaired.fq.gz \
  $f.reverse_paired.fq.gz $f.reverse_unpaired.fq.gz \
  ILLUMINACLIP:/nfs/scratch/papayv/Tarakihi/popgen/03_trimming/NexteraPE-PE.fa:2:30:10
  mv $f* $output_dir
  echo "sample $f trimmed"
#HEADCROP:10 
done

#cpt=24, mem=62G, threads=12: 36 min for one sample. MaxMem=21.37G
#cpt=24, mpc=6G, threads=12: ~30min / sample. MaxMem=37.39G
