#!/bin/bash
#SBATCH --job-name=filter_ns
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --partition=parallel
#SBATCH --time=1-1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/09_filter_repeats/%j_filter_n.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/09_filter_repeats/%j_filter_n.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#### Discard a read pair if more than 10% of bases are uncertain (the Ns) in either one read ###

module load seqkit/0.13.2

hardmasked=/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/08_Repeatmasker/TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P.hardmasked.fasta
softmasked=/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/08_Repeatmasker/TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P.softmasked.fasta
name=TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P.hardmasked
name_soft=TARdn2_isoseq_all_tissues_clustered_hq_aligned_to_TARdn_V2P.softmasked
dir=/nfs/scratch/papayv/Tarakihi/TARdn2/Isoseq/01_clustering_pipeline/09_filter_repeats/

### Count the proportions of Ns ###

seqkit fx2tab -H -n -i -B n $hardmasked > $dir/$name.N_percent

##-H, --header-line            print header line
##-n, --name                   only print names (no sequences and qualities)
##-i, --only-id                print ID instead of full head
##-B, --base-content strings   print base content (in percentage, e.g. 0.67 = 0.67%)

#
echo "which sequences have N > 20%" > $dir/$name.N_percent_20
gawk -F $'\t' '{if($2>=20)print$1 " " $2}' $dir/$name.N_percent >> $dir/$name.N_percent_20
echo "which sequences have N > 70%" > $dir/$name.N_percent_70
gawk -F $'\t' '{if($2>=70)print$1 " " $2}' $dir/$name.N_percent >> $dir/$name.N_percent_70


## filter the fastq files to keep only the ones with less than 70% N
gawk -F'[ ]' '{print$1}'  $dir/$name.N_percent_70 >  $dir/$name.N_percent_70_labels
tail -n +3  $dir/$name.N_percent_70_labels >  $dir/$name.N_percent_70.filter_labels #labels only

cp $softmasked $dir/$name_soft.fasta

sed -i 's/trpt/TRPT/g' $dir/$name_soft.fasta
#-i[SUFFIX], --in-place[=SUFFIX]   edit files in place (makes backup if SUFFIX supplied)

seqkit grep -v -f $dir/$name.N_percent_70.filter_labels $dir/$name_soft.fasta -o $dir/$name_soft.repfiltered.fasta
seqkit grep -f $dir/$name.N_percent_70.filter_labels $dir/$name_soft.fasta -o $dir/$name_soft.reponly.fasta
#-v, --invert-match           invert the sense of matching, to select non-matching records
#-f, --pattern-file string    pattern file (one record per line)

echo "how many reads originaly"
grep -o '>' $dir/$name_soft.fasta | wc -l
echo "how many reads filtered out"
grep -o '>' $dir/$name_soft.reponly.fasta | wc -l
echo "how many reads have been kept"
grep -o '>' $dir/$name_soft.repfiltered.fasta | wc -l

