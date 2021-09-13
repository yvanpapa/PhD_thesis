setwd("G:/DATA/WORK/WGS_PIPELINE/1_TARdn/TARdn2/Isoseq/01_clustering_pipeline/10_caract_repeat_transcripts")

#An asterisk (*) in the final column (no example shown) indicates that there is a higher-scoring match whose domain partly (<80%) includes the domain of this match.
#http://www.repeatmasker.org/webrepeatmaskerhelp.html
#So I added a "best" in the last column of each row that does not contain an asterisk

RE_trscrpts <- read.table("G:/DATA/WORK/WGS_PIPELINE/1_TARdn/TARdn2/Isoseq/01_clustering_pipeline/10_caract_repeat_transcripts/RE_transcripts_characterized_formatted.txt", quote="\"", comment.char="")

df<-RE_trscrpts[,c(5:8,10,11,16)]
colnames(df)<-c("trscrpt_id","start_qry","end_qry","after_match","name","class","score")

df<-df[order(df$trscrpt_id),]

#Keep only matchs that dont have a higher-scoring overlapping match
df<-df[-which(df$score=="*"),]

length(unique(df$trscrpt_id)) # 2347 unique transcripts


####If a transcript has several matches all equal, keep only one line####

# Get all the non-unique transcripts
n_occur <- data.frame(table(df$trscrpt_id))
n_occur[n_occur$Freq > 1,]
df[df$trscrpt_id %in% n_occur$Var1[n_occur$Freq > 1],]->duplicates_df

#Remove all the unknowns if in other duplicates
df->df2 #df2 will be purged of unknowns in duplicates
for (id in  unique(duplicates_df$trscrpt_id)) {

  dfsubs<-df2[which(df2$trscrpt_id==id),]

  if (length(unique(dfsubs$class))>1)
{
  if (length(which(dfsubs$class=="Unknown"))>0)
  {
    rownames(dfsubs[(which(dfsubs$class=="Unknown")),])->rn
    df2<-df2[-which(rownames(df2) %in% rn),]
    }
}
  
}

n_occur <- data.frame(table(df2$trscrpt_id))
n_occur[n_occur$Freq > 1,]
df2[df2$trscrpt_id %in% n_occur$Var1[n_occur$Freq > 1],]->duplicates_df2
#Remove all the simple_repeats if in other duplicates
df2->df3 #df3 will be purged of simple_repeats in other duplicates
for (id in  unique(duplicates_df2$trscrpt_id)) {
  
  dfsubs<-df3[which(df3$trscrpt_id==id),]
  
  if (length(unique(dfsubs$class))>1)
  {
    if (length(which(dfsubs$class=="Simple_repeat"))>0)
    {
      rownames(dfsubs[(which(dfsubs$class=="Simple_repeat")),])->rn
      df3<-df3[-which(rownames(df3) %in% rn),]
    }
  }
  
}

#Remove all duplicates if they all have the same class
n_occur <- data.frame(table(df3$trscrpt_id))
n_occur[n_occur$Freq > 1,]
df3[df3$trscrpt_id %in% n_occur$Var1[n_occur$Freq > 1],]->duplicates_df3

df3->df4 #df4 will have only uplicates with different classes
for (id in  unique(duplicates_df3$trscrpt_id)) {
  
  dfsubs<-df4[which(df4$trscrpt_id==id),]
  if (length(unique(dfsubs$class))==1){
   rownames(dfsubs)->rn
    rn[-1]->rn
    df4<-df4[-which(rownames(df4) %in% rn),]
  }
}

#Keep only the longest matched class
n_occur <- data.frame(table(df4$trscrpt_id))
n_occur[n_occur$Freq > 1,]
df4[df4$trscrpt_id %in% n_occur$Var1[n_occur$Freq > 1],]->duplicates_df4

df4->df5 

#> length(unique(duplicates_df4$trscrpt_id))
#[1] 1307
#id<-unique(duplicates_df4$trscrpt_id)[1252]
for (id in  unique(duplicates_df4$trscrpt_id)) {
  dfsubs<-df5[which(df5$trscrpt_id==id),]
  sums<-c()
  
  #i<-unique(dfsubs$class)[1]
  for (i in unique(dfsubs$class)){
  sum(dfsubs$end_qry[which(dfsubs$class==i)]-dfsubs$start_qry[which(dfsubs$class==i)])->sum
  sums<-c(sums,sum)}
  unique(dfsubs$class)[which(sums<max(sums))]->shorter_classes
  if (length(shorter_classes)>0){ #this is in case the mlongest ones have the same length
  rownames(dfsubs[which(dfsubs$class %in% shorter_classes),])->rn
  df5<-df5[-which(rownames(df5) %in% rn),]
}
}

#df5 should not have several classes of duplicates anymore, except if they have the same length

#Remove all duplicates of the same class again
n_occur <- data.frame(table(df5$trscrpt_id))
n_occur[n_occur$Freq > 1,]
df5[df5$trscrpt_id %in% n_occur$Var1[n_occur$Freq > 1],]->duplicates_df5

df5->df6 #df6 will have no duplicates except classes of the same length
for (id in  unique(duplicates_df5$trscrpt_id)) {
  
  dfsubs<-df6[which(df6$trscrpt_id==id),]
  if (length(unique(dfsubs$class))==1){
    rownames(dfsubs)->rn
    rn[-1]->rn
    df6<-df6[-which(rownames(df6) %in% rn),]
  }
}


length(df$trscrpt_id)
length(df2$trscrpt_id)
length(df3$trscrpt_id)
length(df4$trscrpt_id)
length(df5$trscrpt_id)
length(df6$trscrpt_id)

length(unique(df$trscrpt_id))
length(unique(df2$trscrpt_id))
length(unique(df3$trscrpt_id))
length(unique(df4$trscrpt_id))
length(unique(df5$trscrpt_id))
length(unique(df6$trscrpt_id))

########
##NOW LET'S COUNT THOSE CLASSES! ###

###First remove the hybrid###
n_occur <- data.frame(table(df6$trscrpt_id))
n_occur[n_occur$Freq > 1,]
df6[df6$trscrpt_id %in% n_occur$Var1[n_occur$Freq > 1],]->duplicates_df6

#trscrpt_id start_qry end_qry after_match      name          class score
#27636 PB.8764.3|trpt/30887      2337    2351      (1991) DR0071712 LINE/Rex-Babar  best
#27639 PB.8764.3|trpt/30887      2699    2713      (1629) DR0165595       LTR/ERVL  best

rownames(duplicates_df6)->rn
df7<-df6[-which(rownames(df6) %in% rn),]

length(df7$trscrpt_id)
length(unique(df7$trscrpt_id))

gsub('\\/.*', '', df7$class)->df7$class_simple
unique(df7$class_simple)

table(df7$class_simple)

#And dont forget the hybrid one!!
