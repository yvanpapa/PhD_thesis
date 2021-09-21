#!/bin/bash
#SBATCH --job-name=convert_to_zff_BT
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --partition=parallel
#SBATCH --time=10:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BT/maker/BTdn_rnd1.maker.output/snap/snap_rnd1_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BT/maker/BTdn_rnd1.maker.output/snap/snap_rnd1_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#/!\ I think that maker2zff has to run in the TARdn_V2P_rnd1.maker.output directory for some reason
# Most of code aquired from: https://gist.github.com/darencard/bb1001ac1532dd4225b030cf0cd61ce2
#More detail in SNAP manual: https://github.com/KorfLab/SNAP
#And in MAKER tutorial: http://weatherby.genetics.utah.edu/MAKER/wiki/index.php/MAKER_Tutorial_for_WGS_Assembly_and_Annotation_Winter_School_2018

source activate genome_annotation
#module load perl/CPAN/5.16
#module load BioPerl/1.7.2
#module load MAKER/2.31.10

index_log=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BT/maker/BTdn_rnd1.maker.output/BTdn_rnd1_master_datastore_index.log
#gff_file=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BT/maker/BTdn_rnd1.maker.output/BTdn_rnd1.all.maker.gff
dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BT/maker/BTdn_rnd1.maker.output/snap/
name=BTdn_rnd1

#maker2zff --help

### export 'confident' gene models from MAKER and rename to something meaningful ####
cd $dir

echo "filter 1"
maker2zff -x 0.25 -l 50 -d $index_log

mv $dir/genome.dna $dir/$name.zff.aed0.25.length50.dna
mv $dir/genome.ann $dir/$name.zff.aed0.25.length50.ann

echo "dflt filter"
maker2zff -d $index_log

mv $dir/genome.dna $dir/$name.zff.default_param.dna
mv $dir/genome.ann $dir/$name.zff.default_param.ann

echo "no filter"
maker2zff -n -d $index_log

mv $dir/genome.dna $dir/$name.zff.nofilter.dna
mv $dir/genome.ann $dir/$name.zff.nofilter.ann

echo "length50"
#let's be less stringent for the fish species from chapter 2, because the ESTs are from another species
maker2zff -x 1.00 -l 50 -d $index_log

mv $dir/genome.dna $dir/$name.zff.aed1.00.length50.dna
mv $dir/genome.ann $dir/$name.zff.aed1.00.length50.ann

##or:
##maker2zff -d $index_log
##-x number    Max AED to allow 0.5 is default
##-l number    The min length of the protein sequence produced by the mRNA
##-d <datastore_index>

#fathom --help

echo "stats"
#### gather some stats and validate ####
fathom $dir/$name.zff.nofilter.ann $dir/$name.zff.nofilter.dna -gene-stats > $dir/gene-stats.log
fathom $dir/$name.zff.nofilter.ann $dir/$name.zff.nofilter.dna -validate > $dir/validate.log

####remove the errors####
### not necessay. errors are filtered by SNAP in the last step

##cat $dir/validate.log | grep "error" > $dir/errors.list
##gawk -F'[ ]' '{print$2}' $dir/errors.list > $dir/errors.labels
##grep -vwEf $dir/errors.labels $dir/$name.zff.aed0.25.length50.ann > $dir/$name.zff.aed0.25.length50.ann2
###-v, --invert-match        select non-matching lines
###-w, --word-regexp         force PATTERN to match only whole words
###-E, --extended-regexp     PATTERN is an extended regular expression (ERE)
###-f, --file=FILE           obtain PATTERN from FILE

#### gather stats and validate again ####
##fathom $dir/$name.zff.aed0.25.length50.ann2 $dir/$name.zff.aed0.25.length50.dna -gene-stats > $dir/gene-stats2.log
##fathom $dir/$name.zff.aed0.25.length50.ann2 $dir/$name.zff.aed0.25.length50.dna -validate > $dir/validate2.log
##cat $dir/validate2.log | grep "error" > $dir/errors2.list

echo "collect 1000bp regions"
### collect the training sequences and annotations, plus 1000 surrounding bp for training
fathom $dir/$name.zff.nofilter.ann $dir/$name.zff.nofilter.dna -categorize 1000 > $dir/categorize.log
fathom $dir/uni.ann $dir/uni.dna -export 1000 -plus > $dir/uni-plus.log 

echo "create the training parameters"
### create the training parameters
forge --help

mkdir $dir/params
cd $dir/params
forge $dir/export.ann $dir/export.dna > $dir/forge.log
cd $dir/

echo "assembly the HMM"
#### assembly the HMM
hmm-assembler.pl --help

hmm-assembler.pl $dir/$name.zff.aed1.00.length50 params > $dir/$name.zff.nofilter.hmm

echo "done"



