#https://popgen.nescent.org/2018-03-27_RDA_GEA.html
#DONT FORGET TO CHANGE NPERM IN SIGNIF.FULL AND SIGNIF.AXIS IF NEEDED

setwd("G:/DATA/WORK/P0 THESIS/CHAPTER 5B/R")

library(vcfR)
library(dartR)
library(glue)
#library(sdmpredictors) #for loading env data
#library(leaflet) #optionnal to check samples locs on google maps
library(psych) # Used to investigate correlations among predictors    
library(vegan) # Used to run RDA

indir<- "G:/DATA/WORK/WGS_PIPELINE/2_popgen/15R_Outflank/scaffolds/"
sort(as.numeric(list.files(indir)))->scfs
print(glue("Analysing {length(scfs)} scaffolds"))


vcf_raw_list<-list()
gl_list<-list()
gl_grouped_list<-list()
gl_GEA_list<-list()
gen_list<-list()
gen.imp_list<-list()

envloaded<-0  #load env data frame only in the first instence of the loop

for (f in scfs[1:10]) # #
#f<-10
{
  ####import vcf file ####
  print(glue("reading scaffold {f}"))
  
  vcf_file <- glue("{indir}/{f}/call_set_AGRFlib1_to_6_V2P.rn.QCmaf.scf{f}.AB.vcf.gz")
  vcf_raw <- read.vcfR(vcf_file, verbose = TRUE) # ~2 minutes # #
  vcfR2genlight(vcf_raw, n.cores = 1)->gl #~1 minute # #

print(gl)
print(gl@ind.names)


####2. assign populations####
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

#####3. remove KTAR, TAS, GBK, and juveniles #######
gl_GEA<- gl.drop.pop(gl_grouped,
                     pop.list=c("04.TBGBJ","GBK","18.KTAR","17.TAS"),
                     recalc=T,mono.rm=T,verbose=5) #~30 seconds
#156 ind left
print(gl_GEA)
print(pop(gl_GEA))
print(levels(pop(gl_GEA)))

####4. convert to data frame and replace NAs####
#convert to large snp matrix
data.frame(as.matrix(gl_GEA))->gen
dim(gen)

#We have 156 individuals (rows) genotyped at 182,341 SNPs (columns).
#RDA requires complete data frames (i.e., no missing data). 
#We'll use a simple approach to imputing missing values:
#we will impute using the most common genotype at each SNP across all individuals.
sum(is.na(gen))
gen.imp <- apply(gen, 2, function(x) replace(x, is.na(x), as.numeric(names(which.max(table(x))))))
sum(is.na(gen.imp))

####5. Get env data frame ####

if (envloaded==0) {
env_6_variables <- read.csv("G:/DATA/WORK/P0 THESIS/CHAPTER 5B/R/env_6_variables.txt", sep="")


# Optionnal: Visualise sites of interest in google maps
#m <- leaflet()
#m <- addTiles(m)
#m <- addMarkers(m,env_6_variables$long, lat=env_6_variables$lat, 
#                popup=env_6_variables$location)
#m

env<-env_6_variables

#optionnal, to look at some variables:

### MAYBE PLOT THESE VARIABLES IN THE OTHER SCRIPT!

env$location <- as.factor(env$location)    # Make location a factor
str(env)

#### 6. rename ind names and sort data frames so match order ####
env <- env[order(env$individual),]
gsub("-","_",env[,1])->env[,1]
}

gen.imp <- gen.imp[order(rownames(gen.imp)),]
#optionnal, to check if there are disparities
rownames(gen.imp)==env[,1]
data.frame(rownames(gen.imp),env[,1])->df
#View(df)
which(rownames(gen.imp)!=env[,1])

#!!!!!! CAUTION !!!!!!
#only do this if you have checked that rownames(gen.imp) and env[,1] do match 
###in the right order!!!!

env[,1]->rownames(gen.imp)
identical(rownames(gen.imp), env[,1])
str(env)

if (envloaded==0) {
#### 7. check for highly correlated predictors ####
png(glue("./RDA_outdir/pair_panels.png"), width = 6, height = 4, units = "in",res=300)
pairs.panels(env[,5:10], scale=T)
dev.off()
  
}
  
# They are all weakly or not correlated!

#### 8. Run the RDA ####
tar.rda <- rda(gen.imp ~ ., data=env[,5:10], scale=T) #takes 1 minute with 2 vars
tar.rda

RsquareAdj(tar.rda)
#Our constrained ordination explains about 0.04% of the variation
summary(eigenvals(tar.rda, model = "constrained"))
png(glue("./RDA_outdir/eig_{f}.png"), width = 6, height = 4, units = "in",res=300)
screeplot(tar.rda.10)
dev.off()

png(glue("./RDA_outdir/eig_1.png"), width = 6, height = 4, units = "in",res=300)
screeplot(tar.rda.1)
dev.off()

pdf(glue("./RDA_outdir/eig_1.pdf"), width = 6, height = 4)
screeplot(tar.rda.1)
dev.off()


signif.full <- anova.cca(tar.rda, parallel=getOption("mc.cores"),
                         permutations = how(nperm=999)) # default is permutation=999 #~15min with 2 axes
#~20min with 6 variables
signif.full # for scaffold 1, p=0.023!
#Permutation test for rda under reduced model
#Permutation: free
#Number of permutations: 999
#Model: rda(formula = gen.imp ~ mean_DP + mean_SSTP, data = pred, scale = T)
#Df Variance      F Pr(>F)
#Model      2     2375 1.0095  0.106
#Residual 153   179966  
#p=0.106, NOT SIGNIFICANT


if (envloaded==0) {
levels(env$location)
#### assign colors ####
colors<-c("01.UWCNI"="#006c31",
          "10. Wellington"="#ff8bc3",
          "11. Wairarapa"="#ddc637",
          "12. Hawkes Bay"="#86004e",
          "13. East Cape"="#49adad",
          "14. ENLD/Hauraki Gulf"="#ea6d33",
          "15. East Northland"="#8f6400",
          "16. Chatham Islands"="#42006b",
          "2. Taranaki"="#c07700",
          "3. TBGB"="#e9b1ff",
          "5. Upper WCSI" ="#68a825",
          "6. Lower WCSI"="#b664d9",
          "7. Fiordland"="#70ec8f",
          "8. Christchurch"="#a6002c",
          "9. Cape Campbell"="#6284ff")
}

png(glue("./RDA_outdir/rda_{f}.png"), width = 12, height = 8, units = "in",res=300)
plot(tar.rda, type="n", scaling=3)
points(tar.rda, display="species", pch=20, cex=0.7, col="gray32", scaling=3)           # the SNPs
points(tar.rda, display="sites", pch=21, cex=1.3, col="gray32", scaling=3, bg=colors[env$location]) # the tarakihi
text(tar.rda, scaling=3, display="bp", col="#0868ac", cex=1)                           # the predictors
legend("bottomright", legend=levels(env$location), bty="n", col="gray32", pch=21, cex=0.8, pt.bg=colors)
dev.off()


#### END FIRST LOOP HERE ####
vcf_raw_list[f]<-vcf_raw
gl_list[f]<-gl
gl_grouped_list[f]<-gl_grouped
gl_GEA_list[f]<-gl_GEA
gen_list[[f]]<-gen
gen.imp_list[[f]]<-gen.imp

name<-paste("tar.rda",f,sep=".")
assign(name,tar.rda)
name<-paste("signif.full",f,sep=".")
assign(name,signif.full)

envloaded<-1
print(glue("Scaffold {f} complete"))
save.image("RDA_QCAB_2_loop1.RData")

#END OF FIRST LOOP
}

