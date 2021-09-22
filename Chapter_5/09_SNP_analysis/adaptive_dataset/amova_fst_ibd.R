library("dartR")
library("poppr")
library("StAMPP")

library(pheatmap)

setwd("G:/DATA/WORK/WGS_PIPELINE/2_popgen/16_SNP_analysis_DARTR/210519_3_ADAPTVE_DATASET/q_0_05_He_0_1/results")
load("G:/DATA/WORK/WGS_PIPELINE/2_popgen/16_SNP_analysis_DARTR/210519_3_ADAPTVE_DATASET/amova_and_fst_bootstrap_adaptive.R.RData")

#### AMOVA nosmall ####
pop(gl_nosmall)

data.frame(cbind(gl_nosmall@ind.names,as.character(pop(gl_nosmall))))->df_strata

cbind(df_strata,df_strata[,2])->df_strata
colnames(df_strata)<-c("ID","Population","TAR_Area")

df_strata[which(df_strata[,2]=="12.HB"),3]<-"TAR2"
df_strata[which(df_strata[,2]=="02.TARA"),3]<-"TAR8"
df_strata[which(df_strata[,2]=="11.WAI"),3]<-"TAR2"
df_strata[which(df_strata[,2]=="13.EC"),3]<-"TAR2"
df_strata[which(df_strata[,2]=="09.CC"),3]<-"TAR7"
df_strata[which(df_strata[,2]=="05.UWCSI"),3]<-"TAR7"
df_strata[which(df_strata[,2]=="10.WGTN"),3]<-"TAR2"
df_strata[which(df_strata[,2]=="03.TBGB"),3]<-"TAR7"
df_strata[which(df_strata[,2]=="06.LWCSI"),3]<-"TAR7"
df_strata[which(df_strata[,2]=="01.UWCNI"),3]<-"TAR1"
df_strata[which(df_strata[,2]=="14.ENHG"),3]<-"TAR1"
df_strata[which(df_strata[,2]=="15.ENLD"),3]<-"TAR1"
df_strata[which(df_strata[,2]=="17.TAS"),3]<-"AU"
df_strata[which(df_strata[,2]=="08.CHCH" ),3]<-"TAR3"

gl_nosmall_strata <- strata(gl_nosmall, value = df_strata)
head(strata(gl_nosmall_strata, combine = FALSE))

# #poppr.amova(gl_nosmall_strata,~TAR_Area/Population)->amova #~30sec
set.seed(1999)
# #amova_signif   <- randtest(amova, nrepet = 999) #999 = ~5min

#### AMOVA noTAS ####

data.frame(cbind(gl_noTAS@ind.names,as.character(pop(gl_noTAS))))->df_strata_noTAS

cbind(df_strata_noTAS,df_strata_noTAS[,2])->df_strata_noTAS
colnames(df_strata_noTAS)<-c("ID","Population","TAR_Area")

df_strata_noTAS[which(df_strata_noTAS[,2]=="12.HB"),3]<-"TAR2"
df_strata_noTAS[which(df_strata_noTAS[,2]=="02.TARA"),3]<-"TAR8"
df_strata_noTAS[which(df_strata_noTAS[,2]=="11.WAI"),3]<-"TAR2"
df_strata_noTAS[which(df_strata_noTAS[,2]=="13.EC"),3]<-"TAR2"
df_strata_noTAS[which(df_strata_noTAS[,2]=="09.CC"),3]<-"TAR7"
df_strata_noTAS[which(df_strata_noTAS[,2]=="05.UWCSI"),3]<-"TAR7"
df_strata_noTAS[which(df_strata_noTAS[,2]=="10.WGTN"),3]<-"TAR2"
df_strata_noTAS[which(df_strata_noTAS[,2]=="03.TBGB"),3]<-"TAR7"
df_strata_noTAS[which(df_strata_noTAS[,2]=="06.LWCSI"),3]<-"TAR7"
df_strata_noTAS[which(df_strata_noTAS[,2]=="01.UWCNI"),3]<-"TAR1"
df_strata_noTAS[which(df_strata_noTAS[,2]=="14.ENHG"),3]<-"TAR1"
df_strata_noTAS[which(df_strata_noTAS[,2]=="15.ENLD"),3]<-"TAR1"
df_strata_noTAS[which(df_strata_noTAS[,2]=="17.TAS"),3]<-"AU"
df_strata_noTAS[which(df_strata_noTAS[,2]=="08.CHCH" ),3]<-"TAR3"

