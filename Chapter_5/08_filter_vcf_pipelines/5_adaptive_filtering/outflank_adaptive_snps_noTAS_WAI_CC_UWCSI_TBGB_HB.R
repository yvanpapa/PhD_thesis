#### set up environment####
dir<-"G:/DATA/WORK/WGS_PIPELINE/2_popgen/15R_Select_adaptive_snps"
setwd(dir)

library(dartR)
library(data.table) # for fread
library(glue)
library(OutFLANK)
library(pegas)
library(runner)
library(vcfR)

qval <- 0.05 #max q-value for analysis
He<- 0.1 # min He for analysis
qval2<-0.05 #min q-value for top candidates selection
He2<-0.1 #min He for top candidates selection
filter<-"noTAS_WAI_CC_UWCSI_TBGB_HB"

outdir<-glue("{dir}/results/q_{qval2}_He_{He2}_{filter}")
dir.create(outdir)

#check manual here: http://rstudio-pubs-static.s3.amazonaws.com/305384_9aee1c1046394fb9bd8e449453d72847.html
indir<- "G:/DATA/WORK/WGS_PIPELINE/2_popgen/15R_Outflank/scaffolds/"
sort(as.numeric(list.files(indir)))->scfs
scf_lengths <- data.table::fread("./TARdn_assembly_V2_p_srn.txt")

#Run this only the first time!
vcf_file<-list()
vcf_raw<-list()  
gl<-list()
gl_grouped<-list()
gl_nosmall<-list()
FstDataFrame<-list()

print(glue("Analysing 250 scaffolds"))
for (f in scfs[1:250])
  #f<-scfs[33] for testing