#### SIGNIF AXIS: takes a while ####
#THIS TAKES TOO MUCH TIME, WE'LL DO IT AT THE END
tar.rda.1->tar.rda
saveRDS(tar.rda.1, file = "rda_scf1.RDS")
#empty environment because we need space

tar.rda <- readRDS("rda_scf1.RDS")

#Error: cannot allocate vector of size 217.0 Mb -> we need more memory allocated, so
#I just run it with 99 here 

signif.axis <- anova.cca(tar.rda, by="axis", parallel=getOption("mc.cores"),
 permutations = how(nperm=99)) #3h31
signif.axis
#Axis 1 is Pr(>F) = 0.01! The other axes are Pr(>F) > 0.1

#### START HERE AFTER LOOP ####

tar.rda.1->tar.rda
vif.cca(tar.rda)
#> vif.cca(tar.rda)
#BO21_tempmean_bdmean                 BO_damean BO21_salinityrange_bdmean          BO21_ironmean_ss 
#1.064817                  1.246880                  1.193915                  1.159694 
#BO21_ppmean_bdmin  MS_biogeo07_concavity_5m 
#1.542224                  1.227707 
#All values are below 10, and most are below 5
#which indicates that multicollinearity among these predictors shouldn't be a problem for the model.




#Identify candidate SNPs involved in local adaptation
load.rda <- scores(tar.rda, choices=c(1), display="species")  # Species scores for the first constrained axes

png(glue("./RDA_outdir/loadings_RDA1.png"), width = 6, height = 4, units = "in",res=300)
hist(load.rda[,1], main="Loadings on RDA1")
dev.off()

#identify SNPs that load in the tails of these distributions.
#We can be less stringent by changing sd=3.5 to sd=3

