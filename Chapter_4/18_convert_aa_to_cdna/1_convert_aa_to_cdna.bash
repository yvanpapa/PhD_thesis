#!/bin/bash
#SBATCH --job-name=convert$pep_alndir_dna
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --partition=parallel
#SBATCH --time=2-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/CDS/convert_dna_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/CDS/convert_dna_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#We need to get the right CDS sequences in the right order that correspond to the aligned pep files. However Orthofinder keep only the gene names
#of each sequence after finding the primary reads. We have to do a few steps to be able to retrieve the TRSCRPT name of each corresponding AA first.
module load seqkit/0.13.2

# 1) let's copy all the singe copy orthologues in a folder
#All the orthogroups sequences are here: orthodir
#The list of the single copy orthologues is here: list_sing_copy_ortho
#We created an array from that list
dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/
orthodir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/1_2_proteomes/all_teleost/primary_transcripts/OrthoFinder/Results_Jun21/Orthogroup_Sequences/
list_sing_copy_ortho=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/1_2_proteomes/all_teleost/primary_transcripts/OrthoFinder/Results_Jun21/Orthogroups/Orthogroups_SingleCopyOrthologues.txt
readarray -t array < $list_sing_copy_ortho
sing_orthodir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/CDS/1_convert_dna_inputs/
mkdir -p $sing_orthodir

for f in "${array[@]}" ; do
cp $orthodir/$f.fa $sing_orthodir/
done