{
####import vcf file ####
print(glue("reading scaffold {f}"))

vcf_file[f] <- glue("{indir}/{f}/call_set_AGRFlib1_to_6_V2P.rn.QCmaf.scf{f}.AB.vcf.gz")
vcf_raw[[f]] <- read.vcfR(vcf_file[[f]], verbose = TRUE) #~1min
vcfR2genlight(vcf_raw[[f]], n.cores = 1)->gl[[f]] #~30sec
nInd(gl[[f]])
# 188
nLoc(gl[[f]])
#nb of SNPs

###assign populations####
gsub("[0-9]","", gl[[f]]@ind.names)->pops_grouped
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

gl[[f]]->gl_grouped[[f]]
pops_grouped->pop(gl_grouped[[f]])
gl_grouped[[f]]

#### remove filtered populations ####
gl_nosmall[[f]]<- gl.drop.pop(gl_grouped[[f]],
                     pop.list=c("04.TBGBJ","07.FRDL",
                                "16.CHAT","GBK","18.KTAR",
                                "17.TAS","11.WAI","09.CC",
                                "05.UWCSI","03.TBGB","12.HB"),
                     recalc=T,mono.rm=T,verbose=5)  #~30sec
#165 pops left
pop(gl_nosmall[[f]])
nInd(gl_nosmall[[f]])

####create outflank inputs: SNdata, locusNames, popNames ####
### Outflank requires SNPdata: an array with a row for each individual 
###in the data set and a column for each locus
m <- as.matrix(gl_nosmall[[f]])  #careful, too big for view
#head(m[,1:5])
#the value in each column must be either 0, 1, 2, or 9
#For any locus that is unknown for an individual, SNPdata should have a 9 for that locus on that row
#m[38:60,1:5]
m[which(is.na(m))]<-9
#m[38:60,1:5]
m->SNPdata
dimnames(SNPdata) <- NULL
head(SNPdata[,1:20])

###locusNames is a character vector that gives a list of identifying names for each locus.
###(The length of the locusNames vector should be the same as the number of columns in SNPmat.)
colnames(m)->locusNames
#head(m[,1:5])
#locusNames[1:5]

as.character(pop(gl_nosmall[[f]]))->popNames
#popNames[1:30]
#m[1:30,1:5]

#### MakeDiploidFSTMat ####
#We are going to use the MakeDiploidFSTMat() function to calculate 
#the outflank variables from the SNP data:
print(glue("reading scaffold {f}"))
FstDataFrame[[f]] <- MakeDiploidFSTMat(SNPdata,locusNames,popNames) #~1min
head(FstDataFrame[[f]])

####outflank analysis####
outlier <- OutFLANK(FstDataFrame[[f]], NumberOfSamples=nPop(gl_nosmall[[f]]),
                    LeftTrimFraction = 0.05, RightTrimFraction = 0.05,
                    Hmin = He, qthreshold = qval)

### select outliers
outliers_indices <- which(outlier$results$OutlierFlag==TRUE)
outliers_candidates <- outlier$results[outliers_indices,]


top_outliers_candidates<-outliers_candidates[which(outliers_candidates$qvalues<qval2 & 
                                outliers_candidates$He>He2),]
pos<-as.integer(gsub(".*_","",top_outliers_candidates$LocusName))

#### thin outliers ####
scf_runner <-  runner(x= top_outliers_candidates
              ,idx = pos
              ,f   = function(x){x[["LocusName"]][[which.max(x[["FST"]])]] }     
              ,k   = 500000
              ,at  = seq(from =1, to = max(scf_lengths$length[f]+500000), by = 500000)
              ,na_pad = FALSE)

top_outliers_candidates_selected<- top_outliers_candidates %>% 
  dplyr::filter(LocusName %in% scf_runner)
pos_slctd<-as.integer(gsub(".*_","",top_outliers_candidates_selected$LocusName))

# Create logical vector for top candidates (qvalues<0.01 and He>0.1)
top_candidates <- outlier$results$qvalues<qval2 & outlier$results$He>He2
top_candidates[which(is.na(top_candidates))]<-FALSE


#plot top candidates on scaffold
position<-position(gl_nosmall[[f]])
png(glue("{outdir}/a_{f}_top_outliers_position.png"), width = 6, height = 4, units = "in",res=300)
plot(position, outlier$results$FST,col="grey",pch=20) 
points(position[top_candidates], outlier$results$FST[top_candidates], 
       pch=21, cex=1, col="red")
dev.off()

# clean up by removing low He variants
png(glue("{outdir}/b_{f}_top_outliers_position_nolowHE.png"), width = 6, height = 4, units = "in",res=300)
keep <- outlier$results$He>0.1 & !is.na(outlier$results$He)
plot(position[keep], outlier$results$FST[keep],col="grey",pch=20) 
points(position[top_candidates], outlier$results$FST[top_candidates], 
       pch=21, cex=1, col="red")
dev.off()

#plot selected top candidates on scaffold
position<-position(gl_nosmall[[f]])
png(glue("{outdir}/c_{f}_selected_outliers_position.png"), width = 6, height = 4, units = "in",res=300)
plot(position, outlier$results$FST,col="grey",pch=20) 
points(pos_slctd, top_outliers_candidates_selected$FST, 
       pch=21, cex=1, col="blue")
dev.off()

# clean up by removing low He variants
png(glue("{outdir}/d_{f}_selected_outliers_position_nolowHE.png"), width = 6, height = 4, units = "in",res=300)
keep <- outlier$results$He>0.1 & !is.na(outlier$results$He)
plot(position[keep], outlier$results$FST[keep],col="grey",pch=20) 
points(pos_slctd, top_outliers_candidates_selected$FST, 
       pch=21, cex=1, col="blue")
dev.off()


##### list top candidates #####
chr(gl_nosmall[[f]])[top_candidates]
position[top_candidates]
data.frame(chr(gl_nosmall[[f]])[top_candidates],position[top_candidates])->df
write.table(df,file = glue("{outdir}/g_{f}_list_top_outliers.txt"),sep = "\t",
            row.names = F,col.names = F,quote=F)

write.table(df,file = glue("{outdir}/1_list_top_outliers.txt"),sep = "\t",
            row.names = F,col.names = F,quote=F,append=T)

#### list selected outlier ####
##### list top candidates #####
chr(gl_nosmall[[f]])[1:length(pos_slctd)]
pos_slctd


data.frame(rep.int(f,length(pos_slctd)),pos_slctd)->df2
write.table(df2,file = glue("{outdir}/h_{f}_list_selected_outliers.txt"),sep = "\t",
            row.names = F,col.names = F,quote=F)

write.table(df2,file = glue("{outdir}/2_list_selected_outliers.txt"),sep = "\t",
            row.names = F,col.names = F,quote=F,append=T)
}
