# import packages
library(dplyr)
library(ggplot2)
library(gridExtra)
library(grid)
library(reshape2)




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


# change in per capita total homelessness
p <- ggplot(data = changes, aes(x = total_homeless_change)) + 
  geom_density(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Change From Previous Year in Per Capita Homelessness\nper State/Year Pair') + 
  xlab('Homelessness Change') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/total_homeless_change_dens.png", width=600, height=450)
p
dev.off()



# change in per capita tweets
p <- ggplot(data = changes, aes(x = tweet_norm_changes)) + 
  geom_density(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Change From Previous Year in Per Capita Tweets\nper State/Year Pair') + 
  xlab('Tweet Volume Change') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/tweets_norm_change_dens.png", width=600, height=450)
p
dev.off()


# change in sentiment
p <- ggplot(data = changes, aes(x = sent_change)) + 
  geom_density(color = 'black', fill = 'gray') + 
  ggtitle('Distribution of Change From Previous Year in Tweet Sentiment\nper State/Year Pair') + 
  xlab('Sentiment Change') + 
  ylab('Frequency') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/sentiment_change_dens.png", width=600, height=450)
p
dev.off()






#### Box plots of variable distributions ####


# all log variables
temp <- all_data %>% mutate(state_year = paste(state, year)) %>% 
  select(-state, -year, -sentiment, -raw_sent)
temp <- temp[, c('state_year','tweet_count','tweet_percent','total_homeless_norm','tweets_norm')]
names(temp) <- c('state_year','Number of Tweets','Percentage of Tweets',
                 'Per Capita Homelessness','Per Capita Tweets')
data_long <- melt(temp)
p <- ggplot(data_long, aes(x = variable, y = log10(value))) + 
  geom_boxplot(fill = 'lightgray') +
  ggtitle('Distributions of Variables') + 
  xlab('') +
  ylab('Log10(Variable)') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/boxplot_all.png", width=800, height=450)
p
dev.off()
  
rm(temp)

















#### changes in tweets vs changes in homelessness

# build plots for the following states:
states = c('CT','MA','GA','CA','FL','AR')

# with bars plotted on top of each other:
for (st in states) {
  p <- ggplot(data = homeless_changes %>% filter(state == st) %>% within(year <- factor(year, levels = year))) +
    geom_col(aes(x = year, y = total_homeless_change, fill = "Homelessness"),
             alpha = 0.8) + 
    geom_col(aes(x = year, y = tweet_norm_changes, group = 1, fill = "Tweets"),
             alpha = 0.8) +
    scale_fill_manual(values = c("darkblue","lightblue")) + 
    labs(fill="") +
    geom_hline(yintercept = 0) +
    xlab('Year') + 
    ylab('Change From Prior Year') + 
    ggtitle(paste('Changes in Per Capita Tweets and Per Capita\nTotal Homelessness in', st)) +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
          axis.title.y = element_text(size = 9.5), legend.text = element_text(size = 11))
  
  print(p)
  
  f = paste("figures/eda/changes_homeless_tweets_", st, ".png", sep = "")
  png(filename=f, width=700, height=450)
  print(p)
  dev.off()
}


# with offset (grouped) bars:
for (st in states) {
  p <- ggplot(data = homeless_changes %>% filter(state == st) %>% within(year <- factor(year, levels = year))) +
    geom_col(aes(x = year, y = total_homeless_change, fill = "Homelessness"),
             width = 0.4, position = position_nudge(0.22)) + 
    geom_col(aes(x = year, y = tweet_norm_changes, group = 1, fill = "Tweets"),
             width = 0.4, position = position_nudge(-0.22)) +
    scale_fill_manual(values = c("darkblue","lightblue")) + 
    labs(fill="") +
    geom_hline(yintercept = 0) +
    xlab('Year') + 
    ylab('Change From Prior Year') + 
    ggtitle(paste('Changes in Per Capita Tweets and Per Capita\nTotal Homelessness in', st)) +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
          axis.title.y = element_text(size = 9.5))
  
  print(p)
}









#### Playing with the data ####



