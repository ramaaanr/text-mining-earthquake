setwd("C:/Users/ASUS/Documents/Programming Project/R/sem5-text-mining/text-mining-earthquake/")
library(wordcloud)
library(tm)
library(RColorBrewer)

rm(list = ls())

# TODO 1: Mengambil data
main_data <- read.csv(
  "data-results/data_gempa_processed.csv",
  stringsAsFactors = FALSE
)

# TODO 2: menyimpan kedalam corpus
main_data.corpus <- cbind.data.frame(
  paste0("doc_", c(1:nrow(main_data))),
  main_data$text
)

colnames(main_data.corpus) <- c("doc_id", "text")

corpus <- VCorpus(DataframeSource(main_data.corpus))

# TODO 3: Menghitung kemunculan kata
tdm <- TermDocumentMatrix(
  corpus,
  control = list(weighting = weightTfIdf)
)

# TODO 4: Menyimpan TDM kedalam Matrikx
tdm.matrix <- as.matrix(tdm)

# TODO 5: Menghitung frekuensi kemunculan kata dalam seluruh dokumen
term.freq <- rowSums(tdm.matrix)

# TODO 6: Konversi ke dataframe dan mengurutkan data
freq.df <- data.frame(
  word = names(term.freq),
  frequency = term.freq
)
freq.df <- freq.df[order(freq.df[, 2], decreasing = T), ]

# TODO 7: Membuat wordcloud
wordcloud.viz <- wordcloud(
  freq.df$word,
  freq.df$frequency,
  max.words = 150,
  colors = brewer.pal(8, "Paired")
)

