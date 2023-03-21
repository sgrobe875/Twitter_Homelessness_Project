# import packages
library(dplyr)





# set working directory to the location of this file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Recommended but not required to clear environment
rm(list = ls(all.names = TRUE)) 





### read in data files and reformat where necessary


## normalized total homelessness data
homelessness <- read.csv('data/percapita_total.csv')
names(homelessness) <- c('state','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019','2022')

homelessness_long <- data.frame(matrix(ncol = 3, nrow = 0))   # dataframe to hold long form data

for (row in seq(1,nrow(homelessness))) {
  st <- homelessness[row,'state']
  for (col in seq(2,length(names(homelessness)))) {
    yr <- names(homelessness)[col]
    long_row <- c(st, homelessness[row,col], yr)
    homelessness_long <- rbind(homelessness_long, long_row)
  }
}

colnames(homelessness_long) <- c("state", "total_homeless_norm", "year") 
rm(homelessness)
homelessness_long$year <- as.integer(homelessness_long$year)
homelessness_long$total_homeless_norm <- as.numeric(homelessness_long$total_homeless_norm)




## normalized tweet counts
tweet_counts <- read.csv("data/percapita_tweets.csv")
names(tweet_counts) <- c('state','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019','2022')


# rework tweet counts to get in long format
tweet_counts_long <- data.frame(matrix(ncol = 3, nrow = 0))   # data frame to hold long form data

for (row in seq(1,nrow(tweet_counts))) {
  st <- tweet_counts[row,'state']
  for (col in seq(2,length(names(tweet_counts)))) {
    yr <- names(tweet_counts)[col]
    long_row <- c(st, tweet_counts[row,col], yr)
    tweet_counts_long <- rbind(tweet_counts_long, long_row)
  }
}

colnames(tweet_counts_long) <- c("state", "tweets_norm", "year") 
rm(tweet_counts)
tweet_counts_long$year <- as.integer(tweet_counts_long$year)
tweet_counts_long$tweets_norm <- as.numeric(tweet_counts_long$tweets_norm)



## sentiment data

# all 
# day_sent_all <- read.csv('data/sentiment/day_sentiment.csv')
month_sent_all <- read.csv('data/sentiment/month_sentiment.csv')
year_sent_all <- read.csv('data/sentiment/year_sentiment.csv')
state_year_sent_all <- read.csv('data/sentiment/state_year_sentiment.csv')

# unique tweets only
# day_sent_unique <- read.csv('data/sentiment/day_sentiment_unique.csv')
month_sent_unique <- read.csv('data/sentiment/month_sentiment_unique.csv')
year_sent_unique <- read.csv('data/sentiment/year_sentiment_unique.csv')
state_year_sent_unique <- read.csv('data/sentiment/state_year_sentiment_unique.csv')

# qrts
# day_sent_qrt <- read.csv('data/sentiment/day_sentiment_qrt.csv')
month_sent_qrt <- read.csv('data/sentiment/month_sentiment_qrt.csv')
year_sent_qrt <- read.csv('data/sentiment/year_sentiment_qrt.csv')
state_year_sent_qrt <- read.csv('data/sentiment/state_year_sentiment_qrt.csv')

# replies
# day_sent_replies <- read.csv('data/sentiment/day_sentiment_replies.csv')
month_sent_replies <- read.csv('data/sentiment/month_sentiment_replies.csv')
year_sent_replies <- read.csv('data/sentiment/year_sentiment_replies.csv')
state_year_sent_replies <- read.csv('data/sentiment/state_year_sentiment_replies.csv')



### rescale all of the sentiment columns

# day_sent_all$sentiment <- day_sent_all$sentiment - 5
# day_sent_all$sentiment <- day_sent_all$sentiment / 4

month_sent_all$sentiment <- month_sent_all$sentiment - 5
month_sent_all$sentiment <- month_sent_all$sentiment / 4
month_sent_all$sentiment <- as.numeric(month_sent_all$sentiment)
month_sent_all$sentiment[month_sent_all$sentiment < -1] <- NA

year_sent_all$sentiment <- year_sent_all$sentiment - 5
year_sent_all$sentiment <- year_sent_all$sentiment / 4
year_sent_all$sentiment <- as.numeric(year_sent_all$sentiment)
year_sent_all$sentiment[year_sent_all$sentiment < -1] <- NA

