#### Load packages (leaflet allows to load google maps) ####
library(sdmpredictors) #for loading env data
library(leaflet) #optionnal to check samples locs on google maps
library(psych) # Used to investigate correlations among predictors    
library(vegan) # Used to run RDA

#### List layers avaialble in Bio-ORACLE v2 ####
list_datasets()
layers.bio2 <- list_layers( datasets="Bio-ORACLE" )

#### env variable dataframe ####
# let's create a complete data frame with only the latest version of each variable 
layers.bio_v21<-layers.bio2[grep("BO21_",layers.bio2$layer_code),] #v2.1
layers.bio_v2<-layers.bio2[grep("BO2_",layers.bio2$layer_code),] #v2
layers.bio_v1<-layers.bio2[grep("BO_",layers.bio2$layer_code),] #v1
sort(layers.bio_v21$name)==sort(layers.bio_v2$name) #v2 and v2.1 have the same variables
length(which(duplicated(c(layers.bio_v1$name,layers.bio_v21$name))))
rbind(layers.bio_v1,layers.bio_v21)->layers_bio
layers_bio <- layers_bio[order(layers_bio$name),]
layers.marspec <- list_layers( datasets="MARSPEC" )
rbind(layers_bio,layers.marspec)->all_layers

#I had to filter the layers #54, 58, 62, 66, 70, 74 because they dont have the
#correct extant
v_layers<-c(1:53,55:57,59:61,63:65,67:69,71:73,75:length(all_layers$layer_code))

df_all_env_vals<-load_layers(layercodes = sort(all_layers$layer_code)[v_layers], 
                             equalarea=FALSE, 
                             rasterstack=TRUE,datadir="datadir")

#### generate samples df ####
#sample coordinates
#Get samples coordinates. 
#!!! we don't center at 180 here bc not necessary
coord_points <- read.delim("TAR_latlon.txt")
sample_locs<-coord_points[,c(1,6,11,12)]

sample_locs2<-sample_locs[-grep("GB19-001-K",sample_locs[,2]),]
sample_locs2<-sample_locs2[-grep("18. King TAR",sample_locs2[,1]),]
sample_locs2<-sample_locs2[-grep("JUV",sample_locs2[,1]),]
sample_locs2<-sample_locs2[-grep("17. Tasmania",sample_locs2[,1]),]

#We need to tweak some of the latlon for samples for which that was not provided
#move FRDL coord a bit to West so they are not considered enclaved in land
#-> move them to Dusky Sound cause they were probably caughted around there
sample_locs2$long[which(sample_locs2$loc_label=="7. Fiordland")]<-166.46
sample_locs2$lat[which(sample_locs2$loc_label=="7. Fiordland")]<--45.76
#move latlon of ENLD (that was estimatd) so it's not <200m
sample_locs2$long[which(sample_locs2$loc_label=="15. East Northland")[-1]]<-174
#move latlon of some of EC that were estimatd so it's not <200m
sample_locs2$long[which(sample_locs2$loc_label=="13. East Cape"&sample_locs2$long==178.69)]<-178.55
sample_locs2$long[which(sample_locs2$loc_label=="13. East Cape"&sample_locs2$long==178.25)]<-178.2
#move latlon of some of EC that were estimatd so it's not <200m
sample_locs2$long[which(sample_locs2$loc_label=="10. Wellington"&sample_locs2$long==174.56)]<-174.6


#### generate env_tot df ####
env_tot1 <- data.frame(individual=sample_locs2$Unique.fish.ID.,location=sample_locs2$loc_label,
                       long=sample_locs2$long,lat=sample_locs2$lat,
                       extract(subset(df_all_env_vals,1:100),sample_locs2[,4:3]))
env_tot2 <- data.frame(individual=sample_locs2$Unique.fish.ID.,location=sample_locs2$loc_label,
                       long=sample_locs2$long,lat=sample_locs2$lat,
                       extract(subset(df_all_env_vals,101:200),sample_locs2[,4:3]))
env_tot3 <- data.frame(individual=sample_locs2$Unique.fish.ID.,location=sample_locs2$loc_label,
                       long=sample_locs2$long,lat=sample_locs2$lat,
                       extract(subset(df_all_env_vals,201:300),sample_locs2[,4:3])) 
