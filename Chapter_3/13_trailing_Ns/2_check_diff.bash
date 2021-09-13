#!/bin/bash
#SBATCH --job-name=diff
#SBATCH --cpus-per-task=12
#SBATCH --mem=24G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/7D_Trailing_Ns/%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/7D_Trailing_Ns/%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

### inputs###


assembly_name=TARdn_assembly_V2_p_srn.fasta
dir=/nfs/scratch/papayv/Tarakihi/TARdn/7D_Trailing_Ns


####
#module load  seqkit/0.13.2
#based on https://www.biostars.org/p/412636/
#cp $assembly_dir/$assembly_name $dir/$assembly_name.cp1
#cp $assembly_dir/$assembly_name $dir/$assembly_name.cp2
#### TEST 1
#seqkit -is replace -p "^n+|n+$" -r "" $dir/$assembly_name.cp1 > $dir/$assembly_name.cp1_nn
#### TEST 2
#sed -r '/^>/! s/n+$|^n+//g' $dir/$assembly_name.cp2 > $dir/$assembly_name.cp2_nn

#### check if something actually happened

diff $dir/$assembly_name.cp1 $dir/$assembly_name.cp1_nn
diff $dir/$assembly_name.cp2 $dir/$assembly_name.cp2_nn
diff $dir/test2 $dir/test3