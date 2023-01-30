# import packages
library(dplyr)
library(ggplot2)
library(stringr)
library(tidyverse)
library(lubridate)
library(scales)



# set working directory to the location of this file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


# Recommended but not required to clear environment
rm(list = ls(all.names = TRUE)) 


# use this R file to automatically read in the relevant data files all at once
source('load_data.R')





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
sentiment_monthly <- function(df, title = NULL, st = NULL, yr = NULL) {
  # convert strings to Dates
  df$month <- as.Date(paste(df$month, '-01', sep=''))
  
  # plot
  ggplot(data = df, mapping = aes(x = month, y = sentiment)) + 
    geom_line() + 
    ggtitle(paste('Monthly Mean Sentiment Over Time', title)) + 
    xlab('Time') + 
    ylab('Compound Sentiment') + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))
}
  


# plot the sentiment over all years and states with monthly averages
sentiment_yearly <- function(df = year_sent_all, title = NULL) {
  # plot
  ggplot(data = df, mapping = aes(x = year, y = sentiment)) + 
    geom_line() + 
    ggtitle(paste('Yearly Mean Sentiment Over Time', title)) + 
    xlab('Time') + 
    ylab('Compound Sentiment') + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))
}








###################################################################




## Daily averages

png(filename="figures/sentiment/daily_sentiment.png", width=600, height=400)
p <- sentiment_daily()
p
dev.off()



sentiment_daily()               # all sentiment
# sentiment_daily('CA')           # only California
# sentiment_daily(2017)           # only 2017
# sentiment_daily('CA', 2017)     # only California in 2017




# Monthly averages

png(filename="figures/sentiment/monthly_sentiment.png", width=600, height=400)
p <- sentiment_monthly(month_sent_all)
p
dev.off()


png(filename="figures/sentiment/monthly_sentiment_unique.png", width=600, height=400)
p <- sentiment_monthly(month_sent_unique, 'Across All Unique Tweets')
p
dev.off()


png(filename="figures/sentiment/monthly_sentiment_replies.png", width=600, height=400)
p <- sentiment_monthly(month_sent_replies, 'Across All Reply Tweets')
p
dev.off()


png(filename="figures/sentiment/monthly_sentiment_qrt.png", width=600, height=400)
p <- sentiment_monthly(month_sent_qrt, 'Across All Quote Tweets')
p
dev.off()



sentiment_monthly(month_sent_all)                # all sentiment
sentiment_monthly(month_sent_unique, 'Across All Unique Tweets')
sentiment_monthly(month_sent_replies, 'Across All Reply Tweets')
sentiment_monthly(month_sent_qrt, 'Across All Quote Tweets')
# sentiment_monthly('CA')           # only California
# sentiment_monthly(2017)           # only 2017
# sentiment_monthly('CA', 2017)     # only California in 2017



# Yearly averages

png(filename="figures/sentiment/yearly_sentiment_line.png", width=600, height=400)
p <- sentiment_yearly()
p
dev.off()

sentiment_yearly()
sentiment_yearly(year_sent_unique, '(Unique Tweets Only)')
sentiment_yearly(year_sent_qrt, '(Quote Tweets Only)')
sentiment_yearly(year_sent_replies, '(Reply Tweets Only)')




# Change in sentiment per year
p <- ggplot() + 
  geom_col(data = year_sentchanges, aes(x = year, y = sent_change)) +
  ggtitle('Change in Sentiment From Prior Year For All Tweets Containing "Homeless"') +
  xlab('Year') +
  ylab('Change in Sentiment') +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))
print(p)

png(filename="figures/sentiment/yearly_sentchange.png", width=600, height=400)
p
dev.off()



# change in sentiment per month - this one isn't actually super helpful tho
ggplot() + 
  geom_col(data = month_sentchanges, aes(x = month, y = sent_change)) +
  ggtitle('Change in Sentiment From Prior Month For All Tweets Containing "Homeless"') +
  xlab('Month') +
  ylab('Change in Sentiment') +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))





#### Boxplot of state sentiment per year


p <- ggplot(state_year_master, aes(x = year, y = all_sent, group = year)) + 
  geom_boxplot(fill = 'lightgray') +
  scale_x_continuous(breaks = pretty_breaks(n = 10)) +
  xlab('Year') + 
  ylab('Sentiment') + 
  ggtitle('Statewide Sentiment Per Year') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5, size = 15), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))

print(p)

png(filename="figures/sentiment/boxplot_per_year.png", width=600, height=400)
p
dev.off()


p <- ggplot(state_year_master, aes(x = year, y = unique_sent, group = year)) + 
  geom_boxplot(fill = 'lightgray') +
  scale_x_continuous(breaks = pretty_breaks(n = 10)) +
  xlab('Year') + 
  ylab('Sentiment') + 
  ggtitle('Statewide Sentiment Per Year (Unique Tweets Only)') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5, size = 15), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))

print(p)

png(filename="figures/sentiment/boxplot_per_year_unique.png", width=600, height=400)
p
dev.off()


p <- ggplot(state_year_master, aes(x = year, y = reply_sent, group = year)) + 
  geom_boxplot(fill = 'lightgray') +
  scale_x_continuous(breaks = pretty_breaks(n = 10)) +
  xlab('Year') + 
  ylab('Sentiment') + 
  ggtitle('Statewide Sentiment Per Year (Reply Tweets Only)') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5, size = 15), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))

print(p)

png(filename="figures/sentiment/boxplot_per_year_replies.png", width=600, height=400)
p
dev.off()


p <- ggplot(state_year_master, aes(x = year, y = qrt_sent, group = year)) + 
  geom_boxplot(fill = 'lightgray') +
  scale_x_continuous(breaks = pretty_breaks(n = 10)) +
  xlab('Year') + 
  ylab('Sentiment') + 
  ggtitle('Statewide Sentiment Per Year (Quote Tweets Only)') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5, size = 15), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))

print(p)

png(filename="figures/sentiment/boxplot_per_year_qrt.png", width=600, height=400)
p
dev.off()




