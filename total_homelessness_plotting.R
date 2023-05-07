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




#### Time to make one million different plots!



#### Plot set up ##################################################################


#### build the continuous color palette for mean sentiment

# color mapping:             negative --> neutral --> positive
color_scale<-colorRampPalette(c("#de1616","lightgray","darkblue"))
# find the largest extent (magnitude) of sentiment and set that as limits in both directions for color consistency
lims = max(abs(min(state_year_master$all_sent, na.rm = TRUE)), abs(max(state_year_master$all_sent, na.rm = TRUE)))
# build the palette from these parameters
sent_color_palette <- scale_colour_gradientn(colours = color_scale(100), limit = c(-lims,lims))


# create variables for title and labels, since most plots will use the same ones
title <- 'Volume of Tweets as a Function of Total Homelessness'
title_percents <- 'Percentage of Yearly Tweets as a Function of Total Homelessness'
xlabel <- 'Log10(Total Homelessness Per Capita)'
ylabel <- 'Log10(Number of Geotagged Tweets Per Capita Containing "Homeless")'
ylabel_percents <- 'Log10(Percentage of All Tweets Containing "Homeless")'
legendtitle <- 'Average\nSentiment'


# subsets of the data by sentiment
negative_sent <- state_year_master %>% filter(all_sent < 0)
positive_sent <- state_year_master %>% filter(all_sent > 0)

# font sizes for plots that need to be zoomed
zoom_theme <- theme(plot.title = element_text(hjust = 0.5, size = 18), axis.text=element_text(size=11),
                    axis.title = element_text(size = 14), legend.title = element_text(size = 14),
                    legend.text = element_text(size=11))














#### Build the plots! ###########################################################


### All sentiment ###

# per capita tweets
p <- ggplot(data = state_year_master, 
            mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = all_sent)) + 
  geom_point(alpha = 0.8, size = 2) + 
  sent_color_palette + 
  ggtitle(title) +
  xlab(xlabel) + 
  ylab(ylabel) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/total_homeless/all_sentiment_percapita.png", width=600, height=350)
p
dev.off()




test <- cor.test(log10(state_year_master$total_homeless_norm), log10(state_year_master$tweets_norm))
p <- state_year_master %>% 
  ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = all_sent)) + 
  geom_point(alpha = 0.8, size = 2) + 
  geom_smooth(method = 'lm', se = FALSE, color = 'black') +
  annotate("text", x=log10(0.0008), y=log10(0.0015), 
           label= paste("Correlation coefficient =",format(round(test$estimate, 5)))) + 
  sent_color_palette + 
  ggtitle(paste(title)) +
  xlab(xlabel) + 
  ylab(ylabel) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/total_homeless/all_sentiment_percapita_linreg.png", width=600, height=350)
p
dev.off()

summary(lm(log10(tweets_norm) ~ log10(total_homeless_norm), data=state_year_master))


# percentage tweets --- FIX
p <- ggplot(data = state_year_master, 
            mapping = aes(x = log10(total_homeless_norm), y = log10(tweet_percent), color = all_sent)) + 
  geom_point(alpha = 0.8, size = 2) + 
  sent_color_palette + 
  ggtitle(title_percents) +
  xlab(xlabel) + 
  ylab(ylabel_percents) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/total_homeless/all_sentiment_percentage.png", width=600, height=350)
p
dev.off()





### Positive sentiment only ###

# per capita tweets
p <- state_year_master %>% filter(all_sent > 0) %>% 
  ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = all_sent)) + 
    geom_point(alpha = 0.8, size = 2) + 
    sent_color_palette + 
    ggtitle(paste(title, '\nFor States with Mostly Positive Sentiment')) +
    xlab(xlabel) + 
    ylab(ylabel) + 
    labs(color = legendtitle) + 
    theme_bw() + 
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
          axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/total_homeless/positive_sentiment_percapita.png", width=700, height=450)
p
dev.off()

# percentage tweets ---- FIX
p <- all_data %>% filter(sentiment > 0) %>%
  ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweet_percent), color = sentiment)) + 
  geom_point(alpha = 0.8, size = 2) + 
  sent_color_palette + 
  ggtitle(paste(title_percents, '\nFor States with Mostly Positive Sentiment')) +
  xlab(xlabel) + 
  ylab(ylabel_percents) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/total_homeless/positive_sentiment_percentage.png", width=600, height=350)
