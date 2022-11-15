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
