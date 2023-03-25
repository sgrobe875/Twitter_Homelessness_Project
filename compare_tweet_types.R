# import packages
library(dplyr)
library(ggplot2)
library(gridExtra)
library(grid)
library(scales)




# set working directory to the location of this file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Recommended but not required to clear environment
rm(list = ls(all.names = TRUE)) 

# read in the data
source('load_data.R')



### Declare functions ###


# Produces a line graph of monthly sentiment with one line for each of the three tweet types
# Quote RTs, Unique, and Replies
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



# Same as the above function, but also includes a line of the overall sentiment each month
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


# Creates grouped bar plot with average sentiment each year, 2014-2022
# Each year has three bars, one for each of the three tweet types
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


# Same as above, but uses the passed in parameter to "zoom in" by starting the plot at a certain year
# Allows us to filter out the weirdness in the early years of the data set as a result of small sample sizes
yearly_bar_types_cutoff <- function(yr) {
  width_value <- 0.25
  
  unique_df <- year_sent_unique %>% filter(year >= yr)
  qrt_df <- year_sent_qrt %>% filter(year >= yr)
  replies_df <- year_sent_replies %>% filter(year >= yr)
  
  ggplot() +
    # left
    geom_col(aes(x = year, y = sentiment, fill = 'blue'), data = unique_df,
             width = width_value, position = position_nudge(-width_value)) +
    # middle
    geom_col(aes(x = year, y = sentiment, fill = 'darkblue'), data = qrt_df,
             width = width_value) +
    # right
    geom_col(aes(x = year, y = sentiment, fill = "lightblue"), data = replies_df,
             width = width_value, position = position_nudge(width_value)) +
    scale_fill_manual(values = c('blue','darkblue','lightblue'), labels = c('Unique','Quote RTs','Replies')) + 
    labs(fill="Tweet Type") +
    ggtitle("Average Sentiment Per Year by Tweet Type") +
    xlab('Year') + 
    ylab('Sentiment') +
    scale_x_continuous(breaks = seq(yr, 2022), labels = seq(yr, 2022)) + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))
}




### Function calls ###

png(filename="figures/sentiment/compare_monthly.png", width=700, height=400)
p <- sentiment_monthly_types()
p
dev.off()

png(filename="figures/sentiment/compare_monthly_baseline.png", width=700, height=400)
p <- sentiment_monthly_types_baseline()
p
dev.off()

png(filename="figures/sentiment/compare_yearly.png", width=700, height=450)
p <- yearly_bar_types()
p
dev.off()

png(filename="figures/sentiment/compare_yearly_zoomed.png", width=700, height=450)
p <- yearly_bar_types_cutoff(2015)
p
dev.off()
