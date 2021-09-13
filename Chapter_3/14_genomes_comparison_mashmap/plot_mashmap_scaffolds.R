setwd("G:/DATA/WORK/WGS_PIPELINE/1_TARdn/8B_Genomes_Comparisons_marshmap")


library(ggplot2)

#### 1.1 qV1scf1 vs rV2P ####

rv2pqv1_table <- read.delim("G:/DATA/WORK/WGS_PIPELINE/1_TARdn/8B_Genomes_Comparisons_marshmap/05_marshmap_rV2P_qV1/rV2P_qV1_plot_table_R.txt")
#the table must be sorted by 1) query scf 2) ref scf 3) start position in ref
V1scf1<-rv2pqv1_table[which(rv2pqv1_table[,1]==1),]
#Keep only V1 scaffold 1, and only matches >90%
#V1scf1<-V1scf1[which(V1scf1$identity>=90),]
V1scf1<-V1scf1[order(V1scf1$query_V1,V1scf1$X0_based_start),]

#https://ggplot2.tidyverse.org/reference/geom_linerange.html
q_fragments<-factor(seq(1,length(rownames(V1scf1))))    #trt
lower<-V1scf1$start
upper<-V1scf1$end.1
mid<-apply(rbind(lower,upper),2,median)    #resp
strand<-factor(V1scf1$strand)  #group
r_scf<-factor(V1scf1$ref_V2P)
identity<-V1scf1$identity
frag_length<-V1scf1$end - V1scf1$X0_based_start
frag_length_factor<-c()
frag_length_factor[which(frag_length>1000000)]<-">1,000,000" #more than 1 million
frag_length_factor[which(frag_length<1000001)]<-">100,000" # bw 100 001 and 1 000 000
frag_length_factor[which(frag_length<100001)]<-">10,000" # bw 10 001 and 100 000
frag_length_factor[which(frag_length<10001)]<-">1000" # bw 1001 and 10 000
frag_length_factor[which(frag_length<1000)]<-"<1000" # shorter than 1000


df <- data.frame(q_fragments,mid,strand,lower,upper,r_scf,frag_length_factor)
df$r_scf <- factor(df$r_scf,      # Reordering group factor levels
                       levels = rev(levels(df$r_scf)))
df$strand <- factor(df$strand,      # Reordering group factor levels
                   levels = rev(levels(df$strand)))
df$frag_length_factor<-factor(df$frag_length_factor,
                              levels=c("<1000",">1000",">10,000",">100,000",">1,000,000"))

#simple plot
p <- ggplot(df, aes(q_fragments, mid, color=strand))
p + geom_pointrange(aes(ymin = lower, ymax = upper))+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V1 scaffold 1 fragments",y="V2P scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)

#plot with more info
q <- ggplot(df, aes(q_fragments, mid, shape = strand,color=identity))
q + geom_pointrange(aes(ymin = lower, ymax = upper,size=frag_length_factor))+
  scale_size_discrete(range = c(0.5, 1.5),name="fragment length (bp)")+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
            panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
   #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V1 scaffold 1 fragments",y="V2P scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)

  
#### 1.2 qV1scf2 vs rV2P ####
#the table must be sorted by 1) query scf 2) ref scf 3) start position in ref
#replace V1scf1 -> V1scf2
#replace rv2pqv1_table[,1]==1 -> rv2pqv1_table[,1]==2
#replace legends
V1scf2<-rv2pqv1_table[which(rv2pqv1_table[,1]==2),]
#Keep only V1 scaffold 1, and only matches >90%
#V1scf2<-V1scf2[which(V1scf2$identity>=90),]
V1scf2<-V1scf2[order(V1scf2$query_V1,V1scf2$X0_based_start),]

#https://ggplot2.tidyverse.org/reference/geom_linerange.html
q_fragments<-factor(seq(1,length(rownames(V1scf2))))    #trt
lower<-V1scf2$start
upper<-V1scf2$end.1
mid<-apply(rbind(lower,upper),2,median)    #resp
strand<-factor(V1scf2$strand)  #group
r_scf<-factor(V1scf2$ref_V2P)
identity<-V1scf2$identity
frag_length<-V1scf2$end - V1scf2$X0_based_start
frag_length_factor<-c()
frag_length_factor[which(frag_length>1000000)]<-">1,000,000" #more than 1 million
frag_length_factor[which(frag_length<1000001)]<-">100,000" # bw 100 001 and 1 000 000
frag_length_factor[which(frag_length<100001)]<-">10,000" # bw 10 001 and 100 000
frag_length_factor[which(frag_length<10001)]<-">1000" # bw 1001 and 10 000
frag_length_factor[which(frag_length<1000)]<-"<1000" # shorter than 1000