state_year_sent_all$sentiment <- state_year_sent_all$sentiment - 5
state_year_sent_all$sentiment <- state_year_sent_all$sentiment / 4
state_year_sent_all$sentiment <- as.numeric(state_year_sent_all$sentiment)
state_year_sent_all$sentiment[state_year_sent_all$sentiment < -1] <- NA
#
# day_sent_unique$sentiment <- day_sent_unique$sentiment - 5
# day_sent_unique$sentiment <- day_sent_unique$sentiment / 4

month_sent_unique$sentiment <- month_sent_unique$sentiment - 5
month_sent_unique$sentiment <- month_sent_unique$sentiment / 4
month_sent_unique$sentiment <- as.numeric(month_sent_unique$sentiment)
month_sent_unique$sentiment[month_sent_unique$sentiment < -1] <- NA

year_sent_unique$sentiment <- year_sent_unique$sentiment - 5
year_sent_unique$sentiment <- year_sent_unique$sentiment / 4
year_sent_unique$sentiment <- as.numeric(year_sent_unique$sentiment)
year_sent_unique$sentiment[year_sent_unique$sentiment < -1] <- NA

state_year_sent_unique$sentiment <- state_year_sent_unique$sentiment - 5
state_year_sent_unique$sentiment <- state_year_sent_unique$sentiment / 4
state_year_sent_unique$sentiment <- as.numeric(state_year_sent_unique$sentiment)
state_year_sent_unique$sentiment[state_year_sent_unique$sentiment < -1] <- NA
#
# day_sent_qrt$sentiment <- day_sent_qrt$sentiment - 5
# day_sent_qrt$sentiment <- day_sent_qrt$sentiment / 4

month_sent_qrt$sentiment <- month_sent_qrt$sentiment - 5
month_sent_qrt$sentiment <- month_sent_qrt$sentiment / 4
month_sent_qrt$sentiment <- as.numeric(month_sent_qrt$sentiment)
month_sent_qrt$sentiment[month_sent_qrt$sentiment < -1] <- NA

year_sent_qrt$sentiment <- year_sent_qrt$sentiment - 5
year_sent_qrt$sentiment <- year_sent_qrt$sentiment / 4
year_sent_qrt$sentiment <- as.numeric(year_sent_qrt$sentiment)
year_sent_qrt$sentiment[year_sent_qrt$sentiment < -1] <- NA

state_year_sent_qrt$sentiment <- state_year_sent_qrt$sentiment - 5
state_year_sent_qrt$sentiment <- state_year_sent_qrt$sentiment / 4
state_year_sent_qrt$sentiment <- as.numeric(state_year_sent_qrt$sentiment)
state_year_sent_qrt$sentiment[state_year_sent_qrt$sentiment < -1] <- NA
#
# day_sent_replies$sentiment <- day_sent_replies$sentiment - 5
# day_sent_replies$sentiment <- day_sent_replies$sentiment / 4

month_sent_replies$sentiment <- month_sent_replies$sentiment - 5
month_sent_replies$sentiment <- month_sent_replies$sentiment / 4
month_sent_replies$sentiment <- as.numeric(month_sent_replies$sentiment)
month_sent_replies$sentiment[month_sent_replies$sentiment < -1] <- NA

year_sent_replies$sentiment <- year_sent_replies$sentiment - 5
year_sent_replies$sentiment <- year_sent_replies$sentiment / 4
year_sent_replies$sentiment <- as.numeric(year_sent_replies$sentiment)
year_sent_replies$sentiment[year_sent_replies$sentiment < -1] <- NA

state_year_sent_replies$sentiment <- state_year_sent_replies$sentiment - 5
state_year_sent_replies$sentiment <- state_year_sent_replies$sentiment / 4
state_year_sent_replies$sentiment <- as.numeric(state_year_sent_replies$sentiment)
state_year_sent_replies$sentiment[state_year_sent_replies$sentiment < -1] <- NA



### Changes in values from previous year

## Homelessness changes
homeless_changes <- read.csv("data/percapita_annual_changes_total.csv")
og_names <- c('state','2011','2012','2013','2014','2015','2016','2017','2018','2019')
names(homeless_changes) <- og_names

# empty dataframe to hold the long form data
df_long <- data.frame(matrix(ncol = 3, nrow = 0))