outliers <- function(x,z){
  lims <- mean(x) + c(-1, 1) * z * sd(x)     # find loadings +/-z sd from mean loading     
  x[x < lims[1] | x > lims[2]]               # locus names in these tails
}

cand1 <- outliers(load.rda[,1],3.5) 
length(cand1) #55 (306 with std=3)

ncand <- length(cand1)
ncand #55

#We have 55 candidates on axis 1

cand1 <- cbind.data.frame(rep(1,times=length(cand1)), names(cand1), unname(cand1))
colnames(cand1) <- c("axis","snp","loading")
cand1$snp <- as.character(cand1$snp)

cand <- cand1
cand$snp <- as.character(cand$snp)

#Let's add in the correlations of each candidate SNP with the eight environmental predictors:

foo <- matrix(nrow=(ncand), ncol=6)  # 6 columns for 6 predictors
colnames(foo) <- c("tempmean_bdmean","damean","salinityrange_bdmean",
                   "ironmean_ss","ppmean_bdmin","concavity")

gen.imp_list[[1]]->gen.imp
env[,5:10]->pred

for (i in 1:length(cand$snp)) {
  nam <- cand[i,2]
  snp.gen <- gen.imp[,nam]
  foo[i,] <- apply(pred,2,function(x) cor(x,snp.gen))
}


cand <- cbind.data.frame(cand,foo)  
head(cand)

#Next, we'll see which of the predictors each candidate SNP is most strongly correlated with:

for (i in 1:length(cand$snp)) {
  bar <- cand[i,]
  cand[i,10] <- names(which.max(abs(bar[4:9]))) # gives the variable
  cand[i,11] <- max(abs(bar[4:9]))              # gives the correlation
}

colnames(cand)[10] <- "predictor"
colnames(cand)[11] <- "correlation"

table(cand$predictor) 
#A lot of them are linked to temperature!

write.table(cand, file = "RDA_outdir/axis1_scf1_outlier_candidates.txt", quote = F, sep = "\t",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = TRUE)

#Let's look at RDA plots again, but this time focus in on the SNPs in the ordination space. 
#We'll color code the SNPs based on the predictor variable that they are most strongly 
#correlated with.

sel <- cand$snp
envcol <- cand$predictor
envcol[envcol=="tempmean_bdmean"] <- '#1f78b4'
envcol[envcol=="damean"] <- '#a6cee3'
envcol[envcol=="salinityrange_bdmean"] <- '#6a3d9a'
envcol[envcol=="ironmean_ss"] <- '#e31a1c'
envcol[envcol=="ppmean_bdmin"] <- '#33a02c'
envcol[envcol=="concavity"] <- '#ffff33'


# color by predictor:
col.pred <- rownames(tar.rda$CCA$v) # pull the SNP names

for (i in 1:length(sel)) {           # color code candidate SNPs
  foo <- match(sel[i],col.pred)
  col.pred[foo] <- envcol[i]
}

col.pred[grep("X*_",col.pred)] <- '#f1eef6' # non-candidate SNPs
empty <- col.pred
empty[grep("#f1eef6",empty)] <- rgb(0,1,0, alpha=0) # transparent
empty.outline <- ifelse(empty=="#00FF0000","#00FF0000","gray32")
bg <- c('#1f78b4','#a6cee3','#6a3d9a','#e31a1c','#33a02c','#ffff33')


#Now we're ready to plot the SNPs:
# axes 1 & 2
png(glue("./RDA_outdir/rda_1_signif.png"), width = 6, height = 4, units = "in",res=300)
plot(tar.rda, type="n", scaling=3, xlim=c(-1,1), ylim=c(-1,1))
points(tar.rda, display="species", pch=21, cex=0.5, col="gray32", bg=col.pred, scaling=3)
points(tar.rda, display="species", pch=21, cex=0.5, col=empty.outline, bg=empty, scaling=3)
text(tar.rda, scaling=3, display="bp", col="#0868ac", cex=1)
legend("bottomright", legend=c("tempmean_bdmean","damean","salinityrange_bdmean",
                               "ironmean_ss","ppmean_bdmin","concavity"), 
       bty="n", col="gray32", pch=21, cex=1, pt.bg=bg)
dev.off()


#### Final plot ####
tar.rda.1->tar.rda
summary(eigenvals(tar.rda, model = "constrained"))

#sel_coords <- tar.rda$CCA$v[rownames(tar.rda$CCA$v) %in% sel, ]  # Extract rows from data
                                               # Print data frame subset

png(glue("./RDA_outdir/rda_1_final.png"), width = 12, height = 8, units = "in",res=300)
plot(tar.rda, type="n", scaling=3,
     xlab="Constrained axis 1: 17.29%",ylab="Constrained axis 2: 17.09%")
