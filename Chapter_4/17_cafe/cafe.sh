#interactive srun for CAFE

#manual here: https://github.com/hahnlab/CAFE/blob/master/docs/cafe_manual.pdf
#tutorial here: http://evomicsorg.wpengine.netdna-cdn.com/wp-content/uploads/2016/06/cafe_tutorial-1.pdf
#python scripts found on cafe github

#The necessary inputs for CAFE are:
#1 a data file containing gene family sizes for the taxa included in the phylogenetic tree
#2 a Newick formatted phylogenetic tree, including branch lengths

#For 1, get the orthofinder report file in:
#/nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/20_orthofinder/1_2_proteomes/all_teleost/primary_transcripts/OrthoFinder/Results_Jun21/Orthogroups/Orthogroups.GeneCount.tsv
#Modify manually to get something like that: https://iu.app.box.com/v/cafetutorial-files/file/150464645357
#For 2, get the tree here: /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/22_paml/teleosts_test1/run1/FigTree.tre
#And save it as a newick file (with e.g. Figtree) #carefuk: we lose the node ages CI by doing this

cd /nfs/scratch/papayv/Tarakihi/TARdn/Z_fish_assemblies/23_cafe/

srun --partition quicktest --pty --cpus-per-task 12 --time 05:00:00 --mem 24G bash
source activate cafe

#Gene families that have large
#gene copy number variance can cause parameter estimates to be non-informative. You
#can remove gene families with large variance from your dataset, but we found that
#putting aside the gene families in which one or more species have ≥ 100 gene copies does the trick
python cafe_tutorial/python_scripts/cafetutorial_clade_and_size_filter.py -i unfiltered_cafe_input.txt -o filtered_cafe_input.txt -s

mkdir -p reports
cafe
#1)  Estimating the birth-death parameter λ
load -i filtered_cafe_input.txt -t 12 -l reports/log_run1.txt
#load Data file & run parameters
#-i filename : Enter the path to the file containing gene family data.
#-l filename : Enter the path to the file where CAFE will write the main output.
tree ((ENSDARG:2.13018,((ENSONIG:1.0107,(ENSORLG:0.802023,ENSXMAG:0.802023):0.208677):0.114004,((BARdnRA:0.463653,KAdnRA:0.463653):0.525459,((BTdnRA:0.836501,(ENSTRUG:0.386719,ENSTNIG:0.386719):0.449782):0.078045,(ENSGACG:0.8344,(BMdnRA:0.195632,(TARdnRA:0.046791,KTARdnRA:0.046791):0.148841):0.638767):0.080146):0.074567):0.135591):1.005476):0.530423,ENSLOCG:2.660603)
lambda -s #~10 sec
#lambda Find/specify birth-death parameter
#-s: CAFE will search using an optimization algorithm to find the value(s) of λ
#that maximize the log likelihood of the data for all families.
report reports/report_run1 #~1-2 min
#summarise results
CTRL+C #necessary to quit CAFE terminal to use python script
python cafe_tutorial/python_scripts/cafetutorial_report_analysis.py -i reports/report_run1.cafe -o reports/summary_run1
#les résultats qui nous intéressent sont dans reports/summary_run1_node.txt

#plot tree of rapid evolving gene families: DOES NOT WORK WITH THE CURRENT CONDA INSTALLATION: ImportError: No module named Bio
#python cafe_tutorial/python_scripts/cafetutorial_draw_tree.py -i reports/summary_run1_node.txt \
#-t '((ENSDARG:2.13018,((ENSONIG:1.0107,(ENSORLG:0.802023,ENSXMAG:0.802023):0.208677):0.114004,((BARdnRA:0.463653,KAdnRA:0.463653):0.525459,((BTdnRA:0.836501,(ENSTRUG:0.386719,ENSTNIG:0.386719):0.449782):0.078045,(ENSGACG:0.8344,(BMdnRA:0.195632,(TARdnRA:0.046791,KTARdnRA:0.046791):0.148841):0.638767):0.080146):0.074567):0.135591):1.005476):0.530423,ENSLOCG:2.660603)' \
#-d '((ENSDARG<0>,((ENSONIG<2>,(ENSORLG<4>,ENSXMAG<6>)<5>)<3>,((BARdnRA<8>,KAdnRA<10>)<9>,((BTdnRA<12>,(ENSTRUG<14>,ENSTNIG<16>)<15>)<13>,(ENSGACG<18>,(BMdnRA<20>,(TARdnRA<22>,KTARdnRA<24>)<23>)<21>)<19>)<17>)<11>)<7>)<1>,ENSLOCG<26>)<25>' \
#-o reports/summary_run1_tree_rapid.png -y Rapid
#-d: copy the line: #IDs of nodes in reports/report_run1.cafe

#As described in section 2.2.4, families with high variance in gene copy number can lead
#to non-informative parameter estimates, so we had to set them aside. 
#We can now analyse them with the λ estimate obtained from the other gene families 