# values in the first column will go in the first column in the long form dataframe
for (row in seq(1,nrow(homeless_changes))) {
  r <- homeless_changes[row,1]
  
  # loop through subsequent columns to get values for the second column of long form dataframe
  for (col in seq(2,length(names(homeless_changes)))) {
    c <- names(homeless_changes)[col]
    long_row <- c(r, c, homeless_changes[row,col])
    df_long <- rbind(df_long, long_row)
  }
}

names(df_long) <- c('state','year','total_homeless_change')

homeless_changes <- df_long
rm(df_long)


homeless_changes$total_homeless_change <- as.numeric(homeless_changes$total_homeless_change)
homeless_changes$year <- as.integer(homeless_changes$year)


# append NA for 2010 and 2022
states <- unlist(homeless_changes %>% distinct(state))
for (st in states) {
  row <- c(st, 2010, NA)
  homeless_changes <- rbind(homeless_changes, row)
  
  row <- c(st, 2022, NA)
  homeless_changes <- rbind(homeless_changes, row)
}



## sentiment changes - all
years <- seq(2010,2022)
# years <- append(years, 2022)
states <- unlist(homelessness_long %>% distinct(state))

yr_col <- c()
st_col <- c()
sent_change <- c()

for (st in states) {
  for (yr in years) {
    if (yr == 2010) {
      yr_col <- append(yr_col, yr)
      st_col <- append(st_col, st)
      sent_change <- append(sent_change, NA)
    } else {
      prev <- state_year_sent_all$sentiment[state_year_sent_all$state == st & state_year_sent_all$year == yr - 1]
      curr <- state_year_sent_all$sentiment[state_year_sent_all$state == st & state_year_sent_all$year == yr]
      if (is.na(prev) | is.na(curr)) {
        yr_col <- append(yr_col, yr)
        st_col <- append(st_col, st)
        sent_change <- append(sent_change, NA)
      } else {
        yr_col <- append(yr_col, yr)
        st_col <- append(st_col, st)
        sent_change <- append(sent_change, curr - prev)
      }
    }
  }
}

sentiment_changes_all <- data.frame(st_col, yr_col, sent_change)
names(sentiment_changes_all) <- c('state','year','all_sent_change')


## sentiment changes - unique
yr_col <- c()
st_col <- c()
sent_change <- c()

for (st in states) {
  for (yr in years) {
    if (yr == 2010) {
      yr_col <- append(yr_col, yr)
      st_col <- append(st_col, st)
      sent_change <- append(sent_change, NA)
    } else {
      prev <- state_year_sent_unique$sentiment[state_year_sent_unique$state == st & state_year_sent_unique$year == yr - 1]
      curr <- state_year_sent_unique$sentiment[state_year_sent_unique$state == st & state_year_sent_unique$year == yr]
      
      yr_col <- append(yr_col, yr)
      st_col <- append(st_col, st)
      sent_change <- append(sent_change, curr - prev)
    }
  }
}

sentiment_changes_unique <- data.frame(st_col, yr_col, sent_change)
names(sentiment_changes_unique) <- c('state','year','unique_sent_change')



## sentiment changes - qrts
yr_col <- c()
st_col <- c()
sent_change <- c()

for (st in states) {
  for (yr in years) {
    if (yr == 2010) {
      yr_col <- append(yr_col, yr)
      st_col <- append(st_col, st)
      sent_change <- append(sent_change, NA)
    } else {
      prev <- state_year_sent_qrt$sentiment[state_year_sent_qrt$state == st & state_year_sent_qrt$year == yr - 1]
      curr <- state_year_sent_qrt$sentiment[state_year_sent_qrt$state == st & state_year_sent_qrt$year == yr]
      
      # if state is not included in the dataset
      if (length(prev) == 0 | length(curr) == 0) {
        sent_change <- append(sent_change, NA)
      } else {
        sent_change <- append(sent_change, curr - prev)
      }
    
      yr_col <- append(yr_col, yr)
      st_col <- append(st_col, st)
    }
  }
}

sentiment_changes_qrt <- data.frame(st_col, yr_col, sent_change)
names(sentiment_changes_qrt) <- c('state','year','qrt_sent_change')



## sentiment changes - rts
yr_col <- c()
st_col <- c()
sent_change <- c()