gl_noTAS_strata <- strata(gl_noTAS, value = df_strata_noTAS)
head(strata(gl_noTAS_strata))

poppr.amova(gl_noTAS_strata,~TAR_Area/Population)->amova_noTAS #~30sec
set.seed(1999)
amova_noTAS_signif <- randtest(amova_noTAS, nrepet = 999) #~ 5min

#### AMOVA West - East ####

gl_noWEL<- gl.drop.pop(gl_grouped,
                       pop.list=c("04.TBGBJ","07.FRDL","16.CHAT","GBK",
                                  "18.KTAR","17.TAS","10.WGTN"),
                       recalc=T,mono.rm=T,verbose=5)

data.frame(cbind(gl_noWEL@ind.names,as.character(pop(gl_noWEL))))->df_strata_noWEL

cbind(df_strata_noWEL,df_strata_noWEL[,2])->df_strata_noWEL
colnames(df_strata_noWEL)<-c("ID","Population","Coast")

df_strata_noWEL[which(df_strata_noWEL[,2]=="12.HB"),3]<-"East"
df_strata_noWEL[which(df_strata_noWEL[,2]=="02.TARA"),3]<-"West"
df_strata_noWEL[which(df_strata_noWEL[,2]=="11.WAI"),3]<-"East"
df_strata_noWEL[which(df_strata_noWEL[,2]=="13.EC"),3]<-"East"
df_strata_noWEL[which(df_strata_noWEL[,2]=="09.CC"),3]<-"East"
df_strata_noWEL[which(df_strata_noWEL[,2]=="05.UWCSI"),3]<-"West"
df_strata_noWEL[which(df_strata_noWEL[,2]=="03.TBGB"),3]<-"West"
df_strata_noWEL[which(df_strata_noWEL[,2]=="06.LWCSI"),3]<-"West"
df_strata_noWEL[which(df_strata_noWEL[,2]=="01.UWCNI"),3]<-"West"
df_strata_noWEL[which(df_strata_noWEL[,2]=="14.ENHG"),3]<-"East"
df_strata_noWEL[which(df_strata_noWEL[,2]=="15.ENLD"),3]<-"East"
df_strata_noWEL[which(df_strata_noWEL[,2]=="08.CHCH" ),3]<-"East"



gl_noWEL_strata <- strata(gl_noWEL, value = df_strata_noWEL)
head(strata(gl_noWEL_strata))

poppr.amova(gl_noWEL_strata,~Coast/Population)->amova_noWEL #~30sec
set.seed(1991)
amova_noWEL_signif <- randtest(amova_noWEL, nrepet = 999) #~ 5min

#### AMOVA SI West - SI East ####

gl_SI<- gl.drop.pop(gl_grouped,
                    pop.list=c("04.TBGBJ","07.FRDL","16.CHAT","GBK",
                               "18.KTAR","17.TAS","10.WGTN","12.HB",
                               "02.TARA","11.WAI","13.EC","01.UWCNI",
                               "14.ENHG","15.ENLD"),
                    recalc=T,mono.rm=T,verbose=5)
data.frame(cbind(gl_SI@ind.names,as.character(pop(gl_SI))))->df_strata_SI

cbind(df_strata_SI,df_strata_SI[,2])->df_strata_SI
colnames(df_strata_SI)<-c("ID","Population","Coast")

df_strata_SI[which(df_strata_SI[,2]=="09.CC"),3]<-"East"
df_strata_SI[which(df_strata_SI[,2]=="05.UWCSI"),3]<-"West"
df_strata_SI[which(df_strata_SI[,2]=="03.TBGB"),3]<-"West"
df_strata_SI[which(df_strata_SI[,2]=="06.LWCSI"),3]<-"West"
df_strata_SI[which(df_strata_SI[,2]=="08.CHCH" ),3]<-"East"

gl_SI_strata <- strata(gl_SI, value = df_strata_SI)
head(strata(gl_SI_strata))

poppr.amova(gl_SI_strata,~Coast/Population)->amova_SI #~30sec
set.seed(1991)
amova_SI_signif <- randtest(amova_SI, nrepet = 999) #~ 5min

#### AMOVA NIWest - NIEast ####

