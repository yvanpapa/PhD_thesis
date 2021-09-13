

#Copy and rename files 
cd /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/maker/TRIAL2_TARdn_V2P/TARdn_V2P_rnd1.maker.output/augustus/round1/run_TARdn_V2P_rnd1.maker/augustus_output/
cp retraining_parameters/ retraining_parameters_renamed/
cp retraining_parameters/* retraining_parameters_renamed/
cd /nfs/scratch/papayv/Tarakihi/TARdn/11_genome_annotation/maker/TRIAL2_TARdn_V2P/TARdn_V2P_rnd1.maker.output/augustus/round1/run_TARdn_V2P_rnd1.maker/augustus_output/retraining_parameters_renamed/

ls -1

mv BUSCO_TARdn_V2P_rnd1.maker_3588704500_exon_probs.pbl Tarakihi_exon_probs.pbl
mv BUSCO_TARdn_V2P_rnd1.maker_3588704500_igenic_probs.pbl Tarakihi_igenic_probs.pbl
mv BUSCO_TARdn_V2P_rnd1.maker_3588704500_intron_probs.pbl Tarakihi_intron_probs.pbl
mv BUSCO_TARdn_V2P_rnd1.maker_3588704500_metapars.cfg Tarakihi_metapars.cfg
mv BUSCO_TARdn_V2P_rnd1.maker_3588704500_metapars.cgp.cfg Tarakihi_metapars.cgp.cfg
mv BUSCO_TARdn_V2P_rnd1.maker_3588704500_metapars.utr.cfg Tarakihi_metapars.utr.cfg
mv BUSCO_TARdn_V2P_rnd1.maker_3588704500_parameters.cfg Tarakihi_parameters.cfg
mv BUSCO_TARdn_V2P_rnd1.maker_3588704500_parameters.cfg.orig1 Tarakihi_parameters.cfg.orig1
mv BUSCO_TARdn_V2P_rnd1.maker_3588704500_weightmatrix.txt Tarakihi_weightmatrix.txt

#rename the files cited within certain HMM configuration files.
sed -i 's/BUSCO_TARdn_V2P_rnd1.maker_3588704500/Tarakihi/g' Tarakihi_parameters.cfg
sed -i 's/BUSCO_TARdn_V2P_rnd1.maker_3588704500/Tarakihi/g' Tarakihi_parameters.cfg.orig1

#Finally, we must copy these into the $AUGUSTUS_CONFIG_PATH species HMM location so they are accessible by Augustus and MAKER.
#Use the same Augustus config path as the BUSCO script
AUGUSTUS_CONFIG_PATH=/nfs/scratch/papayv/Tarakihi/TARdn/08_Assembly_stats/augustus/config/
mkdir $AUGUSTUS_CONFIG_PATH/species/Tarakihi
cp Tarakihi*  $AUGUSTUS_CONFIG_PATH/species/Tarakihi/