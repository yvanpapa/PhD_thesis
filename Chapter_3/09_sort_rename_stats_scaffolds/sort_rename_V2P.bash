#!/bin/bash
#SBATCH --job-name=sort_rename
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/07_1_sortrename_scaffolds/V2_P/job_%j.out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/07_1_sortrename_scaffolds/V2_P/job_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

module load seqkit/0.13.2

#manual: https://bioinf.shenwei.me/seqkit/usage/#sort

REF=/nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P/TARdn_assembly_V2_p.fasta

#get the list of seq names
seqkit seq $REF -n

#sort by size (longest to shortest, s=sorted)
time seqkit sort -l -r -2 $REF > /nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P/TARdn_assembly_V2_p_s.fasta
#cpt=12, mem=32G. real	0m2.545s
# -l, --by-length by sequence length
# -r, --reverse reverse the result
#-2, --two-pass  two-pass mode read files twice to lower memory usage. (only for FASTA format)

#get the new list of seq names
echo "length ordered seq names"
seqkit seq /nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P/TARdn_assembly_V2_p_s.fasta -n

#rename by simple numbers (rn=renames)
time seqkit replace -p .+ -r "{nr}" /nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P/TARdn_assembly_V2_p_s.fasta \
> /nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P/TARdn_assembly_V2_p_srn.fasta
#cpt=12, mem=32G. real	0m4.087s

#echo "final list of names"
seqkit seq /nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P/TARdn_assembly_V2_p_srn.fasta -n

echo "compute read stats in tabular format"
time seqkit fx2tab $REF -l -B A -B T -B G -B C -B N -g -G -H -n > /nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P/TARdn_assembly_V2.tab

time seqkit fx2tab /nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P/TARdn_assembly_V2_p_srn.fasta -l -B A -B T -B G -B C -B N -g -G -H -n \
> /nfs/scratch/papayv/Tarakihi/TARdn/TARdn_assembly_V2_P/TARdn_assembly_V2_p_srn.tab