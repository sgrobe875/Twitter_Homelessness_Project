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
sentiment_daily <- function(st = NULL, yr = NULL) {
  
  # group by date and find average sentiment
  # sent_by_date <- geotagged %>% group_by(date_posted) %>% mutate(mean_sent = mean(sentiment)) %>% 
  #   distinct(date_posted, .keep_all = TRUE)
  
  # set up plot title
  title <- 'Daily Mean Sentiment Over Time'
  
  
  ### filter the data according to function parameters ###
  
  # filtering by only year (st = year)
  if (is.numeric(st)) {
    sent_by_date <- geotagged %>% filter(year == as.character(st)) %>%  # filter out the year
      group_by(date_posted) %>%                                         # group by month
      mutate(mean_sent = mean(sentiment)) %>%                           # calculate mean for each group (month)
      distinct(date_posted, .keep_all = TRUE) %>%                       # remove duplicates
      select(date_posted, mean_sent, year, state)                       # extract useful columns (optional)
    
    title <- paste(title, ' (', as.character(st), ')', sep='')
  }
  
  # no filtering (plotting all sentiment)
  else if (is.null(st)) {
    sent_by_date <- geotagged %>% group_by(date_posted) %>%    # no filtering needed, so just group by month
      mutate(mean_sent = mean(sentiment)) %>%                  # calculate mean sentiment for each month
      distinct(date_posted, .keep_all = TRUE) %>%              # remove duplicates
      select(date_posted, mean_sent, year, state)              # extract useful columns (optional)
  }
  
  # filtering by only state (st = state)
  else if (is.null(yr)) {
    sent_by_date <- geotagged %>% filter(state == st) %>%         # filter out the state
      group_by(date_posted) %>%                                   # group by month
      mutate(mean_sent = mean(sentiment)) %>%                     # calculate mean for each group (month)
      distinct(date_posted, .keep_all = TRUE) %>%                 # remove duplicates
      select(date_posted, mean_sent, year, state)                 # extract useful columns (optional)
    
    title <- paste(title, ' (', st, ')', sep='')
  }
  
  # filtering by both (st = state, yr = year)
  else {
    sent_by_date <- geotagged %>% filter(state == st) %>%         # filter out the state
      filter(year == yr) %>%                                      # filter out the year
      group_by(date_posted) %>%                                   # group by month
      mutate(mean_sent = mean(sentiment)) %>%                     # calculate mean for each group (month)
      distinct(date_posted, .keep_all = TRUE) %>%                 # remove duplicates
      select(date_posted, mean_sent, year, state)                 # extract useful columns (optional)
    
    title <- paste(title, ' (', st, ', ', as.character(yr), ')', sep='')
  }

  
  # plot
  ggplot(data = sent_by_date, mapping = aes(x = date_posted, y = mean_sent)) + 
    geom_line() + 
    ggtitle(title) + 
    xlab('Time') + 
    ylab('Compound Sentiment') + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))
}


# plot the sentiment over all years and states with monthly averages
sentiment_monthly <- function(st = NULL, yr = NULL) {
  # copy of main dataframe with only years and months
  temp <- geotagged %>% mutate(month_posted = format_ISO8601(date_posted, precision = "ym"))
  
  # reformat so it plots at the first day of each month
  temp$month_posted <- paste(temp$month_posted, '-01', sep = '')
  temp$month_posted <- as.Date(temp$month_posted)
  
  # set up plot title
  title <- 'Monthly Mean Sentiment Over Time'
  
  
  
  ### filter the data according to function parameters ###
  
  # filtering by only year (st = year)
  if (is.numeric(st)) {
    sent_by_date <- temp %>% filter(year == as.character(st)) %>%  # filter out the year
      group_by(month_posted) %>%                                   # group by month
      mutate(mean_sent = mean(sentiment)) %>%                      # calculate mean for each group (month)
      distinct(month_posted, .keep_all = TRUE) %>%                 # remove duplicates
      select(month_posted, mean_sent, year, state)                 # extract useful columns (optional)

    title <- paste(title, ' (', as.character(st), ')', sep='')
  }
  
  # no filtering (plotting all sentiment)
  else if (is.null(st)) {
    # st = 'dummy'
    sent_by_date <- temp %>% group_by(month_posted) %>%    # no filtering needed, so just group by month
      mutate(mean_sent = mean(sentiment)) %>%              # calculate mean sentiment for each month
      distinct(month_posted, .keep_all = TRUE) %>%         # remove duplicates
      select(month_posted, mean_sent, year, state)         # extract useful columns (optional)
  }
  
  # filtering by only state (st = state)
  else if (is.null(yr)) {
    sent_by_date <- temp %>% filter(state == st) %>%               # filter out the state
      group_by(month_posted) %>%                                   # group by month
      mutate(mean_sent = mean(sentiment)) %>%                      # calculate mean for each group (month)
      distinct(month_posted, .keep_all = TRUE) %>%                 # remove duplicates
      select(month_posted, mean_sent, year, state)                 # extract useful columns (optional)
    
    # sent_by_date <- sent_by_date %>% filter(state == st)
    title <- paste(title, ' (', st, ')', sep='')
  }
  
  # filtering by both (st = state, yr = year)
  else {
    sent_by_date <- temp %>% filter(state == st) %>%               # filter out the state
      filter(year == yr) %>%                                       # filter out the year
      group_by(month_posted) %>%                                   # group by month
      mutate(mean_sent = mean(sentiment)) %>%                      # calculate mean for each group (month)
      distinct(month_posted, .keep_all = TRUE) %>%                 # remove duplicates
      select(month_posted, mean_sent, year, state)                 # extract useful columns (optional)
    
    # sent_by_date <- sent_by_date %>% filter(state == st) %>% filter(year == as.character(yr))
    title <- paste(title, ' (', st, ', ', as.character(yr), ')', sep='')
  }
  
  
  
  # plot
  ggplot(data = sent_by_date, mapping = aes(x = month_posted, y = mean_sent)) + 
    geom_line() + 
    ggtitle(title) + 
    xlab('Time') + 
    ylab('Compound Sentiment') + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))
}


# plot the sentiment over all years and states with monthly averages
sentiment_yearly <- function() {
  # copy of main dataframe with only years and months
  temp <- data.frame(geotagged)
  temp$year <- as.numeric(temp$year)
  
  # group by month and find average sentiment
  sent_by_date <- temp %>% group_by(year) %>% mutate(mean_sent = mean(sentiment)) %>% 
    select(year, mean_sent) %>% distinct(year, .keep_all = TRUE)
  
  # plot
  ggplot(data = sent_by_date, mapping = aes(x = year, y = mean_sent)) + 
    geom_line() + 
    ggtitle('Yearly Mean Sentiment Over Time') + 
    xlab('Time') + 
    ylab('Compound Sentiment') + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))
}








###################################################################




## Daily averages

sentiment_daily()               # all sentiment
sentiment_daily('CA')           # only California
sentiment_daily(2017)           # only 2017
sentiment_daily('CA', 2017)     # only California in 2017




# Monthly averages

sentiment_monthly()               # all sentiment
sentiment_monthly('CA')           # only California
sentiment_monthly(2017)           # only 2017
sentiment_monthly('CA', 2017)     # only California in 2017







