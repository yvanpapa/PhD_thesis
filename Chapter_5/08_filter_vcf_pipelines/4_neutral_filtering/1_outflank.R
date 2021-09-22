#### set up environment####
setwd("G:/DATA/WORK/WGS_PIPELINE/2_popgen/15R_Outflank")
library(OutFLANK)
library(vcfR)
library(pegas)
library(dartR)
library(glue)

#check manual here: http://rstudio-pubs-static.s3.amazonaws.com/305384_9aee1c1046394fb9bd8e449453d72847.html
indir<- "G:/DATA/WORK/WGS_PIPELINE/2_popgen/15R_Outflank/scaffolds/"
sort(as.numeric(list.files(indir)))->scfs
print(glue("Analysing {length(scfs)} scaffolds"))
for (f in scfs[-c(1:228)])
{
####import vcf file ####
  print(glue("reading scaffold {f}"))

vcf_file <- glue("{indir}/{f}/call_set_AGRFlib1_to_6_V2P.rn.QCmaf.scf{f}.AB.vcf.gz")
vcf_raw <- read.vcfR(vcf_file, verbose = TRUE)
vcfR2genlight(vcf_raw, n.cores = 1)->gl
nInd(gl)
# 188
nLoc(gl)
#nb of SNPs

###assign populations####

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
sort(pops_grouped)
levels(pops_grouped)

gl->gl_grouped
pops_grouped->pop(gl_grouped)
gl_grouped

#### remove low sampled populations and KTAR ####
gl_nosmall<- gl.drop.pop(gl_grouped,
                     pop.list=c("04.TBGBJ","07.FRDL","16.CHAT","GBK","18.KTAR"),
                     recalc=T,mono.rm=T,verbose=5)
#165 pops left
pop(gl_nosmall)
nInd(gl_nosmall)

####create outflank inputs: SNdata, locusNames, popNames ####
### Outflank requires SNPdata: an array with a row for each individual 
###in the data set and a column for each locus
m <- as.matrix(gl_nosmall)  #careful, too big for view
head(m[,1:5])
#the value in each column must be either 0, 1, 2, or 9
#For any locus that is unknown for an individual, SNPdata should have a 9 for that locus on that row
m[38:60,1:5]
m[which(is.na(m))]<-9
m[38:60,1:5]
m->SNPdata
dimnames(SNPdata) <- NULL
head(SNPdata[,1:20])

###locusNames is a character vector that gives a list of identifying names for each locus.
###(The length of the locusNames vector should be the same as the number of columns in SNPmat.)
colnames(m)->locusNames
head(m[,1:5])
locusNames[1:5]

as.character(pop(gl_nosmall))->popNames
popNames[1:30]
m[1:30,1:5]

#### MakeDiploidFSTMat ####
#We are going to use the MakeDiploidFSTMat() function to calculate 
#the outflank variables from the SNP data:
print(glue("reading scaffold {f}"))
FstDataFrame <- MakeDiploidFSTMat(SNPdata,locusNames,popNames)
head(FstDataFrame)

#### check some preliminary stuff ####

png(glue("./results/a_{f}_fstcorrvsnocorr.png"), width = 4.5, height = 4, units = "in",res=300)
plot(FstDataFrame$FST, FstDataFrame$FSTNoCorr, 
     xlim=c(-0.05,1), ylim=c(-0.05,1),
     pch=20,cex=0.6)
abline(0,1)
dev.off()

#### optionnal: example of bad data by simulating ####
###SNPdata_missing <- SNPdata
###missing <- sample(1:nrow(SNPdata_missing), 100, replace=FALSE)
###SNPdata_missing[missing,1] <- 9
###FstDataFrame_missing <- MakeDiploidFSTMat(SNPdata_missing,locusNames,popNames)
###plot(FstDataFrame_missing$FST, FstDataFrame_missing$FSTNoCorr, 
###     xlim=c(-0.05,1), ylim=c(-0.05,1), pch=20)
## ###Highlight the SNP that is missing a lot of data
###points(FstDataFrame_missing$FST[1], FstDataFrame_missing$FSTNoCorr[1], col="blue", pch=8, cex=1.3)
###abline(0,1)

### check if FST distribution looks chi-squared distributed ####
png(glue("./results/b_{f}_hevsfstnocorr.png"), width = 6, height = 4, units = "in",res=300)
plot(FstDataFrame$He, FstDataFrame$FSTNoCorr, pch=20, col="grey")
dev.off()

png(glue("./results/c_{f}_histfstnocorr.png"), width = 4.5, height = 4, units = "in",res=300)
hist(FstDataFrame$FSTNoCorr, breaks=seq(0,max(!is.na(FstDataFrame$FSTNoCorr)), by=0.001))
dev.off()

####outflank analysis####
outlier <- OutFLANK(FstDataFrame, NumberOfSamples=nPop(gl_nosmall),
                    LeftTrimFraction = 0.05, RightTrimFraction = 0.05,
                    Hmin = 0.1, qthreshold = 0.05)

#These are all default parametes in outflank!
png(glue("./results/d_{f}_outflank.png"), width = 6, height = 4, units = "in",res=300)
OutFLANKResultsPlotter(outlier, withOutliers = TRUE,
                       NoCorr = TRUE, Hmin = 0.1, binwidth = 0.003, Zoom =
                         FALSE, RightZoomFraction = 0.04, titletext = NULL)
dev.off()

png(glue("./results/e_{f}_histoutliers.png"), width = 6, height = 4, units = "in",res=300)
hist(outlier$results$pvaluesRightTail)
dev.off()


str(outlier)
fileConn<-file(glue("./results/f_{f}_results.txt"))
writeLines(as.character(c("N Ind",nInd(gl_nosmall),"N SNPs",nLoc(gl_nosmall),"FSTbar",
            "N outliers",sum(outlier$results$qvalues<0.01, na.rm=TRUE),
            outlier$FSTbar,"FSTNoCorrbar",outlier$FSTNoCorrbar,
            "dfInferred",outlier$dfInferred,"numberLowFstOutliers",
            outlier$numberLowFstOutliers,"numberHighFstOutliers",
            outlier$numberHighFstOutliers)),fileConn)
close(fileConn)

write.table(outlier$results,file=glue("./results/g_{f}_outflank_table.txt"))

#### check outliers ####

png(glue("./results/h_{f}_outliers.png"), width = 6, height = 4, units = "in",res=300)
plot(outlier$results$He, outlier$results$FST, pch=20, col="grey")
points(outlier$results$He[outlier$results$qvalues<0.01], 
       outlier$results$FST[outlier$results$qvalues<0.01], pch=21, col="red")
dev.off()
### Note how OutFLANK identifies potential outliers at He < 0.1, even though
### these loci were excluded in the trimming algorithm

# Create logical vector for top candidates (qvalues<0.01 and He>0.1)
top_candidates <- outlier$results$qvalues<0.01 & outlier$results$He>0.1
top_candidates[which(is.na(top_candidates))]<-FALSE

png(glue("./results/i_{f}_top_outliers.png"), width = 6, height = 4, units = "in",res=300)
plot(outlier$results$He, outlier$results$FST, pch=20, col="grey")
points(outlier$results$He[top_candidates], outlier$results$FST[top_candidates],
       pch=21, col="blue")
dev.off()

#plot top candidates on scaffold
position<-position(gl_nosmall)
png(glue("./results/j_{f}_top_outliers_position.png"), width = 6, height = 4, units = "in",res=300)
plot(position, outlier$results$FST,col="grey",pch=20) 
points(position[top_candidates], outlier$results$FST[top_candidates], 
       pch=21, cex=1, col="blue")
dev.off()

# clean up by removing low He variants
png(glue("./results/k_{f}_top_outliers_position_nolowHE.png"), width = 6, height = 4, units = "in",res=300)
keep <- outlier$results$He>0.1 & !is.na(outlier$results$He)
plot(position[keep], outlier$results$FST[keep],col="grey",pch=20) 
points(position[top_candidates], outlier$results$FST[top_candidates], 
       pch=21, cex=1, col="blue")
dev.off()

##### list top candidates #####
topcan <- outlier$results[top_candidates,]
topcan[order(topcan$LocusName),]

chr(gl_nosmall)[top_candidates]
position[top_candidates]
data.frame(chr(gl_nosmall)[top_candidates],position[top_candidates])->df
write.table(df,file = glue("./results/l_{f}_list_outliers.txt"),sep = "\t",
            row.names = F,col.names = F,quote=F)

write.table(df,file = glue("./results/1_list_outliers.txt"),sep = "\t",
            row.names = F,col.names = F,quote=F,append=T)
}