p
dev.off()





### Positive sentiment only with regression line and corr coeff ###

# per capita tweets
test <- cor.test(log10(positive_sent$total_homeless_norm), log10(positive_sent$tweets_norm))
p <- state_year_master %>% filter(all_sent > 0) %>% 
  ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = all_sent)) + 
  geom_point(alpha = 0.8, size = 2) + 
  geom_smooth(method = 'lm', se = FALSE, color = 'black') +
  annotate("text", x=log10(0.0008), y=log10(0.0015), 
           label= paste("Correlation coefficient =",format(round(test$estimate, 5)))) + 
  sent_color_palette + 
  ggtitle(paste(title,'\nFor States with Mostly Positive Sentiment')) +
  xlab(xlabel) + 
  ylab(ylabel) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

summary(lm(log10(tweets_norm) ~ log10(total_homeless_norm), data=state_year_master %>% filter(all_sent > 0)))


png(filename="figures/total_homeless/positive_sentiment_regression_percapita.png", width=700, height=450)
p
dev.off()

# percentage tweets --- FIX
test <- cor.test(log10(positive_sent$total_homeless_norm), log10(positive_sent$tweet_percent))
p <- all_data %>% filter(sentiment > 0) %>% 
  ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweet_percent), color = sentiment)) + 
  geom_point(alpha = 0.8, size = 2) + 
  geom_smooth(method = 'lm', se = FALSE, color = 'black') +
  annotate("text", x=log10(0.0008), y=log10(0.2), 
           label= paste("Correlation coefficient =",format(round(test$estimate, 5)))) + 
  sent_color_palette + 
  ggtitle(paste(title_percents,'\nFor States with Mostly Positive Sentiment')) +
  xlab(xlabel) + 
  ylab(ylabel_percents) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/total_homeless/positive_sentiment_regression_percentage.png", width=700, height=450)
p
dev.off()




### Negative sentiment only ###

# per capita tweets
p <- state_year_master %>% filter(all_sent < 0) %>% 
  ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = all_sent)) + 
  geom_point(alpha = 0.8, size = 2) + 
  sent_color_palette + 
  ggtitle(paste(title, '\nFor States with Mostly Negative Sentiment')) +
  xlab(xlabel) + 
  ylab(ylabel) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/total_homeless/negative_sentiment_percapita.png", width=700, height=450)
p
dev.off()

# percentage tweets --- FIX 
p <- all_data %>% filter(sentiment < 0) %>% 
  ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweet_percent), color = sentiment)) + 
  geom_point(alpha = 0.8, size = 2) + 
  sent_color_palette + 
  ggtitle(paste(title_percents, '\nFor States with Mostly Negative Sentiment')) +
  xlab(xlabel) + 
  ylab(ylabel_percents) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/total_homeless/negative_sentiment_percentage.png", width=700, height=450)
p
dev.off()





### Negative sentiment only with regression line ###

# per capita tweets
state_year_master %>% filter(all_sent < 0) %>%
  ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = all_sent)) +
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

summary(lm(log10(tweets_norm) ~ log10(total_homeless_norm), data=state_year_master %>% filter(all_sent < 0)))

# percentage tweets --- FIX
all_data %>% filter(sentiment < 0) %>%
  ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweet_percent), color = sentiment)) +
  geom_point(alpha = 0.8, size = 2) +
  geom_smooth(method = 'lm', se = FALSE, color = 'black') +
  sent_color_palette +
  ggtitle(paste(title_percents, '\nFor States with Mostly Negative Sentiment')) +
  xlab(xlabel) +
  ylab(ylabel_percents) +
  labs(color = legendtitle) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))





### Negative sentiment only with regression line plus corr coeff textbox ###

# per capita tweets
test <- cor.test(log10(negative_sent$total_homeless_norm), log10(negative_sent$tweets_norm))
p <- state_year_master %>% filter(all_sent < 0) %>%
  ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = all_sent)) +
  geom_point(alpha = 0.8, size = 2) +
  annotate("text", x=log10(0.001), y=log10(0.0002), 
           label= paste("Correlation coefficient =", format(round(test$estimate,5)))) + 
  geom_smooth(method = 'lm', se = FALSE, color = 'black') +
  sent_color_palette +
  ggtitle(paste(title, '\nFor States with Mostly Negative Sentiment')) +
  xlab(xlabel) +
  ylab(ylabel) +
  labs(color = legendtitle) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/total_homeless/negative_sentiment_regression_percapita.png", width=700, height=450)
