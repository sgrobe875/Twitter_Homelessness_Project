# import packages
library(dplyr)
library(ggplot2)




# set working directory to the location of this file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


# Recommended but not required to clear environment
rm(list = ls(all.names = TRUE)) 



#### Start with sentiment and tweet volume data ####

# use this R file to automatically read in the data and rescale the sentiment values
source('rescale_sentiment.R')

# read in normalized tweet counts
tweet_counts <- read.csv("data/normalized_tweet_counts_by_state_by_year.csv")
names(tweet_counts) <- c('state','2010','2011','2012','2013','2014','2015','2016','2017','2018')


# rework tweet counts to get in long format
tweet_counts_long <- data.frame(matrix(ncol = 3, nrow = 0))   # dataframe to hold long form data

for (row in seq(1,nrow(tweet_counts))) {
  st <- tweet_counts[row,'state']
  for (col in seq(2,length(names(tweet_counts)))) {
    yr <- names(tweet_counts)[col]
    long_row <- c(st, tweet_counts[row,col], yr)
    tweet_counts_long <- rbind(tweet_counts_long, long_row)
  }
}

colnames(tweet_counts_long) <- c("state", "tweets_norm", "year") 


# join sentiment and tweet counts data by year & state
counts_and_sent <- merge(state_year_sent, tweet_counts_long, by = c('state', 'year'))




#### Repeat with homelessness counts ####

# make one df for total homelessness and one for unsheltered homelessness
total_homeless <- read.csv('data/normalized_total.csv')
names(total_homeless) <- c('state','2010','2011','2012','2013','2014','2015','2016','2017')

unsheltered_homeless <- read.csv('data/normalized_unsheltered.csv')
names(unsheltered_homeless) <- c('state','2010','2011','2012','2013','2014','2015','2016','2017')





# rework tweet counts to get in long format
total_long <- data.frame(matrix(ncol = 3, nrow = 0))   # dataframe to hold long form data

for (row in seq(1,nrow(total_homeless))) {
  st <- total_homeless[row,'state']
  for (col in seq(2,length(names(total_homeless)))) {
    yr <- names(total_homeless)[col]
    long_row <- c(st, total_homeless[row,col], yr)
    total_long <- rbind(total_long, long_row)
  }
}

colnames(total_long) <- c("state", "total_homeless_norm", "year") 






# rework tweet counts to get in long format
unshelt_long <- data.frame(matrix(ncol = 3, nrow = 0))   # dataframe to hold long form data

for (row in seq(1,nrow(unsheltered_homeless))) {
  st <- unsheltered_homeless[row,'state']
  for (col in seq(2,length(names(unsheltered_homeless)))) {
    yr <- names(unsheltered_homeless)[col]
    long_row <- c(st, unsheltered_homeless[row,col], yr)
    unshelt_long <- rbind(unshelt_long, long_row)
  }
}

colnames(unshelt_long) <- c("state", "unshelt_homeless_norm", "year") 






# join each of these to the prior one
total_sent_counts <- merge(counts_and_sent, total_long, by = c('state', 'year'))

everything <- merge(total_sent_counts, unshelt_long, by = c('state', 'year'))



# write this final master dataframe to a file to save it
write.csv(everything, 'data/homelessness_rate_data.csv')














