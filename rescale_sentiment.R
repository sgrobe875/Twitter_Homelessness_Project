library(dplyr)

# editing the labMT sentiment to range from -1 to 1
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
state_sent <- read.csv('data/state_sentiment.csv')
year_sent <- read.csv('data/year_sentiment.csv')
state_year_sent <- read.csv('data/state_year_sentiment.csv')
month_sent <- read.csv('data/month_sentiment.csv')
day_sent <- read.csv('data/day_sentiment.csv')



# now rescale to -1 to 1
state_sent$sentiment <- state_sent$sentiment - 5
state_sent$sentiment <- state_sent$sentiment / 4

year_sent$sentiment <- year_sent$sentiment - 5
year_sent$sentiment <- year_sent$sentiment / 4

state_year_sent$sentiment <- state_year_sent$sentiment - 5
state_year_sent$sentiment <- state_year_sent$sentiment / 4

month_sent$sentiment <- month_sent$sentiment - 5
month_sent$sentiment <- month_sent$sentiment / 4

day_sent$sentiment <- day_sent$sentiment - 5
day_sent$sentiment <- day_sent$sentiment / 4



# read in the other relevant data files
homelessness_tweetcounts <- read.csv('data/homelessness_rate_data.csv')
homelessness_tweetcounts <- homelessness_tweetcounts %>% select(-X)

all_data <- read.csv("data/state_year_all_data.csv")
all_data <- all_data %>% select(-X)







# convert to long format
homeless_changes <- read.csv("data/percapita_changes_totalhomeless.csv")
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


# join with tweet counts
homeless_changes <- merge(homeless_changes, homelessness_tweetcounts, by = c('state','year'))


years <- seq(2011,2019)
states <- unlist(all_data %>% distinct(state))

tweet_norm_changes <- c()
yr_col <- c()
st_col <- c()

for (st in states) {
  for (yr in years) {
    prev <- all_data$tweets_norm[all_data$state == st & all_data$year == yr-1]
    curr <- all_data$tweets_norm[all_data$state == st & all_data$year == yr]
    
    tweet_norm_changes <- append(tweet_norm_changes, curr - prev)
    yr_col <- append(yr_col, yr)
    st_col <- append(st_col, st)
  }
}

temp <- data.frame(st_col, yr_col, tweet_norm_changes)
names(temp) <- c('state','year','tweet_norm_changes')



homeless_changes <- merge(homeless_changes, temp, by = c('state','year'))


# percent_twitter_activity <- read.csv('data/percents_of_total_twitter_activity.csv')





# clean up the console
rm(c, col, long_row, og_names, r, row)




# read in (and manipulate) sentiment change data
month_sentchanges <- read.csv('data/monthly_sentchanges.csv')
month_sentchanges <- month_sentchanges %>% select(-X)
month_sentchanges$month <- substr(month_sentchanges$month,1,7)
month_sentchanges <- within(month_sentchanges, month <- factor(month, levels = month_sentchanges$month))




year_sentchanges <- read.csv('data/year_sentchanges.csv')
year_sentchanges <- year_sentchanges %>% select(-X)
year_sentchanges <- within(year_sentchanges, year <- factor(year, levels = year_sentchanges$year))




state_year_sentchanges <- read.csv('data/state_year_sentchanges.csv')
state_year_sentchanges <- state_year_sentchanges %>% select(-X)


rm(curr, prev, st, st_col, states, tweet_norm_changes, years, yr, yr_col)



changes <- merge(homeless_changes, state_year_sentchanges, by = c('state','year'))
changes <- changes %>% select(state, year, total_homeless_change, tweet_norm_changes, sent_change)

