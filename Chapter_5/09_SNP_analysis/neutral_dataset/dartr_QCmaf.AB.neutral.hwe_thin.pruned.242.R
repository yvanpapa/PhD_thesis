##Slow commands are marked with # #
###FILTER2: QCmaf AB
###QC="--minDP 3 --max-alleles 2# --min-alleles 2# --minQ 600# 
###--max-missing 0.95# --min-meanDP 8# --max-meanDP 25#"
##maf="--maf 0.01#"
##Allelic Imbalance filtered (via binomial test by filtering out heteroz sites signific =! 50%)
##Outflank-detected outliers removed
##--hwe 0.05 --maf 0.01 --thin 1500
##LD pruned

#### 1. set up environment ####
print("1. set up environment")

setwd("G:/DATA/WORK/WGS_PIPELINE/2_popgen/16_SNP_analysis_DARTR/210514_2_NEUTRAL_DATASET")
library("vcfR")      #to read vcf
##https://cran.r-project.org/web/packages/vcfR/vignettes/intro_to_vcfR.html
library("pegas")     #to convert vcf in genlight
##BiocManager::install(c("SNPRelate", "qvalue")) # necessary for dartR
library("dartR")     #for analyses
##https://cran.r-project.org/web/packages/dartR/vignettes/IntroTutorial_dartR.pdf
library("ape") #for reference fasta genome
library("plotly") #for gl.pcoa.plot
library("ggplot2")
library("ggthemes")
library("glue")
library("StAMPP") #for stamppFst 
library("adegenet") #for DAPC

# Does not work with 7 millions SNPs, too heavy: cannot allocate vector of size 10.6 Gb
vcf_file <- "G:/DATA/WORK/WGS_PIPELINE/2_popgen/16_SNP_analysis_DARTR/210514_2_NEUTRAL_DATASET/call_set_AGRFlib1_to_6_V2P.rn.QCmaf.AB.neutral.hwe_thin.pruned.242.vcf.gz"

#### 2. read vcf file ####
print("2. read vcf file")
# #vcf <- read.vcfR( vcf_file, verbose = TRUE) #several minutes
# #vcfR2genlight(vcf, n.cores = 1)->gl #several minutes

#### 3. basic stats ####
print("3. basic stats")
print(gl)
##166924
print(glue("{nPop(gl)} populations"))
##0    #after:13
print(gl@ind.names)

####4. assign populations####
print("4. assign populations")

##use this command to rename if it was not done before
#gsub("/nfs/scratch/papayv/Tarakihi/popgen/09_markdups/lib[0-9]/bamfiles/aln_pe_","",gl@ind.names)->gl@ind.names

gsub("[0-9]","", gl@ind.names)->pops_grouped
gsub(".markdup.bam","",pops_grouped)->pops_grouped
sub("_","",pops_grouped)->pops_grouped
sub("_","",pops_grouped)->pops_grouped
sub("_","",pops_grouped)->pops_grouped

