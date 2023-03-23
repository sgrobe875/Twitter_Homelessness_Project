# import packages
library(dplyr)
library(ggplot2)
library(gridExtra)
library(grid)




# set working directory to the location of this file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Recommended but not required to clear environment
rm(list = ls(all.names = TRUE)) 

# read in the data
source('load_data.R')




sentiment_monthly_types <- function() {
  # convert strings to Dates
  month_sent_qrt$month <- as.Date(paste(month_sent_qrt$month, '-01', sep=''))
  month_sent_replies$month <- as.Date(paste(month_sent_replies$month, '-01', sep=''))
  month_sent_unique$month <- as.Date(paste(month_sent_unique$month, '-01', sep=''))
  
  # plot
  ggplot() + 
    geom_line(data = month_sent_qrt, aes(x = month, y = sentiment, color='black')) + 
    geom_line(data = month_sent_unique, aes(x = month, y = sentiment, color='blue')) + 
    geom_line(data = month_sent_replies, aes(x = month, y = sentiment, color='darkgreen')) + 
    ggtitle('Monthly Mean Sentiment Over Time Per Tweet Type') + 
    xlab('Time') + 
    ylab('Compound Sentiment') + 
    labs(color = "Legend") + 
    
    scale_color_manual(values = c('black', "blue","darkgreen"), labels=c("Quote RTs", "Unique Tweets", "Replies")) + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))
}


sentiment_monthly_types_baseline <- function() {
  # convert strings to Dates
  month_sent_all$month <- as.Date(paste(month_sent_all$month, '-01', sep=''))
  
  month_sent_qrt$month <- as.Date(paste(month_sent_qrt$month, '-01', sep=''))
  month_sent_replies$month <- as.Date(paste(month_sent_replies$month, '-01', sep=''))
  month_sent_unique$month <- as.Date(paste(month_sent_unique$month, '-01', sep=''))
  
  # plot
  ggplot() + 
    geom_line(data = month_sent_qrt, aes(x = month, y = sentiment, color='black')) + 
    geom_line(data = month_sent_unique, aes(x = month, y = sentiment, color='blue')) + 
    geom_line(data = month_sent_replies, aes(x = month, y = sentiment, color='darkgreen')) + 
    geom_line(data = month_sent_all, aes(x = month, y = sentiment, color='red')) +
    ggtitle('Monthly Mean Sentiment Over Time Per Tweet Type\nvs. Overall Monthly Mean Sentiment') + 
    xlab('Time') + 
    ylab('Compound Sentiment') + 
    labs(color = "Legend") + 
    scale_color_manual(values = c('black','blue','darkgreen','red'), labels=c('Quote RTs','Unique Tweets','Replies','Overall')) + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))
}



yearly_bar_types <- function() {
  width_value <- 0.25
  
  ggplot() +
    # left
    geom_col(aes(x = year, y = sentiment, fill = 'blue'), data = year_sent_unique,
             width = width_value, position = position_nudge(-width_value)) +
    # middle
    geom_col(aes(x = year, y = sentiment, fill = 'darkblue'), data = year_sent_qrt,
             width = width_value) +
    # right
    geom_col(aes(x = year, y = sentiment, fill = "lightblue"), data = year_sent_replies,
             width = width_value, position = position_nudge(width_value)) +
    scale_fill_manual(values = c('blue','darkblue','lightblue'), labels = c('Unique','Quote RTs','Replies')) + 
    labs(fill="Tweet Type") +
    ggtitle("Average Sentiment Per Year by Tweet Type") +
    xlab('Year') + 
    ylab('Sentiment') +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))
}


sentiment_monthly_types()



sentiment_monthly_types_baseline()



yearly_bar_types()
