setwd("C:/Users/ASUS/Documents/Programming Project/R/sem5-text-mining/text-mining-earthquake/")
rm(list = ls())

library(class)
library(gmodels)

data = read.csv(
  "data-results/data-unigram.csv",
  stringsAsFactors = FALSE
)

row_labels <- data[, ncol(data)]

set.seed(123)

size <- floor(0.8 * nrow(data))

train_ind <- sample(
  seq_len(nrow(data)),
  size = size,
)

train_labels <- data[train_ind, ncol(data)]
test_labels <- row_labels[-train_ind]
data_train <- data[train_ind, 1:(ncol(data)-1)]
data_test <- data[-train_ind, 1:(ncol(data)-1)]

model <- knn(
  train = data_train,
  test = data_test,
  cl = train_labels,
  k = 3
)

ct = CrossTable(
  x = test_labels,
  y = model,
  prop.chisq = FALSE
)

print(ct)

# mode = table("Prections" = knn.prediction, Actual = test_labels)