for (st in states) {
  for (yr in years) {
    if (yr == 2010) {
      yr_col <- append(yr_col, yr)
      st_col <- append(st_col, st)
      sent_change <- append(sent_change, NA)
    } else {
      prev <- state_year_sent_replies$sentiment[state_year_sent_replies$state == st & state_year_sent_replies$year == yr - 1]
      curr <- state_year_sent_replies$sentiment[state_year_sent_replies$state == st & state_year_sent_replies$year == yr]
      
      if (length(prev) == 0 | length(curr) == 0) {
        sent_change <- append(sent_change, NA)
      } else {
        sent_change <- append(sent_change, curr - prev)
      }
      
      yr_col <- append(yr_col, yr)
      st_col <- append(st_col, st)
    }
  }
}

sentiment_changes_replies <- data.frame(st_col, yr_col, sent_change)
names(sentiment_changes_replies) <- c('state','year','replies_sent_change')


## tweet count changes
yr_col <- c()
st_col <- c()
twt_change <- c()

for (st in states) {
  for (yr in years) {
    if (yr == 2010) {
      yr_col <- append(yr_col, yr)
      st_col <- append(st_col, st)
      twt_change <- append(twt_change, NA)
    } else {
      prev <- tweet_counts_long$tweets_norm[tweet_counts_long$state == st & tweet_counts_long$year == yr - 1]
      curr <- tweet_counts_long$tweets_norm[tweet_counts_long$state == st & tweet_counts_long$year == yr]
      
      yr_col <- append(yr_col, yr)
      st_col <- append(st_col, st)
      twt_change <- append(twt_change, curr - prev)
    }
  }
}

tweet_count_changes <- data.frame(st_col, yr_col, twt_change)
names(tweet_count_changes) <- c('state','year','tweet_count_change')


## Loop through sentiments to ensure we have an entry for every state year
for (st in states) {
  for (yr in years) {
    temp <- state_year_sent_qrt$sentiment[state_year_sent_qrt$state == st & state_year_sent_qrt$year == yr]
    if (length(temp) == 0){
      state_year_sent_qrt <- rbind(state_year_sent_qrt, c(st, yr, NA, NA))
    }
    
    temp <- state_year_sent_replies$sentiment[state_year_sent_replies$state == st & state_year_sent_replies$year == yr]
    if (length(temp) == 0){
      state_year_sent_replies <- rbind(state_year_sent_replies, c(st, yr, NA, NA))
    }
  }
}




### Finally, make the master data sets!

########################################################################################################

## state year level 

# add homelessness and tweet count data
state_year_master <- merge(homelessness_long, tweet_counts_long, by = c('state', 'year'))

# add all sentiment data
state_year_master <- merge(state_year_master, state_year_sent_all, by = c('state', 'year'))
state_year_master <- state_year_master %>% rename(all_sent = sentiment, all_raw_sent = raw_sent)

# add unique tweet sentiment data
state_year_master <- merge(state_year_master, state_year_sent_unique, by = c('state', 'year'))
state_year_master <- state_year_master %>% rename(unique_sent = sentiment, unique_raw_sent = raw_sent)

# add qrt sentiment data
state_year_master <- merge(state_year_master, state_year_sent_qrt, by = c('state', 'year'))
state_year_master <- state_year_master %>% rename(qrt_sent = sentiment, qrt_raw_sent = raw_sent)

# add reply sentiment data
state_year_master <- merge(state_year_master, state_year_sent_replies, by = c('state', 'year'))
state_year_master <- state_year_master %>% rename(reply_sent = sentiment, reply_raw_sent = raw_sent)

##

# all sentiment change data
state_year_master <- merge(state_year_master, sentiment_changes_all, by = c('state', 'year'))

# unique sent changes
state_year_master <- merge(state_year_master, sentiment_changes_unique, by = c('state', 'year'))

# qrt sent changes
state_year_master <- merge(state_year_master, sentiment_changes_qrt, by = c('state', 'year'))

# rt sent changes
state_year_master <- merge(state_year_master, sentiment_changes_replies, by = c('state', 'year'))

##

# homelessness changes
state_year_master <- merge(state_year_master, homeless_changes, by = c('state', 'year'))

# tweet count changes
state_year_master <- merge(state_year_master, tweet_count_changes, by = c('state', 'year'))

# write master data set to file
write.csv(state_year_master, 'data/master/state_year_master.csv', row.names = FALSE)

###############################################################################################################

## 