# 2) Make a total protein alignement with all species
genomes_dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/1_2_proteomes/all_teleost/
cat $genomes_dir/*aa.fasta > $genomes_dir/all_aa_tot.fasta

# 3) Let's extract the AA seqs with full names for each single ortho, based on identical AA seqs in single copy ortho
module load seqkit/0.13.2
for f in "${array[@]}" ; do
#get a list composed of single-line fasta sequences without the names
awk '{if(NR==1) {print $0} else {if($0 ~ /^>/) {print "\n"$0} else {printf $0}}}' $sing_orthodir/$f.fa > $sing_orthodir/$f.seqlist.tmp
sed -i '/^>/d' $sing_orthodir/$f.seqlist.tmp
#Here we get the full names AA single ortho fasta files:
cat $genomes_dir/all_aa_tot.fasta | seqkit grep --by-seq --max-mismatch 0 --pattern-file $sing_orthodir/$f.seqlist.tmp > $sing_orthodir/$f.fullname.fa.tmp
done

### There is an issue if a primary sequence from species A is identical to one of the primary seqs from species B. or if two seqs are identical in the same sp
### Here is a somewhat clunky way to fix that, by keeping only one line for each species in each fasta

for f in "${array[@]}" ; do
cat $sing_orthodir/$f.fullname.fa.tmp | grep '^>TARdn' > $sing_orthodir/TAR.tmp1
cat $sing_orthodir/$f.fullname.fa.tmp | grep '^>KTARdn' > $sing_orthodir/KTAR.tmp1
cat $sing_orthodir/$f.fullname.fa.tmp | grep '^>BARdn' > $sing_orthodir/BAR.tmp1
cat $sing_orthodir/$f.fullname.fa.tmp | grep '^>BMdn' > $sing_orthodir/BM.tmp1
cat $sing_orthodir/$f.fullname.fa.tmp | grep '^>BTdn' > $sing_orthodir/BT.tmp1
cat $sing_orthodir/$f.fullname.fa.tmp | grep '^>KAdn' > $sing_orthodir/KA.tmp1
cat $sing_orthodir/$f.fullname.fa.tmp | grep '^>ENSDAR' > $sing_orthodir/ENSDAR.tmp1
cat $sing_orthodir/$f.fullname.fa.tmp | grep '^>ENSGAC' > $sing_orthodir/ENSGAC.tmp1
cat $sing_orthodir/$f.fullname.fa.tmp | grep '^>ENSLOC' > $sing_orthodir/ENSLOC.tmp1
cat $sing_orthodir/$f.fullname.fa.tmp | grep '^>ENSONI' > $sing_orthodir/ENSONI.tmp1
cat $sing_orthodir/$f.fullname.fa.tmp | grep '^>ENSORL' > $sing_orthodir/ENSORL.tmp1
cat $sing_orthodir/$f.fullname.fa.tmp | grep '^>ENSTRU' > $sing_orthodir/ENSTRU.tmp1
cat $sing_orthodir/$f.fullname.fa.tmp | grep '^>ENSTNI' > $sing_orthodir/ENSTNI.tmp1
cat $sing_orthodir/$f.fullname.fa.tmp | grep '^>ENSXMA' > $sing_orthodir/ENSXMA.tmp1


cat $sing_orthodir/TAR.tmp1 | head -1 > $sing_orthodir/TAR.tmp2
cat $sing_orthodir/KTAR.tmp1 | head -1 > $sing_orthodir/KTAR.tmp2
cat $sing_orthodir/BAR.tmp1 | head -1 > $sing_orthodir/BAR.tmp2
cat $sing_orthodir/BM.tmp1 | head -1 > $sing_orthodir/BM.tmp2
cat $sing_orthodir/BT.tmp1 | head -1 > $sing_orthodir/BT.tmp2
cat $sing_orthodir/KA.tmp1 | head -1 > $sing_orthodir/KA.tmp2
cat $sing_orthodir/ENSDAR.tmp1 | head -1 > $sing_orthodir/ENSDAR.tmp2
cat $sing_orthodir/ENSGAC.tmp1 | head -1 > $sing_orthodir/ENSGAC.tmp2
cat $sing_orthodir/ENSLOC.tmp1 | head -1 > $sing_orthodir/ENSLOC.tmp2
cat $sing_orthodir/ENSONI.tmp1 | head -1 > $sing_orthodir/ENSONI.tmp2
cat $sing_orthodir/ENSORL.tmp1 | head -1 > $sing_orthodir/ENSORL.tmp2
cat $sing_orthodir/ENSTRU.tmp1 | head -1 > $sing_orthodir/ENSTRU.tmp2
cat $sing_orthodir/ENSTNI.tmp1 | head -1 > $sing_orthodir/ENSTNI.tmp2
cat $sing_orthodir/ENSXMA.tmp1 | head -1 > $sing_orthodir/ENSXMA.tmp2

cat $sing_orthodir/TAR.tmp2 $sing_orthodir/KTAR.tmp2 $sing_orthodir/BAR.tmp2 $sing_orthodir/BM.tmp2 $sing_orthodir/BT.tmp2 $sing_orthodir/KA.tmp2 \
$sing_orthodir/ENSDAR.tmp2 $sing_orthodir/ENSGAC.tmp2 $sing_orthodir/ENSLOC.tmp2 $sing_orthodir/ENSONI.tmp2 $sing_orthodir/ENSORL.tmp2 $sing_orthodir/ENSTRU.tmp2 \
$sing_orthodir/ENSTNI.tmp2 $sing_orthodir/ENSXMA.tmp2 > $sing_orthodir/$f.singlenamelist.tmp1
awk '{print $1}' $sing_orthodir/$f.singlenamelist.tmp1 > $sing_orthodir/$f.singlenamelist.tmp2
sed -i -e 's/>//' $sing_orthodir/$f.singlenamelist.tmp2
seqkit grep -f $sing_orthodir/$f.singlenamelist.tmp2 $sing_orthodir/$f.fullname.fa.tmp -o $sing_orthodir/$f.fullname.fa

rm $sing_orthodir/*.tmp1
rm $sing_orthodir/*.tmp2
done
#
rm $sing_orthodir/*.tmp

#4) concatenate all cds into one fasta file
cat $genomes_dir/*trscpts.fasta > $genomes_dir/all_1.fasta
cat $genomes_dir/*cds.fasta > $genomes_dir/all_2.fasta
cat $genomes_dir/all_1.fasta $genomes_dir/all_2.fasta > $genomes_dir/all_cds_tot.fasta
rm $genomes_dir/all_1.fasta
rm $genomes_dir/all_2.fasta

#5) Now let's get CDS alignements that correspond to our AA single ortholog alignements
for f in "${array[@]}" ; do
seqkit fx2tab $sing_orthodir/$f.fullname.fa --name > $sing_orthodir/$f.namelist.tmp1
sed -i -e 's/^.*transcript://' $sing_orthodir/$f.namelist.tmp1
awk '{print $1}' $sing_orthodir/$f.namelist.tmp1 > $sing_orthodir/$f.namelist.tmp2

seqkit grep -f $sing_orthodir/$f.namelist.tmp2 $genomes_dir/all_cds_tot.fasta -o $sing_orthodir/$f.cds.fa.tmp
#shorten the names
cat $sing_orthodir/$f.cds.fa.tmp | seqkit replace -p "\s.+" > $sing_orthodir/$f.cds.fa
rm $sing_orthodir/$f.namelist.tmp1
rm $sing_orthodir/$f.namelist.tmp2
rm $sing_orthodir/$f.cds.fa.tmp
done

#6) Now we can actually convert the peptide alignements in DNA alignements!!
source activate pal2nal
pal2nalbin=/nfs/scratch/papayv/bin/miniconda3/envs/pal2nal/bin/
pep_alndir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/outputs_all_teleost_June21/3_4_mafft_gblocks/
outdir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/CDS/2_convert_dna_outputs/
mkdir -p $outdir

for f in "${array[@]}" ; do
#f="${array[0]}"
$pal2nalbin/pal2nal.pl -output fasta $pep_alndir/$f.al.fa  $sing_orthodir/$f.cds.fa  > $outdir/$f.cds.al.fa
done

