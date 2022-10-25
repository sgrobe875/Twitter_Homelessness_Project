# import packages
library(dplyr)
library(ggplot2)
library(RColorBrewer)




# set working directory to the location of this file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


# Recommended but not required to clear environment
rm(list = ls(all.names = TRUE)) 




# read in the data
d <- read.csv('data/homelessness_rate_data.csv')




# plot!

# build the continuous color pallette for mean sentiment

# red = most negative, white = neutral, green = most positive
redgreen<-colorRampPalette(c("red","white","green"))
# find the largest extent of sentiment and set that as limits in both directions for color consistency
lims = max(abs(min(d$mean_sent)), abs(max(d$mean_sent)))
# build the pallette from these parameters
sent_color_pallette <- scale_colour_gradientn(colours = redgreen(100), limit = c(-lims,lims))





#########




ggplot(data = d, mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = mean_sent)) + 
  geom_point(alpha = 0.8) + 
  sent_color_pallette + 
  ggtitle('Volume of Tweets Per Capita by Total Homelessness Per Capita') +
  xlab('Log10(Total Homelessness Per Capita)') + 
  ylab('Log10(Number of Tweets Per Capita)') + 
  labs(color = 'Average\nSentiment') + 
  theme_dark() +
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))


d %>% filter(mean_sent > 0) %>% 
ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = mean_sent)) + 
  geom_point(alpha = 0.8) + 
  sent_color_pallette + 
  ggtitle('Volume of Tweets Per Capita by Total Homelessness Per Capita\nFor States with Mostly Positive Sentiment') +
  xlab('Log10(Total Homelessness Per Capita)') + 
  ylab('Log10(Number of Tweets Per Capita)') + 
  labs(color = 'Average\nSentiment') + 
  theme_dark() +
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))


d %>% filter(mean_sent > 0) %>% 
  ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = mean_sent)) + 
  geom_point(alpha = 0.8) + 
  geom_smooth(method = 'lm', se = FALSE, color = 'black') +
  sent_color_pallette + 
  ggtitle('Volume of Tweets Per Capita by Total Homelessness Per Capita\nFor States with Mostly Positive Sentiment') +
  xlab('Log10(Total Homelessness Per Capita)') + 
  ylab('Log10(Number of Tweets Per Capita)') + 
  labs(color = 'Average\nSentiment') + 
  theme_dark() +
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))


d %>% filter(mean_sent < 0) %>% 
  ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = mean_sent)) + 
  geom_point(alpha = 0.8) + 
  sent_color_pallette + 
  ggtitle('Volume of Tweets Per Capita by Total Homelessness Per Capita\nFor States with Mostly Negative Sentiment') +
  xlab('Log10(Total Homelessness Per Capita)') + 
  ylab('Log10(Number of Tweets Per Capita)') + 
  labs(color = 'Average\nSentiment') + 
  theme_dark() +
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))


d %>% filter(mean_sent < 0) %>% 
  ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = mean_sent)) + 
  geom_point(alpha = 0.8) + 
  geom_smooth(method = 'lm', se = FALSE, color = 'black') +
  sent_color_pallette + 
  ggtitle('Volume of Tweets Per Capita by Total Homelessness Per Capita\nFor States with Mostly Negative Sentiment') +
  xlab('Log10(Total Homelessness Per Capita)') + 
  ylab('Log10(Number of Tweets Per Capita)') + 
  labs(color = 'Average\nSentiment') + 
  theme_dark() +
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))



#### looking closer at the relationship for negative sentiment

negative_sent <- d %>% filter(mean_sent < 0)
negative_model <- lm(log10(negative_sent$tweets_norm) ~ log10(negative_sent$total_homeless_norm))

# get intercept/slope
negative_model$coefficients

# correlation coefficient
cor.test(log10(negative_sent$tweets_norm), log10(negative_sent$total_homeless_norm))



#### same for positive sentiment because why not 
positive_sent <- d %>% filter(mean_sent > 0)
positive_model <- lm(log10(positive_sent$tweets_norm) ~ log10(positive_sent$total_homeless_norm))

# get intercept/slope
positive_model$coefficients

# correlation coefficient
cor.test(log10(positive_sent$tweets_norm), log10(positive_sent$total_homeless_norm))







#### TODO: PLOT AVERAGE SENTIMENT BY HOMELESSNESS














