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
source('rescale_sentiment.R')





#### Histograms of variable distributions ####


# tweet_count
p <- ggplot(data = all_data, mapping = aes(x = tweet_count)) + 
  geom_histogram(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Tweet Counts per State/Year Pair') + 
  xlab('Number of Tweets') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/tweet_count_hist.png", width=600, height=450)
p
dev.off()


# log10(tweet_count)
p <- ggplot(data = all_data, mapping = aes(x = log10(tweet_count))) + 
  geom_histogram(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Log Tweet Counts per State/Year Pair') + 
  xlab('Log10(Number of Tweets)') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/log(tweet_count)_hist.png", width=600, height=450)
p
dev.off()



# tweet_percent
p <- ggplot(data = all_data, mapping = aes(x = tweet_percent)) + 
  geom_histogram(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Percentage of Yearly Tweets per State/Year Pair') + 
  xlab('Percentage of Tweets') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/tweet_percent_hist.png", width=600, height=450)
p
dev.off()



# log10(tweet_percent)
p <- ggplot(data = all_data, mapping = aes(x = log10(tweet_percent))) + 
  geom_histogram(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Log Percentage of Yearly Tweets per State/Year Pair') + 
  xlab('Log10(Percentage of Tweets)') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/log(tweet_percent)_hist.png", width=600, height=450)
p
dev.off()



# tweets_norm
p <- ggplot(data = all_data, mapping = aes(x = tweets_norm)) + 
  geom_histogram(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Per Capita Tweet Counts per State/Year Pair') + 
  xlab('Tweets Per Capita') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/tweets_norm_hist.png", width=600, height=450)
p
dev.off()



# log10(tweets_norm)
p <- ggplot(data = all_data, mapping = aes(x = log10(tweets_norm))) + 
  geom_histogram(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Log Per Capita Tweet Counts per State/Year Pair') + 
  xlab('Log10(Tweets Per Capita)') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/log(tweets_norm)_hist.png", width=600, height=450)
p
dev.off()




# total_homeless_norm
p <- ggplot(data = all_data, mapping = aes(x = total_homeless_norm)) + 
  geom_histogram(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Per Capita Total Homeless Counts per State/Year Pair') + 
  xlab('Total Homeless Per Capita') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/total_homeless_norm_hist.png", width=600, height=450)
p
dev.off()



# log10(total_homeless_norm)
p <- ggplot(data = all_data, mapping = aes(x = log10(total_homeless_norm))) + 
  geom_histogram(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Log Per Capita Total Homeless Counts per State/Year Pair') + 
  xlab('Total Homeless Per Capita') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/log(total_homeless_norm)_hist.png", width=600, height=450)
p
dev.off()



# unshelt_homeless_norm
p <- ggplot(data = all_data, mapping = aes(x = unshelt_homeless_norm)) + 
  geom_histogram(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Per Capita Unsheltered Homeless Counts per State/Year Pair') + 
  xlab('Unsheltered Homeless Per Capita') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/unshelt_homeless_norm_hist.png", width=600, height=450)
p
dev.off()



# log10(unshelt_homeless_norm)
p <- ggplot(data = all_data, mapping = aes(x = log10(unshelt_homeless_norm))) + 
  geom_histogram(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Log Per Capita Unsheltered Homeless Counts per State/Year Pair') + 
  xlab('Log10(Unsheltered Homeless Per Capita)') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/log(unshelt_homeless_norm)_hist.png", width=600, height=450)
p
dev.off()




# sentiment
p <- ggplot(data = all_data, mapping = aes(x = sentiment)) + 
  geom_histogram(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Average Tweet Sentiment per State/Year Pair') + 
  xlab('Sentiment') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/sentiment_hist.png", width=600, height=450)
p
dev.off()






#### Density plots of variable distributions ####


# tweet_count
p <- ggplot(data = all_data, mapping = aes(x = tweet_count)) + 
  geom_density(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Tweet Counts per State/Year Pair') + 
  xlab('Number of Tweets') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/tweet_count_dens.png", width=600, height=450)
p
dev.off()


# log10(tweet_count)
p <- ggplot(data = all_data, mapping = aes(x = log10(tweet_count))) + 
  geom_density(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Log Tweet Counts per State/Year Pair') + 
  xlab('Log10(Number of Tweets)') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/log(tweet_count)_dens.png", width=600, height=450)
p
dev.off()



# tweet_percent
p <- ggplot(data = all_data, mapping = aes(x = tweet_percent)) + 
  geom_density(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Percentage of Yearly Tweets per State/Year Pair') + 
  xlab('Percentage of Tweets') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/tweet_percent_dens.png", width=600, height=450)
p
dev.off()



# log10(tweet_percent)
p <- ggplot(data = all_data, mapping = aes(x = log10(tweet_percent))) + 
  geom_density(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Log Percentage of Yearly Tweets per State/Year Pair') + 
  xlab('Log10(Percentage of Tweets)') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/log(tweet_percent)_dens.png", width=600, height=450)
p
dev.off()



# tweets_norm
p <- ggplot(data = all_data, mapping = aes(x = tweets_norm)) + 
  geom_density(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Per Capita Tweet Counts per State/Year Pair') + 
  xlab('Tweets Per Capita') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/tweets_norm_dens.png", width=600, height=450)
p
dev.off()



# log10(tweets_norm)
p <- ggplot(data = all_data, mapping = aes(x = log10(tweets_norm))) + 
  geom_density(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Log Per Capita Tweet Counts per State/Year Pair') + 
  xlab('Log10(Tweets Per Capita)') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/log(tweets_norm)_dens.png", width=600, height=450)
p
dev.off()




# total_homeless_norm
p <- ggplot(data = all_data, mapping = aes(x = total_homeless_norm)) + 
  geom_density(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Per Capita Total Homeless Counts per State/Year Pair') + 
  xlab('Total Homeless Per Capita') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/total_homeless_norm_dens.png", width=600, height=450)
p
dev.off()



# log10(total_homeless_norm)
p <- ggplot(data = all_data, mapping = aes(x = log10(total_homeless_norm))) + 
  geom_density(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Log Per Capita Total Homeless Counts per State/Year Pair') + 
  xlab('Total Homeless Per Capita') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/log(total_homeless_norm)_dens.png", width=600, height=450)
p
dev.off()



# unshelt_homeless_norm
p <- ggplot(data = all_data, mapping = aes(x = unshelt_homeless_norm)) + 
  geom_density(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Per Capita Unsheltered Homeless Counts per State/Year Pair') + 
  xlab('Unsheltered Homeless Per Capita') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/unshelt_homeless_norm_dens.png", width=600, height=450)
p
dev.off()



# log10(unshelt_homeless_norm)
p <- ggplot(data = all_data, mapping = aes(x = log10(unshelt_homeless_norm))) + 
  geom_density(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Log Per Capita Unsheltered Homeless Counts per State/Year Pair') + 
  xlab('Log10(Unsheltered Homeless Per Capita)') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/log(unshelt_homeless_norm)_dens.png", width=600, height=450)
p
dev.off()




# sentiment
p <- ggplot(data = all_data, mapping = aes(x = sentiment)) + 
  geom_density(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Average Tweet Sentiment per State/Year Pair') + 
  xlab('Sentiment') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/sentiment_dens.png", width=600, height=450)
p
dev.off()










