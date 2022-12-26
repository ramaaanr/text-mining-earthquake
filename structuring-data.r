library(tm)
rm(list = ls())

#bagian tdm
main_data = read.csv("data-results/data_gempa_processed_with_slang_removal.csv", stringsAsFactors = FALSE)
main_data.corpus = cbind.data.frame(paste0("doc_",c(1:nrow(main_data))), main_data$text)
colnames(main_data.corpus) = c("doc_id", "text")
corpu = VCorpus(DataframeSource(main_data.corpus))
#proses mecahkan jadi per kata
dtm = DocumentTermMatrix(corpu)
main_data.unigram = cbind.data.frame(as.data.frame(as.matrix(dtm)), main_data$class_label)
colnames(main_data.unigram)[ncol(main_data.unigram)] = "class_label"
write.csv(main_data.unigram, "data-results/data-unigram.csv", row.names = FALSE)
