#!/bin/bash
#SBATCH --job-name=quality_filter
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --partition=parallel
#SBATCH --time=2-1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/4_quality_filter/%j_qual.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/4_quality_filter/%j_qual.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#### Discard a read pair if the proportion of low-quality bases (Quality Value =19) is over 50% in either one read. ###

#!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHI
#|    |    |    |    |    |    |    |    |
#0....5...10...15...20...25...30...35...40
#|    |    |    |    |    |    |    |    |
#worst................................best

module load seqkit/0.13.2
read_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/3_count_filter_N/seqs_filtered/
dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/4_quality_filter/
out_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/2_filter/4_quality_filter/seqs_filtered_adpt_N_qual/
array=("003_BAR" "004_BM04" "005_BM05" "014_BT02" "018_KA01")

for f in "${array[@]}" ; do 

### 1) extract all the quality lines only by extracting every 4th line and get all the unique characters
zcat $read_dir/$f*.forward*.fq.gz | awk 'NR % 4 == 0' > $dir/$f.forward.quals
zcat $read_dir/$f*.reverse*.fq.gz | awk 'NR % 4 == 0' > $dir/$f.reverse.quals
## = 2
#, = 11
#: = 25
#F = 37

## 2) count all the unique characters for quality in this file
sed -e "s/./\0\n/g" $dir/$f.forward.quals | sort -u > $dir/$f.forward.all_quals_characters
sed -e "s/./\0\n/g" $dir/$f.reverse.quals | sort -u > $dir/$f.reverse.all_quals_characters

# 3) once this is done look for the low quality characters (<19) and count them in each line
echo "count_lowqual line" > $dir/$f.forward.count_lowqual_per_line
echo "count_lowqual line" > $dir/$f.reverse.count_lowqual_per_line

grep -n -o ",\|#" $dir/$f.forward.quals | sort -n | cut -d : -f 1 | uniq -c | cut -d : -f 1  >> $dir/$f.forward.count_lowqual_per_line
grep -n -o ",\|#" $dir/$f.reverse.quals | sort -n | cut -d : -f 1 | uniq -c | cut -d : -f 1  >> $dir/$f.reverse.count_lowqual_per_line

echo "CAREFUL!!! LINES NUMBER DONT CORRESPOND BETWEEN FORWARD AND REVERSED BECAUSE SOME READS ARE UNPAIRED (this is bc I didnt think about it during the size filtering phase)"
cat $dir/$f.forward.quals | wc -l
cat $dir/$f.reverse.quals | wc -l
cat $dir/$f.forward.count_lowqual_per_line | wc -l
cat $dir/$f.reverse.count_lowqual_per_line | wc -l

##Once we have these numbers:

gawk -F ' ' '{if($1>75)print$1 " " $2}' $dir/$f.forward.count_lowqual_per_line > $dir/$f.forward.count_lowqual_per_line_75
gawk -F ' ' '{if($1>75)print$1 " " $2}' $dir/$f.reverse.count_lowqual_per_line > $dir/$f.reverse.count_lowqual_per_line_75
cat $dir/$f.forward.count_lowqual_per_line_75 | wc -l
cat $dir/$f.reverse.count_lowqual_per_line_75 | wc -l

#get the list of seq IDs that correspond to these numbers
# 1) extract all the label lines and check it is the right number of lines

seqkit fx2tab -H -n -i $read_dir/$f*.forward*.fq.gz > $dir/$f.forward_labels
seqkit fx2tab -H -n -i $read_dir/$f*.reverse*.fq.gz > $dir/$f.reverse_labels
cat $dir/$f.forward_labels | wc -l
cat $dir/$f.reverse_labels | wc -l

#remove header in labels to have corresponding lines
tail -n +2 $dir/$f.forward_labels > $dir/$f.forward_labels_nohead
tail -n +2 $dir/$f.reverse_labels > $dir/$f.reverse_labels_nohead
cat $dir/$f.forward_labels_nohead | wc -l
cat $dir/$f.reverse_labels_nohead | wc -l

#obtain a list of line numbers ONLY
gawk -F ' ' '{print$2}' $dir/$f.forward.count_lowqual_per_line_75 | tail -n +2 > $dir/$f.forward.count_lowqual_per_line_75_lineonly
gawk -F ' ' '{print$2}' $dir/$f.reverse.count_lowqual_per_line_75 | tail -n +2 > $dir/$f.reverse.count_lowqual_per_line_75_lineonly

# get only the required labels that correspond to the line number
awk 'NR==FNR{linesToPrint[$0];next} 
	FNR in linesToPrint' $dir/$f.forward.count_lowqual_per_line_75_lineonly $dir/$f.forward_labels_nohead > $dir/$f.forward_labelstofilter
awk 'NR==FNR{linesToPrint[$0];next} 
	FNR in linesToPrint' $dir/$f.reverse.count_lowqual_per_line_75_lineonly $dir/$f.reverse_labels_nohead > $dir/$f.reverse_labelstofilter
	
cat $dir/$f.forward_labelstofilter | wc -l
cat $dir/$f.reverse_labelstofilter | wc -l

#Finally, filter fastq files by quality


mkdir -p $out_dir

seqkit grep -v -f $dir/$f.forward_labelstofilter $read_dir/$f*.forward*.fq.gz -o $out_dir/$f.forward.fq.gz
seqkit grep -v -f $dir/$f.reverse_labelstofilter $read_dir/$f*.reverse*.fq.gz -o $out_dir/$f.reverse.fq.gz

# Check for low quality >75 again, just to be sure
zcat $out_dir/$f*.forward*.fq.gz | awk 'NR % 4 == 0' > $out_dir/$f.forward.quals
zcat $out_dir/$f*.reverse*.fq.gz | awk 'NR % 4 == 0' > $out_dir/$f.reverse.quals
echo "count_lowqual line" > $out_dir/$f.forward.count_lowqual_per_line
echo "count_lowqual line" > $out_dir/$f.reverse.count_lowqual_per_line
grep -n -o ",\|#" $out_dir/$f.forward.quals | sort -n | cut -d : -f 1 | uniq -c | cut -d : -f 1  >> $out_dir/$f.forward.count_lowqual_per_line
grep -n -o ",\|#" $out_dir/$f.reverse.quals | sort -n | cut -d : -f 1 | uniq -c | cut -d : -f 1  >> $out_dir/$f.reverse.count_lowqual_per_line
gawk -F ' ' '{if($1>75)print$1 " " $2}' $out_dir/$f.forward.count_lowqual_per_line > $out_dir/$f.forward.count_lowqual_per_line_75
gawk -F ' ' '{if($1>75)print$1 " " $2}' $out_dir/$f.reverse.count_lowqual_per_line > $out_dir/$f.reverse.count_lowqual_per_line_75
cat $out_dir/$f.forward.count_lowqual_per_line_75 | wc -l
cat $out_dir/$f.reverse.count_lowqual_per_line_75 | wc -l

done





