setwd("G:/DATA/WORK/WGS_PIPELINE/2_popgen/17_Statistics")
library(ggplot2)
library(grid)
library(ggrepel)

#### 1. fixed differences ####
QCmaf.AB.fixed_alleles <- read.csv("G:/DATA/WORK/WGS_PIPELINE/2_popgen/17_Statistics/call_set_AGRFlib1_to_6_V2P.rn.QCmaf.AB.fixed_alleles", sep="")

QCmaf.AB.fixed_alleles[-which(QCmaf.AB.fixed_alleles$pop1=="18.KTAR" |
                               QCmaf.AB.fixed_alleles$pop2=="18.KTAR"),]->QCmaf.AB.fixed_alleles_TAR
QCmaf.AB.fixed_alleles_TAR[-which(QCmaf.AB.fixed_alleles_TAR$pop1=="GBK" |
                                    QCmaf.AB.fixed_alleles_TAR$pop2=="GBK"),]->QCmaf.AB.fixed_alleles_TAR

means_fixed<-c()
for (i in unique(c(unique(QCmaf.AB.fixed_alleles_TAR$pop1),unique(QCmaf.AB.fixed_alleles_TAR$pop2)))) {
  mean(QCmaf.AB.fixed_alleles_TAR$fixed[which(QCmaf.AB.fixed_alleles_TAR$pop1==i |
                                                QCmaf.AB.fixed_alleles_TAR$pop2==i)])->mean
  means_fixed<-c(means_fixed,mean)
}
names(means_fixed)<-unique(c(unique(QCmaf.AB.fixed_alleles_TAR$pop1),unique(QCmaf.AB.fixed_alleles_TAR$pop2)))
means_fixed
sort(means_fixed)

medians_fixed<-c()
for (i in unique(c(unique(QCmaf.AB.fixed_alleles_TAR$pop1),unique(QCmaf.AB.fixed_alleles_TAR$pop2)))) {
  median(QCmaf.AB.fixed_alleles_TAR$fixed[which(QCmaf.AB.fixed_alleles_TAR$pop1==i |
                                                QCmaf.AB.fixed_alleles_TAR$pop2==i)])->median
  medians_fixed<-c(medians_fixed,median)
}
names(medians_fixed)<-unique(c(unique(QCmaf.AB.fixed_alleles_TAR$pop1),unique(QCmaf.AB.fixed_alleles_TAR$pop2)))
medians_fixed

call_set_AGRFlib1_to_6_V2P.rn.QCmaf.AB <- read.delim("G:/DATA/WORK/WGS_PIPELINE/2_popgen/17_Statistics/call_set_AGRFlib1_to_6_V2P.rn.QCmaf.AB.fixed_alleles_TARKTAR")


#### QCAB dataset ####
QCAB_het_ind_dartr <- read.csv("G:/DATA/WORK/WGS_PIPELINE/2_popgen/17_Statistics/call_set_AGRFlib1_to_6_V2P.rn.QCmaf.AB.het_ind_dartr", sep="")
QCAB_het_ind_dartr[,1:2]->df_qc