pops_grouped[which(pops_grouped=="UWCNI")]
pops_grouped[which(pops_grouped=="UWCNI")]<-"01.UWCNI"
pops_grouped[which(pops_grouped=="NT"|pops_grouped=="TARA")]
pops_grouped[which(pops_grouped=="NT"|pops_grouped=="TARA")]<-"02.TARA"
pops_grouped[which(pops_grouped=="TBGB")]
pops_grouped[which(pops_grouped=="TBGB")]<-"03.TBGB"
pops_grouped[which(pops_grouped=="TBGBJ")]
pops_grouped[which(pops_grouped=="TBGBJ")]<-"04.TBGBJ"
pops_grouped[which(pops_grouped=="SPWCSI")]
pops_grouped[which(pops_grouped=="SPWCSI")]<-"05.UWCSI"
pops_grouped[which(pops_grouped=="WCSI")]
pops_grouped[which(pops_grouped=="WCSI")]<-"06.LWCSI"
pops_grouped[which(pops_grouped=="FRDL")]
pops_grouped[which(pops_grouped=="FRDL")]<-"07.FRDL"
pops_grouped[which(pops_grouped=="CHCH")]
pops_grouped[which(pops_grouped=="CHCH")]<-"08.CHCH"
pops_grouped[which(pops_grouped=="SPCC")]
pops_grouped[which(pops_grouped=="SPCC")]<-"09.CC"
pops_grouped[which(pops_grouped=="WGTN")]
pops_grouped[which(pops_grouped=="WGTN")]<-"10.WGTN"
pops_grouped[which(pops_grouped=="WAI")]
pops_grouped[which(pops_grouped=="WAI")]<-"11.WAI"
pops_grouped[which(pops_grouped=="HB"|pops_grouped=="NAP")]
pops_grouped[which(pops_grouped=="HB"|pops_grouped=="NAP")]<-"12.HB"
pops_grouped[which(pops_grouped=="SPGB"|pops_grouped=="SPEC"|pops_grouped=="GB"|pops_grouped=="EC")]
pops_grouped[which(pops_grouped=="SPGB"|pops_grouped=="SPEC"|pops_grouped=="GB"|pops_grouped=="EC")]<-"13.EC"
pops_grouped[which(pops_grouped=="ENHG")]
pops_grouped[which(pops_grouped=="ENHG")]<-"14.ENHG"
pops_grouped[which(pops_grouped=="ENLD")]
pops_grouped[which(pops_grouped=="ENLD")]<-"15.ENLD"
pops_grouped[which(pops_grouped=="CHAT")]
pops_grouped[which(pops_grouped=="CHAT")]<-"16.CHAT"
pops_grouped[which(pops_grouped=="AU")]
pops_grouped[which(pops_grouped=="AU")]<-"17.TAS"
pops_grouped[which(pops_grouped=="KTAR")]
pops_grouped[which(pops_grouped=="KTAR")]<-"18.KTAR"

as.factor(pops_grouped)->pops_grouped
print(sort(pops_grouped))
print(levels(pops_grouped))

gl->gl_grouped
pops_grouped->pop(gl_grouped)
print(gl_grouped)
print(glue("{nPop(gl_grouped)} populations"))

#### 5. remove low sampled populations and KTAR ####
print("5. remove low sampled populations and KTAR, delete monomorphic loci")
print("remove 04.TBGBJ,07.FRDL,16.CHAT,GBK,18.KTAR")
gl_nosmall<- gl.drop.pop(gl_grouped,
                         pop.list=c("04.TBGBJ","07.FRDL","16.CHAT","GBK","18.KTAR"),
                         recalc=T,mono.rm=T,verbose=5)
#165 pops left
print(gl_nosmall)
print(pop(gl_nosmall))
print(levels(pop(gl_nosmall)))

####6. perform PCA #####
print("perform PCA")

# #pca_nosmall <- gl.pcoa(gl_nosmall, nfactors=5) #~1h

png(glue("./results/barplot.png"), width = 6, height = 4, units = "in",res=300)
barplot(pca_nosmall$eig/sum(pca_nosmall$eig)*100)
dev.off()
pdf(glue("./results/barplot.pdf"),width = 6, height = 4)
barplot(pca_nosmall$eig/sum(pca_nosmall$eig)*100)
dev.off()

#### 7. plot PCA ####
#calculate projected inertia#
axis1<-pca_nosmall$eig[1]/sum(pca_nosmall$eig)*100
axis1<-paste0("PC1: ",round(axis1,digits=2),"%")
axis2<-pca_nosmall$eig[2]/sum(pca_nosmall$eig)*100
axis2<-paste0("PC2: ",round(axis2,digits=2),"%")
axis3<-pca_nosmall$eig[3]/sum(pca_nosmall$eig)*100
axis3<-paste0("PC3: ",round(axis3,digits=2),"%")
axis4<-pca_nosmall$eig[4]/sum(pca_nosmall$eig)*100
axis4<-paste0("PC4: ",round(axis4,digits=2),"%")

