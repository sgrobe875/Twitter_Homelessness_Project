# import packages
library(dplyr)
library(ggplot2)
library(stringr)
library(tidyverse)
library(lubridate)



# set working directory to the location of this file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


# Recommended but not required to clear environment
rm(list = ls(all.names = TRUE)) 


# read in the data
geotagged <- read.csv('data/geotagged_sentiment_only.csv')

# split out the dates and times (they're separated by a T)
dates <- str_split_fixed(geotagged$created_at, "T", 2)

# convert this vector of date strings to Date objects and append to the dataframe as a column
geotagged$date_posted <- as.Date(dates[,1])




#### Plotting functions ###########################################

# plot the sentiment over all years and states with daily averages
all_sentiment_daily <- function() {
  # group by date and find average sentiment
  sent_by_date <- geotagged %>% group_by(date_posted) %>% mutate(mean_sent = mean(sentiment)) %>% 
    select(date_posted, mean_sent) %>% distinct(date_posted, .keep_all = TRUE)

  # plot
  ggplot(data = sent_by_date, mapping = aes(x = date_posted, y = mean_sent)) + 
    geom_line() + 
    ggtitle('Daily Mean Sentiment Over Time') + 
    xlab('Time') + 
    ylab('Compound Sentiment') + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))
}


# plot the sentiment over all years and states with monthly averages
all_sentiment_monthly <- function() {
  # copy of main dataframe with only years and months
  temp <- geotagged %>% mutate(month_posted = format_ISO8601(date_posted, precision = "ym"))
  
  # reformat so it plots at the first day of each month
  temp$month_posted <- paste(temp$month_posted, '-01', sep = '')
  temp$month_posted <- as.Date(temp$month_posted)
  
  # group by each month and calculate mean sentiment
  sent_by_date <- temp %>% group_by(month_posted) %>% mutate(mean_sent = mean(sentiment)) %>% 
    select(month_posted, mean_sent) %>% distinct(month_posted, .keep_all = TRUE)
  
  # plot
  ggplot(data = sent_by_date, mapping = aes(x = month_posted, y = mean_sent)) + 
    geom_line() + 
    ggtitle('Monthly Mean Sentiment Over Time') + 
    xlab('Time') + 
    ylab('Compound Sentiment') + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))
}


# plot the sentiment over all years and states with monthly averages
all_sentiment_yearly <- function() {
  # copy of main dataframe with only years and months
  temp <- geotagged %>% mutate(year_posted = format_ISO8601(date_posted, precision = "y"))
  
  # group by month and find average sentiment
  sent_by_date <- temp %>% group_by(year_posted) %>% mutate(mean_sent = mean(sentiment)) %>% 
    select(date_posted, mean_sent) %>% distinct(date_posted, .keep_all = TRUE)
  
  # plot
  ggplot(data = sent_by_date, mapping = aes(x = date_posted, y = mean_sent)) + 
    geom_line() + 
    ggtitle('Yearly Mean Sentiment Over Time') + 
    xlab('Time') + 
    ylab('Compound Sentiment') + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))
}




###################################################################




all_sentiment_daily()