df <- data.frame(q_fragments,mid,strand,lower,upper,r_scf,frag_length_factor)
df$r_scf <- factor(df$r_scf,      # Reordering group factor levels
                   levels = rev(levels(df$r_scf)))
df$strand <- factor(df$strand,      # Reordering group factor levels
                    levels = rev(levels(df$strand)))
df$frag_length_factor<-factor(df$frag_length_factor,
                              levels=c("<1000",">1000",">10,000",">100,000",">1,000,000"))

#simple plot
p <- ggplot(df, aes(q_fragments, mid, color=strand))
p + geom_pointrange(aes(ymin = lower, ymax = upper))+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V1 scaffold 2 fragments",y="V2P scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)

#plot with more info
q <- ggplot(df, aes(q_fragments, mid, shape = strand,color=identity))
q + geom_pointrange(aes(ymin = lower, ymax = upper,size=frag_length_factor))+
  scale_size_discrete(range = c(0.5, 1.5),name="fragment length (bp)")+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V1 scaffold 2 fragments",y="V2P scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)

#### 2.1 qV1scf1 vs sinChu7####
#replace rv2pqv1_table -> qV1_sinChu7_table
#replace labs
#if other scaffold
##replace V1scf1 -> V1scf2
##replace rv2pqv1_table[,1]==1 -> rv2pqv1_table[,1]==2
qV1_sinChu7_table <- read.delim("G:/DATA/WORK/WGS_PIPELINE/1_TARdn/8B_Genomes_Comparisons_marshmap/06_marshmap_rMF_qV1/rMF_qV1.out.table")


V1scf1<-qV1_sinChu7_table[which(qV1_sinChu7_table[,1]==1),]
#Keep only V1 scaffold 1, and only matches >90%
#V1scf1<-V1scf1[which(V1scf1$identity>=90),]
#the table must be sorted by 1) query scf 2) ref scf 3) start position in ref
V1scf1<-V1scf1[order(V1scf1$query,V1scf1$X0_based_start),]

#https://ggplot2.tidyverse.org/reference/geom_linerange.html
q_fragments<-factor(seq(1,length(rownames(V1scf1))))    #trt
lower<-V1scf1$start
upper<-V1scf1$end.1
mid<-apply(rbind(lower,upper),2,median)    #resp
strand<-factor(V1scf1$strand)  #group
r_scf<-factor(V1scf1$ref)
identity<-V1scf1$identity
frag_length<-V1scf1$end - V1scf1$X0_based_start
frag_length_factor<-c()
frag_length_factor[which(frag_length>1000000)]<-">1,000,000" #more than 1 million
frag_length_factor[which(frag_length<1000001)]<-">100,000" # bw 100 001 and 1 000 000
frag_length_factor[which(frag_length<100001)]<-">10,000" # bw 10 001 and 100 000
frag_length_factor[which(frag_length<10001)]<-">1000" # bw 1001 and 10 000
frag_length_factor[which(frag_length<1000)]<-"<1000" # shorter than 1000


df <- data.frame(q_fragments,mid,strand,lower,upper,r_scf,frag_length_factor)
df$r_scf <- factor(df$r_scf,      # Reordering group factor levels
                   levels = rev(levels(df$r_scf)))
df$strand <- factor(df$strand,      # Reordering group factor levels
                    levels = rev(levels(df$strand)))
df$frag_length_factor<-factor(df$frag_length_factor,
                              levels=c("<1000",">1000",">10,000",">100,000",">1,000,000"))

#simple plot
p <- ggplot(df, aes(q_fragments, mid, color=strand))
p + geom_pointrange(aes(ymin = lower, ymax = upper))+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V1 scaffold 1 fragments",y="sinChu7 scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)

#plot with more info
q <- ggplot(df, aes(q_fragments, mid, shape = strand,color=identity))
q + geom_pointrange(aes(ymin = lower, ymax = upper,size=frag_length_factor))+
  scale_size_discrete(range = c(0.5, 1.5),name="fragment length (bp)")+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V1 scaffold 1 fragments",y="sinChu7 scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)

#### 2.2 qV1scf1 vs sinChu7 90%####
#replace rv2pqv1_table -> qV1_sinChu7_table
#replace labs
#if other scaffold
##replace V1scf1 -> V1scf2
##replace rv2pqv1_table[,1]==1 -> rv2pqv1_table[,1]==2
qV1_sinChu7_table <- read.delim("G:/DATA/WORK/WGS_PIPELINE/1_TARdn/8B_Genomes_Comparisons_marshmap/06_marshmap_rMF_qV1/rMF_qV1.out.table")


