#!/bin/bash
#SBATCH --job-name=BT_agat_filter_length
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/12_filter_gene_models/BT/1_filterlength/filter_lgth_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/12_filter_gene_models/BT/1_filterlength/filter_lgth_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz
threads=2
source activate agat

dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/12_filter_gene_models/BT/1_filterlength/
gff="/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/11_funct_annotation/BT/4_annotation_interproscan/final_outputs/BTdn_rnd2.all.maker.noseq.blastfunc_annotated.iprscan.gff"
gff2="/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/11_funct_annotation/BT/4_annotation_interproscan/final_outputs/BTdn_rnd2.all.maker.blastfunc_annotated.iprscan.gff"
iprscan_domain="/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/11_funct_annotation/BT/4_annotation_interproscan/final_outputs/BTdn_rnd2.visible_iprscan_domains.gff"
prots="/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/11_funct_annotation/BT/3_annotation/functannot_output_protID/BTdn_rnd2.all.maker.proteins.blastfunc_annotated.fasta"
rna="/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/11_funct_annotation/BT/3_annotation/functannot_output_protID/BTdn_rnd2.all.maker.transcripts.blastfunc_annotated.fasta"

#Filter genes which code less than 50 amino acids

#1) obtain the filtered and filtered out gffs with only the gene models 
#We are doing this first because using agat_sp_filter on the whole GFF is very slow and memory demanding
awk '{ if ($2 == "maker") print $0 }' $gff > $dir/BTdn.mkr_rnd2.noseq.blstfnc_annttd.iprscan.onlygenemodels.gff
agat_sp_filter_by_ORF_size.pl --gff $dir/BTdn.mkr_rnd2.noseq.blstfnc_annttd.iprscan.onlygenemodels.gff --test ">=" --size 50 \
--output $dir/BTdn.mkr_rnd2.noseq.blstfnc_annttd.iprscan.onlygenemodels.filtrdlngth.gff
#I took 50 because it's the value used in most publications and it's a multiple of 3

#2) Now we use an index to filter the original GFF because the AGAT script messes up the headers in the output GFF for some reason
#Get the list of IDs of the filtered genes
awk '{ if ($3 ==  "gene") print $9 }' $dir/BTdn.mkr_rnd2.noseq.blstfnc_annttd.iprscan.onlygenemodels.filtrdlngth_NOT_sup=50.gff | \
awk -F';' '{ print $1 }' > $dir/IDs_short.txt
sed -i 's/ID=//' $dir/IDs_short.txt 

grep -v -f $dir/IDs_short.txt $dir/BTdn.mkr_rnd2.noseq.blstfnc_annttd.iprscan.onlygenemodels.gff \
> $dir/BTdn.mkr_rnd2.noseq.blstfnc_annttd.iprscan.onlygenemodels.filtrdlngth.gff

mkdir -p final_outputs

#2) Concatanate the filtered GFF with all the other annotations of noseq_GFF to obtain final filtered GFF
awk '{ if ($2 !=  "maker") print $0 }' $gff > $dir/BTdn.mkr_rnd2.noseq.blstfnc_annttd.iprscan.not_genemodels.gff
cat $dir/BTdn.mkr_rnd2.noseq.blstfnc_annttd.iprscan.onlygenemodels.filtrdlngth.gff $dir/BTdn.mkr_rnd2.noseq.blstfnc_annttd.iprscan.not_genemodels.gff \
> $dir/final_outputs/BTdn_rnd2.all.maker.noseq.blastfunc_annotated.iprscan.lngthfiltered.gff

####gff2 with fasta seqs
awk '{ if ($2 !=  "maker") print $0 }' $gff2 > $dir/BTdn.mkr_rnd2.blstfnc_annttd.iprscan.not_genemodels.gff
cat $dir/BTdn.mkr_rnd2.noseq.blstfnc_annttd.iprscan.onlygenemodels.filtrdlngth.gff $dir/BTdn.mkr_rnd2.blstfnc_annttd.iprscan.not_genemodels.gff \
> $dir/final_outputs/BTdn_rnd2.all.maker.blastfunc_annotated.iprscan.lngthfiltered.gff

module load seqkit/0.13.2 
seqkit grep -nrv -f $dir/IDs_short.txt $prots -o $dir/final_outputs/BTdn_rnd2.all.maker.proteins.blastfunc_annotated.lngthfiltered.fasta
seqkit grep -nrv -f $dir/IDs_short.txt $rna -o $dir/final_outputs/BTdn_rnd2.all.maker.transcripts.blastfunc_annotated.lngthfiltered.fasta

# to keep all the final outputs at the same place
cp $iprscan_domain $dir/final_outputs/