env_tot4 <- data.frame(individual=sample_locs2$Unique.fish.ID.,location=sample_locs2$loc_label,
                       long=sample_locs2$long,lat=sample_locs2$lat,
                       extract(subset(df_all_env_vals,301:355),sample_locs2[,4:3])) 

cbind(env_tot1,env_tot2[,-c(1:4)],env_tot3[,-c(1:4)],env_tot4[,-c(1:4)])->env_tot

####create a list of all variables####
colnames(env_tot)[-c(1:4)]->var_list
var_list[1]
#bathymetry
pairs.panels(env_tot[,grep("bathy",colnames(env_tot))], scale=T)
colnames(env_tot[,grep("bathy",colnames(env_tot))])
pairs.panels(cbind(env_tot$BO_bathymean,env_tot$MS_biogeo06_bathy_slope_5m),scale=T)
var_keep<-c("BO_bathymean","MS_biogeo06_bathy_slope_5m")
var_list[-c(grep("bathy",var_list))]->var_list

var_list[1]
#calcite
pairs.panels(env_tot[,grep("calcite",colnames(env_tot))], scale=T)
colnames(env_tot[,grep("calcite",colnames(env_tot))])
var_keep<-c(var_keep,"BO_calcite")
var_list[-c(grep("calcite",var_list))]->var_list

var_list[1]
#chlorophile
colnames(env_tot[,grep("chlo",colnames(env_tot))])
pairs.panels(env_tot[,grep("chlo",colnames(env_tot))][,c(2,3,6,16,1,4,5,7,8)], scale=T)
pairs.panels(env_tot[,grep("chlo",colnames(env_tot))][,c(2,3,6,16,9:14)], scale=T)
pairs.panels(env_tot[,grep("chlo",colnames(env_tot))][,c(2,3,6,16,15,17:22)], scale=T)
pairs.panels(cbind(env_tot$BO_chlomean,env_tot$BO_chlomin,env_tot$BO21_chloltmax_bdmean,
                   env_tot$BO21_chlomean_bdmin),scale=T)
var_keep<-c(var_keep,"BO_chlomean","BO_chlomin","BO21_chloltmax_bdmean",
            "BO21_chlomean_bdmin")
var_list[-c(grep("chlo",var_list))]->var_list

var_list[1]
#cloud fraction
colnames(env_tot[,grep("cloud",colnames(env_tot))])
pairs.panels(env_tot[,grep("cloud",colnames(env_tot))], scale=T)
var_keep<-c(var_keep,"BO_cloudmean")
var_list[-c(grep("cloud",var_list))]->var_list

var_list[1]
#Diffuse attenuation
colnames(env_tot[,grep("da",colnames(env_tot))])
pairs.panels(env_tot[,grep("da",colnames(env_tot))], scale=T)
var_keep<-c(var_keep,"BO_damean")
var_keep
var_list[-c(grep("da",var_list))]->var_list

var_list[1]
#Dissolved oxygen
colnames(env_tot[,grep("dissox",colnames(env_tot))])
pairs.panels(env_tot[,grep("dissox",colnames(env_tot))][,c(1:13)], scale=T)
pairs.panels(env_tot[,grep("dissox",colnames(env_tot))][,c(14:25)], scale=T)
pairs.panels(cbind(env_tot$BO_dissox,env_tot$BO21_dissoxmean_bdmean,
                   env_tot$BO21_dissoxrange_bdmean),scale=T)
var_keep<-c(var_keep,"BO_dissox","BO21_dissoxmean_bdmean","BO21_dissoxrange_bdmean")
var_list[-c(grep("dissox",var_list))]->var_list

var_list[1]
#nitrate
colnames(env_tot[,grep("nitrate",colnames(env_tot))])
pairs.panels(env_tot[,grep("nitrate",colnames(env_tot))][,c(1:13)], scale=T)
pairs.panels(env_tot[,grep("nitrate",colnames(env_tot))][,c(14:25)], scale=T)
pairs.panels(cbind(env_tot$BO_nitrate,
                   env_tot$BO21_nitraterange_bdmean),scale=T)
var_keep<-c(var_keep,"BO_nitrate","BO21_nitraterange_bdmean")
var_keep
var_list[-c(grep("nitrate",var_list))]->var_list