V1scf1<-qV1_sinChu7_table[which(qV1_sinChu7_table[,1]==1),]
#Keep only V1 scaffold 1, and only matches >90%
V1scf1<-V1scf1[which(V1scf1$identity>=90),]
#the table must be sorted by 1) query scf 2) ref scf 3) start position in ref
V1scf1<-V1scf1[order(V1scf1$query,V1scf1$X0_based_start),]

#https://ggplot2.tidyverse.org/reference/geom_linerange.html
q_fragments<-factor(seq(1,length(rownames(V1scf1))))    #trt
lower<-V1scf1$start
upper<-V1scf1$end.1
mid<-apply(rbind(lower,upper),2,median)    #resp
strand<-factor(V1scf1$strand)  #group
r_scf<-factor(V1scf1$ref)
identity<-V1scf1$identity
frag_length<-V1scf1$end - V1scf1$X0_based_start
frag_length_factor<-c()
frag_length_factor[which(frag_length>1000000)]<-">1,000,000" #more than 1 million
frag_length_factor[which(frag_length<1000001)]<-">100,000" # bw 100 001 and 1 000 000
frag_length_factor[which(frag_length<100001)]<-">10,000" # bw 10 001 and 100 000
frag_length_factor[which(frag_length<10001)]<-">1000" # bw 1001 and 10 000
frag_length_factor[which(frag_length<1000)]<-"<1000" # shorter than 1000


df <- data.frame(q_fragments,mid,strand,lower,upper,r_scf,frag_length_factor)
df$r_scf <- factor(df$r_scf,      # Reordering group factor levels
                   levels = rev(levels(df$r_scf)))
df$strand <- factor(df$strand,      # Reordering group factor levels
                    levels = rev(levels(df$strand)))
df$frag_length_factor<-factor(df$frag_length_factor,
                              levels=c("<1000",">1000",">10,000",">100,000",">1,000,000"))

#simple plot
p <- ggplot(df, aes(q_fragments, mid, color=strand))
p + geom_pointrange(aes(ymin = lower, ymax = upper))+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V1 scaffold 1 fragments",y="sinChu7 scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)

#plot with more info
q <- ggplot(df, aes(q_fragments, mid, shape = strand,color=identity))
q + geom_pointrange(aes(ymin = lower, ymax = upper,size=frag_length_factor))+
  scale_size_discrete(range = c(0.5, 1.5),name="fragment length (bp)")+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V1 scaffold 1 fragments",y="sinChu7 scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)

#### 3.1 qV1scf1 vs SNA1 90% ####
#replace rv2pqv1_table -> qV1_SNA1_table
#replace labs
#if other scaffold
##replace V1scf1 -> V1scf2
##replace rv2pqv1_table[,1]==1 -> rv2pqv1_table[,1]==2
qV1_SNA1_table <- read.delim("G:/DATA/WORK/WGS_PIPELINE/1_TARdn/8B_Genomes_Comparisons_marshmap/07_marshmap_rSNA_qV1/rSNA_qV1.out.table")

V1scf1<-qV1_SNA1_table[which(qV1_SNA1_table[,1]==1),]
#Keep only V1 scaffold 1, and only matches >90%
V1scf1<-V1scf1[which(V1scf1$identity>=90),]
#the table must be sorted by 1) query scf 2) ref scf 3) start position in ref
V1scf1<-V1scf1[order(V1scf1$query,V1scf1$X0_based_start),]

#https://ggplot2.tidyverse.org/reference/geom_linerange.html
q_fragments<-factor(seq(1,length(rownames(V1scf1))))    #trt
lower<-V1scf1$start
upper<-V1scf1$end.1
mid<-apply(rbind(lower,upper),2,median)    #resp
strand<-factor(V1scf1$strand)  #group
r_scf<-factor(V1scf1$ref)
identity<-V1scf1$identity
frag_length<-V1scf1$end - V1scf1$X0_based_start
frag_length_factor<-c()
frag_length_factor[which(frag_length>1000000)]<-">1,000,000" #more than 1 million
frag_length_factor[which(frag_length<1000001)]<-">100,000" # bw 100 001 and 1 000 000
frag_length_factor[which(frag_length<100001)]<-">10,000" # bw 10 001 and 100 000
frag_length_factor[which(frag_length<10001)]<-">1000" # bw 1001 and 10 000
frag_length_factor[which(frag_length<1000)]<-"<1000" # shorter than 1000


df <- data.frame(q_fragments,mid,strand,lower,upper,r_scf,frag_length_factor)
df$r_scf <- factor(df$r_scf,      # Reordering group factor levels
                   levels = rev(levels(df$r_scf)))
