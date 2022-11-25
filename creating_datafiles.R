# import packages
library(dplyr)





# set working directory to the location of this file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Recommended but not required to clear environment
rm(list = ls(all.names = TRUE)) 

# read in the data
source('rescale_sentiment.R')
d <- read.csv('data/homelessness_rate_data.csv')






### Rework homelessness data into long format and write to file ###

# read in normalized tweet counts
tweet_counts <- read.csv("data/percapita_tweets.csv")
names(tweet_counts) <- c('state','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019')


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
names(total_homeless) <- c('state','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019')

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

# everything <- merge(total_sent_counts, unshelt_long, by = c('state', 'year'))



# write this final master dataframe to a file to save it
write.csv(total_sent_counts, 'data/homelessness_rate_data.csv')








#### Synthesize homelessness and sentiment data ####

# join state_year_sent and d on composite key of state, year
joined <- merge(state_year_sent, total_sent_counts, by = c('state', 'year'))  

# clean up bc R hates joins
joined <- joined %>% select(state, year, tweets_norm, total_homeless_norm,
                            raw_sent.x, sentiment.x)
names(joined) <- c('state','year','tweets_norm','total_homeless_norm',
                   'raw_sent', 'sentiment')

# write to csv
write.csv(joined, "data/state_year_all_data.csv")










#### Obtaining tweet counts and percents ####

# read in cleaned tweet data
tweets <- read.csv('data/geotagged_cleaned.csv')

# record the number of tweets in each unique state/year pair
counts <- tweets %>% group_by(state, year) %>% count

# join to the all_data dataframe 
dat <- merge(counts_and_sent, counts, by = c('state','year'))

# rename the column
names(dat)[6] <- 'tweet_count'



# get the total number of tweets in a year
total_tweets <- tweets %>% group_by(year) %>% count

# join to dat
dat <- merge(dat, total_tweets, by = 'year')

# rename column
names(dat)[7] <- 'total_tweets'

# create column for percentages
dat <- dat %>% mutate(tweet_percent = tweet_count/total_tweets)

# double check our work
for (yr in unlist(c(dat %>% distinct(year)))) {
  curr <- dat %>% filter(year == yr)
  print(yr)
  print(sum(curr$tweet_percent))
}
# pretty close! presumably the only differences are to tweets posted at unknown locations
# these differences are small anyway, so they don't really matter

# clean up the dataframe
dat <- dat %>% select(-total_tweets)

# add total_homeless_norm column
dat <- merge(dat, homelessness_tweetcounts, by = c('state', 'year'))
dat <- dat %>% select(state,year,sentiment.x, raw_sent.x, tweets_norm.x, tweet_count, 
                      tweet_percent, total_homeless_norm)

# clean up
names(dat) <- c('state','year','sentiment','raw_sent','tweets_norm',
                'tweet_count','tweet_percent','total_homeless_norm')


# rewrite to file
write.csv(dat, "data/state_year_all_data.csv")







### Changes in sentiment

# for each state/year pair
years <- seq(2011,2019)
states <- unlist(all_data %>% distinct(state))
yr_col <- c()
st_col <- c()
sent_change <- c()
for (st in states) {
  for (yr in years) {
    prev <- all_data$sentiment[all_data$state == st & all_data$year == yr - 1]
    curr <- all_data$sentiment[all_data$state == st & all_data$year == yr]
    
    yr_col <- append(yr_col, yr)
    st_col <- append(st_col, st)
    sent_change <- append(sent_change, curr - prev)
  }
}

sentiment_changes <- data.frame(st_col, yr_col, sent_change)
names(sentiment_changes) <- c('state','year','sent_change')

write.csv(sentiment_changes, 'data/state_year_sentchanges.csv')



# for each year
years <- seq(2011,2019)
yr_col <- c()
sent_change <- c()
for (yr in years) {
  prev <- year_sent$sentiment[year_sent$year == yr - 1]
  curr <- year_sent$sentiment[year_sent$year == yr]
  
  yr_col <- append(yr_col, yr)
  sent_change <- append(sent_change, curr - prev)
}

sentiment_changes <- data.frame(yr_col, sent_change)
names(sentiment_changes) <- c('year','sent_change')

write.csv(sentiment_changes, 'data/year_sentchanges.csv')




# for each month
month_sent$month <- as.Date(paste(month_sent$month, '-01', sep=''))
month_sent <- month_sent %>% arrange(month, desc = TRUE)
m_col <- c()
sent_change <- c()
for (i in seq(2,nrow(month_sent))) {
  prev <- month_sent[i-1, 'sentiment']
  curr <- month_sent[i, 'sentiment']
  
  m_col <- append(m_col, month_sent[i, 'month'])
  sent_change <- append(sent_change, curr - prev)
}


sentiment_changes <- data.frame(m_col, sent_change)
names(sentiment_changes) <- c('month','sent_change')

write.csv(sentiment_changes, 'data/monthly_sentchanges.csv')