points(sel_coords[,1:2], pch=20, cex=1,scaling=3)  # the selected SNPs
points(tar.rda, display="sites", pch=21, cex=1.3, scaling=3, bg=colors[env$location]) # the tarakihi
text(tar.rda, scaling=3, display="bp", cex=1)                           # the predictors
legend("bottomright", legend=levels(env$location), bty="n", pch=21, cex=0.8, pt.bg=colors)
dev.off()

pdf(glue("./RDA_outdir/rda_1_final.pdf"), width = 12, height = 8)
plot(tar.rda, type="n", scaling=3,
     xlab="Constrained axis 1: 17.29%",ylab="Constrained axis 2: 17.09%")
points(tar.rda, display="sites", pch=21, cex=1.3, scaling=3, bg=colors[env$location]) # the tarakihi
text(tar.rda, scaling=3, display="bp", cex=1)                           # the predictors
legend("bottomright", legend=levels(env$location), bty="n", pch=21, cex=0.8, pt.bg=colors)
dev.off()

#### PLOT THE VARIABLES OF INTEREST ####
var_rasters<-load_layers(layercodes = c("BO21_tempmean_bdmean","BO21_ppmean_bdmin",
                                        "BO21_ironmean_ss","BO21_salinityrange_bdmean",
                                        "BO_damean","MS_biogeo07_concavity_5m"),
                         equalarea=FALSE, rasterstack=TRUE,datadir="datadir")

my.colors = colorRampPalette(c("#5E85B8","#EDF0C0","#C13127"))
nz.ext <- extent(165, 180, -47.5, -34)
var.crop <- crop(var_rasters, nz.ext)
plot(var.crop,col=my.colors(1000))

png(glue("./RDA_outdir/rasters_plots.png"), width = 6, height = 4, units = "in",res=300)
plot(var.crop,col=my.colors(1000))
dev.off()

pdf(glue("./RDA_outdir/rasters_plots.pdf"), width = 6, height = 4)
plot(var.crop,col=my.colors(1000))
dev.off()

#### let's check for a linear correlation between temperature and the RDA axis 1 ####
data.frame(tar.rda$CCA$u[,1])->df1
env->env2
rownames(env2)<-env2$individual
rownames(df1)==rownames(env2)
cbind(env2,df1)->env_rd1


cor(env_rd1$tar.rda.CCA.u...1.,env_rd1$BO21_ppmean_bdmin)
cor(env_rd1$tar.rda.CCA.u...1.,env_rd1$BO21_ironmean_ss)
cor(env_rd1$tar.rda.CCA.u...1.,env_rd1$BO21_salinityrange_bdmean)

library(ggrepel)
cor.test(env_rd1$tar.rda.CCA.u...1.,env_rd1$BO21_tempmean_bdmean)
#R2=-0.6529587 p-value < 2.2e-16
png(glue("./RDA_outdir/lm_temp.png"), width = 6, height = 5, units = "in",res=300)
ggplot(env_rd1, aes(x=BO21_tempmean_bdmean,y=tar.rda.CCA.u...1.,
                    label=location))+
  stat_smooth(method = "lm", col = "blue")+
  geom_point()+
  geom_label()+
  theme_light()+
  theme(
        panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="temperature", y="RDA axis 1")+
  annotate("text",label=c(expression(paste(R^2,"= - 0.653")),"p-value < 0.001"),
           x = c(9,9), y = c(-0.1,-0.12),size=5)
dev.off()

cor.test(env_rd1$tar.rda.CCA.u...1.,env_rd1$lat)
#R2=-0.6532652 p-value < 2.2e-16
png(glue("./RDA_outdir/lm_lat.png"), width = 6, height = 5, units = "in",res=300)
ggplot(env_rd1, aes(x=lat,y=tar.rda.CCA.u...1.,
                    label=location))+
  stat_smooth(method = "lm", col = "blue")+
  geom_point()+
  geom_label()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="latitude", y="RDA axis 1")+
  annotate("text",label=c(expression(paste(R^2,"= - 0.653")),"p-value < 0.001"),
           x = c(-44.5,-44.5), y = c(-0.1,-0.12),size=5)
dev.off()

grep("CHAT",env_rd1$individual)

cor.test(env_rd1$tar.rda.CCA.u...1.[-grep("CHAT",env_rd1$individual)],
         env_rd1$long[-grep("CHAT",env_rd1$individual)])
ggplot(env_rd1[-grep("CHAT",env_rd1$individual),], aes(x=long,y=tar.rda.CCA.u...1.,
                    label=location))+
  stat_smooth(method = "lm", col = "blue")+
  geom_point()+
  geom_label()+
  theme_light()