df$strand <- factor(df$strand,      # Reordering group factor levels
                    levels = rev(levels(df$strand)))
df$frag_length_factor<-factor(df$frag_length_factor,
                              levels=c("<1000",">1000",">10,000",">100,000",">1,000,000"))

#simple plot
p <- ggplot(df, aes(q_fragments, mid, color=strand))
p + geom_pointrange(aes(ymin = lower, ymax = upper))+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V1 scaffold 1 fragments",y="SNA1 scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)

#plot with more info
q <- ggplot(df, aes(q_fragments, mid, shape = strand,color=identity))
q + geom_pointrange(aes(ymin = lower, ymax = upper,size=frag_length_factor))+
  scale_size_discrete(range = c(0.5, 1.5),name="fragment length (bp)")+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V1 scaffold 1 fragments",y="SNA1 scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)

#### 4.1 qV2Pscf1 vs rV2 ####
#replace rv2pqv1_table -> qV1_SNA1_table
#replace labs
#if other scaffold
##replace V1scf2 -> V1scf2
##replace rv2pqv1_table[,1]==1 -> rv2pqv1_table[,1]==2
qV2P_rV2_table <- read.delim("G:/DATA/WORK/WGS_PIPELINE/1_TARdn/8B_Genomes_Comparisons_marshmap/01_mashmap_rV2_qV2P/rV2_qV2P_table.txt")

V2Pscf1<-qV2P_rV2_table[which(qV2P_rV2_table[,1]==1),]
#Keep only V1 scaffold 1, and only matches >90%
#V2Pscf1<-V2Pscf1[which(V2Pscf1$identity>=90),]
#the table must be sorted by 1) query scf 2) ref scf 3) start position in ref
V2Pscf1<-V2Pscf1[order(V2Pscf1$queryV1,V2Pscf1$X0_based_start),]

#https://ggplot2.tidyverse.org/reference/geom_linerange.html
q_fragments<-factor(seq(1,length(rownames(V2Pscf1))))    #trt
lower<-V2Pscf1$start
upper<-V2Pscf1$end.1
mid<-apply(rbind(lower,upper),2,median)    #resp
strand<-factor(V2Pscf1$strand)  #group
r_scf<-factor(V2Pscf1$refV2)
identity<-V2Pscf1$identity
frag_length<-V2Pscf1$end - V2Pscf1$X0_based_start
frag_length_factor<-c()
frag_length_factor[which(frag_length>1000000)]<-">1,000,000" #more than 1 million
frag_length_factor[which(frag_length<1000001)]<-">100,000" # bw 100 001 and 1 000 000
frag_length_factor[which(frag_length<100001)]<-">10,000" # bw 10 001 and 100 000
frag_length_factor[which(frag_length<10001)]<-">1000" # bw 1001 and 10 000
frag_length_factor[which(frag_length<1000)]<-"<1000" # shorter than 1000


df <- data.frame(q_fragments,mid,strand,lower,upper,r_scf,frag_length_factor)
df$r_scf <- factor(df$r_scf,      # Reordering group factor levels
                   levels = rev(levels(df$r_scf)))
df$strand <- factor(df$strand,      # Reordering group factor levels
                    levels = rev(levels(df$strand)))
df$frag_length_factor<-factor(df$frag_length_factor,
                              levels=c("<1000",">1000",">10,000",">100,000",">1,000,000"))

#simple plot
p <- ggplot(df, aes(q_fragments, mid, color=strand))
p + geom_pointrange(aes(ymin = lower, ymax = upper))+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V2P scaffold 1 fragments",y="V2 scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)

#plot with more info
q <- ggplot(df, aes(q_fragments, mid, shape = strand,color=identity))
q + geom_pointrange(aes(ymin = lower, ymax = upper,size=frag_length_factor))+
  scale_size_discrete(range = c(0.5, 1.5),name="fragment length (bp)")+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V2P scaffold 1 fragments",y="V2 scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)

#### 4.2 qV2Pscf2 vs rV2 ####
#replace rv2pqv1_table -> qV1_SNA1_table
#replace labs
#if other scaffold
##replace V1scf2 -> V1scf2
##replace rv2pqv1_table[,1]==1 -> rv2pqv1_table[,1]==2
qV2P_rV2_table <- read.delim("G:/DATA/WORK/WGS_PIPELINE/1_TARdn/8B_Genomes_Comparisons_marshmap/01_mashmap_rV2_qV2P/rV2_qV2P_table.txt")