p
dev.off()


# percentage tweets --- FIX
test <- cor.test(log10(negative_sent$total_homeless_norm), log10(negative_sent$tweet_percent))
p <- all_data %>% filter(sentiment < 0) %>%
  ggplot(mapping = aes(x = log10(total_homeless_norm), y = log10(tweet_percent), color = sentiment)) +
  geom_point(alpha = 0.8, size = 2) +
  annotate("text", x=log10(0.00085), y=log10(0.08), 
           label= paste("Correlation coefficient =", format(round(test$estimate,5)))) + 
  geom_smooth(method = 'lm', se = FALSE, color = 'black') +
  sent_color_palette +
  ggtitle(paste(title_percents, '\nFor States with Mostly Negative Sentiment')) +
  xlab(xlabel) +
  ylab(ylabel_percents) +
  labs(color = legendtitle) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/total_homeless/negative_sentiment_regression_percentage.png", width=700, height=450)
p
dev.off()





### Negative sentiment only where points are state/year labels -- use with zoom function! ###

# per capita tweets
p <- ggplot(data = negative_sent, mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = sentiment)) + 
  geom_text(data = negative_sent, 
            mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm),
                          color = all_sent, label = paste(state, '\n', as.character(year), sep = '')), 
            size = 3) + 
  sent_color_palette + 
  ggtitle(paste(title, 'For States with Mostly Negative Sentiment')) +
  xlab(xlabel) + 
  ylab(ylabel) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  zoom_theme
print(p)

png(filename="figures/total_homeless/negative_state_labels_percapita.png", width=1500, height=1000)
p
dev.off()


# percentage tweets --- FIX
p <- ggplot(data = negative_sent, mapping = aes(x = log10(total_homeless_norm), y = log10(tweet_percent), color = sentiment)) + 
  geom_text(data = negative_sent, 
            mapping = aes(x = log10(total_homeless_norm), y = log10(tweet_percent),
                          color = sentiment, label = paste(state, '\n', as.character(year), sep = '')), 
            size = 3) + 
  sent_color_palette + 
  ggtitle(paste(title_percents, 'For States with Mostly Negative Sentiment')) +
  xlab(xlabel) + 
  ylab(ylabel_percents) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  zoom_theme
print(p)

png(filename="figures/total_homeless/negative_state_labels_percentage.png", width=1500, height=1000)
p
dev.off()




### Negative sentiment only; state/year labels; regression line plus corr coeff -- use with zoom function! ###

# per capita tweets
test <- cor.test(log10(negative_sent$total_homeless_norm), log10(negative_sent$tweets_norm))
p <- ggplot(data = negative_sent, mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = all_sent)) + 
  geom_text(data = negative_sent, 
            mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm),
                          color = all_sent, label = paste(state, '\n', as.character(year), sep = '')), 
            size = 3) + 
  annotate("text", x=log10(0.0008), y=log10(0.0002), 
           label= paste("Correlation coefficient =",format(round(test$estimate,5))), size = 6) + 
  geom_smooth(method = 'lm', se = FALSE, color = 'black') +
  sent_color_palette + 
  ggtitle(paste(title, 'For States with Mostly Negative Sentiment')) +
  xlab(xlabel) + 
  ylab(ylabel) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  zoom_theme
print(p)

png(filename="figures/total_homeless/negative_state_labels_regression_percapita.png", width=1500, height=1000)
p
dev.off()

# percentage tweets --- FIX 
test <- cor.test(log10(negative_sent$total_homeless_norm), log10(negative_sent$tweet_percent))
p <- ggplot(data = negative_sent, mapping = aes(x = log10(total_homeless_norm), y = log10(tweet_percent), color = sentiment)) + 
  geom_text(data = negative_sent, 
            mapping = aes(x = log10(total_homeless_norm), y = log10(tweet_percent),
                          color = sentiment, label = paste(state, '\n', as.character(year), sep = '')), 
            size = 3) + 
  annotate("text", x=log10(0.0008), y=log10(0.08), 
           label= paste("Correlation coefficient =",format(round(test$estimate,5))), size = 6) + 
  geom_smooth(method = 'lm', se = FALSE, color = 'black') +
  sent_color_palette + 
  ggtitle(paste(title_percents, 'For States with Mostly Negative Sentiment')) +
  xlab(xlabel) + 
  ylab(ylabel_percents) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  zoom_theme
