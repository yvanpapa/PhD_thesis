setwd("G:/DATA/WORK/WGS_PIPELINE/4_fish_assemblies/24_paml_selection/pipeline1_tarakihi")

library(ggplot2)
# Basic barplot

df_GOterms<-read.delim("G:/DATA/WORK/WGS_PIPELINE/4_fish_assemblies/24_paml_selection/pipeline1_tarakihi/count_goterms_functions_tarakihi.txt")

##Replace all =1 by "others"
#Others<-c("Others","Others",length(which(df_GOterms$No_terms==1)))
#rbind(Others,df_GOterms)->df_GOterms

#Remove all =1
df_GOterms<-df_GOterms[-which(df_GOterms$No_terms<=2),]

#df_GOterms$No_terms <-factor(df_GOterms$No_terms,
#                            levels = seq(1,max(as.integer(df_GOterms$No_terms)),1))#this is necessary to order the labels on Y


df_GOterms$No_terms<-as.integer(df_GOterms$No_terms) #necessary to plot Y axis corrctly
df_GOterms$Function <-factor(df_GOterms$Function,
                             levels = rev(df_GOterms$Function)) #this is necessary to order the labels on X



ggplot(data=df_GOterms, aes(x=Function, y=No_terms)) +
  geom_bar(stat="identity",color="black",fill="#999999")+ coord_flip()+
  theme_bw()+
  xlab("Gene function or location")+ ylab("Frequency")+
  scale_y_continuous(expand = c(0,0))+
  theme(axis.text.x = element_text( colour = "black",size=12))+
  theme(axis.text.y = element_text( colour = "black",size=12))+
  theme(text = element_text(size=14))