gl_NI<- gl.drop.pop(gl_grouped,
                       pop.list=c("04.TBGBJ","07.FRDL","16.CHAT","GBK",
                                  "18.KTAR","17.TAS","10.WGTN","09.CC",
                                  "05.UWCSI","03.TBGB","06.LWCSI","08.CHCH"),
                       recalc=T,mono.rm=T,verbose=5)

data.frame(cbind(gl_NI@ind.names,as.character(pop(gl_NI))))->df_strata_NI

cbind(df_strata_NI,df_strata_NI[,2])->df_strata_NI

colnames(df_strata_NI)<-c("ID","Population","Coast")
df_strata_NI[which(df_strata_NI[,2]=="12.HB"),3]<-"East"
df_strata_NI[which(df_strata_NI[,2]=="02.TARA"),3]<-"West"
df_strata_NI[which(df_strata_NI[,2]=="11.WAI"),3]<-"East"
df_strata_NI[which(df_strata_NI[,2]=="13.EC"),3]<-"East"
df_strata_NI[which(df_strata_NI[,2]=="09.CC"),3]<-"East"
df_strata_NI[which(df_strata_NI[,2]=="01.UWCNI"),3]<-"West"
df_strata_NI[which(df_strata_NI[,2]=="14.ENHG"),3]<-"East"
df_strata_NI[which(df_strata_NI[,2]=="15.ENLD"),3]<-"East"


gl_NI_strata <- strata(gl_NI, value = df_strata_NI)
head(strata(gl_NI_strata))

poppr.amova(gl_NI_strata,~Coast/Population)->amova_NI #~30sec
set.seed(1991)
amova_NI_NIgnif <- randtest(amova_NI, nrepet = 999) #~ 5min

#### AMOVA nosmall no area####

data.frame(cbind(gl_nosmall@ind.names,as.character(pop(gl_nosmall))))->df_strata_noarea

colnames(df_strata_noarea)<-c("ID","Population")

gl_nosmall_strata_noarea <- strata(gl_nosmall, value = df_strata_noarea)
head(strata(gl_nosmall_strata_noarea, combine = FALSE))

poppr.amova(gl_nosmall_strata_noarea,~Population)->amova_noarea #~30sec
set.seed(1999)
amova_noarea_signif <- randtest(amova_noarea, nrepet = 999) #999 = ~5min


#### AMOVA noTAS no area####

data.frame(cbind(gl_noTAS@ind.names,as.character(pop(gl_noTAS))))->df_strata_noarea_noTAS

colnames(df_strata_noarea_noTAS)<-c("ID","Population")

gl_noTAS_strata_noarea <- strata(gl_noTAS, value = df_strata_noarea_noTAS)
head(strata(gl_noTAS_strata_noarea, combine = FALSE))

poppr.amova(gl_noTAS_strata_noarea,~Population)->amova_noarea_noTAS #~30sec
set.seed(1999)
amova_noarea_noTAS_signif <- randtest(amova_noarea_noTAS, nrepet = 999) #999 = ~5min

#### FST ####

# #pwfst_nosmall_1000 <-stamppFst(gl_nosmall, nboots=1000, percent=95, nclusters=1) #1000: ~2-3h
write.table(pwfst_nosmall_1000$Fsts,file="./FST/pwfst_nosmall_1000_Fst.txt")
write.table(pwfst_nosmall_1000$Pvalues,file="./FST/pwfst_nosmall_1000_pvalues.txt")


pwfst_Fst <- read.csv("./pwfst_nosmall_1000_Fst.txt", 
                             row.names=1, sep="", stringsAsFactors=TRUE)

sub("X","",colnames(pwfst_Fst))->colnames(pwfst_Fst)

#convert to matrix
fst_mat<-as.matrix(pwfst_Fst)
#replace NA by 0
fst_mat[which(fst_mat<0)]<-0
#make matrix symmetric
makeSymm <- function(fst_mat) {
  fst_mat[upper.tri(fst_mat)] <- t(fst_mat)[upper.tri(fst_mat)]
  return(fst_mat)
}
makeSymm(fst_mat)-> fst_mat

#plot heatmap
png(glue("./heatmap_adapt.png"), width = 10, height = 4, units = "in",res=350)
pheatmap(fst_mat,display_numbers=T,number_format="%.4f")
dev.off()
pdf(glue("./heatmap_adapt.pdf"), width = 10, height = 4)
pheatmap(fst_mat,display_numbers=T,number_format="%.4f")
dev.off()

