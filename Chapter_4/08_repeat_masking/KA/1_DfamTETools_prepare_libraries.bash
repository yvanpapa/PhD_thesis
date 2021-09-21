#!/bin/bash
#SBATCH --job-name=KA_repeat_libraries
#SBATCH --cpus-per-task=18
#SBATCH --mem=14G
#SBATCH --partition=parallel
#SBATCH --time=5-00:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/9_repeat_masking/KA/%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/9_repeat_masking/KA/%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

dir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/9_repeat_masking/KA/
singdir=/nfs/scratch/papayv/Tarakihi/TARdn/09_Repeat/new_pipeline/V2P/
sing=$singdir/tetools_latest.sif
genome1=KAdn_assembly_V1_srn
genome1_fasta=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/Genome_assemblies/KA/KAdn_assembly_V1_srn.fasta
threads=18

#if homology-repeat library for actinopterygi already exists:
db_lib=/nfs/scratch/papayv/Tarakihi/TARdn/09_Repeat/new_pipeline/V2P/3_Dfam_TETools_3d_run/TARdn_V2P_repeat_lib_actinodb_ad_and_denovo.fa

#TRF has to be loaded outside of container because of licensing reasons
module load TandemRepeatsFinder/4.09
module load perl/CPAN/5.16
module load singularity/3.5.2
LIBDIR=/nfs/scratch/papayv/Tarakihi/TARdn/09_Repeat/new_pipeline/V2P/Libraries/libs/Libraries/

echo "download dfam-tetools.sh to download DfamTETools container if needed"
##need only once
#singularity pull docker://dfam/tetools:latest


#### DE NOVO LIBRARY ####
time echo "Create a Database for RepeatModeler"
singularity exec $sing BuildDatabase -name $genome1 $genome1_fasta
##~2 min quicktest cpt12, mem 24
time echo "Run Repeat Modeler for de novo repeat detection. Also use the LTR detection pipeline"
singularity exec $sing RepeatModeler -database $genome1 -LTRStruct -pa $threads
time echo "change de novo repeat library to something clearer"
cp $dir/KAdn_assembly_V1_srn-families.fa $dir/KAdn_V1_denovo_repeat_lib.fa

#### REPEATMASKER QUERY LIBRARY #### NEED TO DO THE BELLOW ONLY ONCE AND THEN CAN BE REUSED FOR ALL FISH
##how to install repeatmasker libraries: #in the container: https://github.com/Dfam-consortium/TETools
## outside the container: http://www.repeatmasker.org/RepeatMasker/ section "Installation" 
##currently: Dfam 3.3 + RepeatMasker 2018
#time echo "check at what taxonomic level my species is covered. Can use name or taxonomic ID"
#singularity exec $sing famdb.py -i $LIBDIR/RepeatMaskerLib.h5 lineage --ancestors --descendants Actinopterygii --format totals
#singularity exec $sing famdb.py -i $LIBDIR/RepeatMaskerLib.h5 lineage --ancestors --descendants Actinopterygii
##next step: update Dfam library (cf how to install library)
##and then concatenate:
##You can combine the repeats available in the RepeatMasker library 
##with a custom set of consensus sequences.  To accomplish this 
##use the famdb.py tool:
#touch $dir/actinopterygii_db_ad_repeatlib.fa
#singularity exec $sing famdb.py -i $LIBDIR/RepeatMaskerLib.h5 families \
#--format fasta_name --ancestors --descendants Actinopterygii --include-class-in-name --add-reverse-complement \
# > $dir/actinopterygii_db_ad_repeatlib.fa
 
#The resulting sequences can be concatenated to your own set of sequences in a
#new library file.

######### CONCATENATE LIBRARIES ####################
time echo "compile de novo repeat libraries and Repeatmasker/Dfam/TAR db in one"
#For KA we use the denovo+db repeat lib of TARV2P and combine it with KAV1 de novo replib
cat $dir/KAdn_V1_denovo_repeat_lib.fa $db_lib > $dir/KAdn_V1_repeat_lib_TARV2Pdb_and_denovo.fa

### REPEATMASKER DOES NOT WORK IN THE CONTAINER AT THIS POINT. I TRIED THE FIX BELLOW AND TRIED CONDA INSTALL, BUT DOESNT WORK. ENDED UP RUNNING RM OUT OF THE CONTAINER: RM 4.0.8
