# import packages
library(dplyr)





# set working directory to the location of this file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Recommended but not required to clear environment
rm(list = ls(all.names = TRUE)) 

# read in the data
source('rescale_sentiment.R')
d <- read.csv('data/homelessness_rate_data.csv')





#### Synthesize homelessness and sentiment data ####

# join state_year_sent and d on composite key of state, year
joined <- merge(state_year_sent, d, by = c('state', 'year'))  

# clean up bc R hates joins
joined <- joined %>% select(state, year, tweets_norm, total_homeless_norm, unshelt_homeless_norm,
                            raw_sent.x, sentiment.x)
names(joined) <- c('state','year','tweets_norm','total_homeless_norm','unshelt_homeless_norm',
                   'raw_sent', 'sentiment')

# write to csv
write.csv(joined, "data/state_year_all_data.csv")