####FST noTAS ####
fst_mat_noTAS<-as.matrix(pwfst_Fst[-13,-13])
#replace NA by 0
fst_mat_noTAS[which(fst_mat_noTAS<0)]<-0
#make matrix symmetric
makeSymm <- function(fst_mat_noTAS) {
  fst_mat_noTAS[upper.tri(fst_mat_noTAS)] <- t(fst_mat_noTAS)[upper.tri(fst_mat_noTAS)]
  return(fst_mat_noTAS)
}
makeSymm(fst_mat_noTAS)-> fst_mat_noTAS

#plot heatmap
png(glue("./heatmap_adapt_noTAR.png"), width = 10, height = 4, units = "in",res=350)
pheatmap(fst_mat_noTAS,display_numbers=T,number_format="%.4f")
dev.off()
pdf(glue("./heatmap_adapt_noTAR.pdf"), width = 10, height = 4)
pheatmap(fst_mat_noTAS,display_numbers=T,number_format="%.4f")
dev.off()
#### IBD ####

#### TEST ISOLATION BY DISTANCE ####
library("gdistance")
library("MASS")
####prepare shapefile and raster####
shapefile<-shapefile("G:/DATA/WORK/shapefiles/NewZealand_Boundary.shp") 
plot(shapefile)
ext <- extent(-180, 180, -48, -32) 
#important to have extant -180 180 take chatham into account
gridsize <- 0.1
r <- raster(ext, res=gridsize)
rr <- rasterize(shapefile, r)
plot(rr)
plot(rr,ext=c(-178, -175, -47.36973, -34.39339)) #here is chatham!

#### get genetic distances ####
pwfst_Fst->dnadist
#remove TAS
dnadist[-13,-13]->dnadist
View(as.matrix(dnadist))

#### get geographic distances ####
df_locations<-df_strata_noTAS

#ADD POINTS
library(readxl)
#read_excel
center <- 180
coord_points <- read_excel("G:/DATA/WORK/P0 THESIS/CHAPTER 5 TARAKIHI POPGENOMICS/R/TAR_latlon.xlsx")
coord_points$long.recenter <- ifelse(coord_points$long < center - 180 , coord_points$long + 360, coord_points$long)
coord_points$long_approx.recenter <- ifelse(coord_points$long_approx < center - 180 , coord_points$long_approx + 360, coord_points$long_approx)

pops_locs<-coord_points[,c(1,14,15)]
pops_locs[-which(coord_points$`Unique fish ID#`=="1605-GB19-001-K"),]->pops_locs

pops_locs[which(pops_locs$loc_label=="12. Hawkes Bay"),1]<-"12.HB"
pops_locs[which(pops_locs$loc_label=="2. Taranaki"),1]<-"02.TARA"
pops_locs[which(pops_locs$loc_label=="11. Wairarapa"),1]<-"11.WAI"
pops_locs[which(pops_locs$loc_label=="13. East Cape"),1]<-"13.EC"
pops_locs[which(pops_locs$loc_label=="9. Cape Campbell"),1]<-"09.CC"
pops_locs[which(pops_locs$loc_label=="5. Upper WCSI"),1]<-"05.UWCSI"
pops_locs[which(pops_locs$loc_label=="10. Wellington"),1]<-"10.WGTN"
pops_locs[which(pops_locs$loc_label=="3. TBGB"),1]<-"03.TBGB"
pops_locs[which(pops_locs$loc_label=="6. Lower WCSI"),1]<-"06.LWCSI"
pops_locs[which(pops_locs$loc_label=="1. UWCNI"),1]<-"01.UWCNI"
pops_locs[which(pops_locs$loc_label=="14. ENLD/Hauraki Gulf"),1]<-"14.ENHG"
pops_locs[which(pops_locs$loc_label=="15. East Northland"),1]<-"15.ENLD"
pops_locs[which(pops_locs$loc_label=="8. Christchurch"),1]<-"08.CHCH"
pops_locs[-which(pops_locs$loc_label=="18. King TAR"),]->pops_locs
pops_locs[-which(pops_locs$loc_label=="17. Tasmania"),]->pops_locs
pops_locs[-which(pops_locs$loc_label=="7. Fiordland"),]->pops_locs
pops_locs[-which(pops_locs$loc_label=="16. Chatham Islands"),]->pops_locs
pops_locs[-which(pops_locs$loc_label=="4. TBGB (JUV)"),]->pops_locs