#### assign pops ####
gsub("[0-9]","", df_qc[,1])->location
gsub(".markdup.bam","",location)->location
sub("_","",location)->location
sub("_","",location)->location
sub("_","",location)->location
location[which(location=="UWCNI")]
location[which(location=="UWCNI")]<-"01.UWCNI"
location[which(location=="NT"|location=="TARA")]
location[which(location=="NT"|location=="TARA")]<-"02.TARA"
location[which(location=="TBGB")]
location[which(location=="TBGB")]<-"03.TBGB"
location[which(location=="TBGBJ")]
location[which(location=="TBGBJ")]<-"04.TBGBJ"
location[which(location=="SPWCSI")]
location[which(location=="SPWCSI")]<-"05.UWCSI"
location[which(location=="WCSI")]
location[which(location=="WCSI")]<-"06.LWCSI"
location[which(location=="FRDL")]
location[which(location=="FRDL")]<-"07.FRDL"
location[which(location=="CHCH")]
location[which(location=="CHCH")]<-"08.CHCH"
location[which(location=="SPCC")]
location[which(location=="SPCC")]<-"09.CC"
location[which(location=="WGTN")]
location[which(location=="WGTN")]<-"10.WGTN"
location[which(location=="WAI")]
location[which(location=="WAI")]<-"11.WAI"
location[which(location=="HB"|location=="NAP")]
location[which(location=="HB"|location=="NAP")]<-"12.HB"
location[which(location=="SPGB"|location=="SPEC"|location=="GB"|location=="EC")]
location[which(location=="SPGB"|location=="SPEC"|location=="GB"|location=="EC")]<-"13.EC"
location[which(location=="ENHG")]
location[which(location=="ENHG")]<-"14.ENHG"
location[which(location=="ENLD")]
location[which(location=="ENLD")]<-"15.ENLD"
location[which(location=="CHAT")]
location[which(location=="CHAT")]<-"16.CHAT"
location[which(location=="AU")]
location[which(location=="AU")]<-"17.TAS"
location[which(location=="KTAR")]
location[which(location=="KTAR")]<-"18.KTAR"

df_qc<-cbind(location,df_qc)

QCAB.idepth <- read.delim("G:/DATA/WORK/WGS_PIPELINE/2_popgen/17_Statistics/call_set_AGRFlib1_to_6_V2P.rn.QCmaf.AB.idepth")

QCAB.idepth[,3]->mean_depth
df_qc<-cbind(df_qc,mean_depth)

QCAB.imiss <- read.delim("G:/DATA/WORK/WGS_PIPELINE/2_popgen/17_Statistics/call_set_AGRFlib1_to_6_V2P.rn.QCmaf.AB.imiss")
QCAB.imiss$N_MISS->n_miss
df_qc<-cbind(df_qc,n_miss)

QCAB.fastqc <- read.delim("G:/DATA/WORK/WGS_PIPELINE/2_popgen/17_Statistics/MultiQC.txt")
QCAB.fastqc<-QCAB.fastqc[,-c(2:6)]
QCAB.fastqc <-QCAB.fastqc[-grep("reverse",QCAB.fastqc$Sample),]
#QCAB.fastqc <-QCAB.fastqc[-grep("1278_SPWCSI003",QCAB.fastqc$Sample),] #only if I didnt remove it first
sub(".forward_paired","",QCAB.fastqc$Sample)->QCAB.fastqc$Sample
QCAB.fastqc<-QCAB.fastqc[match(df_qc$ind.name, QCAB.fastqc$Sample),]

df_qc<-cbind(df_qc,QCAB.fastqc[,-1])
df_qc[order(df_qc[,1], df_qc[,2]),]->df_qc
locindname<- paste0(df_qc[,1],df_qc[,2])
df_qc<-cbind(locindname,df_qc)



#### assign colors ####
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

#### plot ####
plot1 <- ggplot() + geom_point(data=df_qc,shape=21,size=3,color="black",
                               aes(x=locindname, y=Ho,
                                   fill=location))+scale_fill_manual(values=colors)+
  scale_color_manual(values=colors)+
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.x=element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        line = element_line(colour = "black"),
        panel.border=element_rect(colour = "black",fill=NA))
plot1

#df_qc_subset<-subset(df_qc,mean_depth<9)

plot2 <- ggplot() + 
  geom_point(data=df_qc,shape=21,size=3,color="black",
             aes(x=locindname, y=mean_depth,
                 fill=location))+scale_fill_manual(values=colors)+
  scale_color_manual(values=colors)+
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.x=element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        line = element_line(colour = "black"),
        panel.border=element_rect(colour = "black",fill=NA))+ 
        geom_text_repel(data=subset(df_qc, mean_depth<8),
        aes(locindname,mean_depth,label=ind.name),nudge_x=0, nudge_y=-1)
