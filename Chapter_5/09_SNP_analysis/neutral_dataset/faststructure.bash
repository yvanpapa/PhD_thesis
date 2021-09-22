#!/bin/bash
#SBATCH --job-name=faststructure
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --partition=parallel
#SBATCH --time=2:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/popgen/14_faststructure/%j_faststructure_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/popgen/14_faststructure/%j_faststructure_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

source activate faststructure

dir=/nfs/scratch/papayv/Tarakihi/popgen/14_faststructure
input=$dir/call_set_AGRFlib1_to_6_V2P.rn.QCmaf.AB.neutral.hwe_thin.pruned.242.fs #need to be .str in the file name but dont specify in the input
output=$dir/call_set_AGRFlib1_to_6_V2P.rn.QCmaf.AB.neutral.hwe_thin.pruned.242.output

array=($(seq 1 1 10)) #array from 1 to 10

for f in "${array[@]}" ; do 
echo "Analysing for K= $f"
structure.py -K $f --input=$input --output=$output --format=str
done

#--tol=<float>   (convergence criterion; default: 10e-6)
#--prior={simple,logistic}   (choice of prior; default: simple)
#--format={bed,str} (format of input file; default: bed)

chooseK.py --input=$output

distruct.py -K 2 --input=$output --output=$output.distruct2.svg
 