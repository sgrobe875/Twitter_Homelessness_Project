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








# percent_twitter_activity <- read.csv('data/percents_of_total_twitter_activity.csv')





# clean up the console
rm(c, col, long_row, og_names, r, row)







