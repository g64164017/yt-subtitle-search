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

tw <- data.frame(doc_id=df$video_id, text=df$cleanText)
k <- Corpus(DataframeSource(tw))

## TF-IDF
tdm_tfidf <- TermDocumentMatrix(k, control = list(
  removePunctuation = TRUE,
  stopwords = TRUE,
  tolower = TRUE,
  stemming = FALSE,
  stripWhitespace = TRUE,
  weighting = weightTfIdf
  # weighting = function(x)
  #   weightTfIdf(x, normalize =
  #                 FALSE)
))
inspect(tdm_tfidf[1:10,1:5])
write.csv("tfidf.csv", x=as.matrix(tdm_tfidf)) 
tdm_dict <- Terms(tdm_tfidf)

## QUERYING

q1 = "machine machine learning"
q2 = "data mining"

# # Query Weighting
# q1_tf = strsplit(q1," ")
# q2_tf = strsplit(q2," ")

# The query below is created from words in fortune(1) and fortune(2)
newQry <- data.frame(doc_id="query", text = q1)
newQryC <- Corpus(DataframeSource(newQry))
tdmNewQry <- TermDocumentMatrix(newQryC, control = list(
  removePunctuation = TRUE,
  stopwords = TRUE,
  tolower = TRUE,
  stemming = FALSE,
  stripWhitespace = TRUE,
  weighting = weightTf
  # ,dictionary=dictC
))
dictQry <- Terms(tdmNewQry)

cor_limit = 0.6
findAssocs(tdm_tfidf,dictQry,corlimit = cor_limit)

tfidf.matrix = as.matrix(tdm_tfidf)
N = length(Docs(tdm_tfidf))

query.matrix = as.matrix(tdmNewQry)
query.matrix = scale(query.matrix, 
                     center = FALSE,
                     scale = sqrt(colSums(query.matrix^2)))

doc.scores <- query.matrix %*% tfidf.matrix