as.matrix(unique(pops_locs))->latlon
rownames(latlon)<-latlon[,1]
latlon<-latlon[,-1]

#match order
latlon[match(rownames(dnadist), rownames(latlon)),]->latlon
latlon<-cbind(as.numeric(latlon[,2]),as.numeric(latlon[,1]))
colnames(latlon)<-c("long","lat")
rownames(latlon)<-rownames(dnadist)
View(latlon)
View(dnadist)
as.dist(dnadist)->dnadist

####crow flight####
pC <- latlon
geoDist <- pointDistance(pC, longlat = TRUE,allpairs=T)
geoDist <- as.dist(geoDist)
as.matrix(geoDist)->m_geoDist
colnames(as.matrix(dnadist))->colnames(m_geoDist)
rownames(as.matrix(dnadist))->rownames(m_geoDist)

#distances are in meters! 

mantel.rtest(geoDist,dnadist,nrepet=999)->mantel_crowflight
#Observation: 0.02752448 , #p-value: 0.153
#plot(geoDist,dnadist)
#abline(lm(dnadist~geoDist), col="red",lty=2)
dens <- kde2d(geoDist,dnadist, n=150)
myPal <- colorRampPalette(c("white","blue","gold", "orange", "red"))
pdf(paste0("figures/tar_IBD_crowflight.pdf"))
plot(geoDist, dnadist,pch=20, 
     xlab="geographic distance", ylab="genetic distance (T92)",cex.lab=1.3)
image(dens, col=transp(myPal(150),.7), add=TRUE)
abline(lm(dnadist~geoDist),lwd=3)
title("Isolation by distance: \"crow flight\"")
dev.off()
tiff(paste0("figures/tar_IBD_crowflight.tiff"),width=600,height=600)
plot(geoDist, dnadist, pch=20,
     xlab="geographic distance", ylab="genetic distance (T92)",cex.lab=1.5)
image(dens, col=transp(myPal(300),.7), add=TRUE)
abline(lm(dnadist~geoDist),lwd=3)
title("Isolation by distance: \"crow flight\"",cex.main=1.5)
dev.off()

####restricted to ocean####

#Create a raster of ocean
rr->roce
roce[is.na(roce[])] <- 2
roce[roce[]==1] <- NA
roce[roce[]==2] <- 1
plot(roce)
plot(roce,ext=c(160, 180, -50, -32))

#do the distance analysis

troce <- transition(roce, mean, directions = 8) #less than 1 min
troceC <- geoCorrection(troce, "c", scl = TRUE)
pC <- latlon
cosDist <- costDistance(troceC, pC)

as.matrix(cosDist)->m_cosDist
colnames(as.matrix(dnadist))->colnames(m_cosDist)
rownames(as.matrix(dnadist))->rownames(m_cosDist)
View(m_cosDist)

mantel.rtest(cosDist,dnadist,nrepet=999)->mantel_ocean
library(MASS)
#Observation: 0.0271162, #p-value: 0.201
dens <- kde2d(cosDist,dnadist, n=150)
myPal <- colorRampPalette(c("white","blue","gold", "orange", "red"))
pdf(paste0("figures/tar_IBD_ocean_restricted.pdf"))
plot(cosDist, dnadist,pch=20, 
     xlab="geographic least-cost distance", ylab="genetic distance (T92)",cex.lab=1.3)
image(dens, col=transp(myPal(150),.7), add=TRUE)
abline(lm(dnadist~cosDist),lwd=3)
title("Isolation by distance: restricted to ocean")
dev.off()
tiff(paste0("figures/tar_IBD_ocean_restricted.tiff"))
plot(cosDist, dnadist,pch=20, 
     xlab="geographic least-cost distance", ylab="genetic distance (T92)",cex.lab=1.5)
image(dens, col=transp(myPal(150),.7), add=TRUE)
abline(lm(dnadist~cosDist),lwd=3)
title("Isolation by distance: restricted to ocean",cex.main=1.5)
dev.off()


#### restricted to ocean WITHOUT CHATHAM ####

pC[-c(24:38),]->pC_nochat
tar_dna[-c(24:38),]->tar_dna_nochat

dist.dna(tar_dna_nochat,model="T92")->dnadist_nochat
View(as.matrix(dnadist_nochat)[1:50,1:50])