V2Pscf2<-qV2P_rV2_table[which(qV2P_rV2_table[,1]==2),]
#Keep only V1 scaffold 1, and only matches >90%
#V2Pscf2<-V2Pscf2[which(V2Pscf2$identity>=90),]
#the table must be sorted by 1) query scf 2) ref scf 3) start position in ref
V2Pscf2<-V2Pscf2[order(V2Pscf2$queryV1,V2Pscf2$X0_based_start),]

#https://ggplot2.tidyverse.org/reference/geom_linerange.html
q_fragments<-factor(seq(1,length(rownames(V2Pscf2))))    #trt
lower<-V2Pscf2$start
upper<-V2Pscf2$end.1
mid<-apply(rbind(lower,upper),2,median)    #resp
strand<-factor(V2Pscf2$strand)  #group
r_scf<-factor(V2Pscf2$refV2)
identity<-V2Pscf2$identity
frag_length<-V2Pscf2$end - V2Pscf2$X0_based_start
frag_length_factor<-c()
frag_length_factor[which(frag_length>1000000)]<-">1,000,000" #more than 1 million
frag_length_factor[which(frag_length<1000001)]<-">100,000" # bw 100 001 and 1 000 000
frag_length_factor[which(frag_length<100001)]<-">10,000" # bw 10 001 and 100 000
frag_length_factor[which(frag_length<10001)]<-">1000" # bw 1001 and 10 000
frag_length_factor[which(frag_length<1000)]<-"<1000" # shorter than 1000


df <- data.frame(q_fragments,mid,strand,lower,upper,r_scf,frag_length_factor)
df$r_scf <- factor(df$r_scf,      # Reordering group factor levels
                   levels = rev(levels(df$r_scf)))
df$strand <- factor(df$strand,      # Reordering group factor levels
                    levels = rev(levels(df$strand)))
df$frag_length_factor<-factor(df$frag_length_factor,
                              levels=c("<1000",">1000",">10,000",">100,000",">1,000,000"))

#simple plot
p <- ggplot(df, aes(q_fragments, mid, color=strand))
p + geom_pointrange(aes(ymin = lower, ymax = upper))+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V2P scaffold 2 fragments",y="V2 scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)

#plot with more info
q <- ggplot(df, aes(q_fragments, mid, shape = strand,color=identity))
q + geom_pointrange(aes(ymin = lower, ymax = upper,size=frag_length_factor))+
  scale_size_discrete(range = c(0.5, 1.5),name="fragment length (bp)")+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V2P scaffold 2 fragments",y="V2 scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)


#### 5.1 qV2Pscf1 vs sinChu7 ####
#replace rv2pqv1_table -> qV1_SNA1_table
#replace labs
#if other scaffold
##replace V1scf2 -> V1scf2
##replace rv2pqv1_table[,1]==1 -> rv2pqv1_table[,1]==2
qV2P_SinChu7_table <- read.delim("G:/DATA/WORK/WGS_PIPELINE/1_TARdn/8B_Genomes_Comparisons_marshmap/04_mashmap_bwa_rMF_qV2P/rMF_qV2P_500minbp.out.table")

V2Pscf1<-qV2P_SinChu7_table[which(qV2P_SinChu7_table[,1]==1),]
#Keep only V1 scaffold 1, and only matches >90%
#V2Pscf1<-V2Pscf1[which(V2Pscf1$identity>=90),]
#the table must be sorted by 1) query scf 2) ref scf 3) start position in ref
V2Pscf1<-V2Pscf1[order(V2Pscf1$query,V2Pscf1$X0_based_start),]

#https://ggplot2.tidyverse.org/reference/geom_linerange.html
q_fragments<-factor(seq(1,length(rownames(V2Pscf1))))    #trt
lower<-V2Pscf1$start
upper<-V2Pscf1$end.1
mid<-apply(rbind(lower,upper),2,median)    #resp
strand<-factor(V2Pscf1$strand)  #group
r_scf<-factor(V2Pscf1$ref)
identity<-V2Pscf1$identity
frag_length<-V2Pscf1$end - V2Pscf1$X0_based_start
frag_length_factor<-c()
frag_length_factor[which(frag_length>1000000)]<-">1,000,000" #more than 1 million
frag_length_factor[which(frag_length<1000001)]<-">100,000" # bw 100 001 and 1 000 000
frag_length_factor[which(frag_length<100001)]<-">10,000" # bw 10 001 and 100 000
frag_length_factor[which(frag_length<10001)]<-">1000" # bw 1001 and 10 000
frag_length_factor[which(frag_length<1000)]<-"<1000" # shorter than 1000


