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


# use this R file to automatically read in the data and rescale the sentiment values
source('rescale_sentiment.R')





#### Plotting functions ###########################################

# plot the sentiment over all years and states with daily averages
sentiment_daily <- function(st = NULL, yr = NULL) {
  # convert strings to Dates
  day_sent$day <- as.Date(day_sent$day)
  
  # plot
  ggplot(data = day_sent, mapping = aes(x = day, y = sentiment)) + 
    geom_line() + 
    ggtitle('Daily Mean Sentiment Over Time') + 
    xlab('Time') + 
    ylab('Compound Sentiment') + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))
}


# plot the sentiment over all years and states with monthly averages
sentiment_monthly <- function(st = NULL, yr = NULL) {
  # convert strings to Dates
  month_sent$month <- as.Date(paste(month_sent$month, '-01', sep=''))
  
  # plot
  ggplot(data = month_sent, mapping = aes(x = month, y = sentiment)) + 
    geom_line() + 
    ggtitle('Monthly Mean Sentiment Over Time') + 
    xlab('Time') + 
    ylab('Compound Sentiment') + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))
}
  


# plot the sentiment over all years and states with monthly averages
sentiment_yearly <- function() {
  # plot
  ggplot(data = year_sent, mapping = aes(x = year, y = sentiment)) + 
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
# sentiment_daily('CA')           # only California
# sentiment_daily(2017)           # only 2017
# sentiment_daily('CA', 2017)     # only California in 2017




# Monthly averages

sentiment_monthly()               # all sentiment
# sentiment_monthly('CA')           # only California
# sentiment_monthly(2017)           # only 2017
# sentiment_monthly('CA', 2017)     # only California in 2017



# Yearly averages

sentiment_yearly()




