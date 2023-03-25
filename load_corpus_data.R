# loading in corpus data

# set working directory to the location of this file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


# start with total data set
month_corpus_all <- read.csv('data/corpus_data/month_data.csv')
year_corpus_all <- read.csv('data/corpus_data/year_data.csv')
state_corpus_all <- read.csv('data/corpus_data/state_data.csv')
state_year_corpus_all <- read.csv('data/corpus_data/state_year_data.csv')


# unique tweets
month_corpus_unique <- read.csv('data/corpus_data/month_data_unique.csv')
year_corpus_unique <- read.csv('data/corpus_data/year_data_unique.csv')
state_corpus_unique <- read.csv('data/corpus_data/state_data_unique.csv')
state_year_corpus_unique <- read.csv('data/corpus_data/state_year_data_unique.csv')


# Quote RTs
month_corpus_qrt <- read.csv('data/corpus_data/month_data_qrt.csv')
year_corpus_qrt <- read.csv('data/corpus_data/year_data_qrt.csv')
state_corpus_qrt <- read.csv('data/corpus_data/state_data_qrt.csv')
state_year_corpus_qrt <- read.csv('data/corpus_data/state_year_data_qrt.csv')


# Replies
month_corpus_replies <- read.csv('data/corpus_data/month_data_replies.csv')
year_corpus_replies <- read.csv('data/corpus_data/year_data_replies.csv')
state_corpus_replies <- read.csv('data/corpus_data/state_data_replies.csv')
state_year_corpus_replies <- read.csv('data/corpus_data/state_year_data_replies.csv')



#### Rescale sentiments ####

month_corpus_all$sentiment <- month_corpus_all$sentiment - 5
month_corpus_all$sentiment <- month_corpus_all$sentiment / 4
month_corpus_all$sentiment <- as.numeric(month_corpus_all$sentiment)

year_corpus_all$sentiment <- year_corpus_all$sentiment - 5
year_corpus_all$sentiment <- year_corpus_all$sentiment / 4
year_corpus_all$sentiment <- as.numeric(year_corpus_all$sentiment)

state_corpus_all$sentiment <- state_corpus_all$sentiment - 5
state_corpus_all$sentiment <- state_corpus_all$sentiment / 4
state_corpus_all$sentiment <- as.numeric(state_corpus_all$sentiment)

state_year_corpus_all$sentiment <- state_year_corpus_all$sentiment - 5
state_year_corpus_all$sentiment <- state_year_corpus_all$sentiment / 4
state_year_corpus_all$sentiment <- as.numeric(state_year_corpus_all$sentiment)

##

month_corpus_unique$sentiment <- month_corpus_unique$sentiment - 5
month_corpus_unique$sentiment <- month_corpus_unique$sentiment / 4
month_corpus_unique$sentiment <- as.numeric(month_corpus_unique$sentiment)

year_corpus_unique$sentiment <- year_corpus_unique$sentiment - 5
year_corpus_unique$sentiment <- year_corpus_unique$sentiment / 4
year_corpus_unique$sentiment <- as.numeric(year_corpus_unique$sentiment)

state_corpus_unique$sentiment <- state_corpus_unique$sentiment - 5
state_corpus_unique$sentiment <- state_corpus_unique$sentiment / 4
state_corpus_unique$sentiment <- as.numeric(state_corpus_unique$sentiment)

state_year_corpus_unique$sentiment <- state_year_corpus_unique$sentiment - 5
state_year_corpus_unique$sentiment <- state_year_corpus_unique$sentiment / 4
state_year_corpus_unique$sentiment <- as.numeric(state_year_corpus_unique$sentiment)

##

month_corpus_qrt$sentiment <- month_corpus_qrt$sentiment - 5
month_corpus_qrt$sentiment <- month_corpus_qrt$sentiment / 4
month_corpus_qrt$sentiment <- as.numeric(month_corpus_qrt$sentiment)

year_corpus_qrt$sentiment <- year_corpus_qrt$sentiment - 5
year_corpus_qrt$sentiment <- year_corpus_qrt$sentiment / 4
year_corpus_qrt$sentiment <- as.numeric(year_corpus_qrt$sentiment)

state_corpus_qrt$sentiment <- state_corpus_qrt$sentiment - 5
state_corpus_qrt$sentiment <- state_corpus_qrt$sentiment / 4
state_corpus_qrt$sentiment <- as.numeric(state_corpus_qrt$sentiment)

state_year_corpus_qrt$sentiment <- state_year_corpus_qrt$sentiment - 5
state_year_corpus_qrt$sentiment <- state_year_corpus_qrt$sentiment / 4
state_year_corpus_qrt$sentiment <- as.numeric(state_year_corpus_qrt$sentiment)

##

month_corpus_replies$sentiment <- month_corpus_replies$sentiment - 5
month_corpus_replies$sentiment <- month_corpus_replies$sentiment / 4
month_corpus_replies$sentiment <- as.numeric(month_corpus_replies$sentiment)

year_corpus_replies$sentiment <- year_corpus_replies$sentiment - 5
year_corpus_replies$sentiment <- year_corpus_replies$sentiment / 4
year_corpus_replies$sentiment <- as.numeric(year_corpus_replies$sentiment)

state_corpus_replies$sentiment <- state_corpus_replies$sentiment - 5
state_corpus_replies$sentiment <- state_corpus_replies$sentiment / 4
state_corpus_replies$sentiment <- as.numeric(state_corpus_replies$sentiment)

state_year_corpus_replies$sentiment <- state_year_corpus_replies$sentiment - 5
state_year_corpus_replies$sentiment <- state_year_corpus_replies$sentiment / 4
state_year_corpus_replies$sentiment <- as.numeric(state_year_corpus_replies$sentiment)