print(p)

png(filename="figures/total_homeless/negative_state_labels_regression_percentage.png", width=1500, height=1000)
p
dev.off()






### Negative sentiment only, large colored points with state/year labels -- use with zoom function! ###

# per capita tweets
p <- ggplot(data = negative_sent, mapping = aes(x = log10(total_homeless_norm), 
                                           y = log10(tweets_norm), color = all_sent)) + 
  geom_point(alpha = 0.8, size = 13.5) + 
  geom_text(label = paste(negative_sent$state, '\n', as.character(negative_sent$year), sep = ''), size = 3, 
            color = 'black') +
  sent_color_palette + 
  ggtitle(paste(title, 'for States with Mostly Negative Sentiment')) +
  xlab(xlabel) + 
  ylab(ylabel) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  zoom_theme
print(p)

png(filename="figures/total_homeless/negative_large_points_percapita.png", width=1500, height=1000)
p
dev.off()

# percentage tweets --- FIX 
p <- ggplot(data = negative_sent, mapping = aes(x = log10(total_homeless_norm), 
                                                y = log10(tweet_percent), color = sentiment)) + 
  geom_point(alpha = 0.8, size = 13.5) + 
  geom_text(label = paste(negative_sent$state, '\n', as.character(negative_sent$year), sep = ''), size = 3, 
            color = 'black') +
  sent_color_palette + 
  ggtitle(paste(title_percents, 'for States with Mostly Negative Sentiment')) +
  xlab(xlabel) + 
  ylab(ylabel_percents) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  zoom_theme
print(p)

png(filename="figures/total_homeless/negative_large_points_percentage.png", width=1500, height=1000)
p
dev.off()





### Negative sentiment; colored points with offset state/year labels -- use with zoom function! ###

# per capita tweets
p <- ggplot(data = negative_sent, mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = all_sent)) + 
  geom_point(alpha = 0.8, size = 3) + 
  geom_text(data = negative_sent, 
            mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm),
                          color = all_sent, label = paste(state, '\n', as.character(year), sep = '')), 
            size = 3.3, nudge_x = log10(1.03), nudge_y = log10(1.11), color = 'black') + 
  sent_color_palette + 
  ggtitle(paste(title, 'For States with Mostly Negative Sentiment')) +
  xlab(xlabel) + 
  ylab(ylabel) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  zoom_theme
print(p)

png(filename="figures/total_homeless/negative_offset_labels_percapita.png", width=1300, height=800)
p
dev.off()

# percentage tweets --- FIX
p <- ggplot(data = negative_sent, mapping = aes(x = log10(total_homeless_norm), y = log10(tweet_percent), color = all_sent)) + 
  geom_point(alpha = 0.8, size = 3) + 
  geom_text(data = negative_sent, 
            mapping = aes(x = log10(total_homeless_norm), y = log10(tweet_percent),
                          color = all_sent, label = paste(state, '\n', as.character(year), sep = '')), 
            size = 3.3, nudge_x = log10(1.03), nudge_y = log10(1.11), color = 'black') + 
  sent_color_palette + 
  ggtitle(paste(title_percents, 'For States with Mostly Negative Sentiment')) +
  xlab(xlabel) + 
  ylab(ylabel_percents) + 
  labs(color = legendtitle) + 
  theme_bw() + 
  zoom_theme
print(p)

png(filename="figures/total_homeless/negative_offset_labels_percentage.png", width=1300, height=800)
p
dev.off()












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

ggplot(data = homelessness_tweetcounts, mapping = aes(x = total_homeless_norm, y = sentiment)) + 
  geom_point(alpha = 0.5)

ggplot(data = homelessness_tweetcounts, mapping = aes(x = log10(total_homeless_norm), y = sentiment)) + 
  geom_point(alpha = 0.5)

ggplot(data = homelessness_tweetcounts, mapping = aes(x = log10(total_homeless_norm), y = log10(sentiment))) + 
  geom_point(alpha = 0.5)




ggplot(data = negative_sent, mapping = aes(x = total_homeless_norm, y = sentiment)) + 
  geom_point(alpha = 0.5)

ggplot(data = negative_sent, mapping = aes(x = log10(total_homeless_norm), y = sentiment)) + 
  geom_point(alpha = 0.5)




