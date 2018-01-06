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
tdm <- TermDocumentMatrix(k, control = list(
  removePunctuation = TRUE,
  stopwords = TRUE,
  tolower = TRUE,
  stemming = FALSE,
  stripWhitespace = TRUE))


## TF
tf <- sort(rowSums(as.matrix(tdm)), decreasing=TRUE)
wf <- data.frame(word=names(tf), freq=tf)
plot(wf$freq, main="Grafik Kata", xlab="Kata", ylab="Frek",type="l", col="blue")


## DF - IDF
DF_t <- sort(rowSums(as.matrix(tdm)!=0), decreasing=TRUE)

# lihat 10 term teratas dan terbawah
head(DF_t,10)
tail(DF_t,10)

# hitung IDF_t
N <- length(colSums(as.matrix(tdm)))	# ukuran korpus
IDF_t <- log(N/DF_t)			        # nilai IDFt

# lihat 10 term teratas dan terbawah
head(IDF_t,10)
tail(IDF_t,10)

# buat grafik TF-IDF
tfidf_data <- data.frame(word=names(tf*IDF_t), freq=tf*IDF_t)
tfidf_data= tfidf_data[with(tfidf_data, order(-freq)), ]
plot(tfidf_data$freq, main="Grafik Kata", xlab="Kata", ylab="TF-IDF",type="l", col="blue")

## SAVING
write.csv("tf.csv", x=tf) 
write.csv("tfidf.csv", x=tfidf_data) 
