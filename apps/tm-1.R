require(tm)
require(chron)

# ## import subtitle file
#
# # option-1: read sample file frm_df.csv from our repo (filesize: 7.5 MB)
# library(RCurl)
# x <- getURL("https://raw.githubusercontent.com/g64164017/yt-subtitle-search/master/apps/data.csv")
# df <- read.csv(text = x)
# 
# option-2: if you have your own file, choose it manuallly
x = file.choose()   # frm_df.csv
setwd(dirname(x))
frm_df = read.csv(x)
x = file.choose()   # data.csv
dt = read.csv(x)

## SEQUENCING
# convert to time
t = chron(times. = frm_df$time_start)
# calc time difference
t_diff = diff(t)
frm_df$time_diff = c(t_diff,chron(times. = "0:0:0"))
frm_df[frm_df$time_diff< chron(times. = "0:0:0"),]$time_diff = chron(times. = "0:0:0")

# show time_diff > 10 s
frm_diff = frm_df[frm_df$time_diff>= chron(times. = "0:0:6"),]
frm_diff = rbind(frm_diff , frm_df[frm_df$time_diff== chron(times. = "0:0:0"),])
frm_diff = frm_diff[ order(frm_diff$X),]
i=1;t=c()
for (s in frm_diff$X){
  t = c(t,paste(frm_df[i:s,]$text, collapse = " "))
  frm_diff$time_start[frm_diff$X==s] = frm_df$time_start[i]
  i=s+1
}
frm_diff$context = t
ds = frm_diff[,c("docid","video_id","time_start","time_end","context")]
t = chron(times=ds$time_start)
ds$url = paste0("https://youtu.be/",ds$video_id
                ,"?t=",hours(chron(times=ds$time_start)),'h'
                ,minutes(chron(times=ds$time_start)),'m',seconds(chron(times=ds$time_start)),'s')
write.csv("ds_sequence.csv", x=as.matrix(ds))


# INDEXING
getTransformations
tw <- data.frame(doc_id=ds$docid, text=ds$context)
k <- Corpus(DataframeSource(tw))
k <- tm_map(k, removePunctuation)

## TF-IDF
tdm_tf <- TermDocumentMatrix(k, control = list(
  removePunctuation = TRUE,
  stopwords = TRUE,
  tolower = TRUE,
  stemming = FALSE,
  stripWhitespace = TRUE
  # weighting = weightTfIdf
  # weighting = function(x)
  #   weightTfIdf(x, normalize =
  #                 FALSE)
))
# inspect(tdm_tf[1:10,1:5])
# tf <- sort(rowSums(as.matrix(tdm_tf)), decreasing=TRUE)
tf <- rowSums(as.matrix(tdm_tf))
wf <- data.frame(word=names(tf), freq=tf)
# findFreqTerms(tdm_tf, lowfreq=100)
DF_t <- rowSums(as.matrix(tdm_tf)!=0)
# DF_t <- sort(rowSums(as.matrix(tdm_tf)!=0), decreasing=TRUE)
N <- length(colSums(as.matrix(tdm_tf)))	# ukuran korpus
IDF_t <- log(N/DF_t)			        # nilai IDFt

tfidf_data = tdm_tf * IDF_t
# tfidf_data <- data.frame(word=names(tf*IDF_t), freq=tf*IDF_t)
write.csv("tfidf.csv", x=as.matrix(tfidf_data)) 
write.csv("idf.csv", x=as.matrix(IDF_t)) 