df <- data.frame(q_fragments,mid,strand,lower,upper,r_scf,frag_length_factor)
df$r_scf <- factor(df$r_scf,      # Reordering group factor levels
                   levels = rev(levels(df$r_scf)))
df$strand <- factor(df$strand,      # Reordering group factor levels
                    levels = rev(levels(df$strand)))
df$frag_length_factor<-factor(df$frag_length_factor,
                              levels=c("<1000",">1000",">10,000",">100,000",">1,000,000"))

#simple plot
p <- ggplot(df, aes(q_fragments, mid, color=strand))
p + geom_pointrange(aes(ymin = lower, ymax = upper))+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V2P scaffold 1 fragments",y="sinChu7 scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)

#plot with more info
q <- ggplot(df, aes(q_fragments, mid, shape = strand,color=identity))
q + geom_pointrange(aes(ymin = lower, ymax = upper,size=frag_length_factor))+
  scale_size_discrete(range = c(0.5, 1.5),name="fragment length (bp)")+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V2P scaffold 1 fragments",y="sinChu7 scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)

#### 5.2 qV2Pscf1 vs sinChu7 90% ####
#replace rv2pqv1_table -> qV1_SNA1_table
#replace labs
#if other scaffold
##replace V1scf2 -> V1scf2
##replace rv2pqv1_table[,1]==1 -> rv2pqv1_table[,1]==2
qV2P_SinChu7_table <- read.delim("G:/DATA/WORK/WGS_PIPELINE/1_TARdn/8B_Genomes_Comparisons_marshmap/04_mashmap_bwa_rMF_qV2P/rMF_qV2P_500minbp.out.table")

V2Pscf1<-qV2P_SinChu7_table[which(qV2P_SinChu7_table[,1]==1),]
#Keep only V1 scaffold 1, and only matches >90%
V2Pscf1<-V2Pscf1[which(V2Pscf1$identity>=90),]
#the table must be sorted by 1) query scf 2) ref scf 3) start position in ref
V2Pscf1<-V2Pscf1[order(V2Pscf1$query,V2Pscf1$X0_based_start),]

#https://ggplot2.tidyverse.org/reference/geom_linerange.html
q_fragments<-factor(seq(1,length(rownames(V2Pscf1))))    #trt
lower<-V2Pscf1$start
upper<-V2Pscf1$end.1
mid<-apply(rbind(lower,upper),2,median)    #resp
strand<-factor(V2Pscf1$strand)  #group
r_scf<-factor(V2Pscf1$ref)
identity<-V2Pscf1$identity
frag_length<-V2Pscf1$end - V2Pscf1$X0_based_start
frag_length_factor<-c()
frag_length_factor[which(frag_length>1000000)]<-">1,000,000" #more than 1 million
frag_length_factor[which(frag_length<1000001)]<-">100,000" # bw 100 001 and 1 000 000
frag_length_factor[which(frag_length<100001)]<-">10,000" # bw 10 001 and 100 000
frag_length_factor[which(frag_length<10001)]<-">1000" # bw 1001 and 10 000
frag_length_factor[which(frag_length<1000)]<-"<1000" # shorter than 1000


df <- data.frame(q_fragments,mid,strand,lower,upper,r_scf,frag_length_factor)
df$r_scf <- factor(df$r_scf,      # Reordering group factor levels
                   levels = rev(levels(df$r_scf)))
df$strand <- factor(df$strand,      # Reordering group factor levels
                    levels = rev(levels(df$strand)))
df$frag_length_factor<-factor(df$frag_length_factor,
                              levels=c("<1000",">1000",">10,000",">100,000",">1,000,000"))

#simple plot
p <- ggplot(df, aes(q_fragments, mid, color=strand))
p + geom_pointrange(aes(ymin = lower, ymax = upper))+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V2P scaffold 1 fragments",y="sinChu7 scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)

#plot with more info
q <- ggplot(df, aes(q_fragments, mid, shape = strand,color=identity))
q + geom_pointrange(aes(ymin = lower, ymax = upper,size=frag_length_factor))+
  scale_size_discrete(range = c(0.5, 1.5),name="fragment length (bp)")+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V2P scaffold 1 fragments",y="sinChu7 scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)

#### 5.3 qV2Pscf2 vs sinChu7 90% ####
#replace rv2pqv1_table -> qV1_SNA1_table
#replace labs
#if other scaffold
##replace V1scf2 -> V1scf2
##replace rv2pqv1_table[,1]==1 -> rv2pqv1_table[,1]==2
qV2P_SinChu7_table <- read.delim("G:/DATA/WORK/WGS_PIPELINE/1_TARdn/8B_Genomes_Comparisons_marshmap/04_mashmap_bwa_rMF_qV2P/rMF_qV2P_500minbp.out.table")

