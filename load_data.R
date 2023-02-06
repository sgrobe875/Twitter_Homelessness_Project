# set working directory to the location of this file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


# master data files
state_year_master <- read.csv('data/master/state_year_master.csv')


# monthly sentiment
month_sent_all <- read.csv('data/sentiment/month_sentiment.csv')
month_sent_unique <- read.csv('data/sentiment/month_sentiment_unique.csv')
month_sent_replies <- read.csv('data/sentiment/month_sentiment_replies.csv')
month_sent_qrt <- read.csv('data/sentiment/month_sentiment_qrt.csv')


# yearly sentiment
year_sent_all <- read.csv('data/sentiment/year_sentiment.csv')
year_sent_unique <- read.csv('data/sentiment/year_sentiment_unique.csv')
year_sent_replies <- read.csv('data/sentiment/year_sentiment_replies.csv')
year_sent_qrt <- read.csv('data/sentiment/year_sentiment_qrt.csv')



# state sentiment
state_sent_all <- read.csv('data/sentiment/state_sentiment.csv')
state_sent_unique <- read.csv('data/sentiment/state_sentiment_unique.csv')
state_sent_replies <- read.csv('data/sentiment/state_sentiment_replies.csv')
state_sent_qrt <- read.csv('data/sentiment/state_sentiment_qrt.csv')



# regional sentiment
region_sent_all <- read.csv('data/sentiment/region_sentiment.csv')




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



region_sent_all$sentiment <- region_sent_all$sentiment - 5
region_sent_all$sentiment <- region_sent_all$sentiment / 4
region_sent_all$sentiment <- as.numeric(region_sent_all$sentiment)
region_sent_all$sentiment[region_sent_all$sentiment < -1] <- NA