cosDist_nochat <- costDistance(troceC, pC_nochat)

as.matrix(cosDist_nochat)->m_cosDist_nochat
colnames(as.matrix(dnadist_nochat))->colnames(m_cosDist_nochat)
rownames(as.matrix(dnadist_nochat))->rownames(m_cosDist_nochat)
View(m_cosDist_nochat[1:100,1:100])

mantel.rtest(cosDist_nochat,dnadist_nochat,nrepet=999)
#Observation: 0.02419971, #p-value: 0.229
dens <- kde2d(cosDist_nochat,dnadist_nochat, n=150)
myPal <- colorRampPalette(c("white","blue","gold", "orange", "red"))
pdf(paste0("figures/tar_IBD_ocean_restricted_no_Chatham.pdf"))
plot(cosDist_nochat, dnadist_nochat,pch=20, 
     xlab="geographic least-cost distance", ylab="genetic distance (T92)",cex.lab=1.3)
image(dens, col=transp(myPal(150),.7), add=TRUE)
abline(lm(dnadist_nochat~cosDist_nochat),lwd=3)
title("Isolation by distance: \nleast-cost restricted to ocean, no Chatham")
dev.off()
tiff(paste0("figures/tar_IBD_ocean_restricted_no_Chatham.tiff"))
plot(cosDist_nochat, dnadist_nochat, pch=20,
     xlab="geographic least-cost distance", ylab="genetic distance (T92)",cex.lab=1.5)
image(dens, col=transp(myPal(150),.7), add=TRUE)
abline(lm(dnadist_nochat~cosDist_nochat),lwd=3)
title("Isolation by distance: \nleast-cost restricted to ocean, no Chatham",cex.main=1.3)
dev.off()

#### AMOVA adaptive dataset ####
library("dartR")
library("poppr")
library("StAMPP")

setwd("G:/DATA/WORK/WGS_PIPELINE/2_popgen/16_SNP_analysis_DARTR/210519_3_ADAPTVE_DATASET")
load("q_0_05_He_0_1/dartr_.QCmaf.AB.adapt_q_0_05_He_0_1_210527.RData")

#### AMOVA nosmall ####
pop(glf_nosmall)

data.frame(cbind(glf_nosmall@ind.names,as.character(pop(glf_nosmall))))->df_strata

cbind(df_strata,df_strata[,2])->df_strata
colnames(df_strata)<-c("ID","Population","TAR_Area")

df_strata[which(df_strata[,2]=="12.HB"),3]<-"TAR2"
df_strata[which(df_strata[,2]=="02.TARA"),3]<-"TAR8"
df_strata[which(df_strata[,2]=="11.WAI"),3]<-"TAR2"
df_strata[which(df_strata[,2]=="13.EC"),3]<-"TAR2"
df_strata[which(df_strata[,2]=="09.CC"),3]<-"TAR7"
df_strata[which(df_strata[,2]=="05.UWCSI"),3]<-"TAR7"
df_strata[which(df_strata[,2]=="10.WGTN"),3]<-"TAR2"
df_strata[which(df_strata[,2]=="03.TBGB"),3]<-"TAR7"
df_strata[which(df_strata[,2]=="06.LWCSI"),3]<-"TAR7"
df_strata[which(df_strata[,2]=="01.UWCNI"),3]<-"TAR1"
df_strata[which(df_strata[,2]=="14.ENHG"),3]<-"TAR1"
df_strata[which(df_strata[,2]=="15.ENLD"),3]<-"TAR1"
df_strata[which(df_strata[,2]=="17.TAS"),3]<-"AU"
df_strata[which(df_strata[,2]=="08.CHCH" ),3]<-"TAR3"

glf_nosmall_strata <- strata(glf_nosmall, value = df_strata)
head(strata(glf_nosmall_strata, combine = FALSE))

poppr.amova(glf_nosmall_strata,~TAR_Area/Population)->amova #~30sec
set.seed(1999)
amova_signif   <- randtest(amova, nrepet = 999) #999 = ~5min

#### AMOVA noTAS ####

data.frame(cbind(glf_noTAS@ind.names,as.character(pop(glf_noTAS))))->df_strata_noTAS

cbind(df_strata_noTAS,df_strata_noTAS[,2])->df_strata_noTAS
colnames(df_strata_noTAS)<-c("ID","Population","TAR_Area")

