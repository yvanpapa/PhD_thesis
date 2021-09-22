setwd("G:/DATA/WORK/WGS_PIPELINE/2_popgen/14_Calculate_LD")
library(readr)
library(dplyr)
library(ggplot2)

for (f in c(1:30)) {

ld <- read_delim(paste("subsets_1M/call_set_AGRFlib1_to_6_V2P.rn.QCmaf.scf",f,".AB.geno.ld.subset1M",
                       sep=""),delim = "\t")
ld <- ld %>% mutate(distance = POS2-POS1)

R2_sum <- ld %>% group_by(distance) %>% summarise(mean    = mean(`R^2`, na.rm = T)
                                                  ,sd      = sd(`R^2`  , na.rm = T)
                                                  ,n       = n()
                                                  ,var_min = mean-sd^2
                                                  ,var_max = mean+sd^2
                                                  ,se_min  = mean-(sd/sqrt(n))
                                                  ,se_max  = mean+(sd/sqrt(n))
)

model<-lm(mean~1 + distance, data=R2_sum)

####plot the LD means

ggplot(R2_sum, aes(x=distance,y=mean))+
 geom_point()+
 geom_smooth(method = "lm", formula = y ~ x + I(x^0.1),size = 1.5)+
  geom_smooth(aes(y=var_min), method = "lm", formula = y ~ x + I(x^0.1),linetype="dashed",size=1)+
geom_smooth(aes(y=var_max), method = "lm", formula = y ~ x + I(x^0.1),linetype="dashed",size=1)+
geom_hline(aes(yintercept =0.2), color = "red", linetype = "dashed", size = 1.1)+
  geom_hline(aes(yintercept =model$coefficients[1]), col="orange",size=1.5)+
xlim(1,3000)+
xlab("Distance (bp)")+
  ylab(expression(paste("Average LD (mean ",R^2,")")))+
theme_bw()
ggsave(paste("./plots/3000_scf",f,".png",sep=""),
 dpi = 300,width = 7, height = 4, units = "in")

###ggplot(R2_sum, aes(x=distance,y=mean))+
###geom_point()+
###geom_smooth(method = "lm", formula = y ~ x + I(x^0.1),size = 1.5)+
###geom_smooth(aes(y=var_min), method = "lm", formula = y ~ x + I(x^0.1),linetype="dashed",size=1)+
###geom_smooth(aes(y=var_max), method = "lm", formula = y ~ x + I(x^0.1),linetype="dashed",size=1)+
###geom_hline(aes(yintercept =0.2), color = "red", linetype = "dashed", size = 1.1)+
###geom_hline(aes(yintercept =model$coefficients[1]), col="orange",size=1.5)+
###xlim(1,50000)+
###xlab("Distance (bp)")+
###ylab(expression(paste("Average LD (mean ",R^2,")")))+
###theme_bw()
###ggsave(paste("./plots/50000_scf",f,".png",sep=""),
###dpi = 300,width = 7, height = 4, units = "in")

ggplot(ld[which(ld$distance<3000),], aes(x=distance,y=`R^2`))+
  geom_point()+
  geom_smooth(method = "lm", formula = y ~ x + I(x^0.01),size = 2)+
  geom_hline(aes(yintercept =model$coefficients[1]), col="orange",size=2)+
  geom_hline(aes(yintercept =0.2), color = "red", linetype = "dashed", size = 1.5)+
  theme_bw()+xlim(1,3000)+
  xlab("Distance (bp)")+
  ylab(expression(paste("Linkage Desequilibrium (",R^2,")")))
ggsave(paste("./plots/nomean_3000_scf",f,".png",sep=""),
       dpi = 300,width = 7, height = 4, units = "in")

###ggplot(ld[which(ld$distance<50000),], aes(x=distance,y=`R^2`))+
###geom_point()+
###geom_smooth(method = "lm", formula = y ~ x + I(x^0.01),size = 2)+
###geom_hline(aes(yintercept =model$coefficients[1]), col="orange",size=2)+
###geom_hline(aes(yintercept =0.2), color = "red", linetype = "dashed", size = 1.5)+
###theme_bw()+xlim(1,50000)+
###xlab("Distance (bp)")+
###ylab(expression(paste("Linkage Desequilibrium (",R^2,")")))
###ggsave(paste("./plots/nomean_50000_scf",f,".png",sep=""),
### dpi = 300,width = 7, height = 4, units = "in")

} 