pop(gl_nosmall)->locations

###list of colours color blind-friendly obtained from  Iwanthue https://medialab.github.io/iwanthue/)
#color palette

colors<-c("01.UWCNI"="#006c31",
       "02.TARA"="#ff8bc3",
       "03.TBGB"="#ddc637",
       "04.TBGBJ"="#86004e",
       "05.UWCSI"="#019953",
       "06.LWCSI"="#7e0068",
       "07.FRDL"="#8f6400",
       "08.CHCH"="#42006b",
       "09.CC"="#c07700",
       "10.WGTN"="#e9b1ff",
       "11.WAI"="#68a825",
       "12.HB"="#b664d9",
       "13.EC"="#70ec8f",
       "14.ENHG"="#a6002c",
       "15.ENLD"="#6284ff",
       "16.CHAT"="#703300",
       "17.TAS"="#027bcb",
       "18.KTAR"="#ea6d33",
       "GBK"="#ff7987")

plot <- ggplot()+ coord_fixed()+geom_hline(yintercept=0, col="darkgrey")+
  geom_vline(xintercept=0, col="darkgrey") 

PCA.dfs <- data.frame(pca_nosmall$scores,locations)

####7.1 axes 1:2 ####
pca.plot12<-plot + geom_point(data=PCA.dfs[,1:2],shape=21,size=2,
                              color="black",aes(x=PC1, y=PC2,
                                                fill=locations))+
  stat_ellipse(aes(x=PCA.dfs$PC1, y=PCA.dfs$PC2,color=locations),
               type="norm",size=0.5)+
  labs(x=axis1, y=axis2)+
theme(panel.grid.major = element_blank(), 
panel.grid.minor = element_blank(),
panel.background = element_blank(), 
line = element_line(colour = "black"),
panel.border=element_rect(colour = "black",fill=NA))+
  scale_fill_manual(values=colors)+scale_color_manual(values=colors)

png(glue("./results/pca_a12.png"), width = 6, height = 4, units = "in",res=300)
pca.plot12
dev.off()
pdf(glue("./results/pca_a12.pdf"))
pca.plot12
dev.off()

####7.2 axes 2:3 ####
pca.plot23<-plot + geom_point(data=PCA.dfs[,2:3],shape=21,size=2,
                              color="black",aes(x=PC2, y=PC3,
                                                fill=locations))+
  stat_ellipse(aes(x=PCA.dfs$PC2, y=PCA.dfs$PC3,color=locations),
               type="norm",size=0.5)+
  labs(x=axis2, y=axis3)+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        line = element_line(colour = "black"),
        panel.border=element_rect(colour = "black",fill=NA))+
  scale_fill_manual(values=colors)+scale_color_manual(values=colors)

png(glue("./results/pca_a23.png"), width = 6, height = 4, units = "in",res=300)
pca.plot23
dev.off()
pdf(glue("./results/pca_a23.pdf"))
pca.plot23
dev.off()


####7.3 axes 3:4 ####
pca.plot34<-plot + geom_point(data=PCA.dfs[,3:4],shape=21,size=2,
                              color="black",aes(x=PC3, y=PC4,
                                                fill=locations))+
  stat_ellipse(aes(x=PCA.dfs$PC3, y=PCA.dfs$PC4,color=locations),
               type="norm",size=0.5)+
  labs(x=axis3, y=axis4)+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        line = element_line(colour = "black"),
        panel.border=element_rect(colour = "black",fill=NA))+
  scale_fill_manual(values=colors)+scale_color_manual(values=colors)

png(glue("./results/pca_a34.png"), width = 6, height = 4, units = "in",res=300)
pca.plot34
dev.off()
pdf(glue("./results/pca_a34.pdf"))
pca.plot34
dev.off()