V2Pscf2<-qV2P_SinChu7_table[which(qV2P_SinChu7_table[,1]==2),]
#Keep only V1 scaffold 1, and only matches >90%
V2Pscf2<-V2Pscf2[which(V2Pscf2$identity>=90),]
#the table must be sorted by 1) query scf 2) ref scf 3) start position in ref
V2Pscf2<-V2Pscf2[order(V2Pscf2$query,V2Pscf2$X0_based_start),]

#https://ggplot2.tidyverse.org/reference/geom_linerange.html
q_fragments<-factor(seq(1,length(rownames(V2Pscf2))))    #trt
lower<-V2Pscf2$start
upper<-V2Pscf2$end.1
mid<-apply(rbind(lower,upper),2,median)    #resp
strand<-factor(V2Pscf2$strand)  #group
r_scf<-factor(V2Pscf2$ref)
identity<-V2Pscf2$identity
frag_length<-V2Pscf2$end - V2Pscf2$X0_based_start
frag_length_factor<-c()
frag_length_factor[which(frag_length>1000000)]<-">1,000,000" #more than 1 million
frag_length_factor[which(frag_length<1000001)]<-">100,000" # bw 100 001 and 1 000 000
frag_length_factor[which(frag_length<100001)]<-">10,000" # bw 10 001 and 100 000
frag_length_factor[which(frag_length<10001)]<-">1000" # bw 1001 and 10 000
frag_length_factor[which(frag_length<1000)]<-"<1000" # shorter than 1000


df <- data.frame(q_fragments,mid,strand,lower,upper,r_scf,frag_length_factor)
df$r_scf <- factor(df$r_scf,      # Reordering group factor levels
                   levels = rev(levels(df$r_scf)))
df$strand <- factor(df$strand,      # Reordering group factor levels
                    levels = rev(levels(df$strand)))
df$frag_length_factor<-factor(df$frag_length_factor,
                              levels=c("<1000",">1000",">10,000",">100,000",">1,000,000"))

#simple plot
p <- ggplot(df, aes(q_fragments, mid, color=strand))
p + geom_pointrange(aes(ymin = lower, ymax = upper))+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V2P scaffold 1 fragments",y="sinChu7 scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)

#plot with more info
q <- ggplot(df, aes(q_fragments, mid, shape = strand,color=identity))
q + geom_pointrange(aes(ymin = lower, ymax = upper,size=frag_length_factor))+
  scale_size_discrete(range = c(0.5, 1.5),name="fragment length (bp)")+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V2P scaffold 1 fragments",y="sinChu7 scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)


#### 6 qV2Pscf1 vs SNA 90% ####
#replace rv2pqv1_table -> qV1_SNA1_table
#replace labs
#if other scaffold
##replace V1scf2 -> V1scf2
##replace rv2pqv1_table[,1]==1 -> rv2pqv1_table[,1]==2
qV2P_SNA1_table <- read.delim("G:/DATA/WORK/WGS_PIPELINE/1_TARdn/8B_Genomes_Comparisons_marshmap/08_marshmap_rSNA_qV2P/rSNA_qV2P.out.table")

V2Pscf1<-qV2P_SNA1_table[which(qV2P_SNA1_table[,1]==1),]
#Keep only V1 scaffold 1, and only matches >90%
V2Pscf1<-V2Pscf1[which(V2Pscf1$identity>=90),]
#the table must be sorted by 1) query scf 2) ref scf 3) start position in ref
V2Pscf1<-V2Pscf1[order(V2Pscf1$query,V2Pscf1$X0_based_start),]

#https://ggplot2.tidyverse.org/reference/geom_linerange.html
q_fragments<-factor(seq(1,length(rownames(V2Pscf1))))    #trt
lower<-V2Pscf1$start
upper<-V2Pscf1$end.1
mid<-apply(rbind(lower,upper),2,median)    #resp
strand<-factor(V2Pscf1$strand)  #group
r_scf<-factor(V2Pscf1$ref)
identity<-V2Pscf1$identity
frag_length<-V2Pscf1$end - V2Pscf1$X0_based_start
frag_length_factor<-c()
frag_length_factor[which(frag_length>1000000)]<-">1,000,000" #more than 1 million
frag_length_factor[which(frag_length<1000001)]<-">100,000" # bw 100 001 and 1 000 000
frag_length_factor[which(frag_length<100001)]<-">10,000" # bw 10 001 and 100 000
frag_length_factor[which(frag_length<10001)]<-">1000" # bw 1001 and 10 000
frag_length_factor[which(frag_length<1000)]<-"<1000" # shorter than 1000