var_list[1]
#Photosynthetically available radiation 
colnames(env_tot[,grep("par",colnames(env_tot))])
pairs.panels(env_tot[,grep("par",colnames(env_tot))], scale=T)
var_keep<-c(var_keep,"BO_parmean")
var_keep
var_list[-c(grep("par",var_list))]->var_list

var_list[1]
#	pH
colnames(env_tot[,grep("ph",colnames(env_tot))])
var_keep<-c(var_keep,"BO_ph")
var_keep
var_list[-c(grep("^BO_ph$",var_list))]->var_list

var_list[1]
#Phosphate
colnames(env_tot[,grep("phosphate",colnames(env_tot))])
pairs.panels(env_tot[,grep("phosphate",colnames(env_tot))][,c(1:13)], scale=T)
pairs.panels(env_tot[,grep("phosphate",colnames(env_tot))][,c(14:25)], scale=T)
pairs.panels(cbind(env_tot$BO_phosphate,env_tot$BO21_phosphatemean_bdmean,
                   env_tot$BO21_phosphaterange_bdmean),scale=T)
var_keep<-c(var_keep,"BO_phosphate","BO21_phosphaterange_bdmean")
var_keep
var_list[-c(grep("phosphate",var_list))]->var_list

var_list[1]
#salinity 
colnames(env_tot[,grep("salinity",colnames(env_tot))])
pairs.panels(env_tot[,grep("salinity",colnames(env_tot))][,c(1:13)], scale=T)
pairs.panels(env_tot[,grep("salinity",colnames(env_tot))][,c(14:25)], scale=T)
pairs.panels(cbind(env_tot$BO_salinity,env_tot$BO21_salinitymean_bdmean,
                   env_tot$BO21_salinityrange_bdmean),scale=T)
var_keep<-c(var_keep,"BO_salinity","BO21_salinityrange_bdmean")
var_keep
var_list[-c(grep("salinity",var_list))]->var_list

var_list[1]
#silicate
colnames(env_tot[,grep("silicate",colnames(env_tot))])
pairs.panels(env_tot[,grep("silicate",colnames(env_tot))][,c(1:13)], scale=T)
pairs.panels(env_tot[,grep("silicate",colnames(env_tot))][,c(14:25)], scale=T)
pairs.panels(cbind(env_tot$BO_silicate,env_tot$BO21_silicatemean_bdmean,
                   env_tot$BO21_silicaterange_bdmean),scale=T)
var_keep<-c(var_keep,"BO_silicate","BO21_silicaterange_bdmean")
var_keep
var_list[-c(grep("silicate",var_list))]->var_list

var_list[1]
#Sea surface temperature
colnames(env_tot[,grep("sst",colnames(env_tot))])
pairs.panels(env_tot[,grep("sst",colnames(env_tot))][,c(1:10)], scale=T)
pairs.panels(env_tot[,grep("sst",colnames(env_tot))][,c(1,11:20)], scale=T)
pairs.panels(cbind(env_tot$BO_sstmean,env_tot$BO_sstrange
                   ),scale=T)
var_keep<-c(var_keep,"BO_sstmean","BO_sstrange")
var_keep
var_list[-c(grep("sst",var_list))]->var_list

var_list[1]
#carbon phytoplankton biomass
colnames(env_tot[,grep("carbonphyto",colnames(env_tot))])
pairs.panels(env_tot[,grep("carbonphyto",colnames(env_tot))][,c(1:12)], scale=T)
pairs.panels(env_tot[,grep("carbonphyto",colnames(env_tot))][,c(13:24)], scale=T)
pairs.panels(env_tot[,grep("carbonphyto",colnames(env_tot))][,c(14:16,1:5)], scale=T)
pairs.panels(env_tot[,grep("carbonphyto",colnames(env_tot))][,c(14:16,6:12)], scale=T)
pairs.panels(cbind(env_tot$BO21_carbonphytomean_bdmean,env_tot$BO21_carbonphytomean_bdmin,
                   env_tot$BO21_carbonphytomean_ss),scale=T)
var_keep<-c(var_keep,"BO21_carbonphytomean_bdmean","BO21_carbonphytomean_ss")
var_keep
var_list[-c(grep("carbonphyto",var_list))]->var_list

