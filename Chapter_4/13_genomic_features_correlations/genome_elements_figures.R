#### let's check for a linear correlation between size and RE ####
Table_genome_elements <- read.delim("G:/DATA/WORK/P0 THESIS/CHAPTER 4 NZ FISH COMPARATIVE GENOMICS/Table_genome_features.txt")
colnames(Table_genome_elements)
colnames(Table_genome_elements)<-c("Species","Genome_size","RE_proportion","Genes_No", "Gene_length",
                                   "Exons_No", "Exon_length", "Introns_No", "Intron_length",
                                   "Genes_prop","Exons_prop","Introns_prop","Complete_BUSCO",
                                   "Total_5putr_lgth","Total_3putr_lgth")

library(ggplot2)
library(ggrepel)

#RE proportion
cor.test(Table_genome_elements$RE_proportion,Table_genome_elements$Genome_size)
#R=0.9681792  p-value = 0.001503
ggplot(Table_genome_elements, aes(x=Genome_size,y=RE_proportion,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Proportion of repetitive elements (%)")+
  annotate("text",label=c(expression(paste(R^2,"= 0.97 P < 0.01"))),
          size=5, x = c(680000000), y = c(25))+
  annotate("text",label=c("***"),
           size=15, x = c(700000000), y = c(42),col="red")->p1.1
p1.1
#SIGNIF

#Genes no.
cor.test(Table_genome_elements$Genes_No ,Table_genome_elements$Genome_size)
#R=0.1865434  p-value = 0.7234
ggplot(Table_genome_elements, aes(x=Genome_size,y=Genes_No,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Number of genes")+
  annotate("text",label=c(expression(paste(R^2,"= 0.19 P = 0.72"))),
           size=5, x = c(680000000), y = c(18000))->p1.2
p1.2

#Gene_length
cor.test(Table_genome_elements$Gene_length ,Table_genome_elements$Genome_size)
#R=-0.2180505  p-value = 0.6781
ggplot(Table_genome_elements, aes(x=Genome_size,y=Gene_length,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Total gene length")+
  annotate("text",label=c(expression(paste(R^2,"= -0.22 P = 0.68"))),
           size=5, x = c(680000000), y = c(18000))->p1.3
p1.3


colnames(Table_genome_elements)
##Exons_No
cor.test(Table_genome_elements$Exons_No ,Table_genome_elements$Genome_size)
#R=-0.2431457   p-value = 0.6425
ggplot(Table_genome_elements, aes(x=Genome_size,y=Exons_No,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Number of exons")+
  annotate("text",label=c(expression(paste(R^2,"= -0.24 P = 0.64"))),
           size=5, x = c(680000000), y = c(50000))->p1.4
p1.4

colnames(Table_genome_elements)
##Exon_length
cor.test(Table_genome_elements$Exon_length ,Table_genome_elements$Genome_size)
#R=-0.241384   p-value = 0.645
ggplot(Table_genome_elements, aes(x=Genome_size,y=Exon_length,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Total exons length")+
  annotate("text",label=c(expression(paste(R^2,"= -0.24 P = 0.65"))),
           size=5, x = c(680000000), y = c(1))->p1.5
p1.5

colnames(Table_genome_elements)
##Introns_No
cor.test(Table_genome_elements$Introns_No ,Table_genome_elements$Genome_size)
#R=-0.2409916   p-value = 0.6455
ggplot(Table_genome_elements, aes(x=Genome_size,y=Introns_No,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Number of introns")+
  annotate("text",label=c(expression(paste(R^2,"= -0.24 P = 0.65"))),
           size=5, x = c(680000000), y = c(30000))->p1.6
p1.6

colnames(Table_genome_elements)
##Intron_length
cor.test(Table_genome_elements$Intron_length ,Table_genome_elements$Genome_size)
#R=-0.213409    p-value = 0.6847
ggplot(Table_genome_elements, aes(x=Genome_size,y=Intron_length,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Total introns length")+
  annotate("text",label=c(expression(paste(R^2,"= -0.21 P = 0.68"))),
           size=5, x = c(680000000), y = c(10000000))->p1.7
p1.7

colnames(Table_genome_elements)
##Genes_prop
cor.test(Table_genome_elements$Genes_prop ,Table_genome_elements$Genome_size)
#R=-0.352196   p-value = 0.4935
ggplot(Table_genome_elements, aes(x=Genome_size,y=Genes_prop,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Proportion of genes (%)")+
  annotate("text",label=c(expression(paste(R^2,"= -0.35 P = 0.49"))),
           size=5, x = c(680000000), y = c(5))->p1.8
p1.8

colnames(Table_genome_elements)
##Exons_prop
cor.test(Table_genome_elements$Exons_prop,Table_genome_elements$Genome_size)
#R=-0.4205162   p-value = 0.4064
ggplot(Table_genome_elements, aes(x=Genome_size,y=Exons_prop,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Proportion of exons (%)")+
  annotate("text",label=c(expression(paste(R^2,"= -0.42 P = 0.41"))),
           size=5, x = c(680000000), y = c(0.5))->p1.9
p1.9

colnames(Table_genome_elements)
##Introns_prop
cor.test(Table_genome_elements$Introns_prop,Table_genome_elements$Genome_size)
#R=-0.338622   p-value = 0.5115
ggplot(Table_genome_elements, aes(x=Genome_size,y=Introns_prop,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Proportion of introns (%)")+
  annotate("text",label=c(expression(paste(R^2,"= -0.34 P = 0.51"))),
           size=5, x = c(680000000), y = c(3))->p1.10
p1.10

colnames(Table_genome_elements)
##Total_5putr_lgth
cor.test(Table_genome_elements$Total_5putr_lgth,Table_genome_elements$Genome_size)
#R=-0.2189307  p-value = 0.6769
ggplot(Table_genome_elements, aes(x=Genome_size,y=Total_5putr_lgth,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Total 5' UTR length")+
  annotate("text",label=c(expression(paste(R^2,"= -0.22 P = 0.68"))),
           size=5, x = c(680000000), y = c(-1800000))->p1.11
p1.11

colnames(Table_genome_elements)
##Total_3putr_lgth
cor.test(Table_genome_elements$Total_3putr_lgth,Table_genome_elements$Genome_size)
#R=-0.2310371  p-value = 0.6596
ggplot(Table_genome_elements, aes(x=Genome_size,y=Total_3putr_lgth,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Total 3' UTR length")+
  annotate("text",label=c(expression(paste(R^2,"= -0.23 P = 0.66"))),
           size=5, x = c(680000000), y = c(-13000000))->p1.12
p1.12

library(gridExtra)
pdf(file = "plots/plot1.pdf",   # The directory you want to save the file in
    width = 19, # The width of the plot in inches
    height = 8) # The height of the plot in inches
grid.arrange(p1.1,p1.2,p1.3,p1.8,p1.4,p1.5,p1.9,p1.6,p1.7,p1.10,p1.11,p1.12,nrow = 3)
dev.off()


#### SAME BUT WITHOUT TARAKIHI ####
Table_genome_elements_noTAR<-Table_genome_elements[-1,]

#RE proportion
cor.test(Table_genome_elements_noTAR$RE_proportion,Table_genome_elements_noTAR$Genome_size)
#R=0.9751321 p-value = 0.00469
ggplot(Table_genome_elements_noTAR, aes(x=Genome_size,y=RE_proportion,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Proportion of repetitive elements (%)")+
  annotate("text",label=c(expression(paste(R^2,"= 0.98 P < 0.01"))),
           size=5, x = c(680000000), y = c(25))+
  annotate("text",label=c("***"),
         size=15, x = c(700000000), y = c(42),col="red")->p2.1
p2.1
#SIGNIF

#Genes no.
cor.test(Table_genome_elements_noTAR$Genes_No ,Table_genome_elements_noTAR$Genome_size)
#R=0.00692815  p-value = 0.9912
ggplot(Table_genome_elements_noTAR, aes(x=Genome_size,y=Genes_No,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Number of genes")+
  annotate("text",label=c(expression(paste(R^2,"= 0.01 P = 0.99"))),
           size=5, x = c(680000000), y = c(18000))->p2.2
p2.2

#Gene_length
cor.test(Table_genome_elements_noTAR$Gene_length ,Table_genome_elements_noTAR$Genome_size)
#R=-0.03999159  p-value = 0.9491
ggplot(Table_genome_elements_noTAR, aes(x=Genome_size,y=Gene_length,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Total gene length")+
  annotate("text",label=c(expression(paste(R^2,"= -0.04 P = 0.95"))),
           size=5, x = c(680000000), y = c(18000))->p2.3
p2.3


colnames(Table_genome_elements_noTAR)
##Exons_No
cor.test(Table_genome_elements_noTAR$Exons_No ,Table_genome_elements_noTAR$Genome_size)
#R=-0.1142254   p-value = 0.8549
ggplot(Table_genome_elements_noTAR, aes(x=Genome_size,y=Exons_No,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Number of exons")+
  annotate("text",label=c(expression(paste(R^2,"= -0.11 P = 0.85"))),
           size=5, x = c(680000000), y = c(50000))->p2.4
p2.4

colnames(Table_genome_elements_noTAR)
##Exon_length
cor.test(Table_genome_elements_noTAR$Exon_length ,Table_genome_elements_noTAR$Genome_size)
#R=-0.1105287  p-value = 0.8596
ggplot(Table_genome_elements_noTAR, aes(x=Genome_size,y=Exon_length,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Total exons length")+
  annotate("text",label=c(expression(paste(R^2,"= -0.11 P = 0.86"))),
           size=5, x = c(680000000), y = c(15000000))->p2.5
p2.5

colnames(Table_genome_elements_noTAR)
##Introns_No
cor.test(Table_genome_elements_noTAR$Introns_No ,Table_genome_elements_noTAR$Genome_size)
#R=-0.1102079    p-value = 0.86
ggplot(Table_genome_elements_noTAR, aes(x=Genome_size,y=Introns_No,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Number of introns")+
  annotate("text",label=c(expression(paste(R^2,"= -0.11 P = 0.86"))),
           size=5, x = c(680000000), y = c(50000))->p2.6
p2.6

colnames(Table_genome_elements_noTAR)
##Intron_length
cor.test(Table_genome_elements_noTAR$Intron_length ,Table_genome_elements_noTAR$Genome_size)
#R=-0.0316617     p-value = 0.9597
ggplot(Table_genome_elements_noTAR, aes(x=Genome_size,y=Intron_length,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Total introns length")+
  annotate("text",label=c(expression(paste(R^2,"= -0.31 P = 0.96"))),
           size=5, x = c(680000000), y = c(10000000))->p2.7
p2.7

colnames(Table_genome_elements_noTAR)
##Genes_prop
cor.test(Table_genome_elements_noTAR$Genes_prop ,Table_genome_elements_noTAR$Genome_size)
#R=-0.3865151    p-value = 0.5204
ggplot(Table_genome_elements_noTAR, aes(x=Genome_size,y=Genes_prop,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Proportion of genes (%)")+
  annotate("text",label=c(expression(paste(R^2,"= -0.39 P = 0.52"))),
           size=5, x = c(680000000), y = c(2))->p2.8
p2.8

colnames(Table_genome_elements_noTAR)
##Exons_prop
cor.test(Table_genome_elements_noTAR$Exons_prop,Table_genome_elements_noTAR$Genome_size)
#R=-0.6751474    p-value = 0.2111
ggplot(Table_genome_elements_noTAR, aes(x=Genome_size,y=Exons_prop,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Proportion of exons (%)")+
  annotate("text",label=c(expression(paste(R^2,"= -0.68 P = 0.21"))),
           size=5, x = c(680000000), y = c(2))->p2.9
p2.9

colnames(Table_genome_elements_noTAR)
##Introns_prop
cor.test(Table_genome_elements_noTAR$Introns_prop,Table_genome_elements_noTAR$Genome_size)
#R=-0.3409004    p-value = 0.5745
ggplot(Table_genome_elements_noTAR, aes(x=Genome_size,y=Introns_prop,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Proportion of introns (%)")+
  annotate("text",label=c(expression(paste(R^2,"= -0.34 P = 0.57"))),
           size=5, x = c(680000000), y = c(1))->p2.10
p2.10

colnames(Table_genome_elements_noTAR)
##Total_5putr_lgth
cor.test(Table_genome_elements_noTAR$Total_5putr_lgth,Table_genome_elements_noTAR$Genome_size)
#R=0.05207159  p-value = 0.9337
ggplot(Table_genome_elements_noTAR, aes(x=Genome_size,y=Total_5putr_lgth,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Total 5' UTR length")+
  annotate("text",label=c(expression(paste(R^2,"= -0.22 P = 0.68"))),
           size=5, x = c(680000000), y = c(25000))->p2.11
p2.11

colnames(Table_genome_elements_noTAR)
##Total_3putr_lgth
cor.test(Table_genome_elements_noTAR$Total_3putr_lgth,Table_genome_elements_noTAR$Genome_size)
#R=-0.3172218   p-value = 0.603
ggplot(Table_genome_elements_noTAR, aes(x=Genome_size,y=Total_3putr_lgth,
                                        label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Total 3' UTR length")+
  annotate("text",label=c(expression(paste(R^2,"= -0.32 P = 0.60"))),
           size=5, x = c(680000000), y = c(-600000))->p2.12
p2.12

library(gridExtra)
pdf(file = "plots/plot1.pdf",   # The directory you want to save the file in
    width = 19, # The width of the plot in inches
    height = 8) # The height of the plot in inches
grid.arrange(p1.1,p1.2,p1.3,p1.8,p1.4,p1.5,p1.9,p1.6,p1.7,p1.10,p1.11,p1.12,nrow = 3)
dev.off()

library(gridExtra)
pdf(file = "plots/plot2.pdf",   # The directory you want to save the file in
    width = 19, # The width of the plot in inches
    height = 8) # The height of the plot in inches
grid.arrange(p2.1,p2.2,p2.3,p2.8,p2.4,p2.5,p2.9,p2.6,p2.7,p2.10,p2.11,p2.12,nrow = 3)
dev.off()


#### BUSCO CORELATION ####
#RE proportion
cor.test(Table_genome_elements$RE_proportion,Table_genome_elements$Complete_BUSCO)
#R=-0.2052859  p-value = 0.6964
ggplot(Table_genome_elements, aes(x=Complete_BUSCO,y=RE_proportion,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Proportion of repetitive elements (%)")+
  annotate("text",label=c(expression(paste(R^2,"= -0.21 P = 0.70"))),
           size=5, x = c(93), y = c(20))->p3.1
p3.1


#Genes no.
cor.test(Table_genome_elements$Genes_No ,Table_genome_elements$Complete_BUSCO)
#R=-0.863688   p-value = 0.02661
ggplot(Table_genome_elements, aes(x=Complete_BUSCO,y=Genes_No,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Number of genes")+
  annotate("text",label=c(expression(paste(R^2,"= -0.86 P < 0.05"))),
           size=5, x = c(93), y = c(18000))+
  annotate("text",label=c("**"),
           size=15, x = c(97), y = c(25000),col="red")->p3.2
p3.2
#SIGNIF

#Gene_length
cor.test(Table_genome_elements$Gene_length ,Table_genome_elements$Complete_BUSCO)
#R=0.9478325  p-value = 0.004011
ggplot(Table_genome_elements, aes(x=Complete_BUSCO,y=Gene_length,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Total gene length")+
  annotate("text",label=c(expression(paste(R^2,"= 0.95 P < 0.01"))),
           size=5, x = c(93), y = c(80000000))+
  annotate("text",label=c("***"),
           size=15, x = c(95), y = c(300000000),col="red")->p3.3
p3.3
#SIGNIF

colnames(Table_genome_elements)
##Exons_No
cor.test(Table_genome_elements$Exons_No ,Table_genome_elements$Complete_BUSCO)
#R=0.9486462   p-value = 0.003888
ggplot(Table_genome_elements, aes(x=Complete_BUSCO,y=Exons_No,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Number of exons")+
  annotate("text",label=c(expression(paste(R^2,"= 0.95 P < 0.01"))),
           size=5, x = c(93), y = c(120000))+
  annotate("text",label=c("***"),
           size=15, x = c(95), y = c(240000),col="red")->p3.4
p3.4
#SIGNIF

colnames(Table_genome_elements)
##Exon_length
cor.test(Table_genome_elements$Exon_length ,Table_genome_elements$Complete_BUSCO)
#R=-0.91  p-value = 0.01254
ggplot(Table_genome_elements, aes(x=Complete_BUSCO,y=Exon_length,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Total exons length")+
  annotate("text",label=c(expression(paste(R^2,"= 0.91 P < 0.05"))),
           size=5, x = c(93), y = c(15000000))+
  annotate("text",label=c("**"),
           size=15, x = c(95), y = c(55000000),col="red")->p3.5
p3.5
#SIGNIF

colnames(Table_genome_elements)
##Introns_No
cor.test(Table_genome_elements$Introns_No ,Table_genome_elements$Complete_BUSCO)
#R=0.9463362  p-value = 0.004242
ggplot(Table_genome_elements, aes(x=Complete_BUSCO,y=Introns_No,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Number of introns")+
  annotate("text",label=c(expression(paste(R^2,"= 0.95 P < 0.01"))),
           size=5, x = c(93), y = c(100000))+
  annotate("text",label=c("***"),
           size=15, x = c(95), y = c(220000),col="red")->p3.6
p3.6
#SIGNIF

colnames(Table_genome_elements)
##Intron_length
cor.test(Table_genome_elements$Intron_length ,Table_genome_elements$Complete_BUSCO)
#R=0.9528541    p-value = 0.003282
ggplot(Table_genome_elements, aes(x=Complete_BUSCO,y=Intron_length,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Total introns length")+
  annotate("text",label=c(expression(paste(R^2,"= 0.95 P < 0.01"))),
           size=5, x = c(93), y = c(60000000))+
  annotate("text",label=c("***"),
           size=15, x = c(95), y = c(250000000),col="red")->p3.7
p3.7
#SIGNIF

colnames(Table_genome_elements)
##Genes_prop
cor.test(Table_genome_elements$Genes_prop ,Table_genome_elements$Complete_BUSCO)
#R=0.9610594  p-value = 0.002245
ggplot(Table_genome_elements, aes(x=Complete_BUSCO,y=Genes_prop,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Proportion of genes (%)")+
  annotate("text",label=c(expression(paste(R^2,"= 0.96 P < 0.01"))),
           size=5, x = c(93), y = c(12))+
  annotate("text",label=c("***"),
           size=15, x = c(95), y = c(54),col="red")->p3.8
p3.8
#SIGNIF

colnames(Table_genome_elements)
##Exons_prop
cor.test(Table_genome_elements$Exons_prop,Table_genome_elements$Complete_BUSCO)
#R=0.9186018   p-value = 0.009669
ggplot(Table_genome_elements, aes(x=Complete_BUSCO,y=Exons_prop,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Proportion of exons (%)")+
  annotate("text",label=c(expression(paste(R^2,"= 0.92 P < 0.01"))),
           size=5, x = c(93), y = c(3))+
  annotate("text",label=c("***"),
           size=15, x = c(95), y = c(9.7),col="red")->p3.9
p3.9
#SIGNIF

colnames(Table_genome_elements)
##Introns_prop
cor.test(Table_genome_elements$Introns_prop,Table_genome_elements$Complete_BUSCO)
#R=0.9660886   p-value = 0.001705
ggplot(Table_genome_elements, aes(x=Complete_BUSCO,y=Introns_prop,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Proportion of introns (%)")+
  annotate("text",label=c(expression(paste(R^2,"= 0.97 P < 0.01"))),
           size=5, x = c(93), y = c(10))+
  annotate("text",label=c("***"),
           size=15, x = c(95), y = c(43),col="red")->p3.10
p3.10
#SIGNIF

colnames(Table_genome_elements_noTAR)
##Total_5putr_lgth
cor.test(Table_genome_elements$Total_5putr_lgth,Table_genome_elements$Complete_BUSCO)
#R=0.8094519   p-value = 0.051
ggplot(Table_genome_elements, aes(x=Complete_BUSCO,y=Total_5putr_lgth,
                                        label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Total 5' UTR length")+
  annotate("text",label=c(expression(paste(R^2,"= 0.81 P = 0.05"))),
           size=5, x = c(93), y = c(-600000))+
  annotate("text",label=c("**"),
           size=15, x = c(95), y = c(2400000),col="red")->p3.11
p3.11

colnames(Table_genome_elements_noTAR)
##Total_3putr_lgth
cor.test(Table_genome_elements$Total_3putr_lgth,Table_genome_elements$Complete_BUSCO)
#R=0.78857  p-value = 0.06233
ggplot(Table_genome_elements, aes(x=Complete_BUSCO,y=Total_3putr_lgth,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Total 3' UTR length")+
  annotate("text",label=c(expression(paste(R^2,"= 0.79 P = 0.06"))),
           size=5, x = c(93), y = c(-5000000))+
  annotate("text",label=c("*"),
           size=15, x = c(95), y = c(18000000),col="red")->p3.12
p3.12

library(gridExtra)
pdf(file = "plots/plot3.pdf",   # The directory you want to save the file in
    width = 19, # The width of the plot in inches
    height = 8) # The height of the plot in inches
grid.arrange(p3.1,p3.2,p3.3,p3.8,p3.4,p3.5,p3.9,p3.6,p3.7,p3.10,p3.11,p3.12,nrow = 3)
dev.off()



#### BUSCO CORELATION WITHOUT TAR####
Table_genome_elements_noTAR<-Table_genome_elements[-1,]

#RE proportion
cor.test(Table_genome_elements_noTAR$RE_proportion,Table_genome_elements_noTAR$Complete_BUSCO)
#R=-0.2125434 p-value = 0.7314
ggplot(Table_genome_elements_noTAR, aes(x=Complete_BUSCO,y=RE_proportion,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Proportion of repetitive elements (%)")+
  annotate("text",label=c(expression(paste(R^2,"= -0.21 P = 0.73"))),
           size=5, x = c(87), y = c(12))->p4.1
p4.1


#Genes no.
cor.test(Table_genome_elements_noTAR$Genes_No ,Table_genome_elements_noTAR$Complete_BUSCO)
#R=-0.5969677   p-value = 0.2879
ggplot(Table_genome_elements_noTAR, aes(x=Complete_BUSCO,y=Genes_No,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Number of genes")+
  annotate("text",label=c(expression(paste(R^2,"= -0.60 P = 0.29"))),
           size=5, x = c(87), y = c(19500))->p4.2
p4.2
#SIGNIF

#Gene_length
cor.test(Table_genome_elements_noTAR$Gene_length ,Table_genome_elements_noTAR$Complete_BUSCO)
#R=0.900708  p-value = 0.03699
ggplot(Table_genome_elements_noTAR, aes(x=Complete_BUSCO,y=Gene_length,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Total gene length")+
  annotate("text",label=c(expression(paste(R^2,"= 0.90 P < 0.05"))),
           size=5, x = c(87), y = c(80000000))+
  annotate("text",label=c("**"),
           size=15, x = c(87), y = c(210000000),col="red")->p4.3
p4.3
#SIGNIF

colnames(Table_genome_elements_noTAR)
##Exons_No
cor.test(Table_genome_elements_noTAR$Exons_No ,Table_genome_elements_noTAR$Complete_BUSCO)
#R=0.8573015   p-value = 0.06331
ggplot(Table_genome_elements_noTAR, aes(x=Complete_BUSCO,y=Exons_No,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Number of exons")+
  annotate("text",label=c(expression(paste(R^2,"= 0.86 P < 0.1"))),
           size=5, x = c(87), y = c(120000))+
  annotate("text",label=c("*"),
           size=15, x = c(87), y = c(220000),col="red")->p4.4
p4.4
#SIGNIF

colnames(Table_genome_elements_noTAR)
##Exon_length
cor.test(Table_genome_elements_noTAR$Exon_length ,Table_genome_elements_noTAR$Complete_BUSCO)
#R=-0.8405702  p-value = 0.07456
ggplot(Table_genome_elements_noTAR, aes(x=Complete_BUSCO,y=Exon_length,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Total exons length")+
  annotate("text",label=c(expression(paste(R^2,"= 0.84 P < 0.1"))),
           size=5, x = c(87), y = c(20000000))+
  annotate("text",label=c("*"),
           size=15, x = c(87), y = c(35000000),col="red")->p4.5
p4.5
#SIGNIF

colnames(Table_genome_elements_noTAR)
##Introns_No
cor.test(Table_genome_elements_noTAR$Introns_No ,Table_genome_elements_noTAR$Complete_BUSCO)
#R=0.9463362  p-value = 0.004242
ggplot(Table_genome_elements_noTAR, aes(x=Complete_BUSCO,y=Introns_No,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Number of introns")+
  annotate("text",label=c(expression(paste(R^2,"= 0.95 P < 0.01"))),
           size=5, x = c(87), y = c(100000))+
  annotate("text",label=c("***"),
           size=15, x = c(87), y = c(220000),col="red")->p4.6
p4.6
#SIGNIF

colnames(Table_genome_elements_noTAR)
##Intron_length
cor.test(Table_genome_elements_noTAR$Intron_length ,Table_genome_elements_noTAR$Complete_BUSCO)
#R=0.9528541    p-value = 0.003282
ggplot(Table_genome_elements_noTAR, aes(x=Complete_BUSCO,y=Intron_length,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Total introns length")+
  annotate("text",label=c(expression(paste(R^2,"= 0.95 P < 0.01"))),
           size=5, x = c(87), y = c(60000000))+
  annotate("text",label=c("***"),
           size=15, x = c(87), y = c(250000000),col="red")->p4.7
p4.7
#SIGNIF

colnames(Table_genome_elements_noTAR)
##Genes_prop
cor.test(Table_genome_elements_noTAR$Genes_prop ,Table_genome_elements_noTAR$Complete_BUSCO)
#R=0.9610594  p-value = 0.002245
ggplot(Table_genome_elements_noTAR, aes(x=Complete_BUSCO,y=Genes_prop,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Proportion of genes (%)")+
  annotate("text",label=c(expression(paste(R^2,"= 0.96 P < 0.01"))),
           size=5, x = c(87), y = c(12))+
  annotate("text",label=c("***"),
           size=15, x = c(87), y = c(54),col="red")->p4.8
p4.8
#SIGNIF

colnames(Table_genome_elements_noTAR)
##Exons_prop
cor.test(Table_genome_elements_noTAR$Exons_prop,Table_genome_elements_noTAR$Complete_BUSCO)
#R=0.9186018   p-value = 0.009669
ggplot(Table_genome_elements_noTAR, aes(x=Complete_BUSCO,y=Exons_prop,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Proportion of exons (%)")+
  annotate("text",label=c(expression(paste(R^2,"= 0.92 P < 0.01"))),
           size=5, x = c(87), y = c(3))+
  annotate("text",label=c("***"),
           size=15, x = c(87), y = c(9.7),col="red")->p4.9
p4.9
#SIGNIF

colnames(Table_genome_elements_noTAR)
##Introns_prop
cor.test(Table_genome_elements_noTAR$Introns_prop,Table_genome_elements_noTAR$Complete_BUSCO)
#R=0.9660886   p-value = 0.001705
ggplot(Table_genome_elements_noTAR, aes(x=Complete_BUSCO,y=Introns_prop,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Proportion of introns (%)")+
  annotate("text",label=c(expression(paste(R^2,"= 0.97 P < 0.01"))),
           size=5, x = c(87), y = c(10))+
  annotate("text",label=c("***"),
           size=15, x = c(87), y = c(43),col="red")->p4.10
p4.10
#SIGNIF

colnames(Table_genome_elements_noTAR_noTAR)
##Total_5putr_lgth
cor.test(Table_genome_elements_noTAR$Total_5putr_lgth,Table_genome_elements_noTAR$Complete_BUSCO)
#R=0.8094519   p-value = 0.051
ggplot(Table_genome_elements_noTAR, aes(x=Complete_BUSCO,y=Total_5putr_lgth,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Total 5' UTR length")+
  annotate("text",label=c(expression(paste(R^2,"= 0.81 P = 0.05"))),
           size=5, x = c(87), y = c(-600000))+
  annotate("text",label=c("**"),
           size=15, x = c(87), y = c(2400000),col="red")->p4.11
p4.11

colnames(Table_genome_elements_noTAR_noTAR)
##Total_3putr_lgth
cor.test(Table_genome_elements_noTAR$Total_3putr_lgth,Table_genome_elements_noTAR$Complete_BUSCO)
#R=0.78857  p-value = 0.06233
ggplot(Table_genome_elements_noTAR, aes(x=Complete_BUSCO,y=Total_3putr_lgth,
                                  label=Species))+
  geom_point()+
  stat_smooth(method = "lm", col = "blue")+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="BUSCO completeness (%)", y="Total 3' UTR length")+
  annotate("text",label=c(expression(paste(R^2,"= 0.79 P = 0.06"))),
           size=5, x = c(87), y = c(-5000000))+
  annotate("text",label=c("*"),
           size=15, x = c(87), y = c(18000000),col="red")->p4.12
p4.12

library(gridExtra)
pdf(file = "plots/plot3.pdf",   # The directory you want to save the file in
    width = 19, # The width of the plot in inches
    height = 8) # The height of the plot in inches
grid.arrange(p4.1,p4.2,p4.3,p4.8,p4.4,p4.5,p4.9,p4.6,p4.7,p4.10,p4.11,p4.12,nrow = 3)
dev.off()

