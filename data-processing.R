library(tm)
library(xlsx)
library(katadasaR)
library(textclean)

rm(list = ls())

checkData <- function() {
  print(corpus.processed[["doc_3"]][["content"]])
}


# TODO 1: Membuat File Corpus

main_data <- read.xlsx(
  "data/data_gempa_300.xlsx",
  sheetName = "sheet"
)

main_data.corpus <- cbind.data.frame(
  paste0("doc_", c(1:nrow(main_data))),
  main_data$text
)

colnames(main_data.corpus) <- c("doc_id", "text")

corpus <- VCorpus(DataframeSource(main_data.corpus))

corpus.processed <- corpus

checkData()

# TODO : Menghapus Tag User
removeUser <- function(x) {
  return(gsub("@\\w+", "", x))
}
corpus.processed <- tm_map(
  corpus.processed,
  content_transformer(removeUser)
)

# TODO : Menghapus URL
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

replaceEmoji <- function(x) {
  return(
    replace_emoji(x)
  )
}

corpus.processed <- tm_map(
  corpus.processed,
  content_transformer(replaceEmoji)
)

# TODO : Mengubah Huruf Kecil
corpus.processed <- tm_map(
  corpus.processed,
  content_transformer(tolower)
)

# TODO menghapus tanca baca
corpus.processed <- tm_map(
  corpus.processed,
  removePunctuation
)

# TODO menghapus angka
corpus.processed <- tm_map(
  corpus.processed,
  removeNumbers
)

# TODO : menghapus stopword
stopwords.id <- readLines("data/stopword/tala-masdevid.txt")
corpus.processed <- tm_map(corpus.processed, removeWords, stopwords.id)

# TODO : mengubah ke kata dasar
getKataDasar <- function(x) {
  str <- unlist(strsplit(stripWhitespace(x), " "))
  str <- sapply(str, katadasaR)
  str <- paste(str, collapse = " ")
  return(str)
}

corpus.processed <- tm_map(
  corpus.processed,
  content_transformer(getKataDasar)
)

# TODO : Replace Slang Words
spell.lex <- read.csv("data/lexicon/combined-lexicon.csv")

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


# TODO : menghapus spasi berlebih
corpus.processed <- tm_map(
  corpus.processed,
  stripWhitespace
)

checkData()

# TODO : Menyiman data ke file csv
corpus.df <- data.frame(
  text = unlist(sapply(corpus.processed, "[", "content")),
  stringsAsFactors = FALSE
)

main_data.processed <- cbind.data.frame(
  corpus.df,
  main_data$class_label
)

colnames(main_data.processed) <- c("text", "class_label")

write.csv(
  main_data.processed,
  "data-results/data_gempa_processed_with_slang_removal.csv",
  row.names = FALSE
)