df <- data.frame(q_fragments,mid,strand,lower,upper,r_scf,frag_length_factor)
df$r_scf <- factor(df$r_scf,      # Reordering group factor levels
                   levels = rev(levels(df$r_scf)))
df$strand <- factor(df$strand,      # Reordering group factor levels
                    levels = rev(levels(df$strand)))
df$frag_length_factor<-factor(df$frag_length_factor,
                              levels=c("<1000",">1000",">10,000",">100,000",">1,000,000"))

#simple plot
p <- ggplot(df, aes(q_fragments, mid, color=strand))
p + geom_pointrange(aes(ymin = lower, ymax = upper))+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V2P scaffold 1 fragments",y="SNA1 scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)

#plot with more info
q <- ggplot(df, aes(q_fragments, mid,color=identity))
q + geom_pointrange(aes(ymin = lower, ymax = upper,size=frag_length_factor))+
  scale_size_discrete(range = c(0.5, 1.5),name="fragment length (bp)")+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="V2P scaffold 1 fragments",y="SNA1 scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)
#, shape = strand

#### 7 sinChu7 vs SNA 90% ####
#replace rv2pqv1_table -> qV1_SNA1_table
#replace labs
#if other scaffold
##replace V1scf2 -> V1scf2
##replace rv2pqv1_table[,1]==1 -> rv2pqv1_table[,1]==2
qsinChu7_SNA1_table <- read.delim("G:/DATA/WORK/WGS_PIPELINE/1_TARdn/8B_Genomes_Comparisons_marshmap/09_marshmap_rSNA_qMF/rSNA_qMF.out.table")

V2Pscf1<-qsinChu7_SNA1_table[which(qsinChu7_SNA1_table[,1]=="CM022461.1"),]
#Keep only V1 scaffold 1, and only matches >90%
V2Pscf1<-V2Pscf1[which(V2Pscf1$identity>=90),]
#the table must be sorted by 1) query scf 2) ref scf 3) start position in ref
V2Pscf1<-V2Pscf1[order(V2Pscf1$query,V2Pscf1$X0_based_start),]

#https://ggplot2.tidyverse.org/reference/geom_linerange.html
q_fragments<-factor(seq(1,length(rownames(V2Pscf1))))    #trt
lower<-V2Pscf1$start
upper<-V2Pscf1$end.1
mid<-apply(rbind(lower,upper),2,median)    #resp
strand<-factor(V2Pscf1$strand)  #group
r_scf<-factor(V2Pscf1$ref)
identity<-V2Pscf1$identity
frag_length<-V2Pscf1$end - V2Pscf1$X0_based_start
frag_length_factor<-c()
frag_length_factor[which(frag_length>1000000)]<-">1,000,000" #more than 1 million
frag_length_factor[which(frag_length<1000001)]<-">100,000" # bw 100 001 and 1 000 000
frag_length_factor[which(frag_length<100001)]<-">10,000" # bw 10 001 and 100 000
frag_length_factor[which(frag_length<10001)]<-">1000" # bw 1001 and 10 000
frag_length_factor[which(frag_length<1000)]<-"<1000" # shorter than 1000


df <- data.frame(q_fragments,mid,strand,lower,upper,r_scf,frag_length_factor)
df$r_scf <- factor(df$r_scf,      # Reordering group factor levels
                   levels = rev(levels(df$r_scf)))
df$strand <- factor(df$strand,      # Reordering group factor levels
                    levels = rev(levels(df$strand)))
df$frag_length_factor<-factor(df$frag_length_factor,
                              levels=c("<1000",">1000",">10,000",">100,000",">1,000,000"))

#simple plot
p <- ggplot(df, aes(q_fragments, mid, color=strand))
p + geom_pointrange(aes(ymin = lower, ymax = upper))+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="sinChu7 CM022461.1 fragments",y="SNA1 scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)

#plot with more info
q <- ggplot(df, aes(q_fragments, mid, shape = strand,color=identity))
q + geom_pointrange(aes(ymin = lower, ymax = upper,size=frag_length_factor))+
  scale_size_discrete(range = c(0.5, 1.5),name="fragment length (bp)")+
  theme(panel.grid.major =   element_line(colour = "lightgrey"),
        panel.grid.minor =   element_line(colour = "lightgrey"),
        panel.background = element_rect(fill = 'white', colour = 'grey'),)+
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #     panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  labs(x="sinChu7 CM022461.1 fragments",y="SNA1 scaffolds")+
  # scale_y_continuous(
  #  breaks=l_to_add2,
  # labels=levels(r_scf))+
  facet_grid(r_scf ~ .)





