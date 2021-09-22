##Slow commands are marked with # #
###FILTER2: QCmaf AB
###QC="--minDP 3 --max-alleles 2# --min-alleles 2# --minQ 600# 
###--max-missing 0.95# --min-meanDP 8# --max-meanDP 25#"
##maf="--maf 0.01#"
##Allelic Imbalance filtered (via binomial test by filtering out heteroz sites signific =! 50%)
##Outflank-detected outliers : q-value=0.05 He=0.1

#### 1. set up environment ####
print("1. set up environment")
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

qval <- "0_05" #max q-value for analysis
He<- "0_1" # min He for analysis
filter<- "noTAS_noWAI_noCC"

setwd(glue("G:/DATA/WORK/WGS_PIPELINE/2_popgen/16_SNP_analysis_DARTR/210519_3_ADAPTVE_DATASET/q_{qval}_He_{He}_noTAS_WAI_CC"))
dir.create("./results")
vcf_file <- glue("call_set_AGRFlib1_to_6_V2P.rn.QCmaf.AB.adapt_q_{qval}_He_{He}_{filter}.vcf.gz")

#### 2. read vcf file ####
print("2. read vcf file")
vcff <- read.vcfR( vcf_file, verbose = TRUE) #several minutes
vcfR2genlight(vcff, n.cores = 1)->glf #several  #replace gl by glf for gl "file" instead of list

#### 3. basic stats ####
print("3. basic stats")
print(glf)
##166924
print(glue("{nPop(glf)} populations"))
##0    #after:13
print(glf@ind.names)

####4. assign populations####
print("4. assign populations")

##use this command to rename if it was not done before
#gsub("/nfs/scratch/papayv/Tarakihi/popgen/09_markdups/lib[0-9]/bamfiles/aln_pe_","",glf@ind.names)->glf@ind.names

gsub("[0-9]","", glf@ind.names)->pops_grouped
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

glf->glf_grouped
pops_grouped->pop(glf_grouped)
print(glf_grouped)
print(glue("{nPop(glf_grouped)} populations"))

#### 5. remove low sampled populations, KTAR and TAS ####
print("5. remove filtered pops, delete monomorphic loci")
glf_nosmall<- gl.drop.pop(glf_grouped,
                         pop.list=c("04.TBGBJ","07.FRDL","16.CHAT",
                                    "GBK","18.KTAR","17.TAS","11.WAI","09.CC"),
                         recalc=T,mono.rm=T,verbose=5)
#165 pops left
print(glf_nosmall)
print(pop(glf_nosmall))
print(levels(pop(glf_nosmall)))

####6. perform PCA #####
print("perform PCA")

pca_nosmall <- gl.pcoa(glf_nosmall, nfactors=5) #~1h

png(glue("./results/barplot.png"), width = 6, height = 4, units = "in",res=300)
barplot(pca_nosmall$eig/sum(pca_nosmall$eig)*100)
dev.off()
pdf(glue("./results/barplot.pdf"), width = 6, height = 4)
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

pop(glf_nosmall)->locations

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
#gl.pcoa.plot(pca_nosmall, glf_nosmall, labels="pop", xaxis=1, yaxis=2)
##dev.print(pdf, paste0('pc1gr_a12.pdf'))
##dev.print(png, paste0('pc1gr_a12.png'),width = 1024, height = 768)
###ind labels
#gl.pcoa.plot(pca_nosmall, glf_nosmall, labels="ind", xaxis=1, yaxis=2)
##dev.print(pdf, paste0('pc1gr_a12_ind.pdf'))
##dev.print(png, paste0('pc1gr_a12_ind.png'),width = 1024, height = 768)
###ellipses
#gl.pcoa.plot(pca_nosmall, glf_nosmall, labels="pop", xaxis=1, yaxis=2,ellipse=T)
##dev.print(pdf, paste0('pc1gr_a12.pdf'))
##dev.print(png, paste0('pc1gr_a12_ellipse.png'),width = 1024, height = 768)
###axes3_4
###pop
#gl.pcoa.plot(pca_nosmall, glf_nosmall, labels="pop", xaxis=3, yaxis=4)
#dev.print(pdf, paste0('pc1_a34.pdf'))
##dev.print(png, paste0('pc1gr_a34.png'),width = 1024, height = 768)
###ellipse
#gl.pcoa.plot(pca_nosmall, glf_nosmall, labels="pop", xaxis=3, yaxis=4,ellipse=T)
#dev.print(pdf, paste0('pc1_a34_ellipse.pdf'))
##dev.print(png, paste0('pc1gr_a34_ellipse.png'),width = 1024, height = 768)

####8. Calculate FST####
print("8. Calculate FST")

pwfst_nosmall <-stamppFst(glf_nosmall, nboots=1000, percent=95, nclusters=1) #~1h
write.table(pwfst_nosmall$Fsts,file="./results/pwfstgr_Fst.txt")
write.table(pwfst_nosmall$Pvalues,file="./results/pwfstgr_pvalues.txt")

#### 9. DAPC not pre-defined populations ####
print("DAPC")
find.clusters(glf_nosmall,max.n.clust=14, 
n.pca=150, n.clust=5)->clusters
#BIC is lowest at 2. I chose 6 because there are 5 TAR managements+TAS in the samples
#I think I will need to re-run clusters on gr_nosmall. But no need to re-run dapc1
#Keep all the PCs, there is no downside: (200 to put more)I chose 150)
#we chose 15 clusters but could be more
#With preset parameters:
#find.clusters(glf_nosmall),max.n.clust=100, 
#n.pca=150, n.clust=5)->clusters

print(table(pop(glf_nosmall), clusters$grp))
png(glue("./results/dapc_clusters.png"), width = 6, height = 4, units = "in",res=300)
table.value(table(pop(glf_nosmall), clusters$grp), col.lab=paste("inf", 1:15),
            row.lab=rownames(table(pop(glf_nosmall), clusters$grp)))
dev.off()

pdf(glue("./results/dapc_clusters.pdf"))
table.value(table(pop(glf_nosmall), clusters$grp), col.lab=paste("inf", 1:15),
            row.lab=rownames(table(pop(glf_nosmall), clusters$grp)))
dev.off()


dapc1 <- dapc(glf_nosmall, clusters$grp,
n.pca=50, n.da=4) #~1h
#We want to retain a minimum of PCs: keep 50
#Keep 14 eigenvalues
### pot DAPC 1:2 ###
png(glue("./results/dapc_12.png"), width = 6, height = 4, units = "in",res=300)
scatter(dapc1, cell = 0, pch = 18:23, cstar = 0,
        mstree = TRUE, lwd = 2, lty = 2)
dev.off()

png(glue("./results/dapc_23.png"), width = 6, height = 4, units = "in",res=300)
scatter(dapc1, cell = 0, pch = 18:23, cstar = 0, xax=2, yax=3,
        mstree = TRUE, lwd = 2, lty = 2)
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
           "2"="#86004e",
           "3"="#c07700",
           "4"="#027bcb",
           "7"="black",
           "5"="#ea6d33",
           "9"="#027bcb")

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

