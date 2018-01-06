## SET WORKING DIRECTORY
# working dir = current file path
setwd(normalizePath("."))
df = read.csv("data.csv")

## TEXT MINING
library(tm)
i=1
# remove subtitle time
df$cleanText <- gsub("[0-9]+:[0-9]+:[0-9]+.[0-9]+","'" , df$subtitle ,ignore.case = TRUE) 
df$cleanText[1]
tw <- data.frame(doc_id=df$video_id, text=df$cleanText)
k <- Corpus(DataframeSource(tw))

## TF-IDF
tdm_tfidf <- TermDocumentMatrix(k, control = list(
  removePunctuation = TRUE,
  stopwords = TRUE,
  tolower = TRUE,
  stemming = FALSE,
  stripWhitespace = TRUE,
  weighting = function(x)
    weightTfIdf(x, normalize =
                  FALSE)
))

inspect(tdm_tfidf[1:10,1:5])

write.csv("tfidf.csv", x=as.matrix(tdm_tfidf)) 