df_strata_noTAS[which(df_strata_noTAS[,2]=="12.HB"),3]<-"TAR2"
df_strata_noTAS[which(df_strata_noTAS[,2]=="02.TARA"),3]<-"TAR8"
df_strata_noTAS[which(df_strata_noTAS[,2]=="11.WAI"),3]<-"TAR2"
df_strata_noTAS[which(df_strata_noTAS[,2]=="13.EC"),3]<-"TAR2"
df_strata_noTAS[which(df_strata_noTAS[,2]=="09.CC"),3]<-"TAR7"
df_strata_noTAS[which(df_strata_noTAS[,2]=="05.UWCSI"),3]<-"TAR7"
df_strata_noTAS[which(df_strata_noTAS[,2]=="10.WGTN"),3]<-"TAR2"
df_strata_noTAS[which(df_strata_noTAS[,2]=="03.TBGB"),3]<-"TAR7"
df_strata_noTAS[which(df_strata_noTAS[,2]=="06.LWCSI"),3]<-"TAR7"
df_strata_noTAS[which(df_strata_noTAS[,2]=="01.UWCNI"),3]<-"TAR1"
df_strata_noTAS[which(df_strata_noTAS[,2]=="14.ENHG"),3]<-"TAR1"
df_strata_noTAS[which(df_strata_noTAS[,2]=="15.ENLD"),3]<-"TAR1"
df_strata_noTAS[which(df_strata_noTAS[,2]=="17.TAS"),3]<-"AU"
df_strata_noTAS[which(df_strata_noTAS[,2]=="08.CHCH" ),3]<-"TAR3"

glf_noTAS_strata <- strata(glf_noTAS, value = df_strata_noTAS)
head(strata(glf_noTAS_strata))

poppr.amova(glf_noTAS_strata,~TAR_Area/Population)->amova_noTAS #~30sec
set.seed(1999)
amova_noTAS_signif <- randtest(amova_noTAS, nrepet = 999) #~ 5min

#### AMOVA West - East ####

gl_noWEL<- gl.drop.pop(glf_grouped,
                       pop.list=c("04.TBGBJ","07.FRDL","16.CHAT","GBK",
                                  "18.KTAR","17.TAS","10.WGTN"),
                       recalc=T,mono.rm=T,verbose=5)

data.frame(cbind(gl_noWEL@ind.names,as.character(pop(gl_noWEL))))->df_strata_noWEL

cbind(df_strata_noWEL,df_strata_noWEL[,2])->df_strata_noWEL
colnames(df_strata_noWEL)<-c("ID","Population","Coast")

df_strata_noWEL[which(df_strata_noWEL[,2]=="12.HB"),3]<-"East"
df_strata_noWEL[which(df_strata_noWEL[,2]=="02.TARA"),3]<-"West"
df_strata_noWEL[which(df_strata_noWEL[,2]=="11.WAI"),3]<-"East"
df_strata_noWEL[which(df_strata_noWEL[,2]=="13.EC"),3]<-"East"
df_strata_noWEL[which(df_strata_noWEL[,2]=="09.CC"),3]<-"East"
df_strata_noWEL[which(df_strata_noWEL[,2]=="05.UWCSI"),3]<-"West"
df_strata_noWEL[which(df_strata_noWEL[,2]=="03.TBGB"),3]<-"West"
df_strata_noWEL[which(df_strata_noWEL[,2]=="06.LWCSI"),3]<-"West"
df_strata_noWEL[which(df_strata_noWEL[,2]=="01.UWCNI"),3]<-"West"
df_strata_noWEL[which(df_strata_noWEL[,2]=="14.ENHG"),3]<-"East"
df_strata_noWEL[which(df_strata_noWEL[,2]=="15.ENLD"),3]<-"East"
df_strata_noWEL[which(df_strata_noWEL[,2]=="08.CHCH" ),3]<-"East"



gl_noWEL_strata <- strata(gl_noWEL, value = df_strata_noWEL)
head(strata(gl_noWEL_strata))

poppr.amova(gl_noWEL_strata,~Coast/Population)->amova_noWEL #~30sec
set.seed(1991)
amova_noWEL_signif <- randtest(amova_noWEL, nrepet = 999) #~ 5min

#### AMOVA SI West - SI East ####

