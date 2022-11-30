setwd("C:/Users/ASUS/Documents/Programming Project/R/sem5-text-mining/text-mining-earthquake/")
rm(list = ls())

colloquial_ind_lexicon <- read.csv(
  "data/lexicon/colloquial-indonesian-lexicon.csv",
  stringsAsFactors = FALSE,
)

slangword_lexicon <- read.csv(
  "data/lexicon/slangword.csv",
  stringsAsFactors = FALSE,
)

combined_lexicon <- rbind.data.frame(
  colloquial_ind_lexicon[, 1:2],
  slangword_lexicon[, 1:2]
)

write.csv(
  combined_lexicon,
  "data/lexicon/combined-lexicon.csv",
  row.names = FALSE
)
