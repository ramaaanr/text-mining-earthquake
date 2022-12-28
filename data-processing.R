setwd("C:/Users/ASUS/Documents/Programming Project/R/sem5-text-mining/text-mining-earthquake/")
rm(list = ls())

library(tm)
library(xlsx)
library(katadasaR)
library(textclean)

# TODO : Membuat Corpus

main_data <- read.xlsx(
  "data/data_gempa.xlsx",
  sheetName = "data"
)

main_data.corpus <- cbind.data.frame(
  paste0("doc_", c(1:nrow(main_data))),
  main_data$text
)

colnames(main_data.corpus) <- c("doc_id", "text")

corpus <- VCorpus(DataframeSource(main_data.corpus))

corpus.processed <- corpus


# TODO : Menghapus Tag User '@'
removeUser = function(x) {
  return(gsub("@\\w+", "", x))
}
corpus.processed <- tm_map(
  corpus.processed,
  content_transformer(removeUser)
)

# TODO : Menghapus URL/Link
cleanURL <- function(x) {
  return(gsub("(f|ht)tp(s?)://\\S+", "", x, perl = T))
}
corpus.processed <- tm_map(
  corpus.processed,
  content_transformer(cleanURL)
)

# TODO : Menghapus Hashtag

cleanHashtag <- function(x) {
  return(gsub("#\\S+", "", x))
}
corpus.processed <- tm_map(
  corpus.processed,
  content_transformer(cleanHashtag)
)

# TODO : Menghapus Emoji

cleanEmoji <- function(x){
  return(gsub("[^\x01-\x7F]", "", x))
}

corpus.processed <- tm_map(
  corpus.processed,
  content_transformer(cleanEmoji)
)

# TODO : Mengubah teks ke huruf kecil
corpus.processed <- tm_map(
  corpus.processed,
  content_transformer(tolower)
)

# TODO Menghapus tanda baca
corpus.processed <- tm_map(
  corpus.processed,
  removePunctuation
)

# TODO Menghapus Angka
corpus.processed <- tm_map(
  corpus.processed,
  removeNumbers
)

# TODO : Mengubah Slang Word
spell.lex <- read.csv("data/lexicon/combined-lexicon.csv", row.names = NULL)

replaceSlangWords <- function(x) {
  return(replace_internet_slang(
    x,
    slang = paste0("\\b", spell.lex$slang, "\\b"),
    replacement = spell.lex$formal,
    ignore.case = TRUE
  ))
}

corpus.processed <- tm_map(
  corpus.processed,
  content_transformer(replaceSlangWords)
)

# TODO : Mengubah ke kata dasar
getKataDasar <- function(x) {
  str <-unlist(strsplit(stripWhitespace(x), " "))
  str <- sapply(str, katadasaR)
  str <- paste(str, collapse = " ")
  return(str)
}

corpus.processed <- tm_map(
  corpus.processed,
  content_transformer(getKataDasar)
)


# TODO : Menghapus Stopword
stopwords.id <- readLines("data/stopword/tala-masdevid.txt")
corpus.processed <- tm_map(
  corpus.processed,
  removeWords,
  stopwords.id
)


# TODO : Menghapus Spasi Berlebih
corpus.processed <- tm_map(
  corpus.processed,
  stripWhitespace
)

# TODO : Menghilangkan Spasi diawal
cleanLeadingWhiteSpace <- function(x) {
  return(
    trimws(x)
  )
}

corpus.processed <- tm_map(
  corpus.processed,
  content_transformer(cleanLeadingWhiteSpace)
)


# TODO : Simpan data
corpus.df <- data.frame(
  text = unlist(sapply(corpus.processed, "[", "content")),
  stringsAsFactors = FALSE
)

main_data.processed <- cbind.data.frame(
  corpus.df,
  main_data$class_label
)

View(main_data.processed)

colnames(main_data.processed) = c("text", "class_label")

write.csv(
  main_data.processed,
  "data-results/data_gempa_processed.csv",
  row.names = FALSE
)

