library(tm)
rm(list = ls())


# TODO: Load Data
main_data <- read.csv(
  "data-results/data_gempa_processed.csv",
  stringsAsFactors = FALSE
)

main_data.corpus = cbind.data.frame(
  paste0("doc_",c(1:nrow(main_data))),
  main_data$text
)

colnames(main_data.corpus) = c("doc_id", "text")

corpus <- VCorpus(DataframeSource(main_data.corpus))

# TODO: Transformasi Data terstruktur
dtm <- DocumentTermMatrix(
  corpus,
  control = list(weighting = weightTfIdf)
)

main_data.unigram = cbind.data.frame(
  as.data.frame(as.matrix(dtm)),
  main_data$class_label
)
colnames(main_data.unigram)[ncol(main_data.unigram)] = "class_label"

# TODO: Simmpan Data
write.csv(main_data.unigram, "data-results/data-unigram.csv", row.names = FALSE)
