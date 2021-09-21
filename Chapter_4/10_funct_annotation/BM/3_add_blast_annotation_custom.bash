#!/bin/bash
#SBATCH --job-name=BM_blast_annotation_custom
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --partition=parallel
#SBATCH --time=2:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/11_funct_annotation/BM/3_annotation/blast_functannot_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/11_funct_annotation/BM/3_annotation/blast_functannot_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/11_funct_annotation/BM/3_annotation/
nr_dir=/nfs/scratch/papayv/Tarakihi/TARdn/12_funct_annotation/ncbi_blast/trial3_custom/
nr=/nfs/scratch/papayv/Tarakihi/TARdn/12_funct_annotation/ncbi_blast/nr.fasta
blast_file=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/11_funct_annotation/BM/1_ncbi_blast/BMdn_rnd2.all.maker.proteins_blast_nr.out_total
gff=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/4_rename_outputs/maker_renamed_outputs/BMdn_rnd2.all.maker.noseq.gff
gff2=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/4_rename_outputs/maker_renamed_outputs/BMdn_rnd2.all.maker.gff
prots="/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/4_rename_outputs/maker_renamed_outputs/BMdn_rnd2.all.maker.proteins.fasta"
trscrpts="/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/4_rename_outputs/maker_renamed_outputs/BMdn_rnd2.all.maker.transcripts.fasta"

###Need to do this only once per database!!!####
##First, let's format the NR fasta database to keep only the protein labels without the sequences, and have one protein ID per line:
##take a peek:
#cat $nr | head -500 > $nr_dir/head_nr
##Remove the sequences:
#grep '^[>]' $nr > $nr_dir/nr_list
#cat $nr_dir/nr_list | head -5 > $nr_dir/head_nr_list
##To replace the annoying SOH character by a line break, I found this fix: https://stackoverflow.com/questions/13180057/replacing-control-character-in-sed
##You need to do cat -v to make it readable and transform the SOH in ^A
#cat -v $nr_dir/nr_list | sed 's/\^A/\n/g' > $nr_dir/nr_list2
#cat $nr_dir/nr_list2 | head -500 > $nr_dir/head_nr_list2
##Remove the ">" because not necessary anymore 
#sed 's/>//' $nr_dir/nr_list2 > $nr_dir/nr_list3  #! this will only remove the first occurence of > in each line
#cat $nr_dir/nr_list3 | head -500 > $nr_dir/head_nr_list3
##Add a ";" at the end of each line, necessary for the annotation
#sed 's/$/;/' $nr_dir/nr_list3 > $nr_dir/nr_list_final
#cat $nr_dir/nr_list_final | head -500 > $nr_dir/head_nr_list_final

##Now let's use the blast output file to filter nr_fasta and keep only the blasted proteins
#take a peak
#cat $blast_file | head -500 > $dir/head_blast_file

#####

#extract column two of blast file (the column with the protein IDs)
awk '{print $2}' $blast_file > $dir/list_blasted_proteins

#Filter nr_fasta to keep only the proteins that blasted
##Need A LOT of memory for the grep part because I get "memory exhausted" with grep even with 256G! The awk command works much faster and better
#grep -f $dir/list_blasted_proteins $nr_dir/nr_list_final > $dir/nr_list_final_filtered
awk 'NR==FNR {a[$1]++; next} $1 in a' $dir/list_blasted_proteins $nr_dir/nr_list_final > $dir/nr_list_final_filtered

#Replace spaces by tabs:
sed -r 's/\s+/\t/' $dir/nr_list_final_filtered > $dir/nr_list_final_filtered2

#Now, add the proteins functions to the BLAST output:
cp $blast_file file1
cp $dir/nr_list_final_filtered2 file2

##This works without the protein ID, not necessary:
#awk -F'\t' 'NR==FNR{a[$1]=$2; next}{gsub("-RA","",$1);print $1"\t"a[$2]}' file2 file1 > file3
##stores the second field ($2) in the associative array a, with the index being the value of the first field of the row in file 2
##in gsub, we remove "-RA" from the first column of file 1, and then we print $1 and the second column of file 2 separated by a tab
#mkdir -p $dir/functannot_output
#awk -F'\t' 'NR==FNR{a[$1]=$2; next}{split($9,b,";");gsub("ID=","",b[1]);gsub("-RA","",b[1]);gsub(/;$/,"",$0);if(a[b[1]] != ""){print $0";Note=blastp: "a[b[1]];} else {print $0";"}}' $dir/file3 $gff > $dir/functannot_output/BMdn_rnd2.all.maker.noseq.blastfunc_annotated.gff
#THis works:
#awk -F'\t' 'NR==FNR{a[$1]=$2; next}{split($9,b,";");gsub("ID=","",b[1]);gsub("-RA","",b[1]);gsub(/;$/,"",$0);if(a[b[1]] != ""){print $0";Note=blastp: "a[b[1]];} else {print $0";"}}' $dir/file3 $gff2 > $dir/functannot_output/BMdn_rnd2.all.maker.blastfunc_annotated.gff

#Let's try to make it better by adding the BLAST ID-> that works!
awk -F'\t' 'NR==FNR{a[$1]=$0; next}{gsub("-RA","",$1);print $1"\t"a[$2]}' $dir/file2 $dir/file1 > $dir/file3.1
sed 's/\t/, /2' $dir/file3.1 > $dir/file3.2
mkdir -p $dir/functannot_output_protID
awk -F'\t' 'NR==FNR{a[$1]=$2; next}{split($9,b,";");gsub("ID=","",b[1]);gsub("-RA","",b[1]);gsub(/;$/,"",$0);if(a[b[1]] != ""){print $0";Note=blastp:"a[b[1]];} else {print $0";"}}' $dir/file3.2 $gff > $dir/functannot_output_protID/BMdn_rnd2.all.maker.noseq.blastfunc_annotated.gff

awk -F'\t' 'NR==FNR{a[$1]=$2; next}{split($9,b,";");gsub("ID=","",b[1]);gsub("-RA","",b[1]);gsub(/;$/,"",$0);if(a[b[1]] != ""){print $0";Note=blastp:"a[b[1]];} else {print $0";"}}' $dir/file3.2 $gff2 > $dir/functannot_output_protID/BMdn_rnd2.all.maker.blastfunc_annotated.gff

#Do the same with prots and transcripts
#This works:
awk -F'\t' 'NR==FNR{a[$1]=$2; next}{if($0 ~ /^>/){split($1,v," ");gsub(">","",v[1]);gsub("-RA","",v[1]);print $0" Note=blastp: "a[v[1]]}else{print $0}}' $dir/file3.2 $prots \
> $dir/functannot_output_protID/BMdn_rnd2.all.maker.proteins.blastfunc_annotated.fasta
##Remove ;
sed -i 's/;//' $dir/functannot_output_protID/BMdn_rnd2.all.maker.proteins.blastfunc_annotated.fasta

awk -F'\t' 'NR==FNR{a[$1]=$2; next}{if($0 ~ /^>/){split($1,v," ");gsub(">","",v[1]);gsub("-RA","",v[1]);print $0" Note=blastp: "a[v[1]]}else{print $0}}' $dir/file3.2 $trscrpts \
> $dir/functannot_output_protID/BMdn_rnd2.all.maker.transcripts.blastfunc_annotated.fasta
##Remove ;
sed -i 's/;//' $dir/functannot_output_protID/BMdn_rnd2.all.maker.transcripts.blastfunc_annotated.fasta