#### if you want to plot PCAs with adegenet ####
##axes1_2
#gl.pcoa.plot(pca_nosmall, gl_nosmall, labels="pop", xaxis=1, yaxis=2)
##dev.print(pdf, paste0('pc1gr_a12.pdf'))
##dev.print(png, paste0('pc1gr_a12.png'),width = 1024, height = 768)
###ind labels
#gl.pcoa.plot(pca_nosmall, gl_nosmall, labels="ind", xaxis=1, yaxis=2)
##dev.print(pdf, paste0('pc1gr_a12_ind.pdf'))
##dev.print(png, paste0('pc1gr_a12_ind.png'),width = 1024, height = 768)
###ellipses
#gl.pcoa.plot(pca_nosmall, gl_nosmall, labels="pop", xaxis=1, yaxis=2,ellipse=T)
##dev.print(pdf, paste0('pc1gr_a12.pdf'))
##dev.print(png, paste0('pc1gr_a12_ellipse.png'),width = 1024, height = 768)
###axes3_4
###pop
#gl.pcoa.plot(pca_nosmall, gl_nosmall, labels="pop", xaxis=3, yaxis=4)
#dev.print(pdf, paste0('pc1_a34.pdf'))
##dev.print(png, paste0('pc1gr_a34.png'),width = 1024, height = 768)
###ellipse
#gl.pcoa.plot(pca_nosmall, gl_nosmall, labels="pop", xaxis=3, yaxis=4,ellipse=T)
#dev.print(pdf, paste0('pc1_a34_ellipse.pdf'))
##dev.print(png, paste0('pc1gr_a34_ellipse.png'),width = 1024, height = 768)

####8. Calculate FST####
print("8. Calculate FST")

# #pwfst_nosmall <-stamppFst(gl_nosmall, nboots=100, percent=95, nclusters=1) #~1h
write.table(pwfst_nosmall$Fsts,file="./results/pwfstgr_Fst.txt")
write.table(pwfst_nosmall$Pvalues,file="./results/pwfstgr_pvalues.txt")


#### 9. DAPC not pre-defined populations ####
print("DAPC")
# #find.clusters(gl_nosmall,max.n.clust=100, 
# #n.pca=150, n.clust=15)->clusters #>1h
#I think I will need to re-run clusters on gr_nosmall. But no need to re-run dapc1
#Keep all the PCs, there is no downside: (200 to put more)I chose 150)
#we chose 15 clusters but could be more

print(table(pop(gl_nosmall), clusters$grp))
png(glue("./results/dapc_clusters.png"), width = 6, height = 4, units = "in",res=300)
table.value(table(pop(gl_nosmall), clusters$grp), col.lab=paste("inf", 1:15),
            row.lab=rownames(table(pop(gl_nosmall), clusters$grp)))
dev.off()
pdf(glue("./results/dapc_clusters.pdf"))
table.value(table(pop(gl_nosmall), clusters$grp), col.lab=paste("inf", 1:15),
            row.lab=rownames(table(pop(gl_nosmall), clusters$grp)))
dev.off()


# #dapc1 <- dapc(gl_nosmall, clusters$grp,
# #n.pca=50, n.da=14) #~1h
#We want to retain a minimum of PCs: keep 50
#Keep 14 eigenvalues
### pot DAPC 1:2 ###
png(glue("./results/dapc_12.png"), width = 6, height = 4, units = "in",res=300)
scatter(dapc1, cell = 0, pch = 18:23, cstar = 0,
        mstree = TRUE, lwd = 2, lty = 2)
dev.off()
pdf(glue("./results/dapc_12.pdf"))
scatter(dapc1, cell = 0, pch = 18:23, cstar = 0,
        mstree = TRUE, lwd = 2, lty = 2)
dev.off()

