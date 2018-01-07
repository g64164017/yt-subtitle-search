# ## import subtitle file
#
# # option-1: read sample file data.csv from our repo (filesize: 7.5 MB)
# library(RCurl)
# x <- getURL("https://raw.githubusercontent.com/g64164017/yt-subtitle-search/master/apps/data.csv")
# df <- read.csv(text = x)
# 
# option-2: if you have your own file, choose it manuallly
x = file.choose()
setwd(dirname(x))
df = read.csv(x)

## TEXT MINING
require(tm)
# i=1
# remove subtitle time
# df$cleanText <- gsub("[0-9]+:[0-9]+:[0-9]+.[0-9]+","'" , df$subtitle ,ignore.case = TRUE) 
# df$cleanText[1]

## SEGMENTING 
docid=c(); v = c(); t0=c(); t1=c(); t=c(); x=1
for(i in 1:length(df$video_id)){
  vid = as.character(df$video_id[i])
  subt = as.character(df$subtitle[i])
  subts = strsplit(subt,"\n\n")
  
  frms=c()
  for (j in subts[[1]]){
    docid = c(docid,paste("doc",x,sep = ""))
    v = c(v,vid)
    frm = strsplit(as.character(j),split = "\n")
    tm = strsplit(frm[[1]][1],",")
    t0 = c(t0,tm[[1]][1]); t1 = c(t1,tm[[1]][2]) 
    t = c(t,frm[[1]][2])
    x=x+1
  }
}

frm_df = data.frame(
  docid = docid,
  video_id = v,
  time_start = t0,
  time_end = t1,
  text = t
  )
write.csv("frm_df.csv", x=as.matrix(frm_df)) 