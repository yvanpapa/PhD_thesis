#!/bin/bash
#SBATCH --job-name=kraken2
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --partition=parallel
#SBATCH --time=1-6:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/3_kraken/%j_kraken_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/3_kraken/%j_kraken_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz


module load kraken/2.0.7-beta
#manual: httpsccb.jhu.edusoftwarekraken2index.shtmlt=manual

DB=/nfs/scratch/papayv/Tarakihi/TARdn/03_Kraken/MiniKraken2_v2_8GB_database
dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/3_kraken/
read_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/5_remove_unpaired_final_fastq/paired/
threads=4

array=("003_BAR" "004_BM04" "005_BM05" "014_BT02" "018_KA01")

for f in "${array[@]}" ; do 

R1=$read_dir/$f.forward.paired.fq.gz
R2=$read_dir/$f.reverse.paired.fq.gz

#echo "Started screening sample $f for vector and contaminants in provided database"
#time kraken2 --db $DB --threads $threads --unclassified-out $f.useqs#.fq --classified-out $f.cseqs#.fq \
#--report $f.kraken_report --paired --use-names --gzip-compressed --fastq-input $R1 $R2
## useless parameter?

echo "compressing cseqs, useqs and job_out"
gzip -c $dir/$f.cseqs*1.fq > $dir/$f.cseqs_1.fq.gz
gzip -c $dir/$f.cseqs*2.fq > $dir/$f.cseqs_2.fq.gz
gzip -c $dir/$f.useqs*1.fq > $dir/$f.useqs_1.fq.gz
gzip -c $dir/$f.useqs*2.fq > $dir/$f.useqs_2.fq.gz


echo "kraken job completed"

done

#gzip -c $dir/*kraken_out > $dir/kraken_out.gz