var_list[1]
#Current velocity
colnames(env_tot[,grep("curvel",colnames(env_tot))])
pairs.panels(env_tot[,grep("curvel",colnames(env_tot))][,c(14,13,1:8)], scale=T)
pairs.panels(env_tot[,grep("curvel",colnames(env_tot))][,c(14,13,9:12)], scale=T)
pairs.panels(env_tot[,grep("curvel",colnames(env_tot))][,c(14,13,15:20)], scale=T)
pairs.panels(env_tot[,grep("curvel",colnames(env_tot))][,c(14,13,21:24)], scale=T)
pairs.panels(cbind(env_tot$BO21_curvelmean_bdmax,
                   env_tot$BO21_curvelmean_bdmean),scale=T)
var_keep<-c(var_keep,"BO21_curvelmean_bdmax","BO21_curvelmean_bdmean")
var_keep
var_list[-c(grep("curvel",var_list))]->var_list

var_list[1]
#Ice cover
colnames(env_tot[,grep("ice",colnames(env_tot))])
var_keep
var_list[-c(grep("ice",var_list))]->var_list

var_list[1]
#Iron concentration
colnames(env_tot[,grep("iron",colnames(env_tot))])
pairs.panels(env_tot[,grep("iron",colnames(env_tot))][,c(14,16,1:8)], scale=T)
pairs.panels(env_tot[,grep("iron",colnames(env_tot))][,c(14,16,9:13)], scale=T)
pairs.panels(env_tot[,grep("iron",colnames(env_tot))][,c(14,16,15,17:20)], scale=T)
pairs.panels(env_tot[,grep("iron",colnames(env_tot))][,c(14,16,21:24)], scale=T)
pairs.panels(cbind(env_tot$BO21_ironmean_bdmean,
                   env_tot$BO21_ironmean_ss),scale=T)
var_keep<-c(var_keep,"BO21_ironmean_bdmean","BO21_ironmean_ss")
var_keep
var_list[-c(grep("iron",var_list))]->var_list


var_list[1]
#light penetration
colnames(env_tot[,grep("light",colnames(env_tot))])
pairs.panels(env_tot[,grep("light",colnames(env_tot))][,c(10,11,1:5)], scale=T)
pairs.panels(env_tot[,grep("light",colnames(env_tot))][,c(10,11,12,6:9)], scale=T)
pairs.panels(env_tot[,grep("light",colnames(env_tot))][,c(10,11,12,13:18)], scale=T)
pairs.panels(cbind(env_tot$BO21_lightbotmean_bdmax,
                   env_tot$BO21_lightbotmean_bdmean,
                   env_tot$BO21_lightbotmean_bdmin),scale=T)
var_keep<-c(var_keep,"BO21_lightbotmean_bdmax","BO21_lightbotmean_bdmean",
            "BO21_lightbotmean_bdmin")
var_keep
var_list[-c(grep("light",var_list))]->var_list

var_list[1]
#primary production
colnames(env_tot[,grep("pp",colnames(env_tot))])
pairs.panels(env_tot[,grep("pp",colnames(env_tot))][,c(14,15,16,1:5)], scale=T)
pairs.panels(env_tot[,grep("pp",colnames(env_tot))][,c(14,15,16,6:10)], scale=T)
pairs.panels(env_tot[,grep("pp",colnames(env_tot))][,c(14,15,16,11:13,17:18)], scale=T)
pairs.panels(env_tot[,grep("pp",colnames(env_tot))][,c(14,15,16,19:24)], scale=T)
pairs.panels(cbind(env_tot$BO21_ppmean_bdmean,
                   env_tot$BO21_ppmean_bdmin,
                   env_tot$BO21_ppmean_ss),scale=T)
var_keep<-c(var_keep,"BO21_ppmean_bdmean","BO21_ppmean_bdmin",
            "BO21_ppmean_ss")
var_keep
var_list[-c(grep("pp",var_list))]->var_list

var_list[1]
#sea water temperature
colnames(env_tot[,grep("temp",colnames(env_tot))])
pairs.panels(env_tot[,grep("temp",colnames(env_tot))][,c(14,22,24,15,16,1:5)], scale=T)
pairs.panels(env_tot[,grep("temp",colnames(env_tot))][,c(14,22,24,6:10)], scale=T)
pairs.panels(env_tot[,grep("temp",colnames(env_tot))][,c(14,22,24,11:13,17:18)], scale=T)
pairs.panels(env_tot[,grep("temp",colnames(env_tot))][,c(14,22,24,19:21,23)], scale=T)
pairs.panels(cbind(env_tot$BO21_tempmean_bdmean,
                   env_tot$BO21_temprange_bdmean,
                   env_tot$BO21_temprange_ss),scale=T)
