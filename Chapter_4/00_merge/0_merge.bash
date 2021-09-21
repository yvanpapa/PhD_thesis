#!/bin/bash
#SBATCH --job-name=merge_fastq
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=2G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/0_merge/%j_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/0_merge/%j_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

indir=/nfs/scratch/papayv/Tarakihi/raw_data/popgen/
outdir=/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/0_merge/

BAR=003_BAR_2
BM1=004_BM04
BM2=005_BM05
BT=014_BT02
KA=018_KA01

cat $indir/*/*$BAR*R1*fastq.gz > $outdir/$BAR.6x_R1.fastq.gz
cat $indir/*/*$BAR*R2*fastq.gz > $outdir/$BAR.6x_R2.fastq.gz
cat $indir/*/*$BM1*R1*fastq.gz > $outdir/$BM1.6x_R1.fastq.gz
cat $indir/*/*$BM1*R2*fastq.gz > $outdir/$BM1.6x_R2.fastq.gz
cat $indir/*/*$BM2*R1*fastq.gz > $outdir/$BM2.6x_R1.fastq.gz
cat $indir/*/*$BM2*R2*fastq.gz > $outdir/$BM2.6x_R2.fastq.gz
cat $indir/*/*$BT*R1*fastq.gz > $outdir/$BT.6x_R1.fastq.gz
cat $indir/*/*$BT*R2*fastq.gz > $outdir/$BT.6x_R2.fastq.gz
cat $indir/*/*$KA*R1*fastq.gz > $outdir/$KA.6x_R1.fastq.gz
cat $indir/*/*$KA*R2*fastq.gz > $outdir/$KA.6x_R2.fastq.gz