# overlaying multiple distributions 
# Note these don't have axis labels because the axes are kind of meaningless
# the takeaway here is the shape of the distribution, not its values!
p <- all_data %>% mutate(total_homeless_norm = total_homeless_norm / max(total_homeless_norm)) %>% 
  mutate(tweets_norm = tweets_norm / max(tweets_norm)) %>% 
  ggplot() +
  geom_density(mapping = aes(x = log10(total_homeless_norm), fill = 'Homelessness'), color = 'black', alpha = 0.3) + 
  geom_density(mapping = aes(x = log10(tweets_norm), fill = 'Tweets'), color = 'black', alpha = 0.3) + 
  labs(fill="") +
  scale_fill_manual(values = c("red","blue")) +
  ggtitle('Distribution of Per Capita Homelessness and Per Capita Tweets,\nNormalized Between 0 and 1') + 
  xlab('') + 
  ylab('') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/eda/compare_homeless_tweets.png", width=700, height=450)
p
dev.off()





# overlaid distributions for homelessness by year
# The unicorn vomit plot!
ggplot() + 
  geom_density(data = all_data %>% filter(year == 2010), mapping = aes(x = total_homeless_norm,
               fill = '2010'), color = 'black', alpha = 0.2) +
  geom_density(data = all_data %>% filter(year == 2011), mapping = aes(x = total_homeless_norm,
               fill = '2011'), color = 'black', alpha = 0.2) +
  geom_density(data = all_data %>% filter(year == 2012), mapping = aes(x = total_homeless_norm,
               fill = '2012'), color = 'black', alpha = 0.2) +
  geom_density(data = all_data %>% filter(year == 2013), mapping = aes(x = total_homeless_norm,
               fill = '2013'), color = 'black', alpha = 0.2) +
  geom_density(data = all_data %>% filter(year == 2014), mapping = aes(x = total_homeless_norm,
               fill = '2014'), color = 'black', alpha = 0.2) +
  geom_density(data = all_data %>% filter(year == 2015), mapping = aes(x = total_homeless_norm,
               fill = '2015'), color = 'black', alpha = 0.2) +
  geom_density(data = all_data %>% filter(year == 2016), mapping = aes(x = total_homeless_norm,
               fill = '2016'), color = 'black', alpha = 0.2) +
  geom_density(data = all_data %>% filter(year == 2017), mapping = aes(x = total_homeless_norm,
               fill = '2017'), color = 'black', alpha = 0.2) +
  geom_density(data = all_data %>% filter(year == 2018), mapping = aes(x = total_homeless_norm,
               fill = '2018'), color = 'black', alpha = 0.2) +
  geom_density(data = all_data %>% filter(year == 2019), mapping = aes(x = total_homeless_norm,
               fill = '2019'), color = 'black', alpha = 0.2) +
  labs(fill="Year") +
  scale_fill_manual(values = c('red','orange','yellow','green','blue','purple','gray','brown','magenta','cyan')) +
  xlab('Per Capita Homelessness') + 
  ylab('Density') + 
  ggtitle('Distribution of Per Capita Total Homelessness By Year') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))











#### Some commented out scratchwork ####





# normed tweet counts and homelessness counts per state
# ggplot() + 
#   geom_histogram(data = all_data %>% filter(state == 'CA'), mapping = aes(x = tweets_norm),
#                fill = 'darkblue', alpha = 0.8) +
#   geom_histogram(data = homeless_changes %>% filter(state == 'CA'), mapping = aes(x = total_homeless_change),
#                fill = 'lightblue', alpha = 0.8) +
#   theme_bw() + 
#   theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
#         axis.title.y = element_text(size = 9.5))







# ggplot(data = homeless_changes %>% filter(state == 'CA') %>% within(year <- factor(year, levels = year))) +
#   geom_col(mapping = aes(x = year, y = tweet_norm_changes, fill = 'Per Capita Tweets'), alpha = 0.8) +
#   geom_col(mapping = aes(x = year, y = total_homeless_change, fill = 'Per Capita Homeless'), alpha = 0.8) +
#   geom_hline(yintercept = 0) +
#   xlab('Year') + 
#   ylab('Change From Prior Year') + 
#   scale_color_manual(name='Legend', 
#                      breaks=c('Per Capita Tweets', 'Per Capita Homeless'),
#                      values=c('Per Capita Tweets'='darkblue', 'Per Capita Homeless'='lightblue')) +
#   theme_bw() +
#   theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
#         axis.title.y = element_text(size = 9.5))









