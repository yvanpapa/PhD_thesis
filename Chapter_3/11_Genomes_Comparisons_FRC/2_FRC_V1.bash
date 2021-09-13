#!/bin/bash
#SBATCH --job-name=frc
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=2G
#SBATCH --partition=quicktest
#SBATCH --time=1:00:00
#SBATCH -o /nfs/scratch/papayv/Tarakihi/TARdn/8C_Genomes_Comparisons_FRC/V1/%j_job_out
#SBATCH -e /nfs/scratch/papayv/Tarakihi/TARdn/8C_Genomes_Comparisons_FRC/V1/%j_job_err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=yvan.papa@vuw.ac.nz

#conda activate frc

dir=/nfs/scratch/papayv/Tarakihi/TARdn/8C_Genomes_Comparisons_FRC
assembly_version=V1
bamfile=aln_pe_TARdn_V1.bam

FRC --pe-sam $dir/$assembly_version/bamfiles/$bamfile \
--pe-max-insert 400 \
--genome-size 520459122 \
--output FRC_V1


#--pe-sam arg: paired end alignment file (in sam or bam format).
# --pe-max-insert arg: maximum allowed insert size for PE (to filter out outleyers)
#estimated genome size (if not supplied genome size is believed to be assembly length)


#--pe-min-insert does not exist anymore
#--mp-sam A_tool1_MP_lib.bam #--mp-min-insert MIN_MP_INS --mp-max-insert MAX_MP_INS only for mate pair reads