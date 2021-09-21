#### let's check for a linear correlation between size and RE ####
Table_repeat_elements <- read.delim("G:/DATA/WORK/P0 THESIS/CHAPTER 4 NZ FISH COMPARATIVE GENOMICS/Table_repeat_elements.txt")
colnames(Table_repeat_elements)<-c("Species","Genome_size","RE_proportion")

library(ggplot2)
library(ggrepel)


ggplot(Table_repeat_elements, aes(x=Genome_size,y=RE_proportion,
                    label=Species))+
  stat_smooth(method = "lm", col = "blue")+
  geom_point()+
  geom_label_repel()+
  theme_light()+
  theme(
    panel.border=element_rect(colour = "black",fill=NA))+
  labs(x="Genome size (Mb)", y="Proportion of repetitive elements in genome (%)")

