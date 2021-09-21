#!/bin/bash
#SBATCH --job-name=filter_ns
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --partition=parallel
#SBATCH --time=1-1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/3_count_filter_N/%j_filter_n.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/3_count_filter_N/%j_filter_n.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#### Discard a read pair if more than 10% of bases are uncertain (the Ns) in either one read ###

module load seqkit/0.13.2

read_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/2_filter_trimmed/
dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/3_count_filter_N/
out_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/3_count_filter_N/seqs_filtered/
array=("003_BAR" "004_BM04" "005_BM05" "014_BT02" "018_KA01")

for f in "${array[@]}" ; do 

### Count the proportions of Ns ###

seqkit fx2tab -H -n -i -B n $read_dir/$f*.forward*.fq.gz > $dir/$f.forward.N_percent
echo "which sequences have N > 0%" > $dir/$f.forward.N_percent_0
gawk -F $'\t' '{if($2>0)print$1 " " $2}' $dir/$f.forward.N_percent >> $dir/$f.forward.N_percent_0
echo "which sequences have N > 10%" > $dir/$f.forward.N_percent_10
gawk -F $'\t' '{if($2>10)print$1 " " $2}' $dir/$f.forward.N_percent >> $dir/$f.forward.N_percent_10

seqkit fx2tab -H -n -i -B n $read_dir/$f*.reverse*.fq.gz > $dir/$f.reverse.N_percent
echo "which sequences have N > 0%" > $dir/$f.reverse.N_percent_0
gawk -F $'\t' '{if($2>0)print$1 " " $2}' $dir/$f.reverse.N_percent >> $dir/$f.reverse.N_percent_0
echo "which sequences have N > 10%" > $dir/$f.reverse.N_percent_10
gawk -F $'\t' '{if($2>10)print$1 " " $2}' $dir/$f.reverse.N_percent >> $dir/$f.reverse.N_percent_10

#-H, --header-line            print header line
#-n, --name                   only print names (no sequences and qualities)
#-i, --only-id                print ID instead of full head
#-B, --base-content strings   print base content (in percentage, e.g. 0.67 = 0.67%)

#### filter the fastq files to keep only the ones with less than 10% N
gawk -F'[ ]' '{print$1}' $dir/$f.forward.N_percent_10 > $dir/$f.forward.N_percent_10_labels
tail -n +3 $dir/$f.forward.N_percent_10_labels > $dir/$f.forward.N_percent_10_labels_only
gawk -F'[ ]' '{print$1}' $dir/$f.reverse.N_percent_10 > $dir/$f.reverse.N_percent_10_labels
tail -n +3 $dir/$f.reverse.N_percent_10_labels > $dir/$f.reverse.N_percent_10_labels_only
cat $dir/$f.forward.N_percent_10_labels_only $dir/$f.reverse.N_percent_10_labels_only > $dir/$f.N_percent_10.filter_labels


mkdir -p $out_dir

seqkit grep -v -f $dir/$f.N_percent_10.filter_labels $read_dir/$f*.forward*.fq.gz -o $out_dir/$f.forward.fq.gz
seqkit grep -v -f $dir/$f.N_percent_10.filter_labels $read_dir/$f*.reverse*.fq.gz -o $out_dir/$f.reverse.fq.gz

echo "number of lines in forward"
zcat $out_dir/$f.forward.fq.gz | wc -l
echo "number of lines in reverse"
zcat $out_dir/$f.reverse.fq.gz | wc -l

#-v, --invert-match           invert the sense of matching, to select non-matching records
#-f, --pattern-file string    pattern file (one record per line)

### Count the proportions of Ns again ###

seqkit fx2tab -H -n -i -B n  $out_dir/$f.forward.fq.gz > $out_dir/$f.forward.N_percent
echo "which sequences have N > 0%" > $out_dir/$f.forward.N_percent_0
gawk -F $'\t' '{if($2>0)print$1 " " $2}' $out_dir/$f.forward.N_percent >> $out_dir/$f.forward.N_percent_0
echo "which sequences have N > 10%" > $out_dir/$f.forward.N_percent_10
gawk -F $'\t' '{if($2>10)print$1 " " $2}' $out_dir/$f.forward.N_percent >> $out_dir/$f.forward.N_percent_10


seqkit fx2tab -H -n -i -B n $out_dir/$f.reverse.fq.gz > $out_dir/$f.reverse.N_percent
echo "which sequences have N > 0%" > $out_dir/$f.reverse.N_percent_0
gawk -F $'\t' '{if($2>0)print$1 " " $2}' $out_dir/$f.reverse.N_percent >> $out_dir/$f.reverse.N_percent_0
echo "which sequences have N > 10%" > $out_dir/$f.reverse.N_percent_10
gawk -F $'\t' '{if($2>10)print$1 " " $2}' $out_dir/$f.reverse.N_percent >> $out_dir/$f.reverse.N_percent_10

done

