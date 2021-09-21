

#Copy and rename files 
cd /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/maker/BMdn_rnd1.maker.output/augustus/BMdn_rnd1/run_actinopterygii_odb10/augustus_output/
cp -r retraining_parameters retraining_parameters_renamed
cd /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BM/maker/BMdn_rnd1.maker.output/augustus/BMdn_rnd1/run_actinopterygii_odb10/augustus_output/retraining_parameters_renamed/BUSCO_BMdn_rnd1/

ls -1

mv BUSCO_BMdn_rnd1_exon_probs.pbl Blue_Moki_exon_probs.pbl
mv BUSCO_BMdn_rnd1_igenic_probs.pbl Blue_Moki_igenic_probs.pbl
mv BUSCO_BMdn_rnd1_intron_probs.pbl Blue_Moki_intron_probs.pbl
mv BUSCO_BMdn_rnd1_metapars.cfg Blue_Moki_metapars.cfg
mv BUSCO_BMdn_rnd1_metapars.cgp.cfg Blue_Moki_metapars.cgp.cfg
mv BUSCO_BMdn_rnd1_metapars.utr.cfg Blue_Moki_metapars.utr.cfg
mv BUSCO_BMdn_rnd1_parameters.cfg Blue_Moki_parameters.cfg
mv BUSCO_BMdn_rnd1_parameters.cfg.orig1 Blue_Moki_parameters.cfg.orig1
mv BUSCO_BMdn_rnd1_weightmatrix.txt Blue_Moki_weightmatrix.txt

#rename the files cited within certain HMM configuration files.
sed -i 's/BUSCO_BMdn_rnd1/Blue_Moki/g' Blue_Moki_parameters.cfg
sed -i 's/BUSCO_BMdn_rnd1/Blue_Moki/g' Blue_Moki_parameters.cfg.orig1

#Finally, we must copy these into the $AUGUSTUS_CONFIG_PATH species HMM location so they are accessible by Augustus and MAKER.
#Use the same Augustus config path as the BUSCO script
AUGUSTUS_CONFIG_PATH=/nfs/scratch/papayv/Tarakihi/TARdn/08_Assembly_stats/augustus/config/
mkdir $AUGUSTUS_CONFIG_PATH/species/Blue_Moki
cp Blue_Moki*  $AUGUSTUS_CONFIG_PATH/species/Blue_Moki/

