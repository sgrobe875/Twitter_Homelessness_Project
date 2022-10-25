# import packages
library(dplyr)
library(ggplot2)




# set working directory to the location of this file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


# Recommended but not required to clear environment
rm(list = ls(all.names = TRUE)) 



#### Start with sentiment and tweet volume data ####

# read in sentiment data
sent_state_year <- read.csv("data/sentiment_by_state_by_year.csv")

# read in normalized tweet counts
tweet_counts <- read.csv("data/normalized_tweet_counts_by_state_by_year.csv")
names(tweet_counts) <- c('state','2010','2011','2012','2013','2014','2015','2016','2017','2018')


# rework tweet counts to get in long format
tweet_counts_long <- data.frame(matrix(ncol = 3, nrow = 0))   # dataframe to hold long form data
colnames(tweet_counts_long) <- c("state", "norm_count", "year") 

for (row in seq(1,nrow(tweet_counts))) {
  st <- tweet_counts[row,'state']
  for (col in seq(2,length(names(tweet_counts)))) {
    yr <- names(tweet_counts)[col]
    long_row <- c(st, tweet_counts[row,col], yr)
    tweet_counts_long <- rbind(tweet_counts_long, long_row)
  }
}

colnames(tweet_counts_long) <- c("state", "norm_count", "year") 


# join sentiment and tweet counts data by year & state
counts_and_sent <- merge(sent_state_year, tweet_counts_long, by = c('state', 'year'))




#### Repeat with homelessness counts ####