# check the correlation of these
cor.test(log10(homelessness_tweetcounts$total_homeless_norm), log10(homelessness_tweetcounts$sentiment))



# Not really anything interesting....
# Don't think I'll go any further with these








#### Try looking at these plots for specific states and/or years ####



plot_filters <- function(st = NULL, yr = NULL)  {
  # make a copy of the dataframe to be safe
  temp <- data.frame(homelessness_tweetcounts)

  # filter by year only
  if (is.numeric(st)) {
    temp <- temp %>% filter(year == st)
    title <- paste(title, ' (', as.character(st), ')', sep='')
  }
  
  # no filter (should be same as first plot above)
  else if (is.null(st)) {
    s <- 'dummy'    # do nothing
  }
  
  # filter by state only
  else if (is.null(yr)) {
    temp <- temp %>% filter(state == st)
    title <- paste(title, ' (', st, ')', sep='')
  }
  
  # filter by both (this is silly tho because it'll always be a single point)
  else {
    temp <- temp %>% filter(state == st) %>% filter(year == yr)
    title <- paste(title, ' (', st, ', ', as.character(yr), ')', sep='')
  }
  # make the plot
  ggplot(data = temp, mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = sentiment)) + 
    geom_point(alpha = 0.8, size = 2) + 
    sent_color_palette + 
    ggtitle(title) +
    xlab(xlabel) + 
    ylab(ylabel) + 
    labs(color = legendtitle) + 
    theme_bw() + 
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
          axis.title.y = element_text(size = 9.5))
}

plot_filters_facet <- function(st = NULL, yr = NULL)  {
  # make a copy of the dataframe to be safe
  temp <- data.frame(homelessness_tweetcounts)
  
  # filter by year only
  if (is.numeric(st)) {
    temp <- temp %>% filter(year == st)
    title <- paste(title, ' (', as.character(st), ')', sep='')
  }
  
  # no filter (should be same as first plot above)
  else if (is.null(st)) {
    s <- 'dummy'    # do nothing
  }
  
  # filter by state only
  else if (is.null(yr)) {
    temp <- temp %>% filter(state == st)
    title <- paste(title, ' (', st, ')', sep='')
  }
  
  # filter by both (this is silly tho because it'll always be a single point)
  else {
    temp <- temp %>% filter(state == st) %>% filter(year == yr)
    title <- paste(title, ' (', st, ', ', as.character(yr), ')', sep='')
  }
  # make the plot
  ggplot(data = temp, mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = sentiment)) + 
    geom_point(alpha = 0.8, size = 2, show.legend = FALSE) + 
    sent_color_palette + 
    ggtitle(as.character(st)) +
    xlab('Log10(Homelessness)') + 
    ylab('Log10(Tweets)') + 
    theme_bw() + 
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
          axis.title.y = element_text(size = 9.5))
}

facet_years <- function() {
  p1 <- plot_filters_facet(2010)
  p2 <- plot_filters_facet(2011)
  p3 <- plot_filters_facet(2012)
  p4 <- plot_filters_facet(2013)
  p5 <- plot_filters_facet(2014)
  p6 <- plot_filters_facet(2015)
  p7 <- plot_filters_facet(2016)
  p8 <- plot_filters_facet(2017)
  
  grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8,
               top=textGrob("Volume of Tweets as a Function of Homelessness, 2010 - 2017", 
                            gp=gpar(fontsize=18,font=8)))
}



plot_filters(2010)
plot_filters(2015)
plot_filters(2016)
plot_filters(2017)

plot_filters('CA')
plot_filters('MA')


facet_years()












#### Compare across all years #####################

p <- ggplot(data = homelessness_tweetcounts, mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = sentiment)) + 
  geom_point(alpha = 0.8) + 
  sent_color_palette + 
  ggtitle(title) +
  xlab(xlabel) + 
  ylab(ylabel) + 
  labs(color = legendtitle) + 
  facet_grid(~ year) + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)



p <- ggplot(data = homelessness_tweetcounts, mapping = aes(x = log10(total_homeless_norm), y = log10(tweets_norm), color = sentiment)) + 
  geom_point(alpha = 0.8) + 
  sent_color_palette + 
  ggtitle(title) +
  xlab(xlabel) + 
  ylab(ylabel) + 
  labs(color = legendtitle) + 
  facet_wrap(~ year) + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/total_homeless/homelessness_facet_year.png", width=800, height=800)
p
dev.off()






















