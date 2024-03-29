# import packages
library(dplyr)
library(ggplot2)
library(gridExtra)
library(grid)



# set working directory to the location of this file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


# Recommended but not required to clear environment
rm(list = ls(all.names = TRUE)) 


# use this R file to automatically read in the data and rescale the sentiment values
source('load_data.R')






state_barplot <- function() {
  # sort by mean sentiment (descending)
  df <- state_sent_all %>% arrange(sentiment)
  
  # convert state to a factor so the dataframe holds this ordering
  df <- within(df, state <- factor(state, levels = factor(df$state)))
  
  # plot 
  ggplot(data = df, mapping = aes(x = state, y = sentiment)) + geom_col() +
    coord_flip() + 
    ggtitle("Mean Compound Sentiment by State (All Years)") + 
    xlab("State") + 
    ylab("Mean Compound Sentiment") + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=9))
}


year_barplot <- function() {
  # sort by mean sentiment (descending)
  df <- year_sent_all %>% arrange(year, desc = TRUE)
  
  # convert year to a factor so the dataframe holds this ordering
  df <- within(df, year <- factor(year, levels = factor(df$year)))
  
  # plot
  ggplot(data = df, mapping = aes(x = year, y = sentiment)) + geom_col() +
    # coord_flip() + 
    ggtitle("Mean Compound Sentiment by Year (All States)") + 
    xlab("Year") + 
    ylab("Mean Compound Sentiment") + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=9))
}


sent_barplot_by_year <- function(yr) {
  # filter by the inputted year
  df <- state_year_sent_only %>% filter(year == yr)

  # sort by mean sentiment (descending)
  df <- df %>% arrange(sentiment)
  
  # convert state to a factor so the dataframe holds this ordering
  df <- within(df, state <- factor(state, levels = factor(df$state)))
  
  # plot 
  ggplot(data = df, mapping = aes(x = state, y = sentiment)) + geom_col() +
    coord_flip() + 
    ggtitle(paste("Mean Compound Sentiment by State (", as.character(yr), ")", sep='')) + 
    xlab("State") + 
    ylab("Mean Compound Sentiment") + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=9))
}



sent_barplot_by_year_facet <- function(yr) {
  # filter by the inputted year
  df <- state_year_sent_only %>% filter(year == yr)

  # sort by mean sentiment (descending)
  df <- df %>% arrange(sentiment)

  # convert state to a factor so the dataframe holds this ordering
  df <- within(df, state <- factor(state, levels = factor(df$state)))

  # plot
  ggplot(data = df, mapping = aes(x = state, y = sentiment)) + geom_col() +
    coord_flip() +
    ggtitle(paste(as.character(yr))) +
    xlab('state') +
    ylab('mean sentiment') +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text.y=element_blank())
}


sent_by_state <- function(st) { 
  # filter by the inputted state
  df <- state_year_sent_only %>% filter(state == st)
  
  df <- df %>% arrange(year, desc = TRUE)
  
  # convert year to a factor so the dataframe holds this ordering
  df <- within(df, year <- factor(year, levels = factor(df$year)))
  
  # plot 
  ggplot(data = df, mapping = aes(x = year, y = sentiment)) + geom_col() +
    ggtitle(paste("Mean Compound Sentiment Per Year (", st, ", 2010 - 2019)", sep='')) + 
    xlab("Year") + 
    ylab("Mean Compound Sentiment") + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=9))
}



sent_change_by_state <- function(st) {
  # filter by the inputted state
  df <- state_year_sent_only %>% filter(state == st)
  df <- df %>% arrange(year, desc = FALSE)
  
  # loop through and calculate differences; add to a dataframe
  sent_changes <- data.frame(matrix(ncol = 2, nrow = 0))
  
  # loop through all years (except 2010, since we need prior data)
  years <- c(2011:2019)
  for (yr in years) {
    curr_sent <- df$sentiment[df$year == yr]     # sentiment for the year in question
    past_sent <- df$sentiment[df$year == yr-1]   # sentiment for prior year
    diff <- curr_sent - past_sent
    
    # append the difference to the sent_changes dataframe
    row <- c(yr, diff)
    sent_changes <- rbind(sent_changes, row)
  }
  
  # fix column names
  names(sent_changes) <- c('year','change')

  sent_changes <- sent_changes %>% arrange(year, desc = TRUE)
  
  # convert year to a factor so the dataframe holds this ordering
  sent_changes <- within(sent_changes, year <- factor(year, levels = factor(df$year)))
  
  # plot 
  ggplot(data = sent_changes, mapping = aes(x = year, y = change)) + geom_col() +
    ggtitle(paste("Changes in Mean Compound Sentiment Per Year (", st, ", 2011 - 2019)", sep='')) + 
    xlab("Year") + 
    ylab("Mean Compound Sentiment") + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=9))
}



