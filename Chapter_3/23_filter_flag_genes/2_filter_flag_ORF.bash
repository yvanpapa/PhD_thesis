#!/bin/bash
#SBATCH --job-name=agat_filter_ORF
#SBATCH --cpus-per-task=2
#SBATCH --mem=24G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/14_filter_gene_models/trial2_lightGFF/2_flag_filter_ORF/filter_ORF_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/14_filter_gene_models/trial2_lightGFF/2_flag_filter_ORF/filter_ORF_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz
threads=2
source activate agat

dir=/nfs/scratch/papayv/Tarakihi/TARdn/14_filter_gene_models/trial2_lightGFF/2_flag_filter_ORF/
gff=/nfs/scratch/papayv/Tarakihi/TARdn/14_filter_gene_models/trial2_lightGFF/1_filterlength/final_outputs/TARdn_V2P_rnd2.all.maker.noseq.blastfunc_annotated.iprscan.lngthfiltered.gff
genome=/nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P/TARdn_assembly_V2_p_srn.fasta
prots="/nfs/scratch/papayv/Tarakihi/TARdn/14_filter_gene_models/trial2_lightGFF/1_filterlength/final_outputs/TARdn_V2P_rnd2.all.maker.proteins.blastfunc_annotated.lngthfiltered.fasta"
rna="/nfs/scratch/papayv/Tarakihi/TARdn/14_filter_gene_models/trial2_lightGFF/1_filterlength/final_outputs/TARdn_V2P_rnd2.all.maker.transcripts.blastfunc_annotated.lngthfiltered.fasta"


#1) obtain the filtered and filtered out gffs with only the gene models
awk '{ if ($2 == "maker") print $0 }' $gff > $dir/TARdn_V2P_rnd2.maker.noseq.blastfunc_annotated.iprscan.lngthfiltered.onlygenemodels.gff
agat_sp_filter_incomplete_gene_coding_models.pl --gff $dir/TARdn_V2P_rnd2.maker.noseq.blastfunc_annotated.iprscan.lngthfiltered.onlygenemodels.gff \
--fasta $genome -v -o $dir/TARdn_V2P_rnd2.maker.noseq.blastfunc_annotated.iprscan.lngthfiltered.onlygenemodels.ORFfilterd.gff

#2) Now we use an index to filter the original GFF because the AGAT script messes up the headers in the output GFF for some reason
#Get the list of IDs of the filtered genes
awk '{ if ($3 ==  "gene") print $9 }' $dir/TARdn_V2P_rnd2.maker.noseq.blastfunc_annotated.iprscan.lngthfiltered.onlygenemodels.ORFfilterd_incomplete.gff | \
awk -F';' '{ print $1 }' > $dir/IDs_incomplete.txt
sed -i 's/ID=//' $dir/IDs_incomplete.txt 

grep -v -f $dir/IDs_incomplete.txt  $dir/TARdn_V2P_rnd2.maker.noseq.blastfunc_annotated.iprscan.lngthfiltered.onlygenemodels.gff \
> $dir/TARdn_V2P_rnd2.maker.noseq.blastfunc_annotated.iprscan.lngthfiltered.onlygenemodels.ORFfilterd2.gff

mkdir -p final_outputs_filtered

#2) Concatanate the filtered GFF with all the other annotations of noseq_GFF to obtain final filtered GFF
awk '{ if ($2 !=  "maker") print $0 }' $gff > $dir/TARdn_V2P_rnd2.maker.noseq.blastfunc_annotated.iprscan.lngthfiltered.not_genemodels.gff
cat $dir/TARdn_V2P_rnd2.maker.noseq.blastfunc_annotated.iprscan.lngthfiltered.onlygenemodels.ORFfilterd2.gff $dir/TARdn_V2P_rnd2.maker.noseq.blastfunc_annotated.iprscan.lngthfiltered.not_genemodels.gff \
> $dir/final_outputs_filtered/TARdn_V2P_rnd2.maker.noseq.blastfunc.iprscan.lngth_ORF_filtered.gff

#3) 
###filter gff2 with fasta seqs
gff2="/nfs/scratch/papayv/Tarakihi/TARdn/14_filter_gene_models/trial2_lightGFF/1_filterlength/final_outputs/TARdn_V2P_rnd2.all.maker.blastfunc_annotated.iprscan.lngthfiltered.gff"
awk '{ if ($2 !=  "maker") print $0 }' $gff2 > $dir/TARdn_V2P_rnd2.maker.blastfunc_annotated.iprscan.lngthfiltered.not_genemodels.gff
cat $dir/TARdn_V2P_rnd2.maker.noseq.blastfunc_annotated.iprscan.lngthfiltered.onlygenemodels.ORFfilterd2.gff $dir/TARdn_V2P_rnd2.maker.blastfunc_annotated.iprscan.lngthfiltered.not_genemodels.gff \
> $dir/final_outputs_filtered/TARdn_V2P_rnd2.maker.blastfunc.iprscan.lngth_ORF_filtered.gff

