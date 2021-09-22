#### set up environment####
#takes a WHILE to load (started 1h45-finished 2h30)
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

outdir<-glue("{dir}/results/q_{qval2}_He_{He2}")
dir.create(outdir)

#check manual here: http://rstudio-pubs-static.s3.amazonaws.com/305384_9aee1c1046394fb9bd8e449453d72847.html
indir<- "G:/DATA/WORK/WGS_PIPELINE/2_popgen/15R_Outflank/scaffolds/"
sort(as.numeric(list.files(indir)))->scfs
scf_lengths <- data.table::fread("./TARdn_assembly_V2_p_srn.txt")

#Use that script only if the following lists are already loaded in env
#vcf_file<-list()
#vcf_raw<-list()  
#gl<-list()
#gl_grouped<-list()
#gl_nosmall<-list()
#FstDataFrame<-list()

print(glue("Analysing 250 scaffolds"))
for (f in scfs[229:250])
  #f<-scfs[33] for testing

{
print(glue("reading scaffold {f}"))

#nInd(gl[[f]])
# 188
#nLoc(gl[[f]])
#nb of SNPs

#gl_grouped[[f]]
#### remove low sampled populations and KTAR ####
#gl_nosmall[[f]]

#165 pops left
#pop(gl_nosmall[[f]])
#nInd(gl_nosmall[[f]])

#### MakeDiploidFSTMat ####
#We are going to use the MakeDiploidFSTMat() function to calculate 
#the outflank variables from the SNP data:
#print(glue("reading scaffold {f}"))
#head(FstDataFrame[[f]])

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
