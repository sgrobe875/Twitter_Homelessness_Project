# import packages
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(ggrepel)




# set working directory to the location of this file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


# Recommended but not required to clear environment
rm(list = ls(all.names = TRUE)) 




# read in the data
d <- read.csv('data/homelessness_rate_data.csv')




# plot!

# build the continuous color pallette for mean sentiment

# red = most negative, white = neutral, green = most positive
redgreen<-colorRampPalette(c("darkred","gray","darkblue"))
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
  theme_bw() + 
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
  theme_bw() + 
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
  theme_bw() + 
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
  theme_bw() + 
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
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))


d %>% filter(mean_sent < 0) %>%
  ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = mean_sent)) +
  geom_point(alpha = 0.8) +
  annotate("text", x=log10(0.00095), y=log10(0.00055), label= "Correlation coefficient = 0.56733") + 
  geom_smooth(method = 'lm', se = FALSE, color = 'black') +
  sent_color_pallette +
  ggtitle('Volume of Tweets Per Capita by Total Homelessness Per Capita\nFor States with Mostly Negative Sentiment') +
  xlab('Log10(Total Homelessness Per Capita)') +
  ylab('Log10(Number of Tweets Per Capita)') +
  labs(color = 'Average\nSentiment') +
  theme_dark() +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))


ggplot(data = negative_sent, mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = mean_sent)) + 
  geom_text(data = negative_sent, 
            mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm),
                          color = mean_sent, label = paste(state, '\n', as.character(year), sep = '')), 
            size = 3) + 
  sent_color_pallette + 
  ggtitle('Volume of Tweets Per Capita by Total Homelessness Per Capita\nFor States with Mostly Negative Sentiment') +
  xlab('Log10(Total Homelessness Per Capita)') + 
  ylab('Log10(Number of Tweets Per Capita)') + 
  labs(color = 'Average\nSentiment') + 
  theme_dark() +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))

## Use this with the zoom function
ggplot(data = negative_sent, mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = mean_sent)) + 
  geom_text(data = negative_sent, 
            mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm),
                          color = mean_sent, label = paste(state, '\n', as.character(year), sep = '')), 
            size = 3) + 
  annotate("text", x=log10(0.0008), y=log10(0.00055), label= "Correlation coefficient = 0.56733", size = 6) + 
  geom_smooth(method = 'lm', se = FALSE, color = 'black') +
  sent_color_pallette + 
  ggtitle('Volume of Tweets Per Capita by Total Homelessness Per Capita\nFor States with Mostly Negative Sentiment') +
  xlab('Log10(Total Homelessness Per Capita)') + 
  ylab('Log10(Number of Tweets Per Capita)') + 
  labs(color = 'Average\nSentiment') + 
  theme_dark() +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))


ggplot(data = negative_sent, mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = mean_sent)) + 
  geom_point(alpha = 0.8) + 
  geom_text(data = negative_sent, 
            mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm),
                          color = mean_sent, label = paste(state, '\n', as.character(year), sep = '')), 
            size = 3, nudge_x = log10(1.03), nudge_y = log10(1.11), color = 'black') + 
  sent_color_pallette + 
  ggtitle('Volume of Tweets Per Capita by Total Homelessness Per Capita\nFor States with Mostly Negative Sentiment') +
  xlab('Log10(Total Homelessness Per Capita)') + 
  ylab('Log10(Number of Tweets Per Capita)') + 
  labs(color = 'Average\nSentiment') + 
  theme_dark() +
  theme_bw() + 
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

ggplot(data = d, mapping = aes(x = total_homeless_norm, y = mean_sent)) + 
  geom_point(alpha = 0.5)

ggplot(data = d, mapping = aes(x = log10(total_homeless_norm), y = mean_sent)) + 
  geom_point(alpha = 0.5)




ggplot(data = negative_sent, mapping = aes(x = total_homeless_norm, y = mean_sent)) + 
  geom_point(alpha = 0.5)

ggplot(data = negative_sent, mapping = aes(x = log10(total_homeless_norm), y = mean_sent)) + 
  geom_point(alpha = 0.5)

# ignoring the potential outlier:
negative_sent %>% filter(mean_sent > -0.4) %>% 
  ggplot(mapping = aes(x = log10(total_homeless_norm), y = mean_sent)) + 
  geom_point(alpha = 0.5)

negative_sent %>% filter(mean_sent > -0.4) %>% 
  ggplot(mapping = aes(x = total_homeless_norm, y = mean_sent)) + 
  geom_point(alpha = 0.5)