gl_SI<- gl.drop.pop(glf_grouped,
                    pop.list=c("04.TBGBJ","07.FRDL","16.CHAT","GBK",
                               "18.KTAR","17.TAS","10.WGTN","12.HB",
                               "02.TARA","11.WAI","13.EC","01.UWCNI",
                               "14.ENHG","15.ENLD"),
                    recalc=T,mono.rm=T,verbose=5)
data.frame(cbind(gl_SI@ind.names,as.character(pop(gl_SI))))->df_strata_SI

cbind(df_strata_SI,df_strata_SI[,2])->df_strata_SI
colnames(df_strata_SI)<-c("ID","Population","Coast")

df_strata_SI[which(df_strata_SI[,2]=="09.CC"),3]<-"East"
df_strata_SI[which(df_strata_SI[,2]=="05.UWCSI"),3]<-"West"
df_strata_SI[which(df_strata_SI[,2]=="03.TBGB"),3]<-"West"
df_strata_SI[which(df_strata_SI[,2]=="06.LWCSI"),3]<-"West"
df_strata_SI[which(df_strata_SI[,2]=="08.CHCH" ),3]<-"East"

gl_SI_strata <- strata(gl_SI, value = df_strata_SI)
head(strata(gl_SI_strata))

poppr.amova(gl_SI_strata,~Coast/Population)->amova_SI #~30sec
set.seed(1991)
amova_SI_signif <- randtest(amova_SI, nrepet = 999) #~ 5min

#### AMOVA NIWest - NIEast ####

gl_NI<- gl.drop.pop(glf_grouped,
                    pop.list=c("04.TBGBJ","07.FRDL","16.CHAT","GBK",
                               "18.KTAR","17.TAS","10.WGTN","09.CC",
                               "05.UWCSI","03.TBGB","06.LWCSI","08.CHCH"),
                    recalc=T,mono.rm=T,verbose=5)

data.frame(cbind(gl_NI@ind.names,as.character(pop(gl_NI))))->df_strata_NI

cbind(df_strata_NI,df_strata_NI[,2])->df_strata_NI

colnames(df_strata_NI)<-c("ID","Population","Coast")
df_strata_NI[which(df_strata_NI[,2]=="12.HB"),3]<-"East"
df_strata_NI[which(df_strata_NI[,2]=="02.TARA"),3]<-"West"
df_strata_NI[which(df_strata_NI[,2]=="11.WAI"),3]<-"East"
df_strata_NI[which(df_strata_NI[,2]=="13.EC"),3]<-"East"
df_strata_NI[which(df_strata_NI[,2]=="09.CC"),3]<-"East"
df_strata_NI[which(df_strata_NI[,2]=="01.UWCNI"),3]<-"West"
df_strata_NI[which(df_strata_NI[,2]=="14.ENHG"),3]<-"East"
df_strata_NI[which(df_strata_NI[,2]=="15.ENLD"),3]<-"East"


gl_NI_strata <- strata(gl_NI, value = df_strata_NI)
head(strata(gl_NI_strata))

poppr.amova(gl_NI_strata,~Coast/Population)->amova_NI #~30sec
set.seed(1991)
amova_NI_NIgnif <- randtest(amova_NI, nrepet = 999) #~ 5min

#### AMOVA nosmall no area####

data.frame(cbind(glf_nosmall@ind.names,as.character(pop(glf_nosmall))))->df_strata_noarea

colnames(df_strata_noarea)<-c("ID","Population")

glf_nosmall_strata_noarea <- strata(glf_nosmall, value = df_strata_noarea)
head(strata(glf_nosmall_strata_noarea, combine = FALSE))

poppr.amova(glf_nosmall_strata_noarea,~Population)->amova_noarea #~30sec
set.seed(1999)
amova_noarea_signif <- randtest(amova_noarea, nrepet = 999) #999 = ~5min


#### AMOVA noTAS no area####

data.frame(cbind(glf_noTAS@ind.names,as.character(pop(glf_noTAS))))->df_strata_noarea_noTAS

colnames(df_strata_noarea_noTAS)<-c("ID","Population")

glf_noTAS_strata_noarea <- strata(glf_noTAS, value = df_strata_noarea_noTAS)
head(strata(glf_noTAS_strata_noarea, combine = FALSE))

poppr.amova(glf_noTAS_strata_noarea,~Population)->amova_noarea_noTAS #~30sec
set.seed(1999)
amova_noarea_noTAS_signif <- randtest(amova_noarea_noTAS, nrepet = 999) #999 = ~5min