png(glue("./results/dapc_23.png"), width = 6, height = 4, units = "in",res=300)
scatter(dapc1, cell = 0, pch = 18:23, cstar = 0, xax=2, yax=3,
        mstree = TRUE, lwd = 2, lty = 2)
dev.off()
pdf(glue("./results/dapc_23.pdf"))
scatter(dapc1, cell = 0, pch = 18:23, cstar = 0, xax=2, yax=3,
        mstree = TRUE, lwd = 2, lty = 2)
dev.off()


#### Report some statistics ####

#Need to set ploidy first or it does not work
ploidy(gl_nosmall)<-2
gl.report.heterozygosity(gl_nosmall,method = "pop")->stats_Het_pop
write.table(stats_Het_pop,quote = F,row.names = F, 
file="G:/DATA/WORK/WGS_PIPELINE/2_popgen/17_Statistics/call_set_AGRFlib1_to_6_V2P.rn.QCmaf.AB.neutral.hwe_thin.pruned.242.het_pop_dartr")

gl.report.heterozygosity(gl_nosmall,method = "ind")->stats_Het_ind
write.table(stats_Het_ind,quote = F,row.names = F, 
file="G:/DATA/WORK/WGS_PIPELINE/2_popgen/17_Statistics/call_set_AGRFlib1_to_6_V2P.rn.QCmaf.AB.neutral.hwe_thin.pruned.242.het_ind_dartr")

####!!!  the loci that are invariant across all individuals in the dataset (that is, across populations),
#is typically unknown. This can render estimates of heterozygosity analysis specific, and so it is not
#valid to compare such estimates across species or even across different analyses.

gl.report.pa(gl_nosmall)->stats_fixed_alleles
write.table(stats_fixed_alleles,quote = F,row.names = F, 
            file="G:/DATA/WORK/WGS_PIPELINE/2_popgen/17_Statistics/call_set_AGRFlib1_to_6_V2P.rn.QCmaf.AB.neutral.hwe_thin.pruned.242.fixed_alleles")

pops_grouped[which(pops_grouped!="18.KTAR")]
pops_grouped[which(pops_grouped=="KTAR")]<-"18.KTAR"
pops_grouped->pops_TARKTAR
levels(pops_TARKTAR)<-c(levels(pops_TARKTAR),"TAR")
pops_TARKTAR[which(pops_TARKTAR!="18.KTAR" & pops_TARKTAR!="GBK")]<-"TAR"
print(sort(pops_TARKTAR))
print(levels(pops_TARKTAR))
gl_grouped->gl_TARKTAR
pops_TARKTAR->pop(gl_TARKTAR)
print(gl_TARKTAR)
print(glue("{nPop(gl_TARKTAR)} populations"))

ploidy(gl_TARKTAR)<-2
gl.report.pa(gl_TARKTAR)->stats_fixed_alleles_TARKTAR
write.table(gl.report.pa,quote = F,row.names = F, 
            file="G:/DATA/WORK/WGS_PIPELINE/2_popgen/17_Statistics/call_set_AGRFlib1_to_6_V2P.rn.QCmaf.AB.neutral.hwe_thin.pruned.242.fixed_alleles")



#####10. remove TAS #######
print("10. remove TAS ")
gl_noTAS<- gl.drop.pop(gl_grouped,
                       pop.list=c("04.TBGBJ","07.FRDL","16.CHAT","GBK","18.KTAR","17.TAS"),
                       recalc=T,mono.rm=T,verbose=5)
#165 pops left
print(gl_noTAS)
print(pop(gl_noTAS))
print(levels(pop(gl_noTAS)))

#####10.1 perform PCA#######
print("10.1 perform PCA")
# #pca_noTAS <- gl.pcoa(gl_noTAS, nfactors=5) #~1h
png(glue("./results/noTAS/barplot.png"), width = 6, height = 4, units = "in",res=300)
barplot(pca_noTAS$eig/sum(pca_noTAS$eig)*100)
dev.off()


