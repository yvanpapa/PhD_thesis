

#Copy and rename files 
cd /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BT/maker/BTdn_rnd1.maker.output/augustus/BTdn_rnd1/run_actinopterygii_odb10/augustus_output/
cp -r retraining_parameters retraining_parameters_renamed
cd /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/10_genome_annotation/BT/maker/BTdn_rnd1.maker.output/augustus/BTdn_rnd1/run_actinopterygii_odb10/augustus_output/retraining_parameters_renamed/BUSCO_BTdn_rnd1/

ls -1

mv BUSCO_BTdn_rnd1_exon_probs.pbl Butterfish_exon_probs.pbl
mv BUSCO_BTdn_rnd1_igenic_probs.pbl Butterfish_igenic_probs.pbl
mv BUSCO_BTdn_rnd1_intron_probs.pbl Butterfish_intron_probs.pbl
mv BUSCO_BTdn_rnd1_metapars.cfg Butterfish_metapars.cfg
mv BUSCO_BTdn_rnd1_metapars.cgp.cfg Butterfish_metapars.cgp.cfg
mv BUSCO_BTdn_rnd1_metapars.utr.cfg Butterfish_metapars.utr.cfg
mv BUSCO_BTdn_rnd1_parameters.cfg Butterfish_parameters.cfg
mv BUSCO_BTdn_rnd1_parameters.cfg.orig1 Butterfish_parameters.cfg.orig1
mv BUSCO_BTdn_rnd1_weightmatrix.txt Butterfish_weightmatrix.txt

#rename the files cited within certain HMM configuration files.
sed -i 's/BUSCO_BTdn_rnd1/Butterfish/g' Butterfish_parameters.cfg
sed -i 's/BUSCO_BTdn_rnd1/Butterfish/g' Butterfish_parameters.cfg.orig1

#Finally, we must copy these into the $AUGUSTUS_CONFIG_PATH species HMM location so they are accessible by Augustus and MAKER.
#Use the same Augustus config path as the BUSCO script
AUGUSTUS_CONFIG_PATH=/nfs/scratch/papayv/Tarakihi/TARdn/08_Assembly_stats/augustus/config/
mkdir $AUGUSTUS_CONFIG_PATH/species/Butterfish
cp Butterfish*  $AUGUSTUS_CONFIG_PATH/species/Butterfish/