var_keep<-c(var_keep,"BO21_tempmean_bdmean","BO21_temprange_bdmean",
            "BO21_temprange_ss")
var_keep
var_list[-c(grep("temp",var_list))]->var_list

var_list[1]
#bio geo stuff, including distance to shore or bathymetric slope
colnames(env_tot[,grep("biogeo",colnames(env_tot))])
pairs.panels(env_tot[,grep("biogeo",colnames(env_tot))][,c(1:7)], scale=T)
var_keep<-c(var_keep,colnames(env_tot[,grep("biogeo",colnames(env_tot))])[1:7])
var_keep
var_list[-c(grep("biogeo",var_list))[1:7]]->var_list

var_list[1]
#sea surface salinity
colnames(env_tot[,grep("sss",colnames(env_tot))])
pairs.panels(env_tot[,grep("sss",colnames(env_tot))][,c(1,4,2:3,5:9)], scale=T)
pairs.panels(env_tot[,grep("sss",colnames(env_tot))][,c(1,4,10:17)], scale=T)
pairs.panels(cbind(env_tot$MS_biogeo08_sss_mean_5m,
                   env_tot$MS_biogeo11_sss_range_5m))
var_keep<-c(var_keep,"MS_biogeo08_sss_mean_5m",
            "MS_biogeo11_sss_range_5m")
var_keep
var_list[-c(grep("sss",var_list))]->var_list

var_list[1]


#Ok, now find a way to subset env_tot for the var_keep columns, and re-do the corr
#analyses on that
env_subset<-env_tot[,c(1:4)]
for (i in 1:length(var_keep)){
env_subset<-cbind(env_subset,env_tot[,which(colnames(env_tot)==var_keep[i])])
colnames(env_subset)<-c(colnames(env_subset)[1:(4+i-1)],var_keep[i])
}


####let's check corr between these variables#####
res <- cor(env_subset[,-c(1:4)])
#### check for significance of corr
library("Hmisc")
res2 <- rcorr(as.matrix(env_subset[,-c(1:4)]))
res2
# Extract the correlation coefficients
res2$r
# Extract p-values
res2$P

# ++++++++++++++++++++++++++++
# flattenCorrMatrix
# ++++++++++++++++++++++++++++
# cormat : matrix of the correlation coefficients
# pmat : matrix of the correlation p-values
flattenCorrMatrix <- function(cormat, pmat) {
  ut <- upper.tri(cormat)
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor  =(cormat)[ut],
    p = pmat[ut]
  )
}
flattenCorrMatrix(res2$r, res2$P)->table_corr
#maybe filter based on that

symnum(res, abbr.colnames = T)->corr_symbols
library(corrplot)
corrplot(res, type = "upper", order = "hclust", 
         tl.col = "black", tl.srt = 45,tl.cex=0.6)

# Insignificant correlations are leaved blank
corrplot(res2$r, type="upper", order="hclust", 
         p.mat = res2$P, sig.level = 0.01, insig = "blank",
         tl.col = "black",tl.srt = 45,tl.cex=0.6)


library(corrplot)
corrplot(res, type = "upper", order = "hclust", 
         tl.col = "black", tl.srt = 45)
col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = res, col = col, symm = TRUE)

# Get some colors
col<- colorRampPalette(c("blue", "white", "red"))(20)

pdf("./RDA_outdir/heatmap_48_variables.pdf", width = 6, height = 6)
heatmap(x = res, col = col, symm = T,cexRow=0.3,cexCol=0.3)
dev.off()

####make a subset with uncorrelated to mean temp####
#Mean temperature at mean depth is probably the most biologically relevant and correlated
#to other variables. Let's remove everything that is correlated to 
#BO21_tempmean_bdmean
table_corr[which(table_corr$row=="BO21_tempmean_bdmean"),]->table_corr_tm_bdm1
table_corr[which(table_corr$column=="BO21_tempmean_bdmean"),]->table_corr_tm_bdm2
rbind(table_corr_tm_bdm1,table_corr_tm_bdm2)->table_corr_tm_bdm
table_corr_tm_bdm[which(table_corr_tm_bdm$p>0.05),]->table_corr_tm_bdm