#### 10.2. plot PCA ####
#calculate projected inertia#
axis1_nt<-pca_noTAS$eig[1]/sum(pca_noTAS$eig)*100
axis1_nt<-paste0("PC1: ",round(axis1_nt,digits=2),"%")
axis2_nt<-pca_noTAS$eig[2]/sum(pca_noTAS$eig)*100
axis2_nt<-paste0("PC2: ",round(axis2_nt,digits=2),"%")
axis3_nt<-pca_noTAS$eig[3]/sum(pca_noTAS$eig)*100
axis3_nt<-paste0("PC3: ",round(axis3_nt,digits=2),"%")
axis4_nt<-pca_noTAS$eig[4]/sum(pca_noTAS$eig)*100
axis4_nt<-paste0("PC4: ",round(axis4_nt,digits=2),"%")

pop(gl_noTAS)->locations_nt

PCA.dfs_nt <- data.frame(pca_noTAS$scores,locations_nt)

####10.2.1 axes 1:2 ####
pca.plot12_nt<-plot + geom_point(data=PCA.dfs_nt[,1:2],shape=21,size=2,
                              color="black",aes(x=PC1, y=PC2,
                                                fill=locations_nt))+
  stat_ellipse(aes(x=PCA.dfs_nt$PC1, y=PCA.dfs_nt$PC2,color=locations_nt),
               type="norm",size=0.5)+
  labs(x=axis1, y=axis2)+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        line = element_line(colour = "black"),
        panel.border=element_rect(colour = "black",fill=NA))+
  scale_fill_manual(values=colors)+scale_color_manual(values=colors)

png(glue("./results/noTAS/pca_a12.png"), width = 6, height = 4, units = "in",res=300)
pca.plot12_nt
dev.off()

####10.2.2 axes 2:3 ####
pca.plot23_nt<-plot + geom_point(data=PCA.dfs_nt[,2:3],shape=21,size=2,
                              color="black",aes(x=PC2, y=PC3,
                                                fill=locations_nt))+
  stat_ellipse(aes(x=PCA.dfs_nt$PC2, y=PCA.dfs_nt$PC3,color=locations_nt),
               type="norm",size=0.5)+
  labs(x=axis2, y=axis3)+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        line = element_line(colour = "black"),
        panel.border=element_rect(colour = "black",fill=NA))+
  scale_fill_manual(values=colors)+scale_color_manual(values=colors)

png(glue("./results/noTAS/pca_a23.png"), width = 6, height = 4, units = "in",res=300)
pca.plot23_nt
dev.off()

####10.2.3 axes 3:4 ####
pca.plot34_nt<-plot + geom_point(data=PCA.dfs_nt[,3:4],shape=21,size=2,
                              color="black",aes(x=PC3, y=PC4,
                                                fill=locations_nt))+
  stat_ellipse(aes(x=PCA.dfs_nt$PC3, y=PCA.dfs_nt$PC4,color=locations_nt),
               type="norm",size=0.5)+
  labs(x=axis3, y=axis4)+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        line = element_line(colour = "black"),
        panel.border=element_rect(colour = "black",fill=NA))+
  scale_fill_manual(values=colors)+scale_color_manual(values=colors)

png(glue("./results/noTAS/pca_a34.png"), width = 6, height = 4, units = "in",res=300)
pca.plot34_nt
dev.off()

####ggplot DAPC####

png(glue("./results/barplot_dapc.png"), width = 6, height = 4, units = "in",res=300)
barplot(dapc1$eig/sum(dapc1$eig)*100)
dev.off()
pdf(glue("./results/barplotdapc.pdf"), width = 6, height = 4)
barplot(dapc1$eig/sum(dapc1$eig)*100)
dev.off()

