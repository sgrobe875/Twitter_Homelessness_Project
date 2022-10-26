# import packages
library(dplyr)
library(ggplot2)
# library(RColorBrewer)
library(ggrepel)




# set working directory to the location of this file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


# Recommended but not required to clear environment
rm(list = ls(all.names = TRUE)) 




# read in the data
d <- read.csv('data/homelessness_rate_data.csv')




#### Time to make one million different plots!



#### Plot set up ##################################################################


#### build the continuous color palette for mean sentiment

# color mapping:             negative --> neutral --> positive
redgreen<-colorRampPalette(c("#de1616","lightgray","darkblue"))
# find the largest extent (magnitude) of sentiment and set that as limits in both directions for color consistency
lims = max(abs(min(d$mean_sent)), abs(max(d$mean_sent)))
# build the palette from these parameters
sent_color_palette <- scale_colour_gradientn(colours = redgreen(100), limit = c(-lims,lims))


# create variables for title and labels, since most plots will use the same ones
title <- 'Volume of Tweets as a Function of Homelessness'
xlabel <- 'Log10(Total Homelessness Per Capita)'
ylabel <- 'Log10(Number of Geotagged Tweets Per Capita Containing "Homeless")'
legendtitle <- 'Average\nSentiment'


# subsets of the data by sentiment
negative_sent <- d %>% filter(mean_sent < 0)
positive_sent <- d %>% filter(mean_sent > 0)

# font sizes for plots that need to be zoomed
zoom_theme <- theme(plot.title = element_text(hjust = 0.5, size = 18), axis.text=element_text(size=11),
                    axis.title = element_text(size = 14), legend.title = element_text(size = 14),
                    legend.text = element_text(size=11))



#### Build the plots! ###########################################################


# All sentiment
ggplot(data = d, mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = mean_sent)) + 
  geom_point(alpha = 0.8, size = 2) + 
  sent_color_palette + 
  ggtitle(title) +
  xlab(xlabel) + 
  ylab(ylabel) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))

# Positive sentiment only
d %>% filter(mean_sent > 0) %>% 
ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = mean_sent)) + 
  geom_point(alpha = 0.8, size = 2) + 
  sent_color_palette + 
  ggtitle(paste(title, '\nFor States with Mostly Positive Sentiment')) +
  xlab(xlabel) + 
  ylab(ylabel) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))

# Positive sentiment only with regression line
d %>% filter(mean_sent > 0) %>% 
  ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = mean_sent)) + 
  geom_point(alpha = 0.8, size = 2) + 
  geom_smooth(method = 'lm', se = FALSE, color = 'black') +
  sent_color_palette + 
  ggtitle(paste(title,'\nFor States with Mostly Positive Sentiment')) +
  xlab(xlabel) + 
  ylab(ylabel) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))

# Negative sentiment only
d %>% filter(mean_sent < 0) %>% 
  ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = mean_sent)) + 
  geom_point(alpha = 0.8, size = 2) + 
  sent_color_palette + 
  ggtitle(paste(title, '\nFor States with Mostly Negative Sentiment')) +
  xlab(xlabel) + 
  ylab(ylabel) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))

# Negative sentiment only with regression line
d %>% filter(mean_sent < 0) %>%
  ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = mean_sent)) +
  geom_point(alpha = 0.8, size = 2) +
  geom_smooth(method = 'lm', se = FALSE, color = 'black') +
  sent_color_palette +
  ggtitle(paste(title, '\nFor States with Mostly Negative Sentiment')) +
  xlab(xlabel) +
  ylab(ylabel) +
  labs(color = legendtitle) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))

# Negative sentiment only with regression line plus corr coeff textbox
d %>% filter(mean_sent < 0) %>%
  ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = mean_sent)) +
  geom_point(alpha = 0.8, size = 2) +
  annotate("text", x=log10(0.00095), y=log10(0.00055), label= "Correlation coefficient = 0.56733") + 
  geom_smooth(method = 'lm', se = FALSE, color = 'black') +
  sent_color_palette +
  ggtitle(paste(title, '\nFor States with Mostly Negative Sentiment')) +
  xlab(xlabel) +
  ylab(ylabel) +
  labs(color = legendtitle) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))

# Negative sentiment only where points are state/year labels -- use with zoom function!
ggplot(data = negative_sent, mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = mean_sent)) + 
  geom_text(data = negative_sent, 
            mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm),
                          color = mean_sent, label = paste(state, '\n', as.character(year), sep = '')), 
            size = 3) + 
  sent_color_palette + 
  ggtitle(paste(title, 'For States with Mostly Negative Sentiment')) +
  xlab(xlabel) + 
  ylab(ylabel) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  zoom_theme

# Negative sentiment only, large colored points with state/year labels -- use with zoom function!
ggplot(data = negative_sent, mapping = aes(x = log10(total_homeless_norm), 
                                           y = log10(tweets_norm), color = mean_sent)) + 
  geom_point(alpha = 0.8, size = 13) + 
  geom_text(label = paste(negative_sent$state, '\n', as.character(negative_sent$year), sep = ''), size = 3, 
            color = 'black') +
  sent_color_palette + 
  ggtitle(paste(title, 'for States with Mostly Negative Sentiment')) +
  xlab(xlabel) + 
  ylab(ylabel) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  zoom_theme

# Negative sentiment only; state/year labels; regression line plus corr coeff -- use with zoom function!
ggplot(data = negative_sent, mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = mean_sent)) + 
  geom_text(data = negative_sent, 
            mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm),
                          color = mean_sent, label = paste(state, '\n', as.character(year), sep = '')), 
            size = 3) + 
  annotate("text", x=log10(0.0008), y=log10(0.00055), label= "Correlation coefficient = 0.56733", size = 6) + 
  geom_smooth(method = 'lm', se = FALSE, color = 'black') +
  sent_color_palette + 
  ggtitle(paste(title, 'For States with Mostly Negative Sentiment')) +
  xlab(xlabel) + 
  ylab(ylabel) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  zoom_theme

# Negative sentiment; colored points with offset state/year labels -- use with zoom function!
ggplot(data = negative_sent, mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = mean_sent)) + 
  geom_point(alpha = 0.8, size = 3) + 
  geom_text(data = negative_sent, 
            mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm),
                          color = mean_sent, label = paste(state, '\n', as.character(year), sep = '')), 
            size = 3.5, nudge_x = log10(1.03), nudge_y = log10(1.11), color = 'black') + 
  sent_color_palette + 
  ggtitle(paste(title, 'For States with Mostly Negative Sentiment')) +
  xlab(xlabel) + 
  ylab(ylabel) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  zoom_theme













#### looking closer at the relationship for negative sentiment

negative_model <- lm(log10(negative_sent$tweets_norm) ~ log10(negative_sent$total_homeless_norm))

# get intercept/slope
negative_model$coefficients

# correlation coefficient
cor.test(log10(negative_sent$tweets_norm), log10(negative_sent$total_homeless_norm))



#### same for positive sentiment because why not 

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



# Not really anything interesting....