plot2


plot3 <- ggplot() + geom_point(data=df_qc,shape=21,size=3,color="black",
                               aes(x=locindname, y=n_miss,
                                   fill=location))+scale_fill_manual(values=colors)+
  scale_color_manual(values=colors)+
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.x=element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        line = element_line(colour = "black"),
        panel.border=element_rect(colour = "black",fill=NA))+ 
  geom_text_repel(data=subset(df_qc, n_miss>1000000),
                  aes(locindname,n_miss,label=ind.name),nudge_x=0, nudge_y=0)
plot3 

plot4 <- ggplot() + geom_point(data=df_qc,shape=21,size=3,color="black",
                               aes(x=locindname, y=R1R2_percent_gc,
                                   fill=location))+scale_fill_manual(values=colors)+
  scale_color_manual(values=colors)+
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.x=element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        line = element_line(colour = "black"),
        panel.border=element_rect(colour = "black",fill=NA))
plot4

plot5 <- ggplot() + geom_point(data=df_qc,shape=21,size=3,color="black",
                               aes(x=locindname, y=R1R2_total_sequences,
                                   fill=location))+scale_fill_manual(values=colors)+
  scale_color_manual(values=colors)+
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        line = element_line(colour = "black"),
        panel.border=element_rect(colour = "black",fill=NA))
plot5



grid.newpage()
grid.draw(rbind(ggplotGrob(plot1), ggplotGrob(plot2),
                ggplotGrob(plot3),ggplotGrob(plot4),ggplotGrob(plot5),size = "last"))

#### figure finale ####
grid.newpage()
grid.draw(rbind(ggplotGrob(plot1), ggplotGrob(plot2),
                ggplotGrob(plot3),ggplotGrob(plot4),ggplotGrob(plot5),size = "last"))



#### Neutral dataset####
neutral_het_ind_dartr <- read.csv("G:/DATA/WORK/WGS_PIPELINE/2_popgen/17_Statistics/call_set_AGRFlib1_to_6_V2P.rn.QCmaf.AB.neutral.hwe_thin.pruned.242.het_ind_dartr", sep="")
neutral_het_ind_dartr[,1:2]->df

#### assign pops ####
gsub("[0-9]","", df[,1])->location
gsub(".markdup.bam","",location)->location
sub("_","",location)->location
sub("_","",location)->location
sub("_","",location)->location
location[which(location=="UWCNI")]
location[which(location=="UWCNI")]<-"01.UWCNI"
location[which(location=="NT"|location=="TARA")]
location[which(location=="NT"|location=="TARA")]<-"02.TARA"
location[which(location=="TBGB")]
location[which(location=="TBGB")]<-"03.TBGB"
location[which(location=="TBGBJ")]
location[which(location=="TBGBJ")]<-"04.TBGBJ"
location[which(location=="SPWCSI")]
location[which(location=="SPWCSI")]<-"05.UWCSI"
location[which(location=="WCSI")]
location[which(location=="WCSI")]<-"06.LWCSI"
location[which(location=="FRDL")]
location[which(location=="FRDL")]<-"07.FRDL"
location[which(location=="CHCH")]
location[which(location=="CHCH")]<-"08.CHCH"
location[which(location=="SPCC")]
location[which(location=="SPCC")]<-"09.CC"
location[which(location=="WGTN")]
location[which(location=="WGTN")]<-"10.WGTN"
location[which(location=="WAI")]
location[which(location=="WAI")]<-"11.WAI"
location[which(location=="HB"|location=="NAP")]
location[which(location=="HB"|location=="NAP")]<-"12.HB"
location[which(location=="SPGB"|location=="SPEC"|location=="GB"|location=="EC")]
location[which(location=="SPGB"|location=="SPEC"|location=="GB"|location=="EC")]<-"13.EC"
location[which(location=="ENHG")]
location[which(location=="ENHG")]<-"14.ENHG"
location[which(location=="ENLD")]
location[which(location=="ENLD")]<-"15.ENLD"
location[which(location=="CHAT")]
location[which(location=="CHAT")]<-"16.CHAT"
location[which(location=="AU")]
location[which(location=="AU")]<-"17.TAS"
location[which(location=="KTAR")]
location[which(location=="KTAR")]<-"18.KTAR"

