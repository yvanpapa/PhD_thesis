#!/bin/bash
#SBATCH --job-name=mashmap
#SBATCH --cpus-per-task=12
#SBATCH --mem=24G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/8B_Genomes_Comparisons/04_mashmap_bwa_rMF_qV2P/mashmap_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/8B_Genomes_Comparisons/04_mashmap_bwa_rMF_qV2P/mashmap_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#Can be run on quicktest, only takes <5 minutes

module load MashMap/2.0
module load perl/CPAN/5.16
module load seqkit/0.13.2


### parameters ###

ref=/nfs/scratch/papayv/Tarakihi/TARdn/other_genomes/ncbi-genomes-2020-11-03/GCA_011952085.1_sinChu7_genomic.fna
query=/nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P/TARdn_assembly_V2_p_srn.fasta
name=rMF_qV2P

dir1=/nfs/scratch/papayv/Tarakihi/TARdn/8B_Genomes_Comparisons
dir2=04_mashmap_bwa_rMF_qV2P

#subset ref (only longer than 1Mb)
seqkit seq -m 1000000 $query > $dir1/$dir2/$name.subset.fasta

### compute table ###

mashmap -r $ref -q $dir1/$dir2/$name.subset.fasta -o $dir1/$dir2/$name.subset.out -t 12

#convert spaces in tabs and add header for table
sed -e 's/ /\t/g' $dir1/$dir2/$name.subset.out > $dir1/$dir2/$name.subset.out.table
sed -i '1 i\query\tlength\t0_based_start\tend\tstrand\tref\tlength\tstart\tend\tidentity' $dir1/$dir2/$name.subset.out.table

#--perc_identity <value>, --pi <value>

#    threshold for identity [default : 85]
#-s <value>, --segLength <value>
#    mapping segment length [default : 5,000]
#    sequences shorter than segment length will be ignored

### plot comparison ###

perl $dir1/generateDotPlot.pl png large $dir1/$dir2/$name.subset.out 
mv $dir1/$dir2/out.png $dir1/$dir2/$name.subset.png

perl $dir1/generateDotPlot.pl postscript large $dir1/$dir2/$name.subset.out 
mv $dir1/$dir2/out.ps $dir1/$dir2/$name.subset.ps


#USAGE: 
#manual here: https://github.com/marbl/MashMap
#generateDotPlot <terminal> <size> <mashmap ouptut file>
#DESCRIPTION:
#    generateDotPlot generates plots of mapping data produced by mashmap (or similar 
#    formatted mapping output). This script borrows most of the routines from 
#    mummerplot in Mummer3 software package. For showing the output plut, either
#    an x11 window will be spawned or an output file (.ps or .png) will be 
#    generated. This script has a dependency on gnuplot.
#  MANDATORY:
#    <terminal>              Set the output terminal to either 'x11', 'postscript' or 'png'
#    <size>                  Set the output size to either 'small', 'medium' or 'large'
#  <mashmap output file>   Provide the mapping output file generated by mashmap   
    