facet_year <- function() {
  p0 <- sent_barplot_by_year_facet(2010)
  p1 <- sent_barplot_by_year_facet(2011)
  p2 <- sent_barplot_by_year_facet(2012)
  p3 <- sent_barplot_by_year_facet(2013)
  p4 <- sent_barplot_by_year_facet(2014)
  p5 <- sent_barplot_by_year_facet(2015)
  p6 <- sent_barplot_by_year_facet(2016)
  p7 <- sent_barplot_by_year_facet(2017)
  p8 <- sent_barplot_by_year_facet(2018)
  p9 <- sent_barplot_by_year_facet(2019)
  p10 <- sent_barplot_by_year_facet(2020)
  p11 <- sent_barplot_by_year_facet(2021)
  p12 <- sent_barplot_by_year_facet(2022)
  
  grid.arrange(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, ncol=3, nrow=5, 
               top=textGrob('Mean Compound Sentiment Per State, 2010 - 2022', gp=gpar(fontsize=20,font=8)))
}










#### Barplot of Sentiment by State ###################

png(filename="figures/sentiment/state_sentiment.png", width=600, height=600)
p <- state_barplot()
p
dev.off()
print(p)

######################################################





#### Barplot of Sentiment by Year ####################

png(filename="figures/sentiment/yearly_sentiment_bar.png", width=600, height=500)
p <- year_barplot()
p
dev.off()
print(p)


######################################################





#### Sentiment for a Specific Year ######################

sent_barplot_by_year(2010)
sent_barplot_by_year(2011)
sent_barplot_by_year(2012)
sent_barplot_by_year(2013)
sent_barplot_by_year(2014)
sent_barplot_by_year(2015)
sent_barplot_by_year(2016)
sent_barplot_by_year(2017)
sent_barplot_by_year(2018)
sent_barplot_by_year(2019)
sent_barplot_by_year(2020)
sent_barplot_by_year(2021)
sent_barplot_by_year(2022)

png(filename="figures/sentiment/sentiment_facet_year.png", width=550, height=700)
p <- facet_year()
p
dev.off()
print(p)

######################################################





#### Sentiment for a specific state #########

sent_by_state('CA')
sent_change_by_state('CA')

sent_by_state('MA')
sent_change_by_state('MA')


######################################################





### Change in tweet volume vs. change in sentiment

# scatterplot
p <- ggplot(data = changes, aes(x = tweet_norm_changes, y = sent_change)) + 
  geom_point(alpha = 0.5) +
  ggtitle('Change in Sentiment as a Function of Change in Tweet Volume') +
  xlab('Change in Per Capita Tweets') +
  ylab('Change in Sentiment') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/sentiment/sentiment_change_by_tweet_change.png", width=700, height=500)
p
dev.off()



# scatterplot + linreg + corr coeff
test <- cor.test(changes$tweet_norm_changes, changes$sent_change)
p <- ggplot(data = changes, aes(x = tweet_norm_changes, y = sent_change)) + 
  geom_point(alpha = 0.5) +
  geom_smooth(method = 'lm', se = FALSE, color = 'red') +
  annotate("text", x= -0.0002, y=0.43, 
           label= paste("Correlation coefficient =",format(round(test$estimate, 5)))) + 
  ggtitle('Change in Sentiment as a Function of Change in Tweet Volume') +
  xlab('Change in Per Capita Tweets') +
  ylab('Change in Sentiment') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/sentiment/sentiment_change_by_tweet_change_linreg.png", width=700, height=500)
p
dev.off()


# check the linear model for the above
mod <- lm(changes$sent_change ~ changes$tweet_norm_changes)






### Change in homelessness volume vs. change in sentiment

# scatterplot
p <- ggplot(data = changes, aes(x = total_homeless_change, y = sent_change)) + 
  geom_point(alpha = 0.5) +
  ggtitle('Change in Sentiment as a Function of Change in Total Homelessness') +
  xlab('Change in Per Capita Total Homelessness') +
  ylab('Change in Sentiment') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/sentiment/sentiment_change_by_homeless_change.png", width=700, height=500)
p
dev.off()



# scatterplot + linreg + corr coeff
test <- cor.test(changes$total_homeless_change, changes$sent_change)
p <- ggplot(data = changes, aes(x = total_homeless_change, y = sent_change)) + 
  geom_point(alpha = 0.5) +
  geom_smooth(method = 'lm', se = FALSE, color = 'red') +
  annotate("text", x= -0.0008, y=0.43, 
           label= paste("Correlation coefficient =",format(round(test$estimate, 5)))) + 
  ggtitle('Change in Sentiment as a Function of Change in Total Homelessness') +
  xlab('Change in Per Capita Total Homelessness') +
  ylab('Change in Sentiment') +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11),
        axis.title.y = element_text(size = 9.5))
print(p)

png(filename="figures/sentiment/sentiment_change_by_homeless_change_linreg.png", width=700, height=500)
p
dev.off()







