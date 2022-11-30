library(rtweet)
library(xlsx)
rm(list = ls())
tweets_data = search_tweets("gempa", locale = "id", n = 10000)
data_frame = data.frame(tweets_data)
#data_frame[is.na.data.frame(data_frame)]

