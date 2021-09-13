#!/bin/bash
#SBATCH --job-name=rm_simple_repeats
#SBATCH --cpus-per-task=4
#SBATCH --mem=4G
#SBATCH --partition=parallel
#SBATCH --time=6:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/repeats/1_rm_simple_repeats_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/repeats/1_rm_simple_repeats_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#Specifying the GFF3 annotation file for the annotated complex repeats (rm_gff) has the effect of hard masking these repeats 
#so that they do not confound our ability to identify coding genes.
#We let MAKER identify simple repeats internally, since it will soft mask these, allowing them to be available for gene annotation.
#https://gist.github.com/darencard/bb1001ac1532dd4225b030cf0cd61ce2

#Regions identified during repeat analysis are masked out in two different ways:
#Complex repeats are hard-masked - the repeat sequence is replaced with the letter N. 
#This essentially removes this sequence from any further consideration at any later point of the annotation process.
#Simple repeats are soft-masked - sequences are transformed to lower case. 
#This prevents alignment programs such as Blast from seeding any new alignments in the soft-masked region, 
#however alignments that begin in a nearby (non-masked) region of the genome can extend into the soft-masked region.
#This is important because low-complexity regions are found within many real genes, they just don't make up the majority of the gene.
#http://weatherby.genetics.utah.edu/MAKER/wiki/index.php/MAKER_Tutorial_for_WGS_Assembly_and_Annotation_Winter_School_2018

module load singularity/3.5.2
singdir=/nfs/scratch/papayv/Tarakihi/TARdn/09_Repeat/new_pipeline/V2P/
sing=$singdir/tetools_latest.sif

dir=/nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/repeats/
out_file="/nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P/20201221_REPEAT_dfam_rb_run3/TARdn_assembly_V2_p_srn.fasta.out"


# create GFF3
singularity exec $sing rmOutToGFF3.pl $out_file > $out_file.gff3

# isolate complex repeats
grep -v -e "Satellite" -e ")n" -e "-rich" $out_file.gff3 \
  > $out_file.complex.gff3

# reformat to work with MAKER

cat $out_file.complex.gff3 | \
  perl -ane '$id; if(!/^\#/){@F = split(/\t/, $_); chomp $F[-1];$id++; $F[-1] .= "\;ID=$id"; $_ = join("\t", @F)."\n"} print $_' \
  > $out_file.complex.reformat.gff3

