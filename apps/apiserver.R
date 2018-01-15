require(plumber)
searchapi <- plumb(file.choose())  # query-1.R -- tfidf, idf, ds_sequence
searchapi$run(port=8000)