unique(c(table_corr_tm_bdm$row,table_corr_tm_bdm$column))


env_subset2<-env_tot[,c(1:4)]
for (i in 1:length(unique(c(table_corr_tm_bdm$row,table_corr_tm_bdm$column)))){
  env_subset2<-cbind(env_subset2,env_tot[,which(colnames(env_tot)==unique(c(table_corr_tm_bdm$row,table_corr_tm_bdm$column))[i])])
  colnames(env_subset2)<-c(colnames(env_subset2)[1:(4+i-1)],unique(c(table_corr_tm_bdm$row,table_corr_tm_bdm$column))[i])
}

# Also remove "MS_biogeo01_aspect_EW_5m" and "MS_biogeo02_aspect_NS_5m"
#because they are hard to interpret
env_subset2[,-c(11:12)]->env_subset2

####let's check corr between these variables again#####
res <- cor(env_subset2[,-c(1:4)])
#### check for significance of corr
library("Hmisc")
res2 <- rcorr(as.matrix(env_subset2[,-c(1:4)]))
res2
# Extract the correlation coefficients
res2$r
# Extract p-values
res2$P

# ++++++++++++++++++++++++++++
# flattenCorrMatrix
# ++++++++++++++++++++++++++++
# cormat : matrix of the correlation coefficients
# pmat : matrix of the correlation p-values
flattenCorrMatrix <- function(cormat, pmat) {
  ut <- upper.tri(cormat)
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor  =(cormat)[ut],
    p = pmat[ut]
  )
}
flattenCorrMatrix(res2$r, res2$P)->table_corr
#maybe filter based on that

symnum(res, abbr.colnames = T)->corr_symbols
library(corrplot)
corrplot(res, type = "upper", order = "hclust", 
         tl.col = "black", tl.srt = 45,tl.cex=0.8)

# Insignificant correlations are leaved blank
corrplot(res2$r, type="upper", order="hclust", 
         p.mat = res2$P, sig.level = 0.05, insig = "blank",
         tl.col = "black",tl.srt = 45,tl.cex=0.8)

pdf("./RDA_outdir/heatmap_9_variables.pdf", width = 6, height = 6)
corrplot(res2$r, type="upper", order="hclust", 
         p.mat = res2$P, sig.level = 0.05, insig = "blank",
         tl.col = "black",tl.srt = 45,tl.cex=0.6)
dev.off()

# Get some colors
col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = res, col = col, symm = TRUE)

View(table_corr)
#let's remove MS_biogeo04_profile_curvature_5m and 	
#MS_biogeo03_plan_curvature_5m ( both correlated to concavity)
#rm BO21_chlomean_bdmin that is correlated to ppmean_bdmin

#### final env ariables subset ####
#env_subset3
env_subset3<-env_subset2[,-which(colnames(env_subset2)=="MS_biogeo04_profile_curvature_5m")]
env_subset3<-env_subset3[,-which(colnames(env_subset3)=="MS_biogeo03_plan_curvature_5m")]
env_subset3<-env_subset3[,-which(colnames(env_subset3)=="BO21_chlomean_bdmin")]

####let's check corr between these variables again#####
res <- cor(env_subset3[,-c(1:4)])
#### check for significance of corr
library("Hmisc")
res2 <- rcorr(as.matrix(env_subset3[,-c(1:4)]))
res2
# Extract the correlation coefficients
res2$r
# Extract p-values
res2$P

flattenCorrMatrix(res2$r, res2$P)->table_corr
#maybe filter based on that

symnum(res, abbr.colnames = T)->corr_symbols
library(corrplot)
corrplot(res, type = "upper", order = "hclust", 
         tl.col = "black", tl.srt = 45,tl.cex=0.8)

# Insignificant correlations are leaved blank
pdf("./RDA_outdir/heatmap_6_variables.pdf", width = 6, height = 6)
corrplot(res2$r, type="upper", order="hclust", 
         p.mat = res2$P, sig.level = 0.05, insig = "blank",
         tl.col = "black",tl.srt = 45,tl.cex=0.6)
dev.off()

heatmap(x = res, col = col, symm = TRUE)

View(table_corr)

#There's still some low corr between some of these variables, but let's
#keep this set for now
env_subset3
write.table(env_subset3, file = "env_6_variables.txt")

