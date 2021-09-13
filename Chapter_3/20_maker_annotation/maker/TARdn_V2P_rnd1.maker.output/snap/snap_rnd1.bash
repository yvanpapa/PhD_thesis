#!/bin/bash
#SBATCH --job-name=convert_to_zff
#SBATCH --cpus-per-task=16
#SBATCH --mem=24G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/maker/TRIAL2_TARdn_V2P/TARdn_V2P_rnd1.maker.output/snap/round1/snap_rnd1_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/maker/TRIAL2_TARdn_V2P/TARdn_V2P_rnd1.maker.output/snap/round1/snap_rnd1_%j.err
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

index_log=/nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/maker/TRIAL2_TARdn_V2P/TARdn_V2P_rnd1.maker.output/TARdn_V2P_rnd1_master_datastore_index.log
#gff_file="/nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/maker/TRIAL2_TARdn_V2P/TARdn_V2P_rnd1.maker.output/TARdn_V2P_rnd1.all.maker.gff"
dir=/nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/maker/TRIAL2_TARdn_V2P/TARdn_V2P_rnd1.maker.output/snap/round1/
name=TARdn_V2P_rnd1

maker2zff --help

#### export 'confident' gene models from MAKER and rename to something meaningful ####

maker2zff -x 0.25 -l 50 -d $index_log

mv $dir/genome.dna $dir/$name.zff.aed0.25.length50.dna
mv $dir/genome.ann $dir/$name.zff.aed0.25.length50.ann

maker2zff -d $index_log

mv $dir/genome.dna $dir/$name.zff.default_param.dna
mv $dir/genome.ann $dir/$name.zff.default_param.ann

maker2zff -n -d $index_log

mv $dir/genome.dna $dir/$name.zff.nofilter.dna
mv $dir/genome.ann $dir/$name.zff.nofilter.ann

#or:
#maker2zff -d $index_log
#-x number    Max AED to allow 0.5 is default
#-l number    The min length of the protein sequence produced by the mRNA
#-d <datastore_index>

fathom --help

#### gather some stats and validate ####
fathom $dir/$name.zff.aed0.25.length50.ann $dir/$name.zff.aed0.25.length50.dna -gene-stats > $dir/gene-stats.log
fathom $dir/$name.zff.aed0.25.length50.ann $dir/$name.zff.aed0.25.length50.dna -validate > $dir/validate.log

####remove the errors####
### not necessay. errors are filtered by SNAP in the last step

#cat $dir/validate.log | grep "error" > $dir/errors.list
#gawk -F'[ ]' '{print$2}' $dir/errors.list > $dir/errors.labels
#grep -vwEf $dir/errors.labels $dir/$name.zff.aed0.25.length50.ann > $dir/$name.zff.aed0.25.length50.ann2
##-v, --invert-match        select non-matching lines
##-w, --word-regexp         force PATTERN to match only whole words
##-E, --extended-regexp     PATTERN is an extended regular expression (ERE)
##-f, --file=FILE           obtain PATTERN from FILE

#### gather stats and validate again ####
#fathom $dir/$name.zff.aed0.25.length50.ann2 $dir/$name.zff.aed0.25.length50.dna -gene-stats > $dir/gene-stats2.log
#fathom $dir/$name.zff.aed0.25.length50.ann2 $dir/$name.zff.aed0.25.length50.dna -validate > $dir/validate2.log
#cat $dir/validate2.log | grep "error" > $dir/errors2.list

### collect the training sequences and annotations, plus 1000 surrounding bp for training
fathom $dir/$name.zff.aed0.25.length50.ann $dir/$name.zff.aed0.25.length50.dna -categorize 1000 > $dir/categorize.log
fathom $dir/uni.ann $dir/uni.dna -export 1000 -plus > $dir/uni-plus.log 

### create the training parameters
forge --help

mkdir $dir/params
cd $dir/params
forge $dir/export.ann $dir/export.dna > $dir/forge.log
cd $dir/

#### assembly the HMM
hmm-assembler.pl --help

hmm-assembler.pl $dir/$name.zff.aed0.25.length50 params > $dir/$name.zff.aed0.25.length50.hmm