df<-cbind(location,df)

neutral.idepth <- read.delim("G:/DATA/WORK/WGS_PIPELINE/2_popgen/17_Statistics/call_set_AGRFlib1_to_6_V2P.rn.QCmaf.AB.neutral.hwe_thin.pruned.242.idepth")
neutral.idepth <-neutral.idepth[-
  grep("KTAR",neutral.idepth$INDV),]
neutral.idepth <-neutral.idepth[-
  grep("GB19001_K",neutral.idepth$INDV),]
neutral.idepth <-neutral.idepth[-
  grep("TBGBJ",neutral.idepth$INDV),]
neutral.idepth <-neutral.idepth[-
  grep("FRDL",neutral.idepth$INDV),]
neutral.idepth <-neutral.idepth[-
  grep("CHAT",neutral.idepth$INDV),]
neutral.idepth[,3]->mean_depth
df<-cbind(df,mean_depth)

neutral.imiss <- read.delim("G:/DATA/WORK/WGS_PIPELINE/2_popgen/17_Statistics/call_set_AGRFlib1_to_6_V2P.rn.QCmaf.AB.neutral.hwe_thin.pruned.242.imiss")
neutral.imiss<-neutral.imiss[-
 grep("KTAR",neutral.imiss$INDV),]
neutral.imiss<-neutral.imiss[-
 grep("GB19001_K",neutral.imiss$INDV),]
neutral.imiss<-neutral.imiss[-
 grep("TBGBJ",neutral.imiss$INDV),]
neutral.imiss<-neutral.imiss[-
 grep("FRDL",neutral.imiss$INDV),]
neutral.imiss<-neutral.imiss[-
 grep("CHAT",neutral.imiss$INDV),]
neutral.imiss$N_MISS->n_miss
df<-cbind(df,n_miss)


df[order(df[,1], df[,1]),]->df
locindname<- paste0(df[,1],df[,2])
df<-cbind(locindname,df)

#### assign colors ####
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

#### plot ####
plot1 <- ggplot() + geom_point(data=df,shape=21,size=3,color="black",
      aes(x=locindname, y=Ho,
      fill=location))+scale_fill_manual(values=colors)+
  scale_color_manual(values=colors)+
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.x=element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        line = element_line(colour = "black"),
        panel.border=element_rect(colour = "black",fill=NA))

df_subset<-subset(df,mean_depth<9)

plot2 <- ggplot() + 
        geom_point(data=df,shape=21,size=3,color="black",
        aes(x=locindname, y=mean_depth,
        fill=location))+scale_fill_manual(values=colors)+
  scale_color_manual(values=colors)+
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.x=element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        line = element_line(colour = "black"),
        panel.border=element_rect(colour = "black",fill=NA))+ 
        geom_text_repel(data=subset(df, mean_depth<8),
            aes(locindname,mean_depth,label=ind.name),nudge_x=0, nudge_y=-1)
plot2
       

plot3 <- ggplot() + geom_point(data=df,shape=21,size=3,color="black",
                               aes(x=locindname, y=n_miss,
                                   fill=location))+scale_fill_manual(values=colors)+
  scale_color_manual(values=colors)+
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.x=element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        line = element_line(colour = "black"),
        panel.border=element_rect(colour = "black",fill=NA))


grid.newpage()
grid.draw(rbind(ggplotGrob(plot1), ggplotGrob(plot2),
                ggplotGrob(plot3),size = "last"))
