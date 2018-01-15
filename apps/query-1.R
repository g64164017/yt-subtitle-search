# ## import subtitle file
#
# # option-1: read sample file frm_df.csv repo (filesize: 7.5 MB)
# library(RCurl)
# x <- getURL("https://raw.githubusercontent.com/g64164017/yt-subtitle-search/master/apps/data.csv")
# df <- read.csv(text = x)
# 
# option-2: if you have your own file, choose it manuallly
x = file.choose()   # TFIDF
setwd(dirname(x))
tfidf_data = read.csv(x)
x = file.choose()   # IDF
IDF_t = read.csv(x)
x = file.choose()   # DS_SEQ
ds_seq = read.csv(x)

library(tm)

## QUERYING

#* @get /search
search_result = function(q = ""){
  # q1 = "machine machine learning"
  # q2 = "data mining"
  # q = "principal component analysis"
  
  # # Query Weighting
  newQry <- data.frame(doc_id="query", text = q)
  newQryC <- Corpus(DataframeSource(newQry))
  tdmNewQry <- TermDocumentMatrix(newQryC, control = list(
    removePunctuation = TRUE,
    stopwords = TRUE,
    tolower = TRUE,
    stemming = FALSE,
    stripWhitespace = TRUE
    # ,  weighting = weightTf
    # ,dictionary=dictC
  ))
  tdmNewQry = as.matrix(tdmNewQry)
  
  tq_idf = tdmNewQry * IDF_t$V1[IDF_t$X %in% rownames(tdmNewQry)]
  
  len_d = sqrt(col_sums(tfidf_data[,-1]^2))
  len_q = sqrt(col_sums(tq_idf^2))
  t = data.frame(tfidf_data[tfidf_data$X %in% rownames(tdmNewQry),-1])
  prod_dq = col_sums(t * as.matrix(tdmNewQry))
  names(prod_dq) = names(t)
  res = prod_dq/(len_d*len_q)
  rank = sort(res[res!=0.0],decreasing = TRUE)
  n = length(rank)
  
  return(ds_seq[gsub("X","",names(rank[1:n])),c("docid","video_id","time_start","url")])
}

search_result(q = "information retrieval")