module load seqkit/0.13.2 
seqkit grep -nrv -f $dir/IDs_incomplete.txt $prots -o $dir/final_outputs_filtered/TARdn_V2P_rnd2.all.maker.proteins.blastfunc_annotated.lngth_ORF_filtered.fasta
seqkit grep -nrv -f $dir/IDs_incomplete.txt $rna -o $dir/final_outputs_filtered/TARdn_V2P_rnd2.all.maker.transcripts.blastfunc_annotated.lngth_ORF_filtered.fasta

# to keep all the final outputs at the same place
cp /nfs/scratch/papayv/Tarakihi/TARdn/13_funct_annotation/2_interproscan/final_outputs/TARdn_V2P_rnd2.visible_iprscan_domains.gff $dir/final_outputs_filtered/

####### NOW, let's have another version that is flagged instead of filtered #####

mkdir -p final_outputs_flagged
awk -F'\t' 'NR==FNR{a[$1]=$1; next}{split($9,b,";");gsub("ID=","",b[1]);gsub("-RA","",b[1]);gsub(/;$/,"",$0);if(a[b[1]] != ""){print $0";FLAG=incomplete_ORF;"} else {print $0";"}}' \
$dir/IDs_incomplete.txt $gff > $dir/final_outputs_flagged/TARdn_V2P_rnd2.mkr.noseq.blstfnc.iprscan.lngthfiltrd.ORFflag.gff

awk -F'\t' 'NR==FNR{a[$1]=$1; next}{split($9,b,";");gsub("ID=","",b[1]);gsub("-RA","",b[1]);gsub(/;$/,"",$0);if(a[b[1]] != ""){print $0";FLAG=incomplete_ORF;"} else {print $0";"}}' \
$dir/IDs_incomplete.txt $gff2 > $dir/final_outputs_flagged/TARdn_V2P_rnd2.mkr.blstfnc.iprscan.lngthfiltrd.ORFflag.gff

awk -F'\t' 'NR==FNR{a[$1]=$1; next}{split($1,b," ");gsub(">","",b[1]);gsub("-RA","",b[1]);gsub(/ $/,"",$0);if(a[b[1]] != ""){print $0" FLAG=incomplete_ORF"} else {print $0}}' \
$dir/IDs_incomplete.txt $prots | sed 's/;//' > $dir/final_outputs_flagged/TARdn_V2P_rnd2.all.maker.proteins.blstfnc.lngthfiltrd.ORFflag.fasta

awk -F'\t' 'NR==FNR{a[$1]=$1; next}{split($1,b," ");gsub(">","",b[1]);gsub("-RA","",b[1]);gsub(/ $/,"",$0);if(a[b[1]] != ""){print $0" FLAG=incomplete_ORF"} else {print $0}}' \
$dir/IDs_incomplete.txt $rna | sed 's/;//' > $dir/final_outputs_flagged/TARdn_V2P_rnd2.all.maker.transcripts.blstfnc.lngthfiltrd.ORFflag.fasta

# to keep all the final outputs at the same place
cp /nfs/scratch/papayv/Tarakihi/TARdn/13_funct_annotation/2_interproscan/final_outputs/TARdn_V2P_rnd2.visible_iprscan_domains.gff $dir/final_outputs_flagged/

#Also keep the light (aka gene-only) version
cp $dir/TARdn_V2P_rnd2.maker.noseq.blastfunc_annotated.iprscan.lngthfiltered.onlygenemodels.ORFfilterd2.gff \
$dir/final_outputs_filtered/TARdn_V2P_rnd2.maker.blastfunc.iprscan.lngth_ORF_filtered.genes_only.gff

awk '{ if ($2 == "maker") print $0 }' $dir/final_outputs_flagged/TARdn_V2P_rnd2.mkr.noseq.blstfnc.iprscan.lngthfiltrd.ORFflag.gff \
> $dir/final_outputs_flagged/TARdn_V2P_rnd2.mkr.noseq.blstfnc.iprscan.lngthfiltrd.ORFflag.genes_only.gff

#Make a version with genes and isoforms only 
awk '{ if ($2 ~ "est2genome") print $0 }' $dir/TARdn_V2P_rnd2.maker.noseq.blastfunc_annotated.iprscan.lngthfiltered.not_genemodels.gff \
> $dir/TARdn_V2P_rnd2.maker.noseq.blastfunc_annotated.iprscan.lngthfiltered.only_isoforms.gff
cat $dir/TARdn_V2P_rnd2.maker.noseq.blastfunc_annotated.iprscan.lngthfiltered.onlygenemodels.ORFfilterd2.gff \
$dir/TARdn_V2P_rnd2.maker.noseq.blastfunc_annotated.iprscan.lngthfiltered.only_isoforms.gff \
> $dir/final_outputs_flagged/TARdn_V2P_rnd2.mkr.noseq.blstfnc.iprscan.lngthfiltrd.ORFflag.genes_and_isoforms_only.gff

#Get the scaffold 1 only if too heavy for jbrowse
mkdir -p scaffold1
awk '{ if ($1 == "1") print $0 }' $dir/final_outputs_flagged/TARdn_V2P_rnd2.mkr.noseq.blstfnc.iprscan.lngthfiltrd.ORFflag.genes_and_isoforms_only.gff \
> $dir/final_outputs_flagged/scaffold1/TARdn_V2P_rnd2.mkr.noseq.blstfnc.iprscan.lngthfiltrd.ORFflag.genes_and_isoforms_only.scf1.gff