#calculate projected inertia#
daxis1<-dapc1$eig[1]/sum(dapc1$eig)*100
daxis1<-paste0("LD1: ",round(daxis1,digits=2),"%")
daxis2<-dapc1$eig[2]/sum(dapc1$eig)*100
daxis2<-paste0("LD2: ",round(daxis2,digits=2),"%")
daxis3<-dapc1$eig[3]/sum(dapc1$eig)*100
daxis3<-paste0("LD3: ",round(daxis3,digits=2),"%")
daxis4<-dapc1$eig[4]/sum(dapc1$eig)*100
daxis4<-paste0("LD4: ",round(daxis4,digits=2),"%")

dapc1$assign->groups

###list of colours color blind-friendly obtained from  Iwanthue https://medialab.github.io/iwanthue/)
#color palette

dcolors<-c("1"="#006c31",
          "2"="#ff8bc3",
          "3"="#ddc637",
          "4"="#86004e",
          "5"="#019953",
          "6"="#7e0068",
          "7"="#8f6400",
          "8"="#42006b",
          "9"="#c07700",
          "10"="#e9b1ff",
          "11"="#68a825",
          "12"="#b664d9",
          "13"="#70ec8f",
          "14"="#a6002c",
          "15"="#6284ff",
          "16"="#703300",
          "17"="#027bcb",
          "18"="#ea6d33",
          "19"="#ff7987")

#### for geom_segment stars####
cbind(dapc1$ind,dapc1$grp)->dapc1_df
colnames(dapc1_df)<-c(colnames(dapc1$ind),"group")
centroids<-cbind(rownames(dapc1$grp.coord),dapc1$grp.coord)
colnames(centroids)<-c("group",colnames(centroids)[-1])
merge(dapc1_df,centroids,by="group")->dapc1_df
df_colors<-cbind(names(dcolors),dcolors)
colnames(df_colors)<-c("group","dcolors")
merge(dapc1_df,df_colors,by="group")->dapc1_df


#plot <- ggplot()+ coord_fixed()+geom_hline(yintercept=0, col="darkgrey")+
#geom_vline(xintercept=0, col="darkgrey") 

DAPC.dfs <- data.frame(dapc1$ind.coord)

####axes 1:2 ####
dapc.plot12<-plot + geom_point(data=DAPC.dfs[,1:2],shape=21,size=2,
                               color="black",aes(x=LD1, y=LD2,
                                                 fill=groups))+
  labs(x=daxis1, y=daxis2)+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        line = element_line(colour = "black"),
        panel.border=element_rect(colour = "black",fill=NA))+
  scale_fill_manual(values=dcolors)+scale_color_manual(values=dcolors)+
  geom_segment(data=dapc1_df,
               aes(x=LD1.x,y=LD2.x,xend=as.numeric(LD1.y),
                   yend=as.numeric(LD2.y),col=as.factor(group)),
               show.legend = FALSE)+
  geom_label(data=as.data.frame(dapc1$grp.coord),
             aes(LD1,LD2,label=rownames(dapc1$grp.coord)))


png(glue("./results/dapc_a12.png"), width = 6, height = 5.5, units = "in",res=350)
dapc.plot12
dev.off()
pdf(glue("./results/dapc_a12.pdf"))
dapc.plot12
dev.off()

#### axes 3 4 ####
dapc.plot34<-plot + geom_point(data=DAPC.dfs[,3:4],shape=21,size=2,
                               color="black",aes(x=LD3, y=LD4,
                                                 fill=groups))+
  labs(x=daxis3, y=daxis4)+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        line = element_line(colour = "black"),
        panel.border=element_rect(colour = "black",fill=NA))+
  scale_fill_manual(values=dcolors)+scale_color_manual(values=dcolors)+
  geom_segment(data=dapc1_df,
               aes(x=LD3.x,y=LD4.x,xend=as.numeric(LD3.y),
                   yend=as.numeric(LD4.y),col=as.factor(group)),
               show.legend = FALSE)+
  geom_label(data=as.data.frame(dapc1$grp.coord),
             aes(LD3,LD4,label=rownames(dapc1$grp.coord)))


png(glue("./results/dapc_a34.png"), width = 6, height = 5.5, units = "in",res=350)
dapc.plot34
dev.off()
pdf(glue("./results/dapc_a34.pdf"))
dapc.plot34
dev.off()

#### if you want to plot PCAs with adegenet ####
##axes1_2
#gl.pcoa.plot(pca_noTAS, gl_noTAS, labels="pop", xaxis=1, yaxis=2)
##dev.print(pdf, paste0('pc1gr_a12.pdf'))
##dev.print(png, paste0('pc1gr_a12.png'),width = 1024, height = 768)
###ind labels
#gl.pcoa.plot(pca_noTAS, gl_noTAS, labels="ind", xaxis=1, yaxis=2)
##dev.print(pdf, paste0('pc1gr_a12_ind.pdf'))
##dev.print(png, paste0('pc1gr_a12_ind.png'),width = 1024, height = 768)
###ellipses
#gl.pcoa.plot(pca_noTAS, gl_noTAS, labels="pop", xaxis=1, yaxis=2,ellipse=T)
##dev.print(pdf, paste0('pc1gr_a12.pdf'))
##dev.print(png, paste0('pc1gr_a12_ellipse.png'),width = 1024, height = 768)
###axes3_4
###pop
#gl.pcoa.plot(pca_noTAS, gl_noTAS, labels="pop", xaxis=3, yaxis=4)
#dev.print(pdf, paste0('pc1_a34.pdf'))
##dev.print(png, paste0('pc1gr_a34.png'),width = 1024, height = 768)
###ellipse
#gl.pcoa.plot(pca_nosmall, gl_noTAS, labels="pop", xaxis=3, yaxis=4,ellipse=T)
#dev.print(pdf, paste0('pc1_a34_ellipse.pdf'))
##dev.print(png, paste0('pc1gr_a34_ellipse.png'),width = 1024, height = 768)

####10.3. Calculate FST####
print("10.3. Calculate FST")

# #pwfst_noTAS <-stamppFst(gl_noTAS, nboots=100, percent=95, nclusters=1) #~1h
write.table(pwfst_noTAS$Fsts,file="./results/noTAS/pwfstgr_Fst.txt")
write.table(pwfst_noTAS$Pvalues,file="./results/noTAS/pwfstgr_pvalues.txt")

#### 10.4. DAPC not pre-defined populations ####
print("DAPC")
# #find.clusters(gl_noTAS,max.n.clust=100, 
# #n.pca=150, n.clust=15)->clusters_noTAS #>1h

#Keep all the PCs, there is no downside: (200 to put more)I chose 150)
#we chose 15 clusters but could be more

print(table(pop(gl_noTAS),clusters_noTAS$grp))
png(glue("./results/noTAS/dapc_clusters.png"), width = 6, height = 4, units = "in",res=300)
table.value(table(pop(gl_noTAS),clusters_noTAS$grp), col.lab=paste("inf", 1:15),
            row.lab=rownames(table(pop(gl_noTAS), clusters_noTAS$grp)))
dev.off()

# #dapc_nt <- dapc(gl_noTAS, clusters_noTAS$grp,
# #n.pca=50, n.da=14) #~1h
#We want to retain a minimum of PCs: keep 50
#Keep 14 eigenvalues
### plot DAPC 1:2 ###
png(glue("./results/noTAS/dapc_12.png"), width = 6, height = 4, units = "in",res=300)
scatter(dapc_nt, cell = 0, pch = 18:23, cstar = 0,
        mstree = TRUE, lwd = 2, lty = 2)
dev.off()

png(glue("./results/noTAS/dapc_23.png"), width = 6, height = 4, units = "in",res=300)
scatter(dapc_nt, cell = 0, pch = 18:23, cstar = 0, xax=2, yax=3,
        mstree = TRUE, lwd = 2, lty = 2)
dev.